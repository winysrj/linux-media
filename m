Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37930 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab1EXNLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 09:11:52 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LLP00L3PB88MR@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 May 2011 14:09:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLP001X8B87HC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 May 2011 14:09:43 +0100 (BST)
Date: Tue, 24 May 2011 15:09:35 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/3] v4l: add g_tvnorms callback to V4L2 subdev
In-reply-to: <1306242576-24458-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Message-id: <1306242576-24458-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1306242576-24458-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Callback is used to acquire TV norms supported by a subdev.
It is used to avoid having standards in top-level driver.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-subdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1562c4f..4206e97 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -261,6 +261,7 @@ struct v4l2_subdev_video_ops {
 	int (*s_crystal_freq)(struct v4l2_subdev *sd, u32 freq, u32 flags);
 	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
 	int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
+	int (*g_tvnorms)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
-- 
1.7.5.1

