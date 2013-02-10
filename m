Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2689 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3BJMuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 09/19] bttv: fill in fb->flags for VIDIOC_G_FBUF
Date: Sun, 10 Feb 2013 13:50:04 +0100
Message-Id: <ebd98b7519e0dad743ac84a8c6bac5d28ec93aa8.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 70878e6..81886e1 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2769,6 +2769,7 @@ static int bttv_g_fbuf(struct file *file, void *f,
 
 	*fb = btv->fbuf;
 	fb->capability = V4L2_FBUF_CAP_LIST_CLIPPING;
+	fb->flags = V4L2_FBUF_FLAG_PRIMARY;
 	if (fh->ovfmt)
 		fb->fmt.pixelformat  = fh->ovfmt->fourcc;
 	return 0;
-- 
1.7.10.4

