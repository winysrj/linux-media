Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaCCKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 77/79] [media] drx-j: disable OOB
Date: Mon,  3 Mar 2014 07:07:11 -0300
Message-Id: <1393841233-24840-78-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like the windows driver, disable OOB after setting the driver
version.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 585d891392c3..f7c57c971f8f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -16676,7 +16676,6 @@ rw_error:
 /* Coefficients for the nyquist fitler (total: 27 taps) */
 #define NYQFILTERLEN 27
 
-#if 0
 static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_param)
 {
 	int rc;
@@ -17177,6 +17176,8 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
+
 /**
 * \fn int ctrl_get_oob()
 * \brief Set modulation standard to be used.
@@ -20026,6 +20027,12 @@ int drxj_open(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
+	rc = ctrl_set_oob(demod, NULL);
+	if (rc != 0) {
+		pr_err("error %d\n", rc);
+		goto rw_error;
+	}
+
 	/* refresh the audio data structure with default */
 	ext_attr->aud_data = drxj_default_aud_data_g;
 
-- 
1.8.5.3

