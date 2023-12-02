import 'package:expense_kit/utils/extensions.dart';
import 'package:expense_kit/view/components/circular_indicator.dart';
import 'package:expense_kit/view/decorations.dart';
import 'package:expense_kit/view_model/auth/auth_cubit.dart';
import 'package:expense_kit/view_model/state_vm.dart';
import 'package:feedback/view/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthSheet extends StatefulWidget {
  const AuthSheet({super.key});

  @override
  StateModel<AuthSheet, AuthCubit> createState() => _AuthSheetState();
}

class _AuthSheetState extends StateModel<AuthSheet, AuthCubit> {
  final TextEditingController _controller = TextEditingController();

  @override
  void listener(state) {
    if (state is AuthSuccess) {
      context.pop();
    }
    if (state is FetchedOTP) {
      _controller.clear();
    }
    super.listener(state);
  }

  @override
  Widget buildMobile(BuildContext context, AuthCubit cubit) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Login with Phone'),
                const SizedBox(
                  height: 32,
                ),
                if (cubit.otpSent)
                  TextField(
                    controller: _controller,
                    enabled: cubit.state is! FetchingOTP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    style: context.titleMedium()?.copyWith(
                          letterSpacing: 16,
                        ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: textDecoration.copyWith(
                      labelText: 'OTP',
                      labelStyle: context.titleLarge(),
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    onChanged: (value) {
                      if (value.length == 6) {
                        cubit.validateOTP(value);
                      }
                    },
                  )
                else
                  TextField(
                    controller: _controller,
                    enabled: cubit.state is! FetchingOTP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    style: context.titleMedium(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: textDecoration.copyWith(
                      labelText: 'Phone Number',
                      labelStyle: context.titleLarge(),
                      prefixText: '+ 91  ',
                      counterText: '',
                    ),
                    maxLength: 10,
                    onChanged: (value) {
                      cubit.phone = value;
                    },
                  ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    if (!cubit.otpSent)
                      Expanded(
                        child: cubit.state is FetchingOTP
                            ? const CircularIndicator()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                ),
                                onPressed: cubit.validNumber()
                                    ? () {
                                        context.hideKeyboard();
                                        cubit.fetchOTP();
                                      }
                                    : null,
                                child: const Text('Get OTP'),
                              ),
                      )
                    else
                      Expanded(
                        child: cubit.state is ValidatingOTP
                            ? const CircularIndicator()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                ),
                                onPressed: () {
                                  context.hideKeyboard();
                                  cubit.validateOTP(_controller.text);
                                },
                                child: const Text('Verify OTP'),
                              ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
