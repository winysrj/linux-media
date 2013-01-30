Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2039 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3A3Oyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 09:54:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/6] radio-miropcm20: fix signal and stereo indication.
Date: Wed, 30 Jan 2013 15:54:04 +0100
Message-Id: <581ac0cef5a2416ccce014551f75eebeaaf16f5a.1359557431.git.hans.verkuil@cisco.com>
In-Reply-To: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
References: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
References: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-miropcm20.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index eb6cd86..3d0ff44 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -82,6 +82,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
 	struct pcm20 *dev = video_drvdata(file);
+	int res;
 
 	if (v->index)
 		return -EINVAL;
@@ -89,8 +90,13 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = 87*16000;
 	v->rangehigh = 108*16000;
-	v->signal = 0xffff;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+	res = snd_aci_cmd(dev->aci, ACI_READ_TUNERSTATION, -1, -1);
+	v->signal = (res & 0x80) ? 0 : 0xffff;
+	/* Note: stereo detection does not work if the audio is muted,
+	   it will default to mono in that case. */
+	res = snd_aci_cmd(dev->aci, ACI_READ_TUNERSTEREO, -1, -1);
+	v->rxsubchans = (res & 0x40) ? V4L2_TUNER_SUB_MONO :
+					V4L2_TUNER_SUB_STEREO;
 	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 	v->audmode = dev->audmode;
 	return 0;
-- 
1.7.10.4

