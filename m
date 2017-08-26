Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32997 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdHZLOZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:14:25 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, ismael@iodev.co.uk,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 5/5] [media] tw68:  make video_device const
Date: Sat, 26 Aug 2017 16:43:34 +0530
Message-Id: <1503746014-16489-6-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
References: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/tw68/tw68-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 58c4dd7..8c1f4a0 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -916,7 +916,7 @@ static int vidioc_s_register(struct file *file, void *priv,
 #endif
 };
 
-static struct video_device tw68_video_template = {
+static const struct video_device tw68_video_template = {
 	.name			= "tw68_video",
 	.fops			= &video_fops,
 	.ioctl_ops		= &video_ioctl_ops,
-- 
1.9.1
