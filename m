Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37255 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbcGDIfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 11/14] cx18: use v4l2_g/s_ctrl instead of the g/s_ctrl ops.
Date: Mon,  4 Jul 2016 10:35:07 +0200
Message-Id: <1467621310-8203-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These ops are deprecated and should not be used anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-alsa-mixer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c b/drivers/media/pci/cx18/cx18-alsa-mixer.c
index 341bddc..2842752 100644
--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
+++ b/drivers/media/pci/cx18/cx18-alsa-mixer.c
@@ -93,7 +93,7 @@ static int snd_cx18_mixer_tv_vol_get(struct snd_kcontrol *kctl,
 	vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
 
 	snd_cx18_lock(cxsc);
-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
+	ret = v4l2_g_ctrl(cx->sd_av->ctrl_handler, &vctrl);
 	snd_cx18_unlock(cxsc);
 
 	if (!ret)
@@ -115,14 +115,14 @@ static int snd_cx18_mixer_tv_vol_put(struct snd_kcontrol *kctl,
 	snd_cx18_lock(cxsc);
 
 	/* Fetch current state */
-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
+	ret = v4l2_g_ctrl(cx->sd_av->ctrl_handler, &vctrl);
 
 	if (ret ||
 	    (cx18_av_vol_to_dB(vctrl.value) != uctl->value.integer.value[0])) {
 
 		/* Set, if needed */
 		vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-		ret = v4l2_subdev_call(cx->sd_av, core, s_ctrl, &vctrl);
+		ret = v4l2_s_ctrl(cx->sd_av->ctrl_handler, &vctrl);
 		if (!ret)
 			ret = 1; /* Indicate control was changed w/o error */
 	}
-- 
2.8.1

