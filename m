Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35702 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752414AbcHZLiZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 07:38:25 -0400
Received: by mail-lf0-f65.google.com with SMTP id l89so3653334lfi.2
        for <linux-media@vger.kernel.org>; Fri, 26 Aug 2016 04:37:44 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH 2/2] cec-follower: extend man page
Date: Fri, 26 Aug 2016 13:37:25 +0200
Message-Id: <1472211445-26700-2-git-send-email-jaffe1@gmail.com>
In-Reply-To: <1472211445-26700-1-git-send-email-jaffe1@gmail.com>
References: <1472211445-26700-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The man page is extended with some more information about the tool and
what it does, and a SEE ALSO section is added.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-follower/cec-follower.1.in | 45 ++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/utils/cec-follower/cec-follower.1.in b/utils/cec-follower/cec-follower.1.in
index 3f32125..1134648 100644
--- a/utils/cec-follower/cec-follower.1.in
+++ b/utils/cec-follower/cec-follower.1.in
@@ -1,19 +1,48 @@
 .TH "CEC-FOLLOWER" "1" "August 2016" "v4l-utils @PACKAGE_VERSION@" "User Commands"
 .SH NAME
-cec-follower - An application to emulate cec followers
+cec-follower - An application to emulate CEC followers
 .SH SYNOPSIS
 .B cec-follower
 [\fI-h\fR] [\fI-d <dev>\fR] [other options]
 .SH DESCRIPTION
-The cec-follower tool is used to emulate cec followers. Based on the configured
-logical address(es) of the CEC device it will emulate the CEC behavior accordingly.
+The \fBcec-follower\fR tool is used to emulate CEC followers. Based on the configured
+logical address(es) of the CEC device it will emulate the CEC behavior
+accordingly.
 
-It is basically a message loop, waiting for messages to arrive and taking the
-appropriate action for each message.
+Configuring the CEC device is done using \fBcec-ctl\fR. Certain CEC functionalities
+are only emulated if the corresponding Device Features flag is set (these are set
+when configuring with \fBcec-ctl\fR). These are:
 
-This makes it possible to act as a specific CEC device. It is also a reference
-implementation on how a follower should behave.
+    - Audio Return Channel (RX and TX)
+    - Audio Rate Control
+    - Deck Control
+    - Record TV screen
 
+\fBcec-follower\fR is basically a message loop, waiting for messages to arrive
+and taking the appropriate action for each message (incoming messages can be
+shown with the \fI--show-msgs\fR option). The follower maintains an internal
+state with appropriate parameters such as volume, current active source, power
+state and so on (state changes can be shown with the \fI--show-state\fR option).
+
+It also aims to be a reference implementation on how a follower should behave.
+
+\fBcec-follower\fR will keep track of incoming messages and look for violations
+of the CEC specification with regards to timings. For example, it will warn if
+it receives the same message again within 200ms after it replied <Feature Abort>
+["Unrecognized Opcode"] to that message, and it will check that press and hold
+behavior is done properly.
+
+\fBcec-follower\fR will periodically send out polling messages to discover when
+a remote device is removed or a new one has appeared. When a device is removed,
+the recorded information about it is cleared. Each logical address is polled
+about once every 15 seconds. In between polls, removing a remote device or
+replacing it with a new one is not detected.
+
+When running compliance tests with \fBcec-compliance\fR, \fBcec-follower\fR
+should be run on the same device to act on incoming messages that are not replies
+to messages sent by the compliance tool. Before each test run \fBcec-follower\fR
+should be restarted if it is running, to initialize the emulated device with a
+clean and known initial state.
 .SH OPTIONS
 .TP
 \fB\-d\fR, \fB\-\-device\fR=\fI<dev>\fR
@@ -43,3 +72,5 @@ This manual page is a work in progress.
 
 Bug reports or questions about this utility should be sent to the linux-media@vger.kernel.org
 mailinglist.
+.SH SEE ALSO
+\fBcec-compliance\fR(1), \fBcec-ctl\fR(1)
-- 
2.7.4

