Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1983 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2JBGsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 02:48:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] v4l2-ioctl: add blocks check for VIDIOC_SUBDEV_G/S_EDID
Date: Tue,  2 Oct 2012 08:47:58 +0200
Message-Id: <10d7f0ff3a151454cd7cf21e59333544e40fc577.1349160401.git.hans.verkuil@cisco.com>
In-Reply-To: <1349160479-5314-1-git-send-email-hverkuil@xs4all.nl>
References: <1349160479-5314-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The maximum size of an EDID is 32768 bytes, which is 32768 / 128 = 256 blocks.

Return -EINVAL if blocks > 256 to ensure that the memory allocation is sane.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 9d3e46c..a9af6f8 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2211,6 +2211,10 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 		struct v4l2_subdev_edid *edid = parg;
 
 		if (edid->blocks) {
+			if (edid->blocks > 256) {
+				ret = -EINVAL;
+				break;
+			}
 			*user_ptr = (void __user *)edid->edid;
 			*kernel_ptr = (void *)&edid->edid;
 			*array_size = edid->blocks * 128;
-- 
1.7.10.4

