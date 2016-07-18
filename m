Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbcGRSau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Subject: [PATCH 15/18] [media] cx88.rst: add contents of hauppauge-wintv-cx88-ir.txt
Date: Mon, 18 Jul 2016 15:30:37 -0300
Message-Id: <f0d17227d7af495bf14c34e306c4e340488703c7.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Import the contents of hauppauge-wintv-cx88-ir.txt, after
converted to ReST into cx88.rst file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx88.rst           | 62 ++++++++++++++++++++++
 .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   | 54 -------------------
 .../video4linux/hauppauge-wintv-cx88-ir.txt        | 54 -------------------
 3 files changed, 62 insertions(+), 108 deletions(-)
 delete mode 100644 Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
 delete mode 100644 Documentation/video4linux/hauppauge-wintv-cx88-ir.txt

diff --git a/Documentation/media/v4l-drivers/cx88.rst b/Documentation/media/v4l-drivers/cx88.rst
index c89dbfa5f9d6..97865007f51f 100644
--- a/Documentation/media/v4l-drivers/cx88.rst
+++ b/Documentation/media/v4l-drivers/cx88.rst
@@ -98,3 +98,65 @@ MO_OUTPUT_FORMAT (0x310164)
 0x47 is the sync byte for MPEG-2 transport stream packets.
 Datasheet incorrectly states to use 47 decimal. 188 is the length.
 All DVB compliant frontends output packets with this start code.
