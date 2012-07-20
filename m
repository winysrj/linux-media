Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35810 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2GTNqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 09:46:54 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] davinci: vpbe: fix build error when CONFIG_VIDEO_ADV_DEBUG is enabled
Date: Fri, 20 Jul 2012 19:16:38 +0530
Message-ID: <1342791998-11398-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Fix build error when CONFIG_VIDEO_ADV_DEBUG is enabled,
declare the vpbe_dev variable.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpbe_display.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index f78ccc0..6fe7034 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -1517,6 +1517,8 @@ static int vpbe_display_g_register(struct file *file, void *priv,
 			struct v4l2_dbg_register *reg)
 {
 	struct v4l2_dbg_match *match = &reg->match;
+	struct vpbe_fh *fh = file->private_data;
+	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 
 	if (match->type >= 2) {
 		v4l2_subdev_call(vpbe_dev->venc,
-- 
1.7.0.4

