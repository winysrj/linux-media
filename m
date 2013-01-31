Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2878 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3AaKZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 13/18] tlg2300: fix missing audioset.
Date: Thu, 31 Jan 2013 11:25:31 +0100
Message-Id: <be96cdafc8e99572c58eeb92c14081705335aa0a.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index da7cbd4..122f299 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -903,7 +903,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
 	 * the audio input index mixed with this video input,
 	 * Poseidon only have one audio/video, set to "0"
 	 */
-	in->audioset	= 0;
+	in->audioset	= 1;
 	in->tuner	= 0;
 	in->std		= V4L2_STD_ALL;
 	in->status	= 0;
-- 
1.7.10.4

