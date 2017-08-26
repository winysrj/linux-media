Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35526 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdHZLOR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:14:17 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, ismael@iodev.co.uk,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 4/5] [media] sta2x11: make video_device const
Date: Sat, 26 Aug 2017 16:43:33 +0530
Message-Id: <1503746014-16489-5-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
References: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 6343d24..eb5a9ea 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -754,7 +754,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static struct video_device video_dev_template = {
+static const struct video_device video_dev_template = {
 	.name = KBUILD_MODNAME,
 	.release = video_device_release_empty,
 	.fops = &vip_fops,
-- 
1.9.1
