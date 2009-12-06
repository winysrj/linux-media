Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbZLFAxi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Dec 2009 19:53:38 -0500
Message-ID: <4B1B0094.6080000@redhat.com>
Date: Sat, 05 Dec 2009 22:53:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: linux-media@vger.kernel.org
Subject: Re: [em28xx] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000000 IP: [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e
References: <255535957.20091206000510@eikelenboom.it>
In-Reply-To: <255535957.20091206000510@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sander Eikelenboom wrote:
> Hi All,
> 
> Tried to update my v4l-dvb modules today, but got a bug with my pinnacle card, seems to be related to the recent changes in the ir code.
> I have added dmesg output of the bug (changeset a871d61b614f tip), and dmesg output of the previous modules (working).
> 
> --
> Sander
> 
> Dec  5 23:30:25 security kernel: [    5.596128] em28xx: New device Pinnacle Systems GmbH PCTV USB2 PAL @ 480 Mbps (2304:0208, interface 0, class 0)
> Dec  5 23:30:25 security kernel: [    5.596535] em28xx #1: chip ID is em2820 (or em2710)
> Dec  5 23:30:25 security kernel: [    5.726154] em28xx #1: i2c eeprom 00: 1a eb 67 95 04 23 08 02 10 00 1e 03 98 1e 6a 2e
> Dec  5 23:30:25 security kernel: [    5.726181] em28xx #1: i2c eeprom 10: 00 00 06 57 6e 00 00 00 8e 00 00 00 07 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726203] em28xx #1: i2c eeprom 20: 16 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726226] em28xx #1: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726247] em28xx #1: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726270] em28xx #1: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726290] em28xx #1: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2e 03 50 00 69 00
> Dec  5 23:30:25 security kernel: [    5.726312] em28xx #1: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
> Dec  5 23:30:25 security kernel: [    5.726333] em28xx #1: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 20 00 47 00
> Dec  5 23:30:25 security kernel: [    5.726354] em28xx #1: i2c eeprom 90: 6d 00 62 00 48 00 00 00 1e 03 50 00 43 00 54 00
> Dec  5 23:30:25 security kernel: [    5.726376] em28xx #1: i2c eeprom a0: 56 00 20 00 55 00 53 00 42 00 32 00 20 00 50 00
> Dec  5 23:30:25 security kernel: [    5.726397] em28xx #1: i2c eeprom b0: 41 00 4c 00 00 00 06 03 31 00 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726420] em28xx #1: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726440] em28xx #1: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726461] em28xx #1: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec  5 23:30:25 security kernel: [    5.726484] em28xx #1: i2c eeprom f0: 00 00 00 00 00 00 00 00 07 56 d9 35 01 ed 0b f8
> Dec  5 23:30:25 security kernel: [    5.726506] em28xx #1: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x0fd77740
> Dec  5 23:30:25 security kernel: [    5.726513] em28xx #1: EEPROM info:
> Dec  5 23:30:25 security kernel: [    5.726517] em28xx #1:      AC97 audio (5 sample rates)
> Dec  5 23:30:25 security kernel: [    5.726522] em28xx #1:      500mA max power
> Dec  5 23:30:25 security kernel: [    5.726528] em28xx #1:      Table at 0x06, strings=0x1e98, 0x2e6a, 0x0000
> Dec  5 23:30:25 security kernel: [    5.726534] em28xx #1: Identified as Pinnacle PCTV USB 2 (card=3)
> Dec  5 23:30:25 security kernel: [    5.735698] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> Dec  5 23:30:25 security kernel: [    5.735716] IP: [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e
> Dec  5 23:30:25 security kernel: [    5.735736] PGD 1fdcb067 PUD 1f65d067 PMD 0 
> Dec  5 23:30:25 security kernel: [    5.735744] Oops: 0000 [1] SMP 
> Dec  5 23:30:25 security kernel: [    5.735750] CPU 0 
> Dec  5 23:30:25 security kernel: [    5.735754] Modules linked in: ir_kbd_i2c(+) saa7115 usbhid(+) hid ff_memless em28xx(+) v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 ir_common videobuf_vmalloc videobuf_core tveeprom i2c_core evdev ext3 jbd mbcache ohci_hcd ohci1394 ieee1394 ehci_hcd uhci_hcd thermal_sys
> Dec  5 23:30:25 security kernel: [    5.735793] Pid: 1091, comm: modprobe Not tainted 2.6.26-2-xen-amd64 #1
> Dec  5 23:30:25 security kernel: [    5.735798] RIP: e030:[<ffffffffa00997be>]  [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e

It is weird to call ir_input_free during the boot. This means that something
got wrong during IR initialization.

Anyway, I think I know here's the bug: the first thing the routine does is this:

        struct ir_scancode_table *rc_tab = input_get_drvdata(dev);

However, if ir_input_init() doesn't initialize fine, rc_tab will be null.

Could you please test if the enclosed patch fixes the issue?

---

Avoid usage of an initialized drvdata

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/linux/drivers/media/common/ir-keytable.c b/linux/drivers/media/common/ir-keytable.c
--- a/linux/drivers/media/common/ir-keytable.c
+++ b/linux/drivers/media/common/ir-keytable.c
@@ -427,6 +427,9 @@ void ir_input_free(struct input_dev *dev
 {
 	struct ir_scancode_table *rc_tab = input_get_drvdata(dev);
 
+	if (!rc_tab)
+		return;
+
 	IR_dprintk(1, "Freed keycode table\n");
 
 	rc_tab->size = 0;
