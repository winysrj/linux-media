Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:52549 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbcAFVSC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 16:18:02 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH] v4l-utils: mc_nextgen_test renable ALSA interfaces
Date: Wed,  6 Jan 2016 14:17:59 -0700
Message-Id: <1452115079-6040-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ALSA interfaces were disable with #if 0. Renable
them.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 contrib/test/mc_nextgen_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/contrib/test/mc_nextgen_test.c b/contrib/test/mc_nextgen_test.c
index 14a0917..7d0344b 100644
--- a/contrib/test/mc_nextgen_test.c
+++ b/contrib/test/mc_nextgen_test.c
@@ -184,7 +184,6 @@ static inline const char *intf_type(uint32_t intf_type)
 		return "v4l2-subdev";
 	case MEDIA_INTF_T_V4L_SWRADIO:
 		return "swradio";
-#if 0
 	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
 		return "pcm-capture";
 	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
@@ -197,7 +196,6 @@ static inline const char *intf_type(uint32_t intf_type)
 		return "rawmidi";
 	case MEDIA_INTF_T_ALSA_HWDEP:
 		return "hwdep";
-#endif
 	default:
 		return "unknown_intf";
 	}
-- 
2.5.0

