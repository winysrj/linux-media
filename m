Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44148 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbeJTWhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 18:37:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id w3-v6so1475308pgs.11
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 07:26:52 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v4 4/6] media: vivid: use V4L2_FRACT_COMPARE
Date: Sat, 20 Oct 2018 23:26:26 +0900
Message-Id: <1540045588-9091-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the equivalent of FRACT_CMP() is added in v4l2 common internal API
header.

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v4
- No changes from v3

 drivers/media/platform/vivid/vivid-vid-cap.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 1599159..f19c701 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1824,9 +1824,6 @@ int vivid_vid_cap_g_parm(struct file *file, void *priv,
 	return 0;
 }
 
-#define FRACT_CMP(a, OP, b)	\
-	((u64)(a).numerator * (b).denominator  OP  (u64)(b).numerator * (a).denominator)
-
 int vivid_vid_cap_s_parm(struct file *file, void *priv,
 			  struct v4l2_streamparm *parm)
 {
@@ -1847,14 +1844,14 @@ int vivid_vid_cap_s_parm(struct file *file, void *priv,
 	if (tpf.denominator == 0)
 		tpf = webcam_intervals[ival_sz - 1];
 	for (i = 0; i < ival_sz; i++)
-		if (FRACT_CMP(tpf, >=, webcam_intervals[i]))
+		if (V4L2_FRACT_COMPARE(tpf, >=, webcam_intervals[i]))
 			break;
 	if (i == ival_sz)
 		i = ival_sz - 1;
 	dev->webcam_ival_idx = i;
 	tpf = webcam_intervals[dev->webcam_ival_idx];
-	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
-	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
+	tpf = V4L2_FRACT_COMPARE(tpf, <, tpf_min) ? tpf_min : tpf;
+	tpf = V4L2_FRACT_COMPARE(tpf, >, tpf_max) ? tpf_max : tpf;
 
 	/* resync the thread's timings */
 	dev->cap_seq_resync = true;
-- 
2.7.4
