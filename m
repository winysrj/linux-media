Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61988 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HDHOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:21 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/21] [media] tuner/xc2028: Add I2C flush callback.
Date: Thu,  4 Aug 2011 09:13:59 +0200
Message-Id: <1312442059-23935-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When loading the firmware, complete each chunk by sending an I2C flush
command to the frontend. Some devices like the tm6000 seem to require
this to properly flush the I2C buffers.

The current code in tm6000 executes the flush command once after each
I2C transfer, which slows down the firmware loading especially when
loading large BASE type images.
---
 drivers/media/common/tuners/tuner-xc2028.c |    7 +++++++
 drivers/media/common/tuners/tuner-xc2028.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 16fba6b..b6b2868 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -614,6 +614,13 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 			p += len;
 			size -= len;
 		}
+
+		/* silently fail if the frontend doesn't support I2C flush */
+		rc = do_tuner_callback(fe, XC2028_I2C_FLUSH, 0);
+		if ((rc < 0) && (rc != -EINVAL)) {
+			tuner_err("error executing flush: %d\n", rc);
+			return rc;
+		}
 	}
 	return 0;
 }
diff --git a/drivers/media/common/tuners/tuner-xc2028.h b/drivers/media/common/tuners/tuner-xc2028.h
index 9778c96..9ebfb2d 100644
--- a/drivers/media/common/tuners/tuner-xc2028.h
+++ b/drivers/media/common/tuners/tuner-xc2028.h
@@ -54,6 +54,7 @@ struct xc2028_config {
 /* xc2028 commands for callback */
 #define XC2028_TUNER_RESET	0
 #define XC2028_RESET_CLK	1
+#define XC2028_I2C_FLUSH	2
 
 #if defined(CONFIG_MEDIA_TUNER_XC2028) || (defined(CONFIG_MEDIA_TUNER_XC2028_MODULE) && defined(MODULE))
 extern struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
-- 
1.7.6

