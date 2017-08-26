Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34713 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754632AbdHZLNy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:13:54 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, ismael@iodev.co.uk,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/5] [media] meye:  make video_device const
Date: Sat, 26 Aug 2017 16:43:30 +0530
Message-Id: <1503746014-16489-2-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
References: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/meye/meye.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 0fe76be..49e047e 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1533,7 +1533,7 @@ static int meye_mmap(struct file *file, struct vm_area_struct *vma)
 	.vidioc_default		= vidioc_default,
 };
 
-static struct video_device meye_template = {
+static const struct video_device meye_template = {
 	.name		= "meye",
 	.fops		= &meye_fops,
 	.ioctl_ops 	= &meye_ioctl_ops,
-- 
1.9.1
