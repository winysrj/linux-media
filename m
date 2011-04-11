Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50193 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1DKM3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 08:29:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LJH00LMFMPCB180@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Apr 2011 13:29:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJH00HNUMPBCF@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Apr 2011 13:29:35 +0100 (BST)
Date: Mon, 11 Apr 2011 14:29:23 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/3] v4l: add g_tvnorms callback to V4L2 subdev
In-reply-to: <1302524964-31407-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1302524964-31407-3-git-send-email-t.stanislaws@samsung.com>
References: <1302524964-31407-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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
1.7.4.3
