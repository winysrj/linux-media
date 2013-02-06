Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2468 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3BFP4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 17/17] bttv: fix g_tuner capabilities override.
Date: Wed,  6 Feb 2013 16:56:35 +0100
Message-Id: <4e112a3426fef3083a3c42b4de5db739238b786d.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The capability field of v4l2_tuner should be ORed by the various subdevs
and by the main driver. In this case the stereo capability was dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/tvaudio.c           |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index e3b33b7..4c91b35 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1803,7 +1803,7 @@ static int tvaudio_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 
 	vt->audmode = chip->audmode;
 	vt->rxsubchans = desc->getrxsubchans(chip);
-	vt->capability = V4L2_TUNER_CAP_STEREO |
+	vt->capability |= V4L2_TUNER_CAP_STEREO |
 		V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
 
 	return 0;
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 98b8fd2..0492fff 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2787,9 +2787,9 @@ static int bttv_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	t->rxsubchans = V4L2_TUNER_SUB_MONO;
+	t->capability = V4L2_TUNER_CAP_NORM;
 	bttv_call_all(btv, tuner, g_tuner, t);
 	strcpy(t->name, "Television");
-	t->capability = V4L2_TUNER_CAP_NORM;
 	t->type       = V4L2_TUNER_ANALOG_TV;
 	if (btread(BT848_DSTATUS)&BT848_DSTATUS_HLOC)
 		t->signal = 0xffff;
-- 
1.7.10.4

