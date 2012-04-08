Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab2DHP7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:59:33 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] stk-webcam: Don't flip the image by default
Date: Sun,  8 Apr 2012 18:01:43 +0200
Message-Id: <1333900903-2585-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prior to this patch the stk-webcam driver was enabling the vflip and mirror
bits in the sensor by default. Which only is the right thing to do if the
sensor is actually mounted upside down, which it usually is not.

Actually we've received upside down reports for both usb-ids which this
driver supports, one for an "ASUSTeK Computer Inc." "A3H" laptop with
a build in 174f:a311 webcam, and one for an "To Be Filled By O.E.M."
"Z96FM" laptop with a build in 05e1:0501 webcam.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/stk-webcam.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index d427f84..86a0fc5 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -38,13 +38,13 @@
 #include "stk-webcam.h"
 
 
-static bool hflip = 1;
+static bool hflip;
 module_param(hflip, bool, 0444);
-MODULE_PARM_DESC(hflip, "Horizontal image flip (mirror). Defaults to 1");
+MODULE_PARM_DESC(hflip, "Horizontal image flip (mirror). Defaults to 0");
 
-static bool vflip = 1;
+static bool vflip;
 module_param(vflip, bool, 0444);
-MODULE_PARM_DESC(vflip, "Vertical image flip. Defaults to 1");
+MODULE_PARM_DESC(vflip, "Vertical image flip. Defaults to 0");
 
 static int debug;
 module_param(debug, int, 0444);
-- 
1.7.9.3

