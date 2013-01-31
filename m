Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1179 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab3AaKZw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/18] tlg2300: fix querycap
Date: Thu, 31 Jan 2013 11:25:29 +0100
Message-Id: <1e895ca6d25da9d6af707d661eefcf73d215d569.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-video.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 312809a..8ab2894 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -142,17 +142,23 @@ static int get_audio_std(v4l2_std_id v4l2_std)
 static int vidioc_querycap(struct file *file, void *fh,
 			struct v4l2_capability *cap)
 {
+	struct video_device *vdev = video_devdata(file);
+	struct poseidon *p = video_get_drvdata(vdev);
 	struct front_face *front = fh;
-	struct poseidon *p = front->pd;
 
 	logs(front);
 
 	strcpy(cap->driver, "tele-video");
 	strcpy(cap->card, "Telegent Poseidon");
 	usb_make_path(p->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
-				V4L2_CAP_AUDIO | V4L2_CAP_STREAMING |
-				V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
+	cap->device_caps = V4L2_CAP_TUNER | V4L2_CAP_AUDIO |
+			V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	if (vdev->vfl_type == VFL_TYPE_VBI)
+		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
+	else
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
+		V4L2_CAP_RADIO | V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE;
 	return 0;
 }
 
-- 
1.7.10.4

