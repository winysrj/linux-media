Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:60263 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbcGFHgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2016 03:36:45 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6B00E180C71
	for <linux-media@vger.kernel.org>; Wed,  6 Jul 2016 09:36:39 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: set V4L2_CAP_TIMEPERFRAME
Message-ID: <3ba975f7-f8eb-c27b-7a57-cd35ef797b15@xs4all.nl>
Date: Wed, 6 Jul 2016 09:36:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vivid driver didn't set the V4L2_CAP_TIMEPERFRAME flag in s_parm for the
non-webcam inputs. This caused a v4l2-compliance fail.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index fdca33f..568330a 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1835,6 +1835,7 @@ int vivid_vid_cap_s_parm(struct file *file, void *priv,
 	/* resync the thread's timings */
 	dev->cap_seq_resync = true;
 	dev->timeperframe_vid_cap = tpf;
+	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
 	parm->parm.capture.timeperframe = tpf;
 	parm->parm.capture.readbuffers  = 1;
 	return 0;
