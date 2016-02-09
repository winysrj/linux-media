Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24330 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbcBILOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 06:14:25 -0500
Date: Tue, 9 Feb 2016 14:14:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] usb/cpia2_core: clean up a min_t() cast
Message-ID: <20160209111411.GA23998@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes sense to make the min_t() cast unsigned here since we don't
really want negative sizes.  Making it signed causes a static checker
warning in Smatch.  Smatch knows "fw->size - i" is positive but it
doesn't know that fw->size is less than INT_MAX so in theory casting it
to int might lead to a negative.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/cpia2/cpia2_core.c b/drivers/media/usb/cpia2/cpia2_core.c
index 187012c..0310fd6 100644
--- a/drivers/media/usb/cpia2/cpia2_core.c
+++ b/drivers/media/usb/cpia2/cpia2_core.c
@@ -923,7 +923,7 @@ static int apply_vp_patch(struct camera_data *cam)
 	/* ... followed by the data payload */
 	for (i = 2; i < fw->size; i += 64) {
 		cmd.start = 0x0C; /* Data */
-		cmd.reg_count = min_t(int, 64, fw->size - i);
+		cmd.reg_count = min_t(uint, 64, fw->size - i);
 		memcpy(cmd.buffer.block_data, &fw->data[i], cmd.reg_count);
 		cpia2_send_command(cam, &cmd);
 	}
