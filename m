Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:27282 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751135AbdHXGAP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 02:00:15 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: sakari.ailus@iki.fi, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] [media] smiapp: check memory allocation failure
Date: Thu, 24 Aug 2017 07:58:39 +0200
Message-Id: <20170824055839.26767-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check memory allocation failure and return -ENOMEM in such a case.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index aff55e1dffe7..700f433261d0 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -841,6 +841,8 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 		&client->dev,
 		compressed_max_bpp - sensor->compressed_min_bpp + 1,
 		sizeof(*sensor->valid_link_freqs), GFP_KERNEL);
+	if (!sensor->valid_link_freqs)
+		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
 		const struct smiapp_csi_data_format *f =
-- 
2.11.0
