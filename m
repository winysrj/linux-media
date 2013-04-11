Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38383 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3DKWFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 18:05:53 -0400
Received: by mail-lb0-f174.google.com with SMTP id s10so2073849lbi.33
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 15:05:52 -0700 (PDT)
To: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [PATCH 1/2] adv8170: fix querystd() method for no input signal
Cc: vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 12 Apr 2013 02:04:51 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304120204.51735.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

When the input signal is not detected querystd() method should return
V4L2_STD_UNKNOWN instead of previously latched analog video standard.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 drivers/media/i2c/adv7180.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/media/i2c/adv7180.c
===================================================================
--- linux.orig/drivers/media/i2c/adv7180.c
+++ linux/drivers/media/i2c/adv7180.c
@@ -135,6 +135,10 @@ struct adv7180_state {
 
 static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 {
+	/* in case V4L2_IN_ST_NO_SIGNAL */
+	if (!(status1 & ADV7180_STATUS1_IN_LOCK))
+		return V4L2_STD_UNKNOWN;
+
 	switch (status1 & ADV7180_STATUS1_AUTOD_MASK) {
 	case ADV7180_STATUS1_AUTOD_NTSM_M_J:
 		return V4L2_STD_NTSC;
