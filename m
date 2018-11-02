Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45882 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeKCIKc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2018 04:10:32 -0400
From: Derek Kelly <user.vdr@gmail.com>
To: linux-input@vger.kernel.org
Cc: sean@mess.org, mchehab+samsung@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH] Input: Add missing event codes for common IR remote buttons
Date: Fri,  2 Nov 2018 16:00:04 -0700
Message-Id: <20181102230004.29285-1-user.vdr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch adds event codes for common buttons found on various
provider and universal remote controls. They represent functions not
covered by existing event codes. Once added, rc_keymaps can be updated
accordingly where applicable.

Signed-off-by: Derek Kelly <user.vdr@gmail.com>
---
 include/uapi/linux/input-event-codes.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index 53fbae27b280..c68d022163e5 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -689,6 +689,19 @@
 #define BTN_TRIGGER_HAPPY39		0x2e6
 #define BTN_TRIGGER_HAPPY40		0x2e7
 
+/* Remote control buttons found across provider & universal remotes */
+#define KEY_LIVE_TV			0x2e8	/* Jump to live tv viewing */
+#define KEY_OPTIONS			0x2e9	/* Jump to options */
+#define KEY_INTERACTIVE			0x2ea	/* Jump to interactive system/menu/item */
+#define KEY_MIC_INPUT			0x2eb	/* Trigger MIC input/listen mode */
+#define KEY_SCREEN_INPUT		0x2ec	/* Open on-screen input system */
+#define KEY_SYSTEM			0x2ed	/* Open systems menu/display */
+#define KEY_SERVICES			0x2ee	/* Open services menu/display */
+#define KEY_DISPLAY_FORMAT		0x2ef	/* Cycle display formats */
+#define KEY_PIP				0x2f0	/* Toggle Picture-in-Picture on/off */
+#define KEY_PIP_SWAP			0x2f1	/* Swap contents between main view and PIP window */
+#define KEY_PIP_POSITION		0x2f2	/* Cycle PIP window position */
+
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
 #define KEY_MAX			0x2ff
-- 
2.19.1
