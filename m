Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4336 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2CaJS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 05:18:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.4] Fix ivtv AUDIO_(BILINGUAL_)CHANNEL_SELECT regression
Date: Sat, 31 Mar 2012 11:18:19 +0200
Cc: Martin Dauskardt <martin.dauskardt@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203311118.19446.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

When I converted ivtv to the new decoder API I introduced a regression in the
support of the old channel select API. The patch below fixes this.

Thanks to Martin Dauskardt for reporting this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 5452bee..989e556 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1763,13 +1763,13 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		IVTV_DEBUG_IOCTL("AUDIO_CHANNEL_SELECT\n");
 		if (iarg > AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
-		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg);
+		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg + 1);
 
 	case AUDIO_BILINGUAL_CHANNEL_SELECT:
 		IVTV_DEBUG_IOCTL("AUDIO_BILINGUAL_CHANNEL_SELECT\n");
 		if (iarg > AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
-		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg);
+		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg + 1);
 
 	default:
 		return -EINVAL;
