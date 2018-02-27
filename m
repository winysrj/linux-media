Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39915 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752930AbeB0OAc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 09:00:32 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: lirc does not use LIRC_CAN_SEND_SCANCODE feature
Date: Tue, 27 Feb 2018 14:00:30 +0000
Message-Id: <20180227140030.16265-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 02d742f4b209 ("media: lirc: lirc daemon fails to detect raw
IR device"), the feature LIRC_CAN_SEND_SCANCODE is no longer used as it
tripped up lircd. The ability to send scancodes for IR Tx is implied by
LIRC_CAN_SEND_PULSE (i.e. any device that can send can use IR Tx encoders).

So, remove LIRC_CAN_SEND_SCANCODE since it never used. This fixes:

Documentation/output/lirc.h.rst:6: WARNING: undefined label:
lirc-can-send-scancode (if the link has no caption the label must precede
a section header

Signed-off-by: Sean Young <sean@mess.org>
---
 include/uapi/linux/lirc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 4fe580d36e41..f5bf06ecd87d 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -54,7 +54,6 @@
 #define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
 #define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
 #define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
-#define LIRC_CAN_SEND_SCANCODE         LIRC_MODE2SEND(LIRC_MODE_SCANCODE)
 #define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
 
 #define LIRC_CAN_SEND_MASK             0x0000003f
-- 
2.14.3
