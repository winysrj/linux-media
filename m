Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcGRSar (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 07/18] [media] cx2341x.rst: add the contents of fw-calling.txt
Date: Mon, 18 Jul 2016 15:30:29 -0300
Message-Id: <d9b8a3f099d9a8b76393da271278d3bd88c0e9ed.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add its contents at this file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx2341x.rst      | 75 ++++++++++++++++++++++++
 Documentation/video4linux/cx2341x/fw-calling.txt | 69 ----------------------
 2 files changed, 75 insertions(+), 69 deletions(-)
 delete mode 100644 Documentation/video4linux/cx2341x/fw-calling.txt

diff --git a/Documentation/media/v4l-drivers/cx2341x.rst b/Documentation/media/v4l-drivers/cx2341x.rst
index 2677ac6fd649..cbfa14eccd76 100644
--- a/Documentation/media/v4l-drivers/cx2341x.rst
+++ b/Documentation/media/v4l-drivers/cx2341x.rst
@@ -1,6 +1,81 @@
 The cx2341x driver
 ==================
 
+How to call the firmware API
+----------------------------
+
+The preferred calling convention is known as the firmware mailbox. The
+mailboxes are basically a fixed length array that serves as the call-stack.
+
+Firmware mailboxes can be located by searching the encoder and decoder memory
+for a 16 byte signature. That signature will be located on a 256-byte boundary.
+
+Signature:
+
+.. code-block:: none
+
+	0x78, 0x56, 0x34, 0x12, 0x12, 0x78, 0x56, 0x34,
+	0x34, 0x12, 0x78, 0x56, 0x56, 0x34, 0x12, 0x78
+
+The firmware implements 20 mailboxes of 20 32-bit words. The first 10 are
+reserved for API calls. The second 10 are used by the firmware for event
+notification.
+
+  ====== =================
+  Index  Name
+  ====== =================
+  0      Flags
+  1      Command
+  2      Return value
+  3      Timeout
+  4-19   Parameter/Result
+  ====== =================
+
+
+The flags are defined in the following table. The direction is from the
+perspective of the firmware.
+
+  ==== ========== ============================================
+  Bit  Direction  Purpose
+  ==== ========== ============================================
+  2    O          Firmware has processed the command.
+  1    I          Driver has finished setting the parameters.
+  0    I          Driver is using this mailbox.
+  ==== ========== ============================================
+
+The command is a 32-bit enumerator. The API specifics may be found in this
+chapter.
+
+The return value is a 32-bit enumerator. Only two values are currently defined:
+
+- 0=success
+- -1=command undefined.
+
+There are 16 parameters/results 32-bit fields. The driver populates these fields
+with values for all the parameters required by the call. The driver overwrites
+these fields with result values returned by the call.
+
+The timeout value protects the card from a hung driver thread. If the driver
+doesn't handle the completed call within the timeout specified, the firmware
+will reset that mailbox.
+
+To make an API call, the driver iterates over each mailbox looking for the
+first one available (bit 0 has been cleared). The driver sets that bit, fills
+in the command enumerator, the timeout value and any required parameters. The
+driver then sets the parameter ready bit (bit 1). The firmware scans the
+mailboxes for pending commands, processes them, sets the result code, populates
+the result value array with that call's return values and sets the call
+complete bit (bit 2). Once bit 2 is set, the driver should retrieve the results
+and clear all the flags. If the driver does not perform this task within the
+time set in the timeout register, the firmware will reset that mailbox.
+
+Event notifications are sent from the firmware to the host. The host tells the
+firmware which events it is interested in via an API call. That call tells the
+firmware which notification mailbox to use. The firmware signals the host via
+an interrupt. Only the 16 Results fields are used, the Flags, Command, Return
+value and Timeout words are not used.
+
+
 Encoder firmware API description
 --------------------------------
 
diff --git a/Documentation/video4linux/cx2341x/fw-calling.txt b/Documentation/video4linux/cx2341x/fw-calling.txt
deleted file mode 100644
index 8d21181de537..000000000000
--- a/Documentation/video4linux/cx2341x/fw-calling.txt
+++ /dev/null
@@ -1,69 +0,0 @@
-This page describes how to make calls to the firmware api.
-
-How to call
-===========
-
-The preferred calling convention is known as the firmware mailbox. The
-mailboxes are basically a fixed length array that serves as the call-stack.
-
-Firmware mailboxes can be located by searching the encoder and decoder memory
-for a 16 byte signature. That signature will be located on a 256-byte boundary.
-
-Signature:
-0x78, 0x56, 0x34, 0x12, 0x12, 0x78, 0x56, 0x34,
-0x34, 0x12, 0x78, 0x56, 0x56, 0x34, 0x12, 0x78
-
-The firmware implements 20 mailboxes of 20 32-bit words. The first 10 are
-reserved for API calls. The second 10 are used by the firmware for event
-notification.
-
-  Index  Name
-  -----  ----
-  0      Flags
-  1      Command
-  2      Return value
-  3      Timeout
-  4-19   Parameter/Result
-
-
-The flags are defined in the following table. The direction is from the
-perspective of the firmware.
-
-  Bit  Direction  Purpose
-  ---  ---------  -------
-  2    O          Firmware has processed the command.
-  1    I          Driver has finished setting the parameters.
-  0    I          Driver is using this mailbox.
-
-
-The command is a 32-bit enumerator. The API specifics may be found in the
-fw-*-api.txt documents.
-
-The return value is a 32-bit enumerator. Only two values are currently defined:
-0=success and -1=command undefined.
-
-There are 16 parameters/results 32-bit fields. The driver populates these fields
-with values for all the parameters required by the call. The driver overwrites
-these fields with result values returned by the call. The API specifics may be
-found in the fw-*-api.txt documents.
-
-The timeout value protects the card from a hung driver thread. If the driver
-doesn't handle the completed call within the timeout specified, the firmware
-will reset that mailbox.
-
-To make an API call, the driver iterates over each mailbox looking for the
-first one available (bit 0 has been cleared). The driver sets that bit, fills
-in the command enumerator, the timeout value and any required parameters. The
-driver then sets the parameter ready bit (bit 1). The firmware scans the
-mailboxes for pending commands, processes them, sets the result code, populates
-the result value array with that call's return values and sets the call
-complete bit (bit 2). Once bit 2 is set, the driver should retrieve the results
-and clear all the flags. If the driver does not perform this task within the
-time set in the timeout register, the firmware will reset that mailbox.
-
-Event notifications are sent from the firmware to the host. The host tells the
-firmware which events it is interested in via an API call. That call tells the
-firmware which notification mailbox to use. The firmware signals the host via
-an interrupt. Only the 16 Results fields are used, the Flags, Command, Return
-value and Timeout words are not used.
-
-- 
2.7.4


