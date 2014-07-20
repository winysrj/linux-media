Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3223 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaGTNKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jul 2014 09:10:08 -0400
Message-ID: <53CBBFAB.6030907@xs4all.nl>
Date: Sun, 20 Jul 2014 15:10:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH for v3.17] v4l2-ioctl: don't set PRIV_MAGIC unconditionally
 in g_fmt()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Regression fix:

V4L2_PIX_FMT_PRIV_MAGIC should only be set for the VIDEO_CAPTURE and
VIDEO_OUTPUT buffer types, and not for any others. In the case of
the win format this overwrites a pointer value that is passed in from
userspace.

Since it is already set for the VIDEO_CAPTURE and VIDEO_OUTPUT cases
anyway this line can just be dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e620387..c11a13d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1143,8 +1143,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
 
-	p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
-
 	/*
 	 * fmt can't be cleared for these overlay types due to the 'clips'
 	 * 'clipcount' and 'bitmap' pointers in struct v4l2_window.
-- 
2.0.0

