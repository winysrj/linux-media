Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46385 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0BILw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 06:52:29 -0500
Message-ID: <4B714E15.4020909@gmail.com>
Date: Tue, 09 Feb 2010 12:59:17 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] video_device: don't free_irq() an element past array vpif_obj.dev[]
 and fix test
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In vpif_get_std_info(): std_info doesn't need the NULL test, it was already
dereferenced anyway. If std_info->stdid is 0 we could early return -1.

In vpif_probe(): local variable q was only assigned. If we error out with
either last two goto's then j equals VPIF_DISPLAY_MAX_DEVICES. So after the
probe_out: label, k also reaches VPIF_DISPLAY_MAX_DEVICES after the loop. In
the first iteration in the loop after vpif_int_err: a free_irq() can occur
of an element &vpif_obj.dev[VPIF_DISPLAY_MAX_DEVICES]->channel_id which is
outside vpif_obj.dev[] array boundaries.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or am I mistaken?

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index dfddef7..8f6605d 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -383,7 +383,7 @@ static int vpif_get_std_info(struct channel_obj *ch)
 	int index;
 
 	std_info->stdid = vid_ch->stdid;
-	if (!std_info)
+	if (!std_info->stdid)
 		return -1;
 
 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
@@ -1423,7 +1423,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct vpif_display_config *config;
-	int i, j = 0, k, q, m, err = 0;
+	int i, j = 0, k, m, err = 0;
 	struct i2c_adapter *i2c_adap;
 	struct common_obj *common;
 	struct channel_obj *ch;
@@ -1573,10 +1573,12 @@ probe_out:
 		video_device_release(ch->video_dev);
 		ch->video_dev = NULL;
 	}
+	if (k == VPIF_DISPLAY_MAX_DEVICES)
+		k = VPIF_DISPLAY_MAX_DEVICES - 1;
 vpif_int_err:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 	vpif_err("VPIF IRQ request failed\n");
-	for (q = k; k >= 0; k--) {
+	for (; k >= 0; k--) {
 		for (m = i; m >= res->start; m--)
 			free_irq(m, (void *)(&vpif_obj.dev[k]->channel_id));
 		res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
