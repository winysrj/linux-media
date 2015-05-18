Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35757 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbbERN3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 09:29:23 -0400
Message-ID: <5559E92D.5040302@xs4all.nl>
Date: Mon, 18 May 2015 15:29:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Andy Walls <awalls@md.metrocast.net>, dan.carpenter@oracle.com
Subject: [PATCH] ivtv: fix incorrect audio mode report in log_status
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The log_status ioctl should report if the audio input has mode Bilingual. However, the
check against the itv->dualwatch_stereo_mode is completely wrong and is a left-over from
the distant past. Not only is the bitmask obviously wrong, the test itself is broken too
since itv->dualwatch_stereo_mode is no longer a bitmask at all.

Fix this code properly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 10c31cd..9a21c17 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1531,7 +1531,8 @@ static int ivtv_log_status(struct file *file, void *fh)
 	ivtv_get_audio_input(itv, itv->audio_input, &audin);
 	IVTV_INFO("Video Input:  %s\n", vidin.name);
 	IVTV_INFO("Audio Input:  %s%s\n", audin.name,
-		(itv->dualwatch_stereo_mode & ~0x300) == 0x200 ? " (Bilingual)" : "");
+		itv->dualwatch_stereo_mode == V4L2_MPEG_AUDIO_MODE_DUAL ?
+			" (Bilingual)" : "");
 	if (has_output) {
 		struct v4l2_output vidout;
 		struct v4l2_audioout audout;
