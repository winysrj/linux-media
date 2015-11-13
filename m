Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:51181 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbbKMOBg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 09:01:36 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 24CC2E3567
	for <linux-media@vger.kernel.org>; Fri, 13 Nov 2015 15:01:32 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-pci-skeleton.c: forgot to update v4l2_match_dv_timings
 call
Message-ID: <5645ED3C.10307@xs4all.nl>
Date: Fri, 13 Nov 2015 15:01:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing new argument to v4l2_match_dv_timings() in this skeleton driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 95ae828..1c8b102 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -509,7 +509,7 @@ static int skeleton_s_dv_timings(struct file *file, void *_fh,
 		return -EINVAL;
 
 	/* Return 0 if the new timings are the same as the current timings. */
-	if (v4l2_match_dv_timings(timings, &skel->timings, 0))
+	if (v4l2_match_dv_timings(timings, &skel->timings, 0, false))
 		return 0;
 
 	/*
