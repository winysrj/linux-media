Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2752 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3EZN1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 21/24] v4l2-int-device: remove unused chip_ident reference.
Date: Sun, 26 May 2013 15:27:16 +0200
Message-Id: <1369574839-6687-22-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-int-device.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index e6aa231..0286c95 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -220,8 +220,6 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_reset_num,
 	/* VIDIOC_INT_INIT */
 	vidioc_int_init_num,
-	/* VIDIOC_DBG_G_CHIP_IDENT */
-	vidioc_int_g_chip_ident_num,
 
 	/*
 	 *
@@ -303,6 +301,5 @@ V4L2_INT_WRAPPER_1(enum_frameintervals, struct v4l2_frmivalenum, *);
 
 V4L2_INT_WRAPPER_0(reset);
 V4L2_INT_WRAPPER_0(init);
-V4L2_INT_WRAPPER_1(g_chip_ident, int, *);
 
 #endif
-- 
1.7.10.4

