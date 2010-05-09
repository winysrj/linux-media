Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1580 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0EIT1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:27:52 -0400
Received: from localhost (cm-84.208.87.21.getinternet.no [84.208.87.21])
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id o49JRoev037521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 May 2010 21:27:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <3c0e23e743fdd08545613d56229a122d128358ba.1273432986.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273432986.git.hverkuil@xs4all.nl>
References: <cover.1273432986.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 21:29:26 +0200
Subject: [PATCH 7/7] [RFC] ivtv: add priority checks for the non-standard commands.
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ivtv/ivtv-ioctl.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index c532b77..de392a2 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1777,7 +1777,25 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 
 static long ivtv_default(struct file *file, void *fh, int cmd, void *arg)
 {
-	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
+	struct ivtv_open_id *id = fh2id(fh);
+	struct ivtv *itv = id->itv;
+	int ret;
+
+	switch (cmd) {
+	case VIDEO_PLAY:
+	case VIDEO_STOP:
+	case VIDEO_FREEZE:
+	case VIDEO_CONTINUE:
+	case VIDEO_COMMAND:
+	case VIDEO_SELECT_SOURCE:
+	case AUDIO_SET_MUTE:
+	case AUDIO_CHANNEL_SELECT:
+	case AUDIO_BILINGUAL_CHANNEL_SELECT:
+		ret = v4l2_prio_check(&itv->v4l2_dev.prio, id->fh.prio);
+		if (ret)
+			return ret;
+		break;
+	}
 
 	switch (cmd) {
 	case VIDIOC_INT_RESET: {
-- 
1.6.4.2

