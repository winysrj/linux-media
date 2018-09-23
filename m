Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32808 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbeIWWdY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Sep 2018 18:33:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id y18-v6so4824286pge.0
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2018 09:35:20 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 4/6] media: vivid: use V4L2_FRACT_COMPARE
Date: Mon, 24 Sep 2018 01:34:50 +0900
Message-Id: <1537720492-31201-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the equivalent of FRACT_CMP() is added in v4l2 common internal API
header.

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- New patch

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
