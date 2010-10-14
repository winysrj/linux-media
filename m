Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:38025 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0JNQau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 12:30:50 -0400
Received: by pxi16 with SMTP id 16so978704pxi.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 09:30:49 -0700 (PDT)
Message-ID: <4CB73034.5040208@gmail.com>
Date: Thu, 14 Oct 2010 13:30:44 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L/DVB: ir: avoid race conditions at device disconnect -
 was: Fwd: Re: *buntu 10.10 rc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch were sent only to lirc ML, due to a problem reported there.

Resending it to linux-media ML.

Cheers,
Mauro

-------- Mensagem original --------
Assunto: Re: *buntu 10.10 rc
Data: Thu, 14 Oct 2010 12:06:39 -0300
De: Mauro Carvalho Chehab <mchehab@redhat.com>
Para: Jarod Wilson <jarod@wilsonet.com>
CC: Greg Oliver <oliver.greg@gmail.com>,  Douglas Pearless <Douglas.Pearless@pearless.co.nz>, LIRC Users <lirc-list@lists.sourceforge.net>

Em 14-10-2010 11:47, Jarod Wilson escreveu:
> On Oct 13, 2010, at 11:57 PM, Greg Oliver wrote:
> ...
>> OK, with the patches, I get 2 key presses played for every 1 real
>> press,
> 
> Is it really 2 key presses, or is it press + repeat? ir-core doesn't do any repeat filtering, and there was actually a repeat bug fixed in those patches, so this isn't entirely unexpected.
> 
> 
>> plus the same oops eventually with more debugs in the modules
>> though..
> 
> Okay, so it seems the usb disconnect is what's triggering this. And I think I'm starting to get a decent idea of why I'm not seeing this myself. The ubuntu lirc packages have some udev bits that re-run the lirc initscript on device plug/unplug, and one of the things the initscript does is poke the protocols sysfs node, which is what triggers the call to store_protocols. I think we're racing with the disconnect here. I'm not sure if we need to add some locking, or just bail from store_protocols if ir_dev is NULL and call it good.
> 
> 
>> [ 3165.068079] ir_rc6_decode: RC6(6A) scancode 0x800f0420 (toggle: 0)
>> [ 3165.068088] ir_g_keycode_from_table: Media Center Ed. eHome
>> Infrared Remote Transceiver (1784:0008): scancode 0x800f0420 keycode
>> 0x69
>> [ 3165.068114] ir_keydown: Media Center Ed. eHome Infrared Remote
>> Transceiver (1784:0008): key down event, key 0x0069, scancode
>> 0x800f0420
>> [ 3165.071059] ir_rc5_decode: RC5(x) decode failed at state 1 (1761us pulse)
>> [ 3165.072055] ir_rc5_decode: RC5(x) decode failed at state 0 (900us space)
>> [ 3165.073059] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.074072] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.081112] ir_rc5_decode: RC5(x) decode failed at state 2 (400us space)
>> [ 3165.083086] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.084065] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.086064] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.089088] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.090061] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.093131] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.100057] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.103071] ir_rc5_decode: RC5(x) decode failed at state 2 (400us pulse)
>> [ 3165.104060] ir_rc5_decode: RC5(x) decode failed at state 0 (500us space)
>> [ 3165.105048] ir_rc5_decode: RC5(x) decode failed at state 1 (400us space)
>> [ 3165.110588] usb 5-1: USB disconnect, address 2
>> [ 3165.111120] ir_input_unregister: Freed keycode table
>> [ 3165.145273] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000048
>> [ 3165.145286] IP: [<ffffffffa0044fca>] store_protocols+0x20a/0x2d0 [ir_core]
>> [ 3165.145305] PGD d848067 PUD d934067 PMD 0
>> [ 3165.145315] Oops: 0000 [#1] SMP
>> [ 3165.145322] last sysfs file: /sys/devices/virtual/rc/rc0/protocols
>> [ 3165.145328] CPU 2
>> [ 3165.145331] Modules linked in: nfsd exportfs nfs lockd fscache
>> nfs_acl auth_rpcgss snd_hda_codec_nvhdmi snd_hda_intel snd_hda_codec
>> snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
>> snd_timer snd_seq_device nvidia(P) snd soundcore snd_page_alloc shpchp
>> sunrpc ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder
>> ir_rc6_decoder usb_debug edac_core edac_mce_amd ir_rc5_decoder
>> i2c_piix4 usbserial ir_nec_decoder rc_rc6_mce k10temp psmouse mceusb
>> serio_raw ir_core lp parport usbhid hid pata_atiixp ahci r8169 mii
>> libahci
>> [ 3165.145408]
>> [ 3165.145416] Pid: 3069, comm: lirc Tainted: P
>> 2.6.36-020636rc7-generic #201010070908 TA880GB+/TA880GB+
>> [ 3165.145423] RIP: 0010:[<ffffffffa0044fca>]  [<ffffffffa0044fca>]
>> store_protocols+0x20a/0x2d0 [ir_core]
>> [ 3165.145439] RSP: 0018:ffff880037b33e18  EFLAGS: 00010202
>> [ 3165.145445] RAX: 0000000000000000 RBX: ffff88022dac79b0 RCX: 0000000000000005
>> [ 3165.145451] RDX: ffff88022ad12400 RSI: ffffffffa0046d80 RDI: ffff88022ad12400
>> [ 3165.145456] RBP: ffff880037b33e78 R08: 0000000000000001 R09: ffffea00002f4af0
>> [ 3165.145462] R10: 0000000000000000 R11: 0000000000000246 R12: ffff88021f4239c0
>> [ 3165.145468] R13: 00000000ffffffed R14: ffffffff8164b520 R15: ffff88022ad12410
>> [ 3165.145475] FS:  00007fa4cb4e7700(0000) GS:ffff880001e80000(0000)
>> knlGS:0000000000000000
>> [ 3165.145481] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 3165.145486] CR2: 0000000000000048 CR3: 000000000da52000 CR4: 00000000000006e0
>> [ 3165.145492] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 3165.145498] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [ 3165.145504] Process lirc (pid: 3069, threadinfo ffff880037b32000,
>> task ffff8801932fc4a0)
>> [ 3165.145509] Stack:
>> [ 3165.145512]  ffffffff81a48f60 0000000000000005 ffff88022ad12400
>> 0000000001883ad0
>> [ 3165.145521] <0> ffff880037b33e68 ffffffff8113cee3 ffff88000d832000
>> ffff88022dac79b0
>> [ 3165.145531] <0> ffff88021f4239c0 00000000ffffffed ffffffff8164b520
>> ffff88022ad12410
>> [ 3165.145542] Call Trace:
>> [ 3165.145556]  [<ffffffff8113cee3>] ? alloc_pages_current+0xa3/0x110
>> [ 3165.145567]  [<ffffffff81388390>] dev_attr_store+0x20/0x30
>> [ 3165.145576]  [<ffffffff811c1d32>] flush_write_buffer+0x62/0x90
>> [ 3165.145584]  [<ffffffff811c1e76>] sysfs_write_file+0x66/0xa0
>> [ 3165.145592]  [<ffffffff81156a7c>] vfs_write+0xcc/0x190
>> [ 3165.145600]  [<ffffffff81157485>] sys_write+0x55/0x90
>> [ 3165.145609]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
>> [ 3165.145614] Code: c7 c7 78 65 04 a0 31 c0 e8 94 ea 01 e1 48 8b 45
>> a8 48 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f c9 c3 48 8b 55 b0 48 8b 82
>> 98 02 00 00 <48> 8b 40 48 48 89 45 c0 e9 31 fe ff ff 48 8b 5d b0 48 81
>> c3 80
>> [ 3165.145687] RIP  [<ffffffffa0044fca>] store_protocols+0x20a/0x2d0 [ir_core]
>> [ 3165.145699]  RSP <ffff880037b33e18>
>> [ 3165.145703] CR2: 0000000000000048
>> [ 3165.145709] ---[ end trace 0241a6f763d5403b ]---
> 

Hmm... see if the enclosed patch helps.

---

V4L/DVB: ir: avoid race conditions at device disconnect

It is possible that, while ir_unregister_class() is handling, some application
could try to access the sysfs nodes, causing an OOPS.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index dab074e..949b055 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -68,6 +68,10 @@ static ssize_t show_protocols(struct device *d,
 	char *tmp = buf;
 	int i;
 
+	/* Device is being removed */
+	if (!ir_dev)
+		return -EINVAL;
+
 	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = ir_dev->rc_tab.ir_type;
 		allowed = ir_dev->props->allowed_protos;
@@ -122,6 +126,10 @@ static ssize_t store_protocols(struct device *d,
 	int rc, i, count = 0;
 	unsigned long flags;
 
+	/* Device is being removed */
+	if (!ir_dev)
+		return -EINVAL;
+
 	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
 		type = ir_dev->rc_tab.ir_type;
 	else
@@ -305,6 +313,7 @@ void ir_unregister_class(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 
+	input_set_drvdata(input_dev, NULL);
 	clear_bit(ir_dev->devno, &ir_core_dev_number);
 	input_unregister_device(input_dev);
 	device_del(&ir_dev->dev);

