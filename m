Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34113 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbbBZXEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 18:04:13 -0500
Received: by wghn12 with SMTP id n12so15651472wgh.1
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 15:04:12 -0800 (PST)
Received: from i72600 ([2001:610:600:8489::10])
        by mx.google.com with ESMTPSA id hg7sm3361678wjb.44.2015.02.26.15.04.11
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Feb 2015 15:04:11 -0800 (PST)
From: "Gert-Jan van der Stroom" <gjstroom@gmail.com>
To: <linux-media@vger.kernel.org>
References: <002401d04ea1$e5cf1780$b16d4680$@gmail.com>	<54EA4BB8.2080106@iki.fi> <20150222185503.41cbcb1a@recife.lan> <002e01d04f87$c09c1c60$41d45520$@gmail.com>
In-Reply-To: <002e01d04f87$c09c1c60$41d45520$@gmail.com>
Subject: RE: Mygica T230 DVB-T/T2/C Ubuntu 14.04 (kernel 3.13.0-45) using media_build
Date: Fri, 27 Feb 2015 00:03:46 +0100
Message-ID: <000001d05218$798ad9e0$6ca08da0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: nl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Gert-Jan van der Stroom [mailto:gjstroom@gmail.com]
> Sent: maandag 23 februari 2015 17:43
> To: linux-media-owner@vger.kernel.org
> Cc: 'Mauro Carvalho Chehab'
> Subject: RE: Mygica T230 DVB-T/T2/C Ubuntu 14.04 (kernel 3.13.0-45) using
> media_build
> 
> > -----Original Message-----
> > From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
> > Sent: zondag 22 februari 2015 22:55
> > To: Antti Palosaari
> > Cc: Gert-Jan van der Stroom; linux-media@vger.kernel.org
> > Subject: Re: Mygica T230 DVB-T/T2/C Ubuntu 14.04 (kernel 3.13.0-45)
> > using media_build
> >
> > Em Sun, 22 Feb 2015 23:35:52 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> > > Mauro,
> > > could you fix your media controller stuff ASAP as I think almost all
> > > DVB devices are currently broken. I have got multiple bug reports....
> >
> > That looks weird... I think the patch adding media controller support
> > for
> the
> > dvb-usb was not merged yet.
> >
> > >
> > > On 02/22/2015 03:17 PM, Gert-Jan van der Stroom wrote:
> > > > Can someone help me to get a Mygica T230 DVB-T/T2/C working on
> > > > Ubuntu 14.04 (kernel 3.13.0-45) using media_build.
> > > > I succeed doing a build of the media_build, the drivers also load
> > > > when I attach the Mygica, but when I try to use it (tvheadend) it
> crashes:
> > > >
> > > > [   61.592114] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm
> state.
> > > > [   61.828138] dvb-usb: will pass the complete MPEG2 transport
stream
> to
> > the
> > > > software demuxer.
> > > > [   61.828279] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
> > > > [   61.847369] i2c i2c-7: Added multiplexed i2c bus 8
> > > > [   61.847372] si2168 7-0064: Silicon Labs Si2168 successfully
> attached
> > > > [   61.857024] si2157 8-0060: Silicon Labs Si2147/2148/2157/2158
> > > > successfully attached
> > > > [   61.857034] usb 1-5: DVB: registering adapter 0 frontend 0
(Silicon
> Labs
> > > > Si2168)...
> > > > [   61.857488] input: IR-receiver inside an USB DVB receiver as
> > > > /devices/pci0000:00/0000:00:1a.7/usb1/1-5/input/input11
> > > > [   61.857541] dvb-usb: schedule remote query interval to 100 msecs.
> > > > [   61.857709] dvb-usb: Mygica T230 DVB-T/T2/C successfully
> initialized
> > and
> > > > connected.
> > > > [   61.857773] usbcore: registered new interface driver
dvb_usb_cxusb
> > > >
> > > > Tvheadend start:
> > > > [  314.356162] BUG: unable to handle kernel NULL pointer
> > > > dereference at
> > > > 0000000000000010
> > > > [  314.356202] IP: [<ffffffffa02ef74c>]
> > > > media_entity_pipeline_start+0x1c/0x390 [media]
> > >
> > >
> > > ^^^^^^^^^^^^ problem is that I think
> > >
> > >
> > > > [  314.356236] PGD 76c6c067 PUD 766b0067 PMD 0 [  314.356260]
> Oops:
> > > > 0000 [#1] SMP [  314.356279] Modules linked in: si2157(OX)
> > > > si2168(OX) i2c_mux
> > > > dvb_usb_cxusb(OX) dib0070(OX) dvb_usb(OX) dvb_core(OX) rc_core(OX)
> > > > media(OX) snd_hda_codec_analog gpio_ich hp_wmi sparse_keymap
> > > > coretemp kvm_intel kvm serio_raw snd_hda_intel i915 lpc_ich
> > > > snd_hda_codec shpchp drm_kms_helper snd_hwdep snd_pcm
> > snd_page_alloc
> > > > snd_timer pl2303 video wmi tpm_infineon drm mac_hid mei_me snd
> > > > soundcore i2c_algo_bit usbserial mei lp parport psmouse e1000e
> > > > floppy
> > ptp pps_core pata_acpi
> > > > [  314.356541] CPU: 1 PID: 1053 Comm: kdvb-ad-0-fe-0 Tainted: G
> W
> > OX
> > > > 3.13.0-45-generic #74-Ubuntu
> >
> > Gert-Jan,
> >
> > Could you please post the stack dump? It would help to know what's
> > calling media_entity_pipeline_start.
> >
> > Regards,
> > Mauro
> >
> [Gert-Jan van der Stroom]
> 
> Here's the complete dmesg:
> 
> [   61.356038] usb 1-5: new high-speed USB device number 5 using ehci-pci
> [   61.488897] usb 1-5: New USB device found, idVendor=0572,
> idProduct=c688
> [   61.488901] usb 1-5: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [   61.488904] usb 1-5: Product: USB Stick
> [   61.488906] usb 1-5: Manufacturer: Max
> [   61.488908] usb 1-5: SerialNumber: 080116
> [   61.541984] media: module verification failed: signature and/or
required
> key missing - tainting kernel
> [   61.542468] media: Linux media interface: v0.10
> [   61.546376] WARNING: You are using an experimental version of the
> media
> stack.
> [   61.546376]  As the driver is backported to an older kernel, it doesn't
> offer
> [   61.546376]  enough quality for its usage in production.
> [   61.546376]  Use it with care.
> [   61.546376] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [   61.546376]  135f9be9194cf7778eb73594aa55791b229cf27c [media]
> dvb_frontend: start media pipeline while thread is running
> [   61.546376]  0f0fa90bd035fa15106799b813d4f0315d99f47e [media]
> cx231xx:
> enable tuner->decoder link at videobuf start
> [   61.546376]  9239effd53d47e3cd9c653830c8465c0a3a427dc [media]
> dvb-frontend: enable tuner link when the FE thread starts
> [   61.564631] WARNING: You are using an experimental version of the
> media
> stack.
> [   61.564631]  As the driver is backported to an older kernel, it doesn't
> offer
> [   61.564631]  enough quality for its usage in production.
> [   61.564631]  Use it with care.
> [   61.564631] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [   61.564631]  135f9be9194cf7778eb73594aa55791b229cf27c [media]
> dvb_frontend: start media pipeline while thread is running
> [   61.564631]  0f0fa90bd035fa15106799b813d4f0315d99f47e [media]
> cx231xx:
> enable tuner->decoder link at videobuf start
> [   61.564631]  9239effd53d47e3cd9c653830c8465c0a3a427dc [media]
> dvb-frontend: enable tuner link when the FE thread starts
> [   61.592114] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
> [   61.828138] dvb-usb: will pass the complete MPEG2 transport stream to
> the
> software demuxer.
> [   61.828279] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
> [   61.847369] i2c i2c-7: Added multiplexed i2c bus 8
> [   61.847372] si2168 7-0064: Silicon Labs Si2168 successfully attached
> [   61.857024] si2157 8-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   61.857034] usb 1-5: DVB: registering adapter 0 frontend 0 (Silicon
Labs
> Si2168)...
> [   61.857488] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1a.7/usb1/1-5/input/input11
> [   61.857541] dvb-usb: schedule remote query interval to 100 msecs.
> [   61.857709] dvb-usb: Mygica T230 DVB-T/T2/C successfully initialized
and
> connected.
> [   61.857773] usbcore: registered new interface driver dvb_usb_cxusb
> [  314.356162] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000010
> [  314.356202] IP: [<ffffffffa02ef74c>]
> media_entity_pipeline_start+0x1c/0x390 [media] [  314.356236] PGD
> 76c6c067 PUD 766b0067 PMD 0 [  314.356260] Oops: 0000 [#1] SMP [
> 314.356279] Modules linked in: si2157(OX) si2168(OX) i2c_mux
> dvb_usb_cxusb(OX) dib0070(OX) dvb_usb(OX) dvb_core(OX) rc_core(OX)
> media(OX) snd_hda_codec_analog gpio_ich hp_wmi sparse_keymap
> coretemp kvm_intel kvm serio_raw snd_hda_intel i915 lpc_ich
> snd_hda_codec shpchp drm_kms_helper snd_hwdep snd_pcm
> snd_page_alloc snd_timer pl2303 video wmi tpm_infineon drm mac_hid
> mei_me snd soundcore i2c_algo_bit usbserial mei lp parport psmouse
> e1000e floppy ptp pps_core pata_acpi
> [  314.356541] CPU: 1 PID: 1053 Comm: kdvb-ad-0-fe-0 Tainted: G        W
OX
> 3.13.0-45-generic #74-Ubuntu
> [  314.356574] Hardware name: Hewlett-Packard HP Compaq dc7900 Ultra-
> Slim Desktop/3033h, BIOS 786G1 v01.26 07/12/2011 [  314.356609] task:
> ffff880036cd4800 ti: ffff880075f7a000 task.ti:
> ffff880075f7a000
> [  314.356635] RIP: 0010:[<ffffffffa02ef74c>]  [<ffffffffa02ef74c>]
> media_entity_pipeline_start+0x1c/0x390 [media] [  314.356673] RSP:
> 0018:ffff880075f7bcd0  EFLAGS: 00010282 [  314.356693] RAX:
> 0000000000000000 RBX: 0000000000000000 RCX:
> 0000000000000000
> [  314.356717] RDX: 0000000000000000 RSI: ffff88007495a264 RDI:
> 0000000000000000
> [  314.356743] RBP: ffff880075f7be40 R08: ffff880075f7a000 R09:
> ffff88007495a000
> [  314.356767] R10: 00000000000001d1 R11: 0000000000000204 R12:
> ffff880076736830
> [  314.356792] R13: ffff880076736830 R14: 0000000000000000 R15:
> ffff88007495a000
> [  314.356817] FS:  0000000000000000(0000) GS:ffff88007b680000(0000)
> knlGS:0000000000000000
> [  314.356845] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b [
> 314.356866] CR2: 0000000000000010 CR3: 000000007672f000 CR4:
> 00000000000407e0
> [  314.356891] Stack:
> [  314.356901]  ffff880075e14800 ffff88007b613540 ffff880075e14800
> ffff880075f7bcf8
> [  314.356936]  ffffffff8109edc8 ffff880075f7bd40 ffffffff810a515d
> ffff880075f7bd18
> [  314.356971]  ffffffff8101bc23 ffff880075e14800 ffff88007b613540
> ffff88007b6134c0
> [  314.357006] Call Trace:
> [  314.357021]  [<ffffffff8109edc8>] ? __enqueue_entity+0x78/0x80 [
> 314.357043]  [<ffffffff810a515d>] ? enqueue_entity+0x2ad/0xbb0 [
> 314.357066]  [<ffffffff8101bc23>] ? native_sched_clock+0x13/0x80 [
> 314.358166]  [<ffffffff810a2f54>] ? update_curr+0xe4/0x180 [  314.359255]
> [<ffffffff810a3442>] ? dequeue_entity+0x142/0x5c0 [  314.360146]
> [<ffffffff810981c5>] ? check_preempt_curr+0x75/0xa0 [  314.360146]
> [<ffffffff8101bc23>] ? native_sched_clock+0x13/0x80 [  314.360146]
> [<ffffffff810a3d0e>] ? dequeue_task_fair+0x44e/0x660 [  314.360146]
> [<ffffffff8109d4e8>] ? sched_clock_cpu+0xa8/0x100 [  314.360146]
> [<ffffffff810125c6>] ? __switch_to+0x126/0x4c0 [  314.360146]
> [<ffffffffa037649b>] dvb_frontend_thread+0x33b/0x970 [dvb_core] [
> 314.360146]  [<ffffffff81724e61>] ? __schedule+0x381/0x7d0 [  314.360146]
> [<ffffffffa0376160>] ?
> dvb_frontend_ioctl_legacy.isra.8+0xce0/0xce0 [dvb_core] [  314.360146]
> [<ffffffff8108b572>] kthread+0xd2/0xf0 [  314.360146]
[<ffffffff8108b4a0>]
> ? kthread_create_on_node+0x1c0/0x1c0
> [  314.360146]  [<ffffffff817318bc>] ret_from_fork+0x7c/0xb0 [
> 314.360146]  [<ffffffff8108b4a0>] ? kthread_create_on_node+0x1c0/0x1c0
> [  314.360146] Code: cb 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
> 66 90 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 89 fb 48 81 ec 48 01 00 00
> <48> 8b 47 10 48 89 bd a0 fe ff ff 48 89 b5 b0 fe ff ff 48 89 85 [
314.360146]
> RIP  [<ffffffffa02ef74c>]
> media_entity_pipeline_start+0x1c/0x390 [media] [  314.360146]  RSP
> <ffff880075f7bcd0> [  314.360146] CR2: 0000000000000010 [  314.360146] -
> --[ end trace 4afaa17fd66e17b4 ]---
> 
> I hope you can solve it, I also get the same problem when I build the
drivers
> with media_build mips cross compiled for VU+ Solo2 which also runs kernel
> 3.13.
> 
> Thanks, Gert-Jan
> 
> > > >
> > > > What is wrong, or do I miss something ?
> > > > I also added the firmware described at:
> > > > http://www.linuxtv.org/wiki/index.php/Geniatech_T230
> > >
> > > regards
> > > Antti
> > >
It's working now:
[ 1460.848020] usb 2-4: new high-speed USB device number 2 using ehci-pci
[ 1460.980871] usb 2-4: New USB device found, idVendor=0572, idProduct=c688
[ 1460.980875] usb 2-4: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 1460.980878] usb 2-4: Product: USB Stick
[ 1460.980881] usb 2-4: Manufacturer: Max
[ 1460.980883] usb 2-4: SerialNumber: 080116
[ 1461.036963] media: module verification failed: signature and/or  required
key missing - tainting kernel
[ 1461.037383] media: Linux media interface: v0.10
[ 1461.053284] WARNING: You are using an experimental version of the media
stack.
[ 1461.053284]  As the driver is backported to an older kernel, it doesn't
offer
[ 1461.053284]  enough quality for its usage in production.
[ 1461.053284]  Use it with care.
[ 1461.053284] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[ 1461.053284]  8a26a258bdb82db241cdc35f332f88dd67bdb9c9 [media] dvb core:
only start media entity if not NULL
[ 1461.053284]  99a85b901eb54f62ff0c3fd6eb56e60b7b9f15c8 Merge tag
'v4.0-rc1' into patchwork
[ 1461.053284]  c517d838eb7d07bbe9507871fab3931deccff539 Linux 4.0-rc1
[ 1461.075904] WARNING: You are using an experimental version of the media
stack.
[ 1461.075904]  As the driver is backported to an older kernel, it doesn't
offer
[ 1461.075904]  enough quality for its usage in production.
[ 1461.075904]  Use it with care.
[ 1461.075904] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[ 1461.075904]  8a26a258bdb82db241cdc35f332f88dd67bdb9c9 [media] dvb core:
only start media entity if not NULL
[ 1461.075904]  99a85b901eb54f62ff0c3fd6eb56e60b7b9f15c8 Merge tag
'v4.0-rc1' into patchwork
[ 1461.075904]  c517d838eb7d07bbe9507871fab3931deccff539 Linux 4.0-rc1
[ 1461.124021] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
[ 1461.360058] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 1461.360349] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
[ 1461.398223] i2c i2c-5: Added multiplexed i2c bus 6
[ 1461.398227] si2168 5-0064: Silicon Labs Si2168 successfully attached
[ 1461.409245] si2157 6-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[ 1461.409255] usb 2-4: DVB: registering adapter 0 frontend 0 (Silicon Labs
Si2168)...
[ 1461.409527] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb2/2-4/input/input13
[ 1461.410733] dvb-usb: schedule remote query interval to 100 msecs.
[ 1461.410918] dvb-usb: Mygica T230 DVB-T/T2/C successfully initialized and
connected.
[ 1461.410933] usbcore: registered new interface driver dvb_usb_cxusb
[ 1492.358127] si2168 5-0064: found a 'Silicon Labs Si2168-B40'
[ 1492.374658] si2168 5-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
[ 1492.919874] si2168 5-0064: firmware version: 4.0.4
[ 1492.931124] si2157 6-0060: found a 'Silicon Labs Si2148-A20'
[ 1492.955098] si2157 6-0060: downloading firmware from file
'dvb-tuner-si2158-a20-01.fw'
[ 1494.008500] si2157 6-0060: firmware version: 2.1.6
[ 1494.008515] usb 2-4: DVB: adapter 0 frontend 0 frequency 0 out of range
(110000000..862000000)

