Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4K5NhEn003074
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 01:23:43 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4K5NVKB021212
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 01:23:31 -0400
Received: by ug-out-1314.google.com with SMTP id s2so645633uge.6
	for <video4linux-list@redhat.com>; Mon, 19 May 2008 22:23:31 -0700 (PDT)
Date: Tue, 20 May 2008 15:24:26 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080520152426.5540ee7f@glory.loctelecom.ru>
In-Reply-To: <1210719122.26311.37.camel@pc10.localdom.local>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Beholder card M6 with MPEG2 coder
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi 

Kernel 2.6.25 vanilla + v4l latest

I try

./v4l2-ctl -d /dev/video0 -D
Driver Info:
	Driver name   : saa7134
	Card type     : Beholder BeholdTV M6 / BeholdTV
	Bus info      : PCI:0000:02:00.0
	Driver version: 526
	Capabilities  : 0x05010015
		Video Capture
		Video Overlay
		VBI Capture
		Tuner
		Read/Write
		Streaming

./v4l2-ctl -d /dev/radio0 -D		
Driver Info:
	Driver name   : saa7134
	Card type     : Beholder BeholdTV M6 / BeholdTV
	Bus info      : PCI:0000:02:00.0
	Driver version: 526
	Capabilities  : 0x00010000
		Tuner

