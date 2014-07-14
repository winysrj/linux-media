Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2586 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbaGNM7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/12] v4l2-ioctl.c: fix enum_freq_bands handling
Date: Mon, 14 Jul 2014 14:59:11 +0200
Message-Id: <1405342752-46998-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
References: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the driver supports enum_freq_bands, but only for certain device
nodes, then it may return -ENOTTY. But in that case the code should
fall into the fall-back case where the current tuner/modulator range
is returned.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 45e2ffa..afed070 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1979,8 +1979,11 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 		if (type != p->type)
 			return -EINVAL;
 	}
-	if (ops->vidioc_enum_freq_bands)
-		return ops->vidioc_enum_freq_bands(file, fh, p);
+	if (ops->vidioc_enum_freq_bands) {
+		err = ops->vidioc_enum_freq_bands(file, fh, p);
+		if (err != -ENOTTY)
+			return err;
+	}
 	if (is_valid_ioctl(vfd, VIDIOC_G_TUNER)) {
 		struct v4l2_tuner t = {
 			.index = p->tuner,
-- 
2.0.1

