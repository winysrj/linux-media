Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34320 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754796AbcHVJFN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:05:13 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so12447596wma.1
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 02:05:13 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCHv2 3/4] pulse8-cec: add notes about behavior in autonomous mode
Date: Mon, 22 Aug 2016 11:04:53 +0200
Message-Id: <1471856694-14182-4-git-send-email-jaffe1@gmail.com>
In-Reply-To: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
References: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pulse8 dongle has some quirky behaviors when in autonomous mode.
Document these.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 37c8418..aa679a3 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -10,6 +10,29 @@
  * this archive for more details.
  */
 
+/*
+ * Notes:
+ *
+ * - Devices with firmware version < 2 do not store their configuration in
+ *   EEPROM.
+ *
+ * - In autonomous mode, only messages from a TV will be acknowledged, even
+ *   polling messages. Upon receiving a message from a TV, the dongle will
+ *   respond to messages from any logical address.
+ *
+ * - In autonomous mode, the dongle will by default reply Feature Abort
+ *   [Unrecognized Opcode] when it receives Give Device Vendor ID. It will
+ *   however observe vendor ID's reported by other devices and possibly
+ *   alter this behavior. When TV's (and TV's only) report that their vendor ID
+ *   is LG (0x00e091), the dongle will itself reply that it has the same vendor
+ *   ID, and it will respond to at least one vendor specific command.
+ *
+ * - In autonomous mode, the dongle is known to attempt wakeup if it receives
+ *   <User Control Pressed> ["Power On"], ["Power] or ["Power Toggle"], or if it
+ *   receives <Set Stream Path> with its own physical address. It also does this
+ *   if it receives <Vendor Specific Command> [0x03 0x00] from an LG TV.
+ */
+
 #include <linux/completion.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-- 
2.7.4

