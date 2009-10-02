Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:64039 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZJBLrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 07:47:24 -0400
Date: Fri, 2 Oct 2009 13:47:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>
Subject: IR device at I2C address 0x7a
Message-ID: <20091002134722.61abbd48@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

[Executive summary: Upmost Purple TV adapter testers wanted!]

While investigating another issue, I have noticed the following message
in the kernel logs of a saa7134 user:

i2c-adapter i2c-0: Invalid 7-bit address 0x7a

The address in question is attempted by an IR device probe, and is only
probed on SAA7134 adapters. The problem with this address is that it is
reserved by the I2C specification for 10-bit addressing, and is thus
not a valid 7-bit address. Before the conversion of ir-kbd-i2c to the
new-style i2c device driver binding model, device probing was done by
ir-kbd-i2c itself so no check was done by i2c-core for address
validity. But since kernel 2.6.31, probing at address 0x7a will be
denied by i2c-core.

So, SAA7134 adapters with an IR device at 0x7a are currently broken.
Do we know how many devices use this address for IR and which they
are? Tracking the changes in the source code, this address was added
in kernel 2.6.8 by Gerd Knorr:
  http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=581f0d1a0ded3e3d4408e5bb7f81b9ee221f6b7a
So this would be used by the "Upmost Purple TV" adapter. Question is,
are there other?

Some web research has pointed me to the Yuan TUN-900:
  http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023405.html
but it isn't clear to me whether the device at 0x7a on this adapter is
the same as the one on the Purple TV. And saa7134-cards says of the
TUN-900: "Remote control not yet implemented" so maybe we can just
ignore it for now.

If we have to, I could make i2c-core more permissive, but I am rather
reluctant to letting invalid addressed being probed, because you never
know how complying chips on the I2C bus will react. I am OK supporting
invalid addresses if they really exist out there, but the impact should
be limited to the hardware in question.

If we only have to care about the Upmost Purple TV, then the following
patch should solve the problem:

* * * * *

From: Jean Delvare <khali@linux-fr.org>
Subject: saa7134: Fix IR support for Purple TV

The i2c core prevents us from probing I2C address 0x7a because it's
not a valid 7-bit address (reserved for 10-bit addressing.) So we must
stop probing this address, and explicitly list all adapters which use
it. Under the assumption that only the Upmost Purple TV adapter uses
this invalid address, this fix should do the trick.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/saa7134/saa7134-input.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-10-02 13:26:39.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-10-02 13:26:49.000000000 +0200
@@ -746,7 +746,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	const unsigned short addr_list[] = {
-		0x7a, 0x47, 0x71, 0x2d,
+		0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
 	};
 
@@ -813,6 +813,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 		dev->init_data.name = "Purple TV";
 		dev->init_data.get_key = get_key_purpletv;
 		dev->init_data.ir_codes = &ir_codes_purpletv_table;
+		info.addr = 0x7a;
 #endif
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:


-- 
Jean Delvare
