Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40199 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783Ab3BZTa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 14:30:58 -0500
Received: by mail-pa0-f52.google.com with SMTP id fb1so2639117pad.11
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2013 11:30:57 -0800 (PST)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-media@vger.kernel.org
Cc: syamsidhardh@gmail.com, mchehab@redhat.com
Subject: [PATCH] media: tuners: Remove redundant NULL check before kfree
Date: Wed, 27 Feb 2013 01:00:45 +0530
Message-Id: <1361907045-2722-1-git-send-email-s.syam@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/media/tuners/tuner-xc2028.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 0945173..878d2c4 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1378,8 +1378,7 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	 * For the firmware name, keep a local copy of the string,
 	 * in order to avoid troubles during device release.
 	 */
-	if (priv->ctrl.fname)
-		kfree(priv->ctrl.fname);
+	kfree(priv->ctrl.fname);
 	memcpy(&priv->ctrl, p, sizeof(priv->ctrl));
 	if (p->fname) {
 		priv->ctrl.fname = kstrdup(p->fname, GFP_KERNEL);
-- 
1.7.9.5

