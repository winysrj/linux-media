Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m73LYx3M015613
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 17:34:59 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m73LYkLg020056
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 17:34:47 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: id012c3076@blueyonder.co.uk, video4linux-list@redhat.com
In-Reply-To: <4895D741.1020906@blueyonder.co.uk>
References: <488C9266.7010108@blueyonder.co.uk>
	<1217364178.2699.17.camel@pc10.localdom.local>
	<4890BBE8.8000901@blueyonder.co.uk>
	<1217457895.4433.52.camel@pc10.localdom.local>
	<48921FF9.8040504@blueyonder.co.uk>
	<1217542190.3272.106.camel@pc10.localdom.local>
	<48942E42.5040207@blueyonder.co.uk>
	<1217679767.3304.30.camel@pc10.localdom.local>
	<4895D741.1020906@blueyonder.co.uk>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 23:28:19 +0200
Message-Id: <1217798899.2676.148.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: xawtv - no picture
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

Hi Ian,

Am Sonntag, den 03.08.2008, 17:05 +0100 schrieb Ian Davidson:
> Hi Hermann,
> 
> 1) I have changed my email "Reply-To" as emails were getting lost in
> the system.
> 
> 2) I searched for modprobe.conf and found one (only)
> in /usr/share/logwatch/default.conf/services.  I opened it and saw
> that it was empty (apart from comments) and added the options line.  I
> then saved it and copied it to /etc and ran depmod.  After rebooting,
> this is what I get in dmesg (extract)
> 
> iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> ppdev: user-space parallel port driver
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 18 (level, low) -> IRQ 18
> saa7133[0]: setting pci latency timer to 64
> saa7133[0]: found at 0000:04:02.0, rev: 209, irq: 18, latency: 64,
> mmio: 0xfebff800
> saa7133[0]: subsystem: 17de:7253, board: KWorld DVB-T 210
> [card=114,insmod option]
> saa7133[0]: board init: gpio is 100
> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1b.0 to 64
> ALSA sound/pci/hda/hda_intel.c:1810: chipset global capabilities =
> 0x4401
> saa7133[0]: i2c eeprom 00: de 17 53 72 ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff
> saa7133[0]: i2c scan: found device @ 0x10  [???]
> ALSA sound/pci/hda/hda_intel.c:749: codec_mask = 0x1
> hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> ALSA sound/pci/hda/hda_codec.c:2857: autoconfig: line_outs=4
> (0x14/0x15/0x16/0x17/0x0)
> ALSA sound/pci/hda/hda_codec.c:2861:    speaker_outs=0
> (0x0/0x0/0x0/0x0/0x0)
> ALSA sound/pci/hda/hda_codec.c:2865:    hp_outs=1
> (0x1b/0x0/0x0/0x0/0x0)
> ALSA sound/pci/hda/hda_codec.c:2866:    mono: mono_out=0x0
> ALSA sound/pci/hda/hda_codec.c:2874:    inputs: mic=0x18, fmic=0x19,
> line=0x1a, fline=0x0, cd=0x0, aux=0x0
> saa7133[0]: i2c scan: found device @ 0x96  [???]
> saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Headphone
> Playback Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker
> Playback Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback
> Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Line-Out
> Playback Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker
> Playback Switch, skipped
> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback
> Switch, skipped
> tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> tda8290 1-004b: setting tuner address to 61
> tda8290 1-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> DVB: registering new adapter (saa7133[0])
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> mtrr: base(0xd0000000) is not aligned on a size(0xff00000) boundary
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: timeout waiting for DSP ready
> device-mapper: multipath: version 1.0.5 loaded
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: waiting for firmware upload...
> tda1004x: no firmware upload (timeout or file not found?)
> tda1004x: firmware upload failed
> loop: module loaded
> EXT3 FS on dm-0, internal journal
> kjournald starting.  Commit interval 5 seconds
> 
> And, when I run xawtv I got this.
> 
> [Ian@localhost ~]$ xawtv -hwscan
> This is xawtv-3.95, running on Linux/i686 (2.6.25.11-97.fc9.i686)
> looking for available devices
> /dev/video0: OK                         [ -device /dev/video0 ]
>     type : v4l2
>     name : KWorld DVB-T 210
>     flags: overlay capture tuner 
> 
> [Ian@localhost ~]$ 
> 
> SO I ran xawtv again (with -remote -nodga) and saw that I could select
> Composite1 an a source.  Then I ran streamer, specifying Composite1
> and I captured an AVI file.  However, as you predicted, the images
> captured are all Black and White.  (We went through all the camera
> options to make sure it wasn't the camera set to BW!)
> 
> Definitely a long way forward.
> 
> Ian
> 
> PS - last time I tried, I am able to record audio through the mobo
> sound system.  I did not seemto be able to tune in the tuner yet.
> 
> 
> hermann pitton wrote: 
> > Hi Ian,
> > 
> > become root !
> > 

definitely a long way, not to talk about lost mails, but on module stuff
you must be root.

That is nothing new at all :) and took much too long.

Since I don't have neither the prior card nor the actual one,
it is time to go back to lists, others might be helpful as well.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
