Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35956 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752408AbcHZLiZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 07:38:25 -0400
Received: by mail-lf0-f68.google.com with SMTP id 33so3651264lfw.3
        for <linux-media@vger.kernel.org>; Fri, 26 Aug 2016 04:37:43 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH 1/2] cec-compliance: extend man page
Date: Fri, 26 Aug 2016 13:37:24 +0200
Message-Id: <1472211445-26700-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The man page is extended with a more detailed description including a
more in-depth explanation of the different test result codes. An example
of how to run tests is also included, and a SEE ALSO section is added.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-compliance/cec-compliance.1.in | 81 +++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/utils/cec-compliance/cec-compliance.1.in b/utils/cec-compliance/cec-compliance.1.in
index b065da5..2c45bcc 100644
--- a/utils/cec-compliance/cec-compliance.1.in
+++ b/utils/cec-compliance/cec-compliance.1.in
@@ -10,8 +10,64 @@ comply with the CEC specification. It can also be used to test the local
 CEC adapter (with the \fI-A\fR option).
 
 By default it will run through all tests, but if one or more of the feature
-test options is given, then only those tests will be performed.
+test options is given, then only those tests will be performed. A set of core
+tests is always run.
 
+The CEC adapter needs to be configured before it is used to run tests with
+\fBcec-compliance\fR. Use \fBcec-ctl\fR for configuration.
+
+If the CEC adapter has claimed several logical addresses, the test set is run
+from each logical address in succession. The remote device needs to report a
+valid physical address in order to run tests on it.
+
+When running compliance tests, \fBcec-follower\fR should be run on the same
+adapter. \fBcec-follower\fR will reply to messages that are not handled by
+\fBcec-compliance\fR. \fBcec-follower\fR will also monitor the device under test
+for behaviors that are not compliant with the specification. Before each test run
+\fBcec-follower\fR should be restarted if it is already running, to initialize
+the emulated device with a clean and known initial state.
+
+Some tests require interactive mode (with the \fI-i\fR option) to confirm that
+the test passed. When in interactive mode, the user is asked to observe or
+perform actions on the remote device. Some tests also give conclusive test
+results when run in interactive mode.
+
+When testing the local CEC adapter's compliance with the CEC API, there must be
+at least one remote device present in order to test transmitting and receiving.
+
+The compliance tests can have several possible outcomes besides passing and
+failing:
+
+    OK                  The test passed.
+
+    OK (Unexpected)     The test passed, but it was unexpected for the device
+                        under test to support it. This might for example occur
+                        when a TV replies to messages in the Deck Control
+                        feature.
+
+    OK (Not Supported)  The test did not pass and is not mandatory for the
+                        device to pass.
+
+    OK (Presumed)       Nothing went wrong during the test, but the test cannot
+                        positively verify that the required effects of the test
+                        occured. The test runner should verify that the test
+                        passed by manually observing the device under test. This
+                        is typically the test result for tests that send
+                        messages that are not replied to, but which induce some
+                        side effect on the device under test, such as a TV
+                        switching to another input or sending a Remote Control
+                        command.
+
+    OK (Refused)        The device supports the feature or message being tested,
+                        but responded <Feature Abort> ["Refused"] to indicate
+                        that it cannot perform the given operation. This might
+                        for example occur when trying to test the One Touch
+                        Record feature on a TV with copy protection enabled.
+
+    FAIL                The test failed and was expected to pass on the device.
+
+Some tests depend on other tests being successful. These are not run if the
+tests they depend on failed, and they will not be shown in the test listing.
 .SH OPTIONS
 .TP
 \fB\-d\fR, \fB\-\-device\fR=\fI<dev>\fR
@@ -101,8 +157,31 @@ testing of Standby, Give Device Power Status and One Touch Play.
 
 .SH EXIT STATUS
 On success, it returns 0. Otherwise, it will return the error code.
+.SH EXAMPLE
+We want to test the compliance of a TV when it is interacting with a Playback
+device. The device node of the CEC adapter which the TV is connected to is
+/dev/cec1.
+
+The local CEC adapter first needs to be configured as a Playback device, and it
+must have an appropriate physical address. It is important that the physical
+address is correct, so as to not confuse the device under test. For example, if
+the CEC adapter is connected to the first input of the TV, the physical address
+1.0.0.0 should generally be used.
+
+    cec-ctl -d1 --playback --phys-addr 1.0.0.0
+
+Next, \fBcec-follower\fR also has to be started on the same device:
+
+    cec-follower -d1
+
+\fBcec-compliance\fR can now be run towards the TV by supplying the \fI-r\fR
+option with the logical address 0:
+
+    cec-compliance -d1 -r0
 .SH BUGS
 This manual page is a work in progress.
 
 Bug reports or questions about this utility should be sent to the linux-media@vger.kernel.org
 mailinglist.
+.SH SEE ALSO
+\fBcec-follower\fR(1), \fBcec-ctl\fR(1)
-- 
2.7.4

