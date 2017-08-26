Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36070 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754709AbdHZKVn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:21:43 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, hverkuil@xs4all.nl,
        corbet@lwn.net, kyungmin.park@samsung.com, kamil@wypas.org,
        a.hajda@samsung.com, bparrot@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 09/10] [media] m2m-deinterlace: make video_device const
Date: Sat, 26 Aug 2017 15:50:11 +0530
Message-Id: <1503742812-16139-10-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
References: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/m2m-deinterlace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 98f6db2..c8a1249 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -979,7 +979,7 @@ static int deinterlace_mmap(struct file *file, struct vm_area_struct *vma)
 	.mmap		= deinterlace_mmap,
 };
 
-static struct video_device deinterlace_videodev = {
+static const struct video_device deinterlace_videodev = {
 	.name		= MEM2MEM_NAME,
 	.fops		= &deinterlace_fops,
 	.ioctl_ops	= &deinterlace_ioctl_ops,
-- 
1.9.1
