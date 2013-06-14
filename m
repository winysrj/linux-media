Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:51291 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3FNN7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 09:59:43 -0400
Received: by mail-qe0-f53.google.com with SMTP id 1so328243qee.12
        for <linux-media@vger.kernel.org>; Fri, 14 Jun 2013 06:59:43 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] Don't call G_TUNER unless actually performing a tuning related call
Date: Fri, 14 Jun 2013 09:59:26 -0400
Message-Id: <1371218366-16081-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Making G_TUNER calls can take a long time on some tuners, in
particular those that load firmware or do power management.  As a
result, we don't want to call G_TUNER unless the user is actually
doing a tuning related call.  The current code makes a G_TUNER
call regardless of what command the user is attempting to perform.

Problem originally identified on the HVR-950q, where even doing
operations like toggling from the composite to the s-video input
would take over 1000ms.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 utils/v4l2-ctl/v4l2-ctl-tuner.cpp | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-tuner.cpp b/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
index ebe74d3..9af6b13 100644
--- a/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
@@ -254,6 +254,13 @@ void tuner_set(int fd)
 		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	double fac = 16;
 
+	if (!options[OptSetFreq] && ! options[OptSetTuner] && !options[OptListFreqBands]
+	    && !options[OptSetModulator] && !options[OptFreqSeek]) {
+		/* Don't actually call G_[MODULATOR/TUNER] if we don't intend to
+		   actually perform any tuner related function */
+		return;
+	}
+
 	if (capabilities & V4L2_CAP_MODULATOR) {
 		type = V4L2_TUNER_RADIO;
 		modulator.index = tuner_index;
-- 
1.8.1.2

