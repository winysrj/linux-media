Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51017 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933003AbcIEL4I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 07:56:08 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Johan Fjeldtvedt <jaffe1@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-compliance: improve man page
Message-ID: <72b66b08-277a-463f-8f9a-90b89498ea80@xs4all.nl>
Date: Mon, 5 Sep 2016 13:56:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clarify the 'OK (Not Supported)' explanation.

Mention that most CEC adapters will detect the physical address automatically and
that the --phys-addr option can be dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/utils/cec-compliance/cec-compliance.1.in b/utils/cec-compliance/cec-compliance.1.in
index a75856d..0d5bada 100644
--- a/utils/cec-compliance/cec-compliance.1.in
+++ b/utils/cec-compliance/cec-compliance.1.in
@@ -45,8 +45,9 @@ failing:
                         when a TV replies to messages in the Deck Control
                         feature.

-    OK (Not Supported)  The test did not pass and is not mandatory for the
-                        device to pass.
+    OK (Not Supported)  The feature that was tested is not supported by the
+                        device under test, and that feature was not mandatory for
+                        the device to pass.

     OK (Presumed)       Nothing went wrong during the test, but the test cannot
                         positively verify that the required effects of the test
@@ -170,6 +171,9 @@ the CEC adapter is connected to the first input of the TV, the physical address

     cec-ctl -d1 --playback --phys-addr 1.0.0.0

+Most CEC adapters will automatically detect the physical address, and for those
+adapters the \fI--phys-addr\fR option is not needed.
+
 Next, \fBcec-follower\fR also has to be started on the same device:

     cec-follower -d1