./v4l2-ctl -d /dev/video1 -D		
Driver Info:
	Driver name   : saa7134
	Card type     : Proteus Pro [philips reference 
	Bus info      : PCI:<NULL>
	Driver version: 526
	Capabilities  : 0x05000001
		Video Capture
		Read/Write
		Streaming

Incorrect data in querycap syscall. After this patch, Information is good:

diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue May 20 09:07:56 2008 +1000
@@ -172,12 +172,16 @@ static int empress_querycap(struct file 
 static int empress_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;

 	strcpy(cap->driver, "saa7134");
 	strlcpy(cap->card, saa7134_boards[dev->board].name,
 		sizeof(cap->card));

./v4l2-ctl -d /dev/video0 -D
Driver Info:
	Driver name   : saa7134
	Card type     : Beholder BeholdTV M6 / BeholdTV
	Bus info      : PCI:0000:02:00.0
	Driver version: 526
	Capabilities  : 0x05010015
		Video Capture
		Video Overlay
		VBI Capture
		Tuner
		Read/Write
		Streaming
		
./v4l2-ctl -d /dev/radio0 -D		
Driver Info:
	Driver name   : saa7134
	Card type     : Beholder BeholdTV M6 / BeholdTV
	Bus info      : PCI:0000:02:00.0
	Driver version: 526
	Capabilities  : 0x00010000
		Tuner

./v4l2-ctl -d /dev/video1 -D		
Driver Info:
	Driver name   : saa7134
	Card type     : Beholder BeholdTV M6 / BeholdTV
	Bus info      : PCI:0000:02:00.0
	Driver version: 526
	Capabilities  : 0x05000001
		Video Capture
		Read/Write
		Streaming

What you think about it? Bad data structure?? Or my patch is right??

With my best regards, Dmitry.

> Am Montag, den 12.05.2008, 20:11 +1000 schrieb Dmitri Belimov:
> > Hi 
> > 
> > Now I start support MPEG2 coder in Beholder M6 card.
> > I have few questions:
> > 1. Befor start MPEG2 stream need configure the saa7134 chip. How to
> > I can make it correctly? 2. Where I can read more about it??
> > 
> > With my best regards, Dmitry.
> > 
> 
> Dmitry, there is some bug on saa7134-empress after ioctl2 conversion
> with recent stuff. I  have only a not yet supported card and can't
> help much.
> 
> To send the M6 extra patch with the empress encoder enabled was not
> much helpful in this situation to track down latest working status,
> if it was never tested.
> 
> However, there is some thread on the linux-dvb ML with Frederic Cand
> involved and he seems to have that latest working status now with a
> known supported card before ioctl2 conversion. On mine format setup
> fails for all known previously working and it needs more work on it.
> 
> On recent, my latest report was that the ioctls seem to come through
> again. In fact, given that the empress pci device was dev/video1 out
> of three and the empress got /dev/video4 then, I was only able to
> control /dev/video2 from empress /dev/video4 successfully for all, but
> not for set standard and channel, which never worked for my card so
> far.
> 
> The assumption, to let /dev/video2 to the empress, assigning video_nr
> 0,1,3,4 to the other cards would resolve that problem, now turns out
> to be wrong.
> 
> Even lining up minors takes free /dev/video2 now for the empress
> device, it is still associated with /dev/video3 of a different card.
> 
> The bug is in within lining up minors and assigning correctly from pci
> dev to empress dev.
> 
> Putting the card now back into another machine as the last of four,
> the previously reported bug becomes visible again, which happens on
> empress_querycap.
> 
> Don't know when I'll have time for it again, so I leave at least the
> oops again, which in my case is not the end of the latter ...
> 
> BTW, we still have the already reported other bugs.
> 
> The users can't set the tuner type anymore. Since almost all older
> cards with can tuners and not global silicon tuners, need to set the
> tuner type independently from what is in the card's entry hard coded
> for only one TV standard, it is not a minor issue.
> 
> The users can't force PAL and SECAM subnorms anymore.
> This will hit at least all PAL_BG NICAM users, lots of countries in
> Europe, since this often ends up in PAL_I detection there and at least
> SECAM_L will lose against SECAM_DK again I would expect.
> 
> Cheers,
> Hermann
> 
> oops with qv4l2 on empress /dev/video4
> 
> > saa7133[2]: registered device vbi2
> > saa7134[3]: setting pci latency timer to 64
> > saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64,
> > mmio: 0xe8003000 saa7134[3]: subsystem: 16be:5000, board: EMPRESS
> > [card=4,insmod option] saa7134[3]: board init: gpio is 820000
> > tuner' 5-0043: chip found @ 0x86 (saa7134[3])
> > tda9887 5-0043: creating new instance
> > tda9887 5-0043: tda988[5/6/7] found
> > tuner' 5-0061: chip found @ 0xc2 (saa7134[3])
> > saa7134[3]: i2c eeprom 00: be 16 00 50 54 20 1c 00 43 43 a9 1c 55
> > d2 b2 92 saa7134[3]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50
> > 32 79 01 3c ca 50 saa7134[3]: i2c eeprom 20: 01 40 01 02 02 03 01
> > 00 06 ff 00 6c 02 51 96 2b saa7134[3]: i2c eeprom 30: a7 58 7a 1f
> > 03 8e 84 5e da 7a 04 b3 05 87 b2 3c saa7134[3]: i2c eeprom 40: ff
> > 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8f saa7134[3]: i2c eeprom
> > 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 00 saa7134[3]: i2c
> > eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff ff ff saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff ff ff saa7134[3]: i2c eeprom a0: ff ff ff ff
> > ff ff ff ff ff ff ff ff ff ff ff ff saa7134[3]: i2c eeprom b0: ff
> > ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff saa7134[3]: i2c eeprom
> > c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff saa7134[3]: i2c
> > eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff ff ff saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff tuner-simple 5-0061: creating new instance
> > tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid
> > Tuner) saa6752hs 5-0020: saa6752hs: chip found @ 0x40 saa7134[3]:
> > registered device video3 [v4l2] saa7134[3]: registered device vbi3
> > saa7134[3]: registered device radio2 DVB: registering new adapter
> > (saa7133[0]) DVB: registering frontend 0 (Philips TDA10046H
> > DVB-T)... tda1004x: setting up plls for 48MHz sampling clock
> > tda1004x: found firmware revision 29 -- ok
> > DVB: registering new adapter (saa7133[1])
> > DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
> > tda1004x: setting up plls for 48MHz sampling clock
> > tda1004x: found firmware revision 29 -- ok
> > DVB: registering new adapter (saa7133[2])
> > DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
> > tda1004x: setting up plls for 48MHz sampling clock
> > tda1004x: found firmware revision 26 -- ok
> > saa7134[3]/empress: saa7134[3]: empress_init
> > saa7134[3]: registered device video4 [mpeg]
> > saa7134[3]/empress: no video signal
> > saa7134[3]/empress: no video signal
> > saa7134[3]/empress: no video signal
> > saa7134[3]/empress: video signal acquired
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: video signal acquired
> > saa7134[3]/empress: no video signal
> > saa7134[3]/empress: no video signal
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: open minor=4
> > saa7134[3]/empress: no video signal
> > saa7134[3]/empress: no video signal
> > saa7134[3]/empress: video signal acquired
> > saa7134[3]/empress: open minor=4
> > BUG: unable to handle kernel NULL pointer dereference at 00000000
> > IP: [<c01d893a>] strlen+0x8/0x11
> > *pde = 189ef067 *pte = 00000000
> > Oops: 0000 [#1] PREEMPT
> > Modules linked in: saa7134_empress tda1004x saa7134_dvb saa6752hs
> > tuner_simple tuner_types tda9887 videobuf_dvb dvb_core tda827x
> > tda8290 tuner saa7134 videodev v4l1_compat compat_ioctl32
> > v4l2_common videobuf_dma_sg videobuf_core ir_kbd_i2c ir_common
> > tveeprom sit tunnel4 rfcomm l2cap bluetooth autofs4 fuse sunrpc
> > ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_ipv6header
> > ip6t_REJECT ip6table_filter ip6_tables x_tables ipv6 dm_mirror
> > dm_multipath dm_mod snd_intel8x0 floppy snd_ac97_codec ac97_bus
> > snd_seq_dummy 3c59x snd_seq_oss snd_seq_midi_event snd_seq
> > snd_seq_device pcspkr mii snd_pcm_oss snd_mixer_oss snd_pcm
> > i2c_nforce2 snd_timer i2c_core snd soundcore snd_page_alloc button
> > pata_acpi pata_amd libata sd_mod scsi_mod dock ext3 jbd uhci_hcd
> > ohci_hcd ehci_hcd [last unloaded: tda827x]
> > 
> > Pid: 25352, comm: qv4l2 Not tainted (2.6.25 #4)
> > EIP: 0060:[<c01d893a>] EFLAGS: 00010246 CPU: 0
> > EIP is at strlen+0x8/0x11
> > EAX: 00000000 EBX: 00000020 ECX: ffffffff EDX: 00000000
> > ESI: 00000000 EDI: 00000000 EBP: d89d1edc ESP: d89d1de4
> >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process qv4l2 (pid: 25352, ti=d89d0000 task=f6e90cb0
> > task.ti=d89d0000) Stack: d89d1f34 c01d7049 c0116a51 d89d1ecc
> > f8a4a4e4 d89d1f34 efbe8400 f8a8a4d4 f8a8a4a5 00000000 f89d6c3d
> > 80685600 d881f5e0 00000001 efb42000 c042cf44 c011b667 00000000
> > 00000202 c0168c66 f739000b f7390005 00000101 00000000 Call Trace:
> >  [<c01d7049>] strlcpy+0x14/0x5f
> >  [<c0116a51>] __wake_up_common+0x2d/0x52
> >  [<f8a8a4d4>] empress_querycap+0x2f/0x5f [saa7134_empress]
> >  [<f8a8a4a5>] empress_querycap+0x0/0x5f [saa7134_empress]
> >  [<f89d6c3d>] __video_do_ioctl+0x4d0/0x2d74 [videodev]
> >  [<c011b667>] wake_up_klogd+0x2b/0x2d
> >  [<c0168c66>] __link_path_walk+0xb15/0xc21
> >  [<c016ef05>] dput+0x15/0xfc
> >  [<c0173169>] mntput_no_expire+0x11/0x7f
> >  [<c0168dfd>] path_walk+0x8b/0x93
> >  [<c011bd13>] printk+0x14/0x18
> >  [<f89d978e>] video_ioctl2+0x16d/0x233 [videodev]
> >  [<f89d9619>] video_open+0x138/0x140 [videodev]
> >  [<c016ac53>] vfs_ioctl+0x47/0x5d
> >  [<c016aebd>] do_vfs_ioctl+0x254/0x26b
> >  [<c013e382>] audit_syscall_exit+0x2a0/0x2bc
> >  [<c016af15>] sys_ioctl+0x41/0x58
> >  [<c0104786>] syscall_call+0x7/0xb
> >  =======================
> > Code: eb 04 19 c0 0c 01 5e 5f c3 56 89 c6 89 d0 88 c4 ac 38 e0 74
> > 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e c3 57 83 c9 ff 89 c7 31
> > c0 <f2> ae f7 d1 49 5f 89 c8 c3 57 89 c7 89 d0 31 d2 85 c9 74 0c f2
> > EIP: [<c01d893a>] strlen+0x8/0x11 SS:ESP 0068:d89d1de4 ---[ end
> > trace 4ac505a5bbed981f ]---
> 
> 
> 
> 
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
