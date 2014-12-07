Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:48224 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbaLGO7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 09:59:50 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id BC5152A0083
	for <linux-media@vger.kernel.org>; Sun,  7 Dec 2014 15:59:42 +0100 (CET)
Message-ID: <54846B5E.90901@xs4all.nl>
Date: Sun, 07 Dec 2014 15:59:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-ioctl: WARN_ON if querycap didn't fill device_caps
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is easy to forget to do in drivers. While v4l2-compliance will check for it,
not everyone remembers to run it. So warn about it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7565871..faac2f4 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1017,6 +1017,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 	ret = ops->vidioc_querycap(file, fh, cap);
 
 	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
+	/*
+	 * Drivers MUST fill in device_caps, so check for this and
+	 * warn if it was forgotten.
+	 */
+	WARN_ON(!(cap->capabilities & V4L2_CAP_DEVICE_CAPS) ||
+		!cap->device_caps);
 	cap->device_caps |= V4L2_CAP_EXT_PIX_FORMAT;
 
 	return ret;
