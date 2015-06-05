Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:32841 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbbFEILe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 04:11:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] v4l2-ioctl: clear the reserved field of v4l2_create_buffers
Date: Fri,  5 Jun 2015 10:11:14 +0200
Message-Id: <1433491875-42608-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433491875-42608-1-git-send-email-hverkuil@xs4all.nl>
References: <1433491875-42608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This field was never cleared by the kernel making future extensions
hard to implement. Clear it now.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 368bc3a..8ffc89a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1804,6 +1804,8 @@ static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 	if (ret)
 		return ret;
 
+	CLEAR_AFTER_FIELD(create, format);
+
 	v4l_sanitize_format(&create->format);
 
 	ret = ops->vidioc_create_bufs(file, fh, create);
-- 
2.1.4

