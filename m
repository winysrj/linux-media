Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1418 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaGUHOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 03:14:53 -0400
Message-ID: <53CCBDE6.7090907@xs4all.nl>
Date: Mon, 21 Jul 2014 09:14:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH for v3.17] v4l2-ioctl: set V4L2_CAP_EXT_PIX_FORMAT for device_caps
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CAP_EXT_PIX_FORMAT is set for capabilities, but it needs to be set for
device_caps as well: device_caps should report all caps relevant to the
device node, and this is one of them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e620387..00ceedf 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1014,6 +1014,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 	ret = ops->vidioc_querycap(file, fh, cap);
 
 	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
+	cap->device_caps |= V4L2_CAP_EXT_PIX_FORMAT;
 
 	return ret;
 }
