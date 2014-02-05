Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60060 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaBEIy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 03:54:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/9] v4l: add enum_freq_bands support to tuner sub-device
Date: Wed,  5 Feb 2014 10:54:38 +0200
Message-Id: <1391590480-2146-7-git-send-email-crope@iki.fi>
In-Reply-To: <1391590480-2146-1-git-send-email-crope@iki.fi>
References: <1391590480-2146-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add VIDIOC_ENUM_FREQ_BANDS, enumerate supported frequency bands,
IOCTL support for sub-device tuners too.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/media/v4l2-subdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d67210a..4682aad 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -192,6 +192,7 @@ struct v4l2_subdev_tuner_ops {
 	int (*s_radio)(struct v4l2_subdev *sd);
 	int (*s_frequency)(struct v4l2_subdev *sd, const struct v4l2_frequency *freq);
 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
+	int (*enum_freq_bands)(struct v4l2_subdev *sd, struct v4l2_frequency_band *band);
 	int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
 	int (*s_tuner)(struct v4l2_subdev *sd, const struct v4l2_tuner *vt);
 	int (*g_modulator)(struct v4l2_subdev *sd, struct v4l2_modulator *vm);
-- 
1.8.5.3

