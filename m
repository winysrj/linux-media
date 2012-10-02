Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:39393 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2JBI5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 04:57:34 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 1/3] s5p-g2d: fix compiler warning
Date: Tue,  2 Oct 2012 10:57:18 +0200
Message-Id: <760bdb23b40b9ce3a8044a3379510889db4bfcf7.1349168132.git.hans.verkuil@cisco.com>
In-Reply-To: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
References: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/s5p-g2d/g2d.c:535:2: warning: passing argument 3 of 'vidioc_try_crop' discards 'const' qualifier from pointer target type [enabled by default]
drivers/media/platform/s5p-g2d/g2d.c:510:12: note: expected 'struct v4l2_crop *' but argument is of type 'const struct v4l2_crop *'

This is fall-out from this commit:

commit 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Wed Sep 5 05:10:48 2012 -0300

    [media] v4l2: make vidioc_s_crop const

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-g2d/g2d.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 1e3b9dd..1bfbc32 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -507,7 +507,7 @@ static int vidioc_g_crop(struct file *file, void *prv, struct v4l2_crop *cr)
 	return 0;
 }
 
-static int vidioc_try_crop(struct file *file, void *prv, struct v4l2_crop *cr)
+static int vidioc_try_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_dev *dev = ctx->dev;
-- 
1.7.10.4

