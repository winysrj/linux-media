Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1413 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaHTW7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 28/29] v4l2-ioctl: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:27 +0200
Message-Id: <1408575568-20562-29-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/v4l2-core/v4l2-ioctl.c:1156:53: warning: incorrect type in initializer (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:1158:42: warning: incorrect type in initializer (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:1161:34: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:1163:35: warning: incorrect type in assignment (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d15e167..46f4c04 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1153,9 +1153,9 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY: {
-		struct v4l2_clip *clips = p->fmt.win.clips;
+		struct v4l2_clip __user *clips = p->fmt.win.clips;
 		u32 clipcount = p->fmt.win.clipcount;
-		void *bitmap = p->fmt.win.bitmap;
+		void __user *bitmap = p->fmt.win.bitmap;
 
 		memset(&p->fmt, 0, sizeof(p->fmt));
 		p->fmt.win.clips = clips;
-- 
2.1.0.rc1

