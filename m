Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3591 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3AaKZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/18] tlg2300: embed video_device instead of allocating it.
Date: Thu, 31 Jan 2013 11:25:23 +0100
Message-Id: <6c7743bffce7a3cb8ea7b6c6f2ae92e79e81dcf4.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-common.h |    2 +-
 drivers/media/usb/tlg2300/pd-radio.c  |   20 ++++++--------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
index 5dd73b7..3a89128 100644
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -118,7 +118,7 @@ struct radio_data {
 	int		users;
 	unsigned int	is_radio_streaming;
 	int		pre_emphasis;
-	struct video_device *fm_dev;
+	struct video_device fm_dev;
 };
 
 #define DVB_SBUF_NUM		4
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 4c76e089..719c3da 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -369,31 +369,23 @@ static struct video_device poseidon_fm_template = {
 	.name       = "Telegent-Radio",
 	.fops       = &poseidon_fm_fops,
 	.minor      = -1,
-	.release    = video_device_release,
+	.release    = video_device_release_empty,
 	.ioctl_ops  = &poseidon_fm_ioctl_ops,
 };
 
 int poseidon_fm_init(struct poseidon *p)
 {
-	struct video_device *fm_dev;
-	int err;
+	struct video_device *vfd = &p->radio_data.fm_dev;
 
-	fm_dev = vdev_init(p, &poseidon_fm_template);
-	if (fm_dev == NULL)
-		return -ENOMEM;
+	*vfd = poseidon_fm_template;
+	vfd->v4l2_dev	= &p->v4l2_dev;
+	video_set_drvdata(vfd, p);
 
-	p->radio_data.fm_dev = fm_dev;
 	set_frequency(p, TUNER_FREQ_MIN_FM);
-	err = video_register_device(fm_dev, VFL_TYPE_RADIO, -1);
-	if (err < 0) {
-		video_device_release(fm_dev);
-		return err;
-	}
-	return 0;
+	return video_register_device(vfd, VFL_TYPE_RADIO, -1);
 }
 
 int poseidon_fm_exit(struct poseidon *p)
 {
-	destroy_video_device(&p->radio_data.fm_dev);
 	return 0;
 }
-- 
1.7.10.4

