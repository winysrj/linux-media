Return-path: <mchehab@pedra>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:35119 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581Ab1DDUTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 16:19:00 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 4/5] tm6000: add kernel module desciption
Date: Mon,  4 Apr 2011 22:18:43 +0200
Message-Id: <1301948324-27186-4-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

add kernel module desciption


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/README |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/README b/drivers/staging/tm6000/README
index c340ebc..48e8d9b 100644
--- a/drivers/staging/tm6000/README
+++ b/drivers/staging/tm6000/README
@@ -1,3 +1,43 @@
+tm6000
+======
+
+You will only use analogue tv, you must additionally load tm6000_alsa. 
+You will only use digital tv, you must additionally load tm6000_dvb.
+For both must load tm6000, tm6000_alsa and tm6000_dvb.
+
+Kernel module parameter:
+
+tm6000
+------
+debug:
+i2c_debug:
+ir_debug:
+card : see CARDLIST
+enable_ir: enable infrared
+    0 -> disable
+    1 -> enable (default)
+tm6010_a_mode: set audio mode (tm6010 only)
+    0 -> auto
+    1 -> A2
+    2 -> NICAM
+    3 -> BTSC
+    etc.
+xc2028_mts: enable mts firmware (xc2028/3028 only)
+    0 -> disable (default)
+    1 -> enable mts firmware
+xc2028_dtv78: set dualband (xc2028/3028 only)
+    0 -> singleband/auto (default) i.e. dtv7 only
+    1 -> dualband
+
+tm6000_alsa
+-----------
+debug: enable debug information
+
+tm6000_dvb
+----------
+debug: enable debug information
+
+
 Todo:
 	- Fix the loss of some blocks when receiving the video URB's
 	- Add a lock at tm6000_read_write_usb() to prevent two simultaneous access to the
-- 
1.7.3.4

