Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56500 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbaGEIwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jul 2014 04:52:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3720A2A1FCF
	for <linux-media@vger.kernel.org>; Sat,  5 Jul 2014 10:51:55 +0200 (CEST)
Message-ID: <53B7BCAB.6090402@xs4all.nl>
Date: Sat, 05 Jul 2014 10:51:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] hdpvr: fix reported HDTV colorspace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The colorspace for HDTV is REC709, not SMPTE240M.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0500c417..f379e50 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -1029,7 +1029,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
 		f->fmt.pix.field = V4L2_FIELD_INTERLACED;
 	} else {
 		/* HDTV formats */
-		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE240M;
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 		f->fmt.pix.field = V4L2_FIELD_NONE;
 	}
 	return 0;
