Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42771 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752865AbeCDPtY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2018 10:49:24 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: alan@linux.intel.com
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 2/3] staging: media: Replace "cant" with "can't"
Date: Sun,  4 Mar 2018 21:18:26 +0530
Message-Id: <1520178507-25141-3-git-send-email-arushisinghal19971997@gmail.com>
In-Reply-To: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
References: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace "cant" with "can't".
"cant" is not same as "Can not" or "Can't".

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index bffe215..634d38c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -444,7 +444,7 @@ static int vpfe_register_entities(struct vpfe_device *vpfe_dev)
 	for (i = 0; i < vpfe_dev->num_ext_subdevs; i++)
 		/*
 		 * if entity has no pads (ex: amplifier),
-		 * cant establish link
+		 * can't establish link
 		 */
 		if (vpfe_dev->sd[i]->entity.num_pads) {
 			ret = media_create_pad_link(&vpfe_dev->sd[i]->entity,
-- 
2.7.4
