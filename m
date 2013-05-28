Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4458 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab3E1I2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 04:28:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: leo@lumanate.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/3] hdpvr: fix querystd 'unknown format' return.
Date: Tue, 28 May 2013 10:27:52 +0200
Message-Id: <1369729674-1802-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369729674-1802-1-git-send-email-hverkuil@xs4all.nl>
References: <1369729674-1802-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If no format has been detected, then querystd should return V4L2_STD_UNKNOWN,
not V4L2_STD_ALL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 2d02b49..81018c4 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -613,7 +613,7 @@ static int vidioc_querystd(struct file *file, void *_fh, v4l2_std_id *a)
 	struct hdpvr_fh *fh = _fh;
 	int ret;
 
-	*a = V4L2_STD_ALL;
+	*a = V4L2_STD_UNKNOWN;
 	if (dev->options.video_input == HDPVR_COMPONENT)
 		return fh->legacy_mode ? 0 : -ENODATA;
 	ret = get_video_info(dev, &vid_info);
-- 
1.7.10.4

