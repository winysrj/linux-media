Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33614 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751894AbdF2JBe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 05:01:34 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] cx23885: add const to v4l2_file_operations structure
Date: Thu, 29 Jun 2017 14:29:19 +0530
Message-Id: <1498726759-11552-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare v4l2_file_operations structure as const as it is only stored
in the fops field of video_device structure. This field is of type
const, so declare v4l2_file_operations structures with similar properties
as const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-417.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 2ff1d1e..a71f3c7 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1416,7 +1416,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 	return 0;
 }
 
-static struct v4l2_file_operations mpeg_fops = {
+static const struct v4l2_file_operations mpeg_fops = {
 	.owner	       = THIS_MODULE,
 	.open           = v4l2_fh_open,
 	.release        = vb2_fop_release,
-- 
2.7.4
