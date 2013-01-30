Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4612 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3A3R4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:56:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] bw-qcam: remove unnecessary qc_reset and qc_setscanmode calls.
Date: Wed, 30 Jan 2013 18:56:44 +0100
Message-Id: <23fade6a5bdd704121c550a0defd3dadbf838675.1359568453.git.hans.verkuil@cisco.com>
In-Reply-To: <1359568604-27876-1-git-send-email-hverkuil@xs4all.nl>
References: <1359568604-27876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <08f9f5df663bb92eec55c1a5bcfb26c820c2ed8a.1359568453.git.hans.verkuil@cisco.com>
References: <08f9f5df663bb92eec55c1a5bcfb26c820c2ed8a.1359568453.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are already done elsewhere.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/parport/bw-qcam.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index d3fe34f..06231b8 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -421,8 +421,6 @@ static void qc_set(struct qcam *q)
 	int val;
 	int val2;
 
-	qc_reset(q);
-
 	/* Set the brightness.  Yes, this is repetitive, but it works.
 	 * Shorter versions seem to fail subtly.  Feel free to try :-). */
 	/* I think the problem was in qc_command, not here -- bls */
@@ -879,10 +877,8 @@ static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = -EINVAL;
 		break;
 	}
-	if (ret == 0) {
-		qc_setscanmode(qcam);
+	if (ret == 0)
 		qcam->status |= QC_PARAM_CHANGE;
-	}
 	return ret;
 }
 
-- 
1.7.10.4

