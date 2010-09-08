Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0IHOQS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 10:16:18 -0400
Date: Wed, 8 Sep 2010 10:16:13 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Brian Rogers <brian@xyzw.org>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	jarod@wilsonet.com, linux-media@vger.kernel.org,
	mchehab@redhat.com, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] ir-core: centralize sysfs raw decoder
 enabling/disabling
Message-ID: <20100908141613.GB22323@redhat.com>
References: <20100613202718.6044.29599.stgit@localhost.localdomain>
 <20100613202930.6044.97940.stgit@localhost.localdomain>
 <4C8797D3.1060606@xyzw.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C8797D3.1060606@xyzw.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 07:04:03AM -0700, Brian Rogers wrote:
>  On 06/13/2010 01:29 PM, David Härdeman wrote:
> >diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
> >index daf33c1..7ae5662 100644
> >--- a/drivers/media/IR/ir-sysfs.c
> >+++ b/drivers/media/IR/ir-sysfs.c
> >@@ -33,122 +33,178 @@ static struct class ir_input_class = {
> >  };
> >
> >  /**
> >- * show_protocol() - shows the current IR protocol
> >+ * show_protocols() - shows the current IR protocol(s)
> >   * @d:		the device descriptor
> >   * @mattr:	the device attribute struct (unused)
> >   * @buf:	a pointer to the output buffer
> >   *
> >- * This routine is a callback routine for input read the IR protocol type.
> >- * it is trigged by reading /sys/class/rc/rc?/current_protocol.
> >- * It returns the protocol name, as understood by the driver.
> >+ * This routine is a callback routine for input read the IR protocol type(s).
> >+ * it is trigged by reading /sys/class/rc/rc?/protocols.
> >+ * It returns the protocol names of supported protocols.
> >+ * Enabled protocols are printed in brackets.
> >   */
> >-static ssize_t show_protocol(struct device *d,
> >-			     struct device_attribute *mattr, char *buf)
> >+static ssize_t show_protocols(struct device *d,
> >+			      struct device_attribute *mattr, char *buf)
> >  {
> >-	char *s;
> >  	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
> >-	u64 ir_type = ir_dev->rc_tab.ir_type;
> >-
> >-	IR_dprintk(1, "Current protocol is %lld\n", (long long)ir_type);
> >-
> >-	/* FIXME: doesn't support multiple protocols at the same time */
> >-	if (ir_type == IR_TYPE_UNKNOWN)
> >-		s = "Unknown";
> >-	else if (ir_type == IR_TYPE_RC5)
> >-		s = "rc-5";
> >-	else if (ir_type == IR_TYPE_NEC)
> >-		s = "nec";
> >-	else if (ir_type == IR_TYPE_RC6)
> >-		s = "rc6";
> >-	else if (ir_type == IR_TYPE_JVC)
> >-		s = "jvc";
> >-	else if (ir_type == IR_TYPE_SONY)
> >-		s = "sony";
> >-	else
> >-		s = "other";
> >+	u64 allowed, enabled;
> >+	char *tmp = buf;
> >+
> >+	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
> 
> This change introduced an oops for me. On my saa7134 MSI TV Anywhere
> Plus, ir_dev->props is null, so dereferencing it causes the
> following while attempting to read
> /sys/devices/virtual/rc/rc0/protocols:
> 
> [  601.632041] BUG: unable to handle kernel NULL pointer dereference
> at (null)
> [  601.632061] IP: [<ffffffffa00f43b5>] show_protocols+0x25/0x120 [ir_core]
> [  601.632079] PGD 7b181067 PUD 7bafe067 PMD 0
> [  601.632093] Oops: 0000 [#1] SMP
> [  601.632103] last sysfs file: /sys/devices/virtual/rc/rc0/protocols
> [  601.632111] CPU 0
> [  601.632115] Modules linked in: binfmt_misc rfcomm parport_pc
> ppdev sco bnep l2cap saa7134_alsa arc4 rc_msi_tvanywhere_plus
> ir_kbd_i2c advantechwdt tda827x rt2500pci rt2x00pci rt2x00lib
> snd_intel8x0 tda8290 snd_ac97_codec led_class ac97_bus tuner
> snd_seq_midi snd_rawmidi ir_lirc_codec lirc_dev mac80211 cfg80211
> snd_seq_midi_event ir_sony_decoder ir_jvc_decoder saa7134
> v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 psmouse
> serio_raw ir_rc6_decoder snd_pcm snd_seq lp shpchp eeprom_93cx6
> btusb snd_timer snd_seq_device videobuf_dma_sg ir_rc5_decoder snd
> videobuf_core ir_nec_decoder ir_common ir_core tveeprom soundcore
> edac_core bluetooth snd_page_alloc parport i2c_nforce2 k8temp
> edac_mce_amd usbhid hid btrfs zlib_deflate crc32c libcrc32c sata_nv
> forcedeth pata_amd
> [  601.632319]
> [  601.632335] Pid: 2928, comm: cat Not tainted
> 2.6.36-rc3-00185-gd56557a #2 KN9 Series(NF-CK804)/Unknow
> [  601.632368] RIP: 0010:[<ffffffffa00f43b5>]  [<ffffffffa00f43b5>]
> show_protocols+0x25/0x120 [ir_core]
> [  601.632404] RSP: 0018:ffff88007bb93e38  EFLAGS: 00010282
> [  601.632423] RAX: ffff88007bb6e000 RBX: ffffffffa00f5ee0 RCX:
> ffffffffa00f4390
> [  601.632444] RDX: 0000000000000000 RSI: ffffffffa00f5ee0 RDI:
> ffff88007bb6e000
> [  601.632465] RBP: ffff88007bb93e68 R08: ffff88007bb6e010 R09:
> ffffffff8164ab40
> [  601.632486] R10: 0000000000000000 R11: 0000000000000246 R12:
> ffff88007c928000
> [  601.632507] R13: 0000000000008000 R14: 000000000246d000 R15:
> ffff88007c8798a0
> [  601.632529] FS:  00007fe7aa26c700(0000) GS:ffff880001e00000(0000)
> knlGS:0000000000000000
> [  601.632561] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  601.632580] CR2: 0000000000000000 CR3: 000000007b19f000 CR4:
> 00000000000006f0
> [  601.632601] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  601.632623] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  601.632644] Process cat (pid: 2928, threadinfo ffff88007bb92000,
> task ffff88007bcd2dc0)
> [  601.632675] Stack:
> [  601.632689]  0000000000000000 ffffffffa00f5ee0 ffff88007bb93f48
> 0000000000008000
> [  601.632713] <0> 000000000246d000 ffff88007c8798a0
> ffff88007bb93e98 ffffffff813816e7
> [  601.632750] <0> ffff88007bb93e88 ffffffff8110681e
> ffff88007bb93e98 ffff88007c8798c0
> [  601.632797] Call Trace:
> [  601.632819]  [<ffffffff813816e7>] dev_attr_show+0x27/0x50
> [  601.632842]  [<ffffffff8110681e>] ? __get_free_pages+0xe/0x50
> [  601.632864]  [<ffffffff811bf5b1>] sysfs_read_file+0xd1/0x1c0
> [  601.632886]  [<ffffffff81152f15>] vfs_read+0xc5/0x190
> [  601.632906]  [<ffffffff81153551>] sys_read+0x51/0x90
> [  601.632928]  [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
> [  601.632947] Code: eb 04 90 90 90 90 55 48 89 e5 41 57 41 56 41 55
> 41 54 53 48 83 ec 08 0f 1f 44 00 00 49 89 d4 e8 12 0e 29 e1 48 8b 90
> 90 02 00 00 <44> 8b 0a 45 85 c9 0f 85 af 00 00 00 4c 8b a8 70 02 00
> 00 48 8b
> [  601.633112] RIP  [<ffffffffa00f43b5>] show_protocols+0x25/0x120 [ir_core]
> [  601.633136]  RSP <ffff88007bb93e38>
> [  601.633152] CR2: 0000000000000000
> [  601.633448] ---[ end trace 0dbd0f2ee839a90b ]---
> 
> A similar problem exists in store_protocols and makes lircd oops and
> die at startup.
> 
> >+		enabled = ir_dev->rc_tab.ir_type;
> >+		allowed = ir_dev->props->allowed_protos;
> >+	} else {
> >+		enabled = ir_dev->raw->enabled_protocols;
> 
> ir_dev->raw is also null. If I check these pointers before using
> them, and bail out if both are null, then I get a working lircd, but
> of course the file /sys/devices/virtual/rc/rc0/protocols no longer
> does anything. On 2.6.35.4, the system never creates the
> /sys/class/rc/rc0/current_protocol file. Is it the case that the
> 'protocols' file should never appear, because my card can't support
> this feature?

Hm... So protocols is indeed intended for hardware that handles raw IR, as
its a list of raw IR decoders available/enabled/disabled for the receiver.
But some devices that do onboard decoding and deal with scancodes still
need to support changing protocols, as they can be told "decode rc5" or
"decode nec", etc... My memory is currently foggy on how it was exactly
that it was supposed to be donee though. :) (Yet another reason I really
need to poke at the imon driver code again).


-- 
Jarod Wilson
jarod@redhat.com

