Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:36826 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaLILrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 06:47:18 -0500
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH] v4l2-ctl: Remove file entry from Android.mk
Date: Tue,  9 Dec 2014 12:47:12 +0100
Message-Id: <1418125632-69086-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

v4l2-ctl-test-patterns.cpp is removed, but still listed in Android.mk.
---
 utils/v4l2-ctl/Android.mk |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-ctl/Android.mk b/utils/v4l2-ctl/Android.mk
index bbd151a..2f0e5b4 100644
--- a/utils/v4l2-ctl/Android.mk
+++ b/utils/v4l2-ctl/Android.mk
@@ -19,7 +19,6 @@ LOCAL_SRC_FILES := \
     v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cpp \
     v4l2-ctl-io.cpp v4l2-ctl-stds.cpp v4l2-ctl-vidcap.cpp v4l2-ctl-vidout.cpp \
     v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
-    v4l2-ctl-streaming.cpp v4l2-ctl-test-patterns.cpp v4l2-ctl-sdr.cpp \
-    v4l2-ctl-edid.cpp vivid-tpg-colors.c vivid-tpg.c
-
+    v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp vivid-tpg-colors.c \
+    vivid-tpg.c
 include $(BUILD_EXECUTABLE)
-- 
1.7.5

