Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33863 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbcCDPyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 10:54:44 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
	linux-media@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] v4l2-mc.h: fix build failure
Date: Fri,  4 Mar 2016 21:24:13 +0530
Message-Id: <1457106853-10969-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are getting build failure with arm for configurations like
exynos_defconfig, at91_dt_defconfig where MEDIA_CONTROLLER is not
defined.
While adding stubs static inline was missed and an extra ';' was added.

Fixes: a77bf7048add ("v4l2-mc.h: Add stubs for the V4L2 PM/pipeline routines")
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---

build logs at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/113601228
and
https://travis-ci.org/sudipm-mukherjee/parport/jobs/113601203

 include/media/v4l2-mc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 96cfca9..6096e63 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -229,13 +229,13 @@ static inline int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 	return 0;
 }
 
-int v4l2_pipeline_pm_use(struct media_entity *entity, int use);
+static inline int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
 {
 	return 0;
 }
 
-int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
-			      unsigned int notification);
+static inline int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
+			      unsigned int notification)
 {
 	return 0;
 }
-- 
1.9.1

