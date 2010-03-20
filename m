Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59093 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0CTOOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 10:14:42 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
	Wolfram Sang <w.sang@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Date: Sat, 20 Mar 2010 15:12:51 +0100
Message-Id: <1269094385-16114-11-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
Subject: [PATCH 10/24] media/radio: fix dangling pointers
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix I2C-drivers which missed setting clientdata to NULL before freeing the
structure it points to. Also fix drivers which do this _after_ the structure
was freed already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/media/radio/radio-tea5764.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 8e718bf..8a6be0a 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -571,6 +571,7 @@ static int __devinit tea5764_i2c_probe(struct i2c_client *client,
 	return 0;
 errrel:
 	video_device_release(radio->videodev);
+	i2c_set_clientdata(client, NULL);
 errfr:
 	kfree(radio);
 	return ret;
@@ -584,6 +585,7 @@ static int __devexit tea5764_i2c_remove(struct i2c_client *client)
 	if (radio) {
 		tea5764_power_down(radio);
 		video_unregister_device(radio->videodev);
+		i2c_set_clientdata(client, NULL);
 		kfree(radio);
 	}
 	return 0;
-- 
1.7.0

