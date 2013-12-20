Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38519 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3LTFuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 00:50:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v5 08/12] v4l: do not allow modulator ioctls for non-radio devices
Date: Fri, 20 Dec 2013 07:49:50 +0200
Message-Id: <1387518594-11609-9-git-send-email-crope@iki.fi>
In-Reply-To: <1387518594-11609-1-git-send-email-crope@iki.fi>
References: <1387518594-11609-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Modulator ioctls could be enabled mistakenly for non-radio devices.
Currently those ioctls are only valid for radio. Fix it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 84b2a84..db76b0a 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -562,6 +562,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	const struct v4l2_ioctl_ops *ops = vdev->ioctl_ops;
 	bool is_vid = vdev->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
+	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
 	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
@@ -735,8 +736,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
 		SET_VALID_IOCTL(ops, VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap);
 	}
-	if (is_tx) {
-		/* transmitter only ioctls */
+	if (is_tx && (is_radio || is_sdr)) {
+		/* radio transmitter only ioctls */
 		SET_VALID_IOCTL(ops, VIDIOC_G_MODULATOR, vidioc_g_modulator);
 		SET_VALID_IOCTL(ops, VIDIOC_S_MODULATOR, vidioc_s_modulator);
 	}
-- 
1.8.4.2

