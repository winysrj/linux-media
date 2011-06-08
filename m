Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34431 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1FHMDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 08:03:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LMH001NB0680E40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 13:03:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMH00GKJ067SM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 13:03:43 +0100 (BST)
Date: Wed, 08 Jun 2011 14:03:30 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/3] v4l: add g_tvnorms callback to V4L2 subdev
In-reply-to: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, mchehab@redhat.com
Message-id: <1307534611-32283-3-git-send-email-t.stanislaws@samsung.com>
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com>
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
1.7.5.4