+
+Hauppauge WinTV cx88 IR information
+-----------------------------------
+
+The controls for the mux are GPIO [0,1] for source, and GPIO 2 for muting.
+
+====== ======== =================================================
+GPIO0  GPIO1
+====== ======== =================================================
+  0        0    TV Audio
+  1        0    FM radio
+  0        1    Line-In
+  1        1    Mono tuner bypass or CD passthru (tuner specific)
+====== ======== =================================================
+
+GPIO 16(I believe) is tied to the IR port (if present).
+
+
+From the data sheet:
+
+- Register 24'h20004  PCI Interrupt Status
+ - bit [18]  IR_SMP_INT Set when 32 input samples have been collected over
+ - gpio[16] pin into GP_SAMPLE register.
+
+What's missing from the data sheet:
+
+- Setup 4KHz sampling rate (roughly 2x oversampled; good enough for our RC5
+  compat remote)
+- set register 0x35C050 to  0xa80a80
+- enable sampling
+- set register 0x35C054 to 0x5
+- enable the IRQ bit 18 in the interrupt mask register (and
+  provide for a handler)
+
+GP_SAMPLE register is at 0x35C058
+
+Bits are then right shifted into the GP_SAMPLE register at the specified
+rate; you get an interrupt when a full DWORD is received.
+You need to recover the actual RC5 bits out of the (oversampled) IR sensor
+bits. (Hint: look for the 0/1and 1/0 crossings of the RC5 bi-phase data)  An
+actual raw RC5 code will span 2-3 DWORDS, depending on the actual alignment.
+
+I'm pretty sure when no IR signal is present the receiver is always in a
+marking state(1); but stray light, etc can cause intermittent noise values
+as well.  Remember, this is a free running sample of the IR receiver state
+over time, so don't assume any sample starts at any particular place.
+
+Additional info
+~~~~~~~~~~~~~~~
+
+This data sheet (google search) seems to have a lovely description of the
+RC5 basics:
+http://www.atmel.com/dyn/resources/prod_documents/doc2817.pdf
+
+This document has more data:
+http://www.nenya.be/beor/electronics/rc5.htm
+
+This document has a  how to decode a bi-phase data stream:
+http://www.ee.washington.edu/circuit_archive/text/ir_decode.txt
+
+This document has still more info:
+http://www.xs4all.nl/~sbp/knowledge/ir/rc5.htm
diff --git a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt b/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
deleted file mode 100644
index f4329a38878e..000000000000
--- a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
+++ /dev/null
@@ -1,54 +0,0 @@
-The controls for the mux are GPIO [0,1] for source, and GPIO 2 for muting.
-
-GPIO0  GPIO1
-  0        0    TV Audio
-  1        0    FM radio
-  0        1    Line-In
-  1        1    Mono tuner bypass or CD passthru (tuner specific)
-
-GPIO 16(i believe) is tied to the IR port (if present).
-
-------------------------------------------------------------------------------------
-
->From the data sheet:
- Register 24'h20004  PCI Interrupt Status
-  bit [18]  IR_SMP_INT Set when 32 input samples have been collected over
-  gpio[16] pin into GP_SAMPLE register.
-
-What's missing from the data sheet:
-
-Setup 4KHz sampling rate (roughly 2x oversampled; good enough for our RC5
-compat remote)
-set register 0x35C050 to  0xa80a80
-
-enable sampling
-set register 0x35C054 to 0x5
-
-Of course, enable the IRQ bit 18 in the interrupt mask register .(and
-provide for a handler)
-
-GP_SAMPLE register is at 0x35C058
-
-Bits are then right shifted into the GP_SAMPLE register at the specified
-rate; you get an interrupt when a full DWORD is received.
-You need to recover the actual RC5 bits out of the (oversampled) IR sensor
-bits. (Hint: look for the 0/1and 1/0 crossings of the RC5 bi-phase data)  An
-actual raw RC5 code will span 2-3 DWORDS, depending on the actual alignment.
-
-I'm pretty sure when no IR signal is present the receiver is always in a
-marking state(1); but stray light, etc can cause intermittent noise values
-as well.  Remember, this is a free running sample of the IR receiver state
-over time, so don't assume any sample starts at any particular place.
-
-http://www.atmel.com/dyn/resources/prod_documents/doc2817.pdf
-This data sheet (google search) seems to have a lovely description of the
-RC5 basics
-
-http://www.nenya.be/beor/electronics/rc5.htm  and more data
-
-http://www.ee.washington.edu/circuit_archive/text/ir_decode.txt
-and even a reference to how to decode a bi-phase data stream.
-
-http://www.xs4all.nl/~sbp/knowledge/ir/rc5.htm
-still more info
-
diff --git a/Documentation/video4linux/hauppauge-wintv-cx88-ir.txt b/Documentation/video4linux/hauppauge-wintv-cx88-ir.txt
deleted file mode 100644
index a2fd363c40c8..000000000000
--- a/Documentation/video4linux/hauppauge-wintv-cx88-ir.txt
+++ /dev/null
@@ -1,54 +0,0 @@
-The controls for the mux are GPIO [0,1] for source, and GPIO 2 for muting.
-
-GPIO0  GPIO1
-  0        0    TV Audio
-  1        0    FM radio
-  0        1    Line-In
-  1        1    Mono tuner bypass or CD passthru (tuner specific)
-
-GPIO 16(i believe) is tied to the IR port (if present).
-
-------------------------------------------------------------------------------------
-
->From the data sheet:
- Register 24'h20004  PCI Interrupt Status
-  bit [18]  IR_SMP_INT Set when 32 input samples have been collected over
-  gpio[16] pin into GP_SAMPLE register.
-
-What's missing from the data sheet:
-
-Setup 4KHz sampling rate (roughly 2x oversampled; good enough for our RC5
-compat remote)
-set register 0x35C050 to  0xa80a80
-
-enable sampling
-set register 0x35C054 to 0x5
-
-Of course, enable the IRQ bit 18 in the interrupt mask register .(and
-provide for a handler)
-
-GP_SAMPLE register is at 0x35C058
-
-Bits are then right shifted into the GP_SAMPLE register at the specified
-rate; you get an interrupt when a full DWORD is received.
-You need to recover the actual RC5 bits out of the (oversampled) IR sensor
-bits. (Hint: look for the 0/1and 1/0 crossings of the RC5 bi-phase data)  An
-actual raw RC5 code will span 2-3 DWORDS, depending on the actual alignment.
-
-I'm pretty sure when no IR signal is present the receiver is always in a
-marking state(1); but stray light, etc can cause intermittent noise values
-as well.  Remember, this is a free running sample of the IR receiver state
-over time, so don't assume any sample starts at any particular place.
-
-http://www.atmel.com/dyn/resources/prod_documents/doc2817.pdf
-This data sheet (google search) seems to have a lovely description of the
-RC5 basics
-
-http://www.nenya.be/beor/electronics/rc5.htm and more data
-
-http://www.ee.washington.edu/circuit_archive/text/ir_decode.txt
-and even a reference to how to decode a bi-phase data stream.
-
-http://www.xs4all.nl/~sbp/knowledge/ir/rc5.htm
-still more info
-
-- 
2.7.4


