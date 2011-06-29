Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30330 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1F2Mv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:51:58 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ009BTYEGZV@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:53 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ00LHOYEF4Q@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:51 +0100 (BST)
Date: Wed, 29 Jun 2011 14:51:11 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/8] v4l: add g_tvnorms_output callback to V4L2 subdev
In-reply-to: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1309351877-32444-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Callback is used to acquire TV norms supported by a subdev.
It is used to avoid having standards in top-level driver.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 include/media/v4l2-subdev.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1562c4f..476fcdd 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -225,6 +225,9 @@ struct v4l2_subdev_audio_ops {
    s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
 	video input devices.
 
+   g_tvnorms_output: get v4l2_std_id with all standards supported by video
+	OUTPUT device. This is ignored by video input devices.
+
    s_crystal_freq: sets the frequency of the crystal used to generate the
 	clocks in Hz. An extra flags field allows device specific configuration
 	regarding clock frequency dividers, etc. If not used, then set flags
@@ -261,6 +264,7 @@ struct v4l2_subdev_video_ops {
 	int (*s_crystal_freq)(struct v4l2_subdev *sd, u32 freq, u32 flags);
 	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
 	int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
+	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
-- 
1.7.5.4

