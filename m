Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:35761 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2GSMAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:00:55 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC PATCH 6/6] v4l2-dev: G_PARM was incorrectly enabled for all video nodes.
Date: Thu, 19 Jul 2012 14:00:24 +0200
Message-Id: <3397e353a24c32221363ba1438ab03364c08b8a9.1342699069.git.hans.verkuil@cisco.com>
In-Reply-To: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
References: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
References: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

G_PARM should only be enabled if:

- vidioc_g_parm is present
- or: it is a video node and vidioc_g_std or tvnorms are set.

Without this additional check v4l2-compliance would complain about
being able to use g_parm when it didn't expect it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index d13c47f..beadd97 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -697,7 +697,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd);
 	SET_VALID_IOCTL(ops, VIDIOC_DECODER_CMD, vidioc_decoder_cmd);
 	SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
-	if (ops->vidioc_g_parm || vdev->vfl_type == VFL_TYPE_GRABBER)
+	if (ops->vidioc_g_parm || (vdev->vfl_type == VFL_TYPE_GRABBER &&
+					(ops->vidioc_g_std || vdev->tvnorms)))
 		set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
 	SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
 	SET_VALID_IOCTL(ops, VIDIOC_G_TUNER, vidioc_g_tuner);
-- 
1.7.10

