Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:52863 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbbJTX1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 19:27:31 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH] v4l-utils: mc_nextgen_test add ALSA capture, playback, and mixer
Date: Tue, 20 Oct 2015 17:27:29 -0600
Message-Id: <1445383649-7848-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for ALSA capture, playback, and mixer entity functions.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 contrib/test/mc_nextgen_test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/contrib/test/mc_nextgen_test.c b/contrib/test/mc_nextgen_test.c
index e287096..e0d0ad2 100644
--- a/contrib/test/mc_nextgen_test.c
+++ b/contrib/test/mc_nextgen_test.c
@@ -227,6 +227,12 @@ static inline const char *ent_function(uint32_t function)
 		return "ATV decoder";
 	case MEDIA_ENT_F_TUNER:
 		return "tuner";
+	case MEDIA_ENT_F_AUDIO_CAPTURE:
+		return "Audio Capture";
+	case MEDIA_ENT_F_AUDIO_PLAYBACK:
+		return "Audio Playback";
+	case MEDIA_ENT_F_AUDIO_MIXER:
+		return "Audio Mixer";
 	case MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN:
 	default:
 		return "unknown entity type";
-- 
2.1.4

