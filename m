Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22100 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab1F2Mvy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:51:54 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ00LJZYEGE3@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ00JAQYEFY9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:51 +0100 (BST)
Date: Wed, 29 Jun 2011 14:51:12 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/8] v4l: add g_dv_preset callback to V4L2 subdev
In-reply-to: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1309351877-32444-4-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Callback is used to acquire current digital video preset from a subdev.
It is used to avoid keeping dv preset in top-level driver.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-subdev.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 476fcdd..af491a1 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -242,6 +242,8 @@ struct v4l2_subdev_audio_ops {
    s_dv_preset: set dv (Digital Video) preset in the sub device. Similar to
 	s_std()
 
+   g_dv_preset: get current dv (Digital Video) preset in the sub device.
+
    query_dv_preset: query dv preset in the sub device. This is similar to
 	querystd()
 
@@ -282,6 +284,8 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_enum_preset *preset);
 	int (*s_dv_preset)(struct v4l2_subdev *sd,
 			struct v4l2_dv_preset *preset);
+	int (*g_dv_preset)(struct v4l2_subdev *sd,
+			struct v4l2_dv_preset *preset);
 	int (*query_dv_preset)(struct v4l2_subdev *sd,
 			struct v4l2_dv_preset *preset);
 	int (*s_dv_timings)(struct v4l2_subdev *sd,
-- 
1.7.5.4

