Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38718 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754194AbdHZKUg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:20:36 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, hverkuil@xs4all.nl,
        corbet@lwn.net, kyungmin.park@samsung.com, kamil@wypas.org,
        a.hajda@samsung.com, bparrot@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 01/10] [media] cx88: make video_device const
Date: Sat, 26 Aug 2017 15:50:03 +0530
Message-Id: <1503742812-16139-2-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
References: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only passed to the const argument of the
function cx88_vdev_init.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index aa49c95..e3101f0 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1075,7 +1075,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 };
 
-static struct video_device cx8802_mpeg_template = {
+static const struct video_device cx8802_mpeg_template = {
 	.name                 = "cx8802",
 	.fops                 = &mpeg_fops,
 	.ioctl_ops	      = &mpeg_ioctl_ops,
-- 
1.9.1
