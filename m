Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4754 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab2APM3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 07:29:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/3] v4l2-ctrls: fix ugly control name.
Date: Mon, 16 Jan 2012 13:29:18 +0100
Message-Id: <4f4e18b94612a34be98e2304a4d9b0cef74acd39.1326716517.git.hans.verkuil@cisco.com>
In-Reply-To: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index da1f4c2..35316f9 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -588,7 +588,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_PILOT_TONE_ENABLED:	return "Pilot Tone Feature Enabled";
 	case V4L2_CID_PILOT_TONE_DEVIATION:	return "Pilot Tone Deviation";
 	case V4L2_CID_PILOT_TONE_FREQUENCY:	return "Pilot Tone Frequency";
-	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-emphasis settings";
+	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-Emphasis";
 	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
 
-- 
1.7.7.3

