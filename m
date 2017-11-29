Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50491 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbdK2TIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 13/22] media: radio-wl1273: fix a parameter name at kernel-doc macro
Date: Wed, 29 Nov 2017 14:08:31 -0500
Message-Id: <f24e56151f4a87194670052d5c9cd3d0ed6b7e19.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solve those warnings:
	drivers/media/radio/radio-wl1273.c:1337: warning: No description found for parameter 'radio'
	drivers/media/radio/radio-wl1273.c:1337: warning: Excess function parameter 'core' description in 'wl1273_fm_set_tx_power'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/radio-wl1273.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 903fcd5e99c0..3cbdc085c65d 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1330,7 +1330,7 @@ static int wl1273_fm_vidioc_s_input(struct file *file, void *priv,
 
 /**
  * wl1273_fm_set_tx_power() -	Set the transmission power value.
- * @core:			A pointer to the device struct.
+ * @radio:			A pointer to the device struct.
  * @power:			The new power value.
  */
 static int wl1273_fm_set_tx_power(struct wl1273_device *radio, u16 power)
-- 
2.14.3
