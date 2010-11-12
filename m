Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab0KLWjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 17:39:00 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACMd0Ut017109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 17:39:00 -0500
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oACMcxbQ016160
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 17:39:00 -0500
Date: Fri, 12 Nov 2010 17:38:59 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR: allow disabling NEC checksum check, enable apple remote
Message-ID: <20101112223859.GA8205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In strict NEC extended IR protocol, a 32-bit signal consists of address,
not address, command and not command, and checksums are performed
between these two pairs of components. Currently, our NEC protocol
decoder strictly enforces these checks, and only uses 24 bits (address,
not address and command) to do scancode to keycode lookups. However,
there are remotes out there using a variant of the NEC protocol, which
assigns different meaning to some of these bits, without using any
checksums.

The test case here is Apple's remotes, which send a two-byte vendor
code instead of address/not address, a pairing ID byte, and a command
byte instead of command/not command.

For further details on the Apple remotes, see:
  http://en.wikipedia.org/wiki/Apple_Remote

If we make it possible to bypass the checksum checks and use the full
32 bits for scancode lookups, the current NEC decoder can successfully
successfully decode and match keys from these remotes, as well as any
others that might employ similar alternate bit meanings.

In the Apple case, we can simply match the vendor code and auto-skip the
checksum checks. For other remotes, we can bypass the checksum by
handing a modparam to the NEC decoder, unless of course we figure out
some other means by which to determine if its a signal for which we
should skip checksumming, and/or develop something cleaner, and/or
decide to only warn (in debug mode) when checksum checks fail.

An Apple keytable using the full 32 bits is included. Existing NEC
extended remotes should continue to fuction with their current 24-bit
tables, but we *could* decide in the future to simplify things and just
use the full 32 bits for all NEC extended (ish) remotes.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ir-nec-decoder.c       |   40 ++++++++++++++++++++----
 drivers/media/rc/keymaps/Makefile       |    1 +
 drivers/media/rc/keymaps/rc-nec-apple.c |   51 +++++++++++++++++++++++++++++++
 include/media/rc-map.h                  |    1 +
 4 files changed, 86 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-nec-apple.c

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 8ff157a..abe9b4d 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -28,6 +28,16 @@
 #define	NEC_TRAILER_SPACE	(10 * NEC_UNIT) /* even longer in reality */
 #define NECX_REPEAT_BITS	1
 
+static bool csum = true;
+module_param(csum, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(csum, "Whether or not to perform NEC chucksum checks "
+		 "(default: true)");
+
+static bool pair;
+module_param(pair, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(pair, "Whether or not the Apple Pairing ID byte should "
+		 "be evaluated for scancode lookups (default: false)");
+
 enum nec_state {
 	STATE_INACTIVE,
 	STATE_HEADER_SPACE,
@@ -49,6 +59,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
 	u8 address, not_address, command, not_command;
+	bool checksum = csum;
 
 	if (!(dev->raw->enabled_protocols & IR_TYPE_NEC))
 		return 0;
@@ -157,22 +168,37 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		command	    = bitrev8((data->bits >>  8) & 0xff);
 		not_command = bitrev8((data->bits >>  0) & 0xff);
 
-		if ((command ^ not_command) != 0xff) {
+		if ((address == 0xee) && (not_address == 0x87)) {
+			IR_dprintk(1, "Apple remote detected, pair ID 0x%02x\n",
+				   not_command);
+			checksum = false;
+			/* We have a default non-paired keymap using 0x00 */
+			if (!pair)
+				not_command = 0x00;
+		}
+
+		if (checksum && ((command ^ not_command) != 0xff)) {
 			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
 				   data->bits);
 			break;
 		}
 
-		if ((address ^ not_address) != 0xff) {
-			/* Extended NEC */
+		if (checksum && ((address ^ not_address) == 0xff)) {
+			/* Normal NEC */
+			scancode = address << 8 | command;
+			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
+		} else if (!checksum) {
+			/* Extended NEC, no checksum */
+			scancode = address << 24 | not_address << 16 |
+				   command <<  8 | not_command;
+			IR_dprintk(1, "NEC (Ext, no csum) scancode 0x%08x\n",
+				   scancode);
+		} else {
+			/* Extended NEC, standard */
 			scancode = address     << 16 |
 				   not_address <<  8 |
 				   command;
 			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
-		} else {
-			/* Normal NEC */
-			scancode = address << 8 | command;
-			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
 		}
 
 		if (data->is_nec_x)
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 3194d39..8fa0e53 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-msi-tvanywhere.o \
 			rc-msi-tvanywhere-plus.o \
 			rc-nebula.o \
+			rc-nec-apple.o \
 			rc-nec-terratec-cinergy-xs.o \
 			rc-norwood.o \
 			rc-npgtech.o \
diff --git a/drivers/media/rc/keymaps/rc-nec-apple.c b/drivers/media/rc/keymaps/rc-nec-apple.c
new file mode 100644
index 0000000..7450280
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-nec-apple.c
@@ -0,0 +1,51 @@
+/* rc-nec-apple.c - Keytable for Apple Remote Controls
+ *
+ * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct ir_scancode nec_apple[] = {
+	{ 0xee870002, KEY_MENU},
+	{ 0xee870003, KEY_MENU},
+	{ 0xee870004, KEY_PLAYPAUSE},
+	{ 0xee870005, KEY_PLAYPAUSE},
+	{ 0xee870006, KEY_FORWARD},
+	{ 0xee870007, KEY_FORWARD},
+	{ 0xee870008, KEY_BACK},
+	{ 0xee870009, KEY_BACK},
+	{ 0xee87000a, KEY_VOLUMEUP},
+	{ 0xee87000b, KEY_VOLUMEUP},
+	{ 0xee87000c, KEY_VOLUMEDOWN},
+	{ 0xee87000d, KEY_VOLUMEDOWN},
+};
+
+static struct rc_keymap nec_apple_map = {
+	.map = {
+		.scan    = nec_apple,
+		.size    = ARRAY_SIZE(nec_apple),
+		.ir_type = IR_TYPE_NEC,
+		.name    = RC_MAP_NEC_APPLE,
+	}
+};
+
+static int __init init_rc_map_nec_apple(void)
+{
+	return ir_register_map(&nec_apple_map);
+}
+
+static void __exit exit_rc_map_nec_apple(void)
+{
+	ir_unregister_map(&nec_apple_map);
+}
+
+module_init(init_rc_map_nec_apple)
+module_exit(exit_rc_map_nec_apple)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e0f17ed..2cdc523 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -110,6 +110,7 @@ void rc_map_init(void);
 #define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
 #define RC_MAP_MSI_TVANYWHERE            "rc-msi-tvanywhere"
 #define RC_MAP_NEBULA                    "rc-nebula"
+#define RC_MAP_NEC_APPLE                 "rc-nec-apple"
 #define RC_MAP_NEC_TERRATEC_CINERGY_XS   "rc-nec-terratec-cinergy-xs"
 #define RC_MAP_NORWOOD                   "rc-norwood"
 #define RC_MAP_NPGTECH                   "rc-npgtech"
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

