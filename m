Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2552 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3LSJDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 04:03:06 -0500
Message-ID: <52B2B627.2090302@xs4all.nl>
Date: Thu, 19 Dec 2013 10:02:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v4 6/7] v4l: enable some IOCTLs for SDR receiver
References: <1387425606-7458-1-git-send-email-crope@iki.fi> <1387425606-7458-7-git-send-email-crope@iki.fi>
In-Reply-To: <1387425606-7458-7-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/19/2013 05:00 AM, Antti Palosaari wrote:
> Enable stream format (FMT) IOCTLs for SDR use. These are used for negotiate
> used data stream format.
> 
> Reorganise some some IOCTL selection logic.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c   | 21 ++++++++++++++++++---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 3 deletions(-)
> 

Can you add this patch to your patch series? Or fold it into your patch 6/7, that's
fine too.

It fixes a small bug I found (not yours, it was there already) where the modulator
ioctls could be enabled for non-radio devices. Currently the modulator ioctls are
only valid for radio.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 2f0982f..bcfd33b 100644
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

