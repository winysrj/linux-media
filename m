Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3288 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2EJHFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 03:05:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/5] tea575x-tuner: mark VIDIOC_S_HW_FREQ_SEEK as an invalid ioctl.
Date: Thu, 10 May 2012 09:05:12 +0200
Message-Id: <c1bd86921cf9aba29d8edfc30712e9d39fb3dd87.1336632433.git.hans.verkuil@cisco.com>
In-Reply-To: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl>
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0f97ebe03ff17602c7a62e8a6a16414f1f897270.1336632433.git.hans.verkuil@cisco.com>
References: <0f97ebe03ff17602c7a62e8a6a16414f1f897270.1336632433.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The tea575x-tuner framework can support the VIDIOC_S_HW_FREQ_SEEK for only
some of the tea575x-based boards. Mark this ioctl as invalid if the board
doesn't support it.

This fixes an issue with S_HW_FREQ_SEEK in combination with priority handling:
since the priority check is done first it could return -EBUSY, even though
calling the S_HW_FREQ_SEEK ioctl would return -ENOTTY. It should always return
ENOTTY in such a case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 sound/i2c/other/tea575x-tuner.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index a63faec..6e9ca7b 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -375,6 +375,9 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 	tea->vd.v4l2_dev = tea->v4l2_dev;
 	tea->vd.ctrl_handler = &tea->ctrl_handler;
 	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
+	/* disable hw_freq_seek if we can't use it */
+	if (tea->cannot_read_data)
+		v4l2_dont_use_cmd(&tea->vd, VIDIOC_S_HW_FREQ_SEEK);
 
 	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
 	v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops, V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
-- 
1.7.10

