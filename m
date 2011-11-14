Return-path: <linux-media-owner@vger.kernel.org>
Received: from cluster-k.mailcontrol.com ([116.50.57.190]:53768 "EHLO
	cluster-k.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1KNWQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 17:16:13 -0500
Received: from rly08k.srv.mailcontrol.com (localhost.localdomain [127.0.0.1])
	by rly08k.srv.mailcontrol.com (MailControl) with ESMTP id pAEMFTGe019806
	for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 22:16:07 GMT
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by rly08k.srv.mailcontrol.com (MailControl) id pAEMEodV014393
	for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 22:14:50 GMT
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: HVR 4000 drivers broken - adapter0/frontend1 busy
Date: Tue, 15 Nov 2011 09:14:26 +1100
Message-ID: <44895934A66CD441A02DCF15DD759BA025A61A@SYDEXCHTMP2.au.fjanz.com>
In-Reply-To: <4EC15F67.8010801@flensrocker.de>
References: <0F9690932B81064FB7B6FCE776BC26C719A34076@FALEX02.au.fjanz.com> <4EC15F67.8010801@flensrocker.de>
From: "Hawes, Mark" <MARK.HAWES@au.fujitsu.com>
To: "L. Hanisch" <dvb@flensrocker.de>
CC: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lars,

Thanks for the reply.

Output of ls -la /dev/dvb/adapter0:

root@Nutrigrain:/home/digitalTV/vdr-1.7.21# ls -la /dev/dvb/adapter0/*
crw-rw---- 1 root video 212, 1 Nov 14 19:20 /dev/dvb/adapter0/demux0
crw-rw---- 1 root video 212, 5 Nov 14 19:20 /dev/dvb/adapter0/demux1
crw-rw---- 1 root video 212, 2 Nov 14 19:20 /dev/dvb/adapter0/dvr0
crw-rw---- 1 root video 212, 6 Nov 14 19:20 /dev/dvb/adapter0/dvr1
crw-rw---- 1 root video 212, 0 Nov 14 19:20 /dev/dvb/adapter0/frontend0
crw-rw---- 1 root video 212, 4 Nov 14 19:20 /dev/dvb/adapter0/frontend1
crw-rw---- 1 root video 212, 3 Nov 14 19:20 /dev/dvb/adapter0/net0
crw-rw---- 1 root video 212, 7 Nov 14 19:20 /dev/dvb/adapter0/net1
root@Nutrigrain:/home/digitalTV/vdr-1.7.21#

As you can see there is a demux1 and dvr1 but all hung off adapter0
which is presumably the problem.

I actually want to use both the DVB-S2 and the DVB-T frontends, though
not concurrently.

Happy to work with you on developing the required patch.

If as you suggest that this is actually a VDR problem then I'll also
post this reply in the VDR mailing list and we can take it from there.

Regards,

Mark. 

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of L. Hanisch
Sent: Tuesday, 15 November 2011 5:35 AM
To: linux-media@vger.kernel.org
Subject: Re: HVR 4000 drivers broken - adapter0/frontend1 busy

Hi,

Am 14.11.2011 04:14, schrieb Hawes, Mark:
> Hi,
>
> I have just acquired a Hauppauge HVR 4000 hybrid DVB-S2 / DVB-T / 
> Analogue card
 > which I am trying to use with VDR 1.7.21 on the latest Slackware
stable release  > using kernel 2.6.37.6.

  vdr doesn't know anything about hybrid cards where you can access only
one frontend at the same time.
  On startup vdr opens all frontends, so when accessing the second one
this is blocked.

  Since I don't know this card exactly, what devices does it create? Is
there also a demux[01] and dvr[01] or just a
demux0 and dvr0? Which frontend do you want to use? For now you have to
choose one and start vdr with the "-D" parameter to tell it which to
use.
  If there's no demux1 and dvr1 and you want to use frontend1 you'll
have the next problem since vdr asumes that every frontend has its own
demux/dvr. I wrote a patch, so vdr uses demux0 with frontend1.

  http://linuxtv.org/pipermail/vdr/2011-November/025411.html

  Soon I will have some DVB-C/T hybrid device so I will try to extend
the patch so both frontends can be used (not at the same time of
course).

  It would be nice if you can send me the output of "ls -la
/dev/dvb/adapter0/*".

  I don't know exactly what the dvb/v4l spec is saying about hybrid
devices and how they should expose their capabilities but it seems to me
there's some discussion about this topic from time to time.

  After all this is a problem at application level, not driver level. If
I'm wrong please correct me.
  And maybe you want to read the vdr mailing list...

Regards,
Lars.

>
> The drivers seem to detect the card OK as seen in dmesg output:
>
> [    7.501729] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9
loaded
> [    7.503174] cx88[0]: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
> [    7.503373] cx88[0]: TV tuner type 63, Radio tuner type -1
> [    7.551718] i915 0000:00:02.0: PCI INT A ->  GSI 16 (level, low) ->
IRQ 16
> [    7.551788] i915 0000:00:02.0: setting latency timer to 64
> [    7.564218] i915 0000:00:02.0: irq 41 for MSI/MSI-X
> [    7.564399] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    7.564825] [drm] initialized overlay support
> [    7.579830] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
> [    7.583007] No connectors reported connected with modes
> [    7.583077] [drm] Cannot find any crtc or sizes - going 1024x768
> [    7.588874] Console: switching to colour frame buffer device 128x48
> [    7.591121] fb0: inteldrmfb frame buffer device
> [    7.591144] drm: registered panic notifier
> [    7.591174] No ACPI video bus found
> [    7.591316] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0
on minor 0
> [    7.617097] cx88[0]: i2c init: enabling analog demod on
HVR1300/3000/4000 tuner
> [    7.702578] IR RC5(x) protocol handler initialized
> [    7.728589] IR RC6 protocol handler initialized
> [    7.730628] cx2388x alsa driver version 0.0.9 loaded
> [    7.746096] IR JVC protocol handler initialized
> [    7.749962] IR Sony protocol handler initialized
> [    7.918601] IR MCE Keyboard/mouse protocol handler initialized
> [    7.980484] lirc_dev: IR Remote Control driver registered, major
243
> [    7.994039] IR LIRC bridge handler initialized
> [    7.994767] tda9887 15-0043: creating new instance
> [    7.994795] tda9887 15-0043: tda988[5/6/7] found
> [    7.995608] tuner 15-0043: Tuner 74 found with type(s) Radio TV.
> [    7.997560] tuner 15-0061: Tuner -1 found with type(s) Radio TV.
> [    8.035897] tveeprom 15-0050: Hauppauge model 69009, rev B2D3,
serial# 3313260
> [    8.035934] tveeprom 15-0050: MAC address is 00:0d:fe:32:8e:6c
> [    8.035965] tveeprom 15-0050: tuner model is Philips FMD1216MEX
(idx 133, type 78)
> [    8.036005] tveeprom 15-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
> [    8.036055] tveeprom 15-0050: audio processor is CX882 (idx 33)
> [    8.036085] tveeprom 15-0050: decoder processor is CX882 (idx 25)
> [    8.037240] tveeprom 15-0050: has radio, has IR receiver, has no IR
transmitter
> [    8.038391] cx88[0]: hauppauge eeprom: model=69009
> [    8.042759] tuner-simple 15-0061: creating new instance
> [    8.043910] tuner-simple 15-0061: type set to 78 (Philips
FMD1216MEX MK3 Hybrid Tuner)
> [    8.087006] Registered IR keymap rc-hauppauge
> [    8.088273] input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:1e.0/0000:03:00.2/rc/rc0/input6
> [    8.089502] rc0: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:1e.0/0000:03:00.2/rc/rc0
> [    8.090743] input: MCE IR Keyboard/Mouse (cx88xx) as
/devices/virtual/input/input7
> [    8.092315] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx)
registered at minor = 0
> [    8.093521] cx88[0]/2: cx2388x 8802 Driver Manager
> [    8.094694] cx88-mpeg driver manager 0000:03:00.2: PCI INT A ->
GSI 19 (level, low) ->  IRQ 19
> [    8.095882] cx88[0]/2: found at 0000:03:00.2, rev: 5, irq: 19,
latency: 64, mmio: 0xfc000000
> [    8.097825] cx8800 0000:03:00.0: PCI INT A ->  GSI 19 (level, low)
->  IRQ 19
> [    8.099081] cx88[0]/0: found at 0000:03:00.0, rev: 5, irq: 19,
latency: 64, mmio: 0xfa000000
> [    8.112941] WARNING: You are using an experimental version of the
media stack.
> [    8.112943]  As the driver is backported to an older kernel, it
doesn't offer
> [    8.112944]  enough quality for its usage in production.
> [    8.112945]  Use it with care.
> [    8.112945] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
> [    8.112946]  e9eb0dadba932940f721f9d27544a7818b2fa1c5 [media] V4L
menu: add submenu for platform devices
> [    8.112947]  1df3a2c6d036f4923c229fa98725deda320680e1 [media] cx88:
fix menu level for the VP-3054 module
> [    8.112948]  486eeb5628f812b4836405e2b2e76594287dd873 [media] V4L
menu: move all PCI(e) devices to their own submenu
> [    8.197600] wm8775 15-001b: chip found @ 0x36 (cx88[0])
> [    8.211895] cx88/2: cx2388x dvb driver version 0.0.9 loaded
> [    8.213155] cx88/2: registering cx8802 driver, type: dvb access:
shared
> [    8.213801] cx88[0]/0: registered device video0 [v4l2]
> [    8.213847] cx88[0]/0: registered device vbi0
> [    8.213891] cx88[0]/0: registered device radio0
> [    8.215082] cx88_audio 0000:03:00.1: PCI INT A ->  GSI 19 (level,
low) ->  IRQ 19
> [    8.215106] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> [    8.220763] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
> [    8.222053] cx88[0]/2: cx2388x based DVB/ATSC card
> [    8.223339] cx8802_alloc_frontends() allocating 2 frontend(s)
> [    8.272844] tuner-simple 15-0061: attaching existing instance
> [    8.274126] tuner-simple 15-0061: couldn't set type to 63. Using 78
(Philips FMD1216MEX MK3 Hybrid Tuner) instead
> [    8.279264] DVB: registering new adapter (cx88[0])
> [    8.280558] DVB: registering adapter 0 frontend 0 (Conexant
CX24116/CX24118)...
> [    8.282871] DVB: registering adapter 0 frontend 1 (Conexant CX22702
DVB-T)...
> [    8.423842] Adding 1954444k swap on /dev/sda2.  Priority:-1
extents:1 across:1954444k
> [    8.503564] fuse init (API version 7.15)
> [    9.184585] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    9.308820] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    9.581725] lp0: using parport0 (interrupt-driven).
> [    9.583036] lp0: console ready
> [   14.900540] ATL1E 0000:01:00.0: irq 42 for MSI/MSI-X
> [   20.345506] ATL1E 0000:01:00.0: eth0: NIC Link is Up<10 Mbps Full
Duplex>
> [   29.618702] NET: Registered protocol family 10
> [   29.618871] lo: Disabled Privacy Extensions
> [   40.210009] eth0: no IPv6 routers present
> [  308.497672] start_kdeinit (2104): /proc/2104/oom_adj is deprecated,
please use /proc/2104/oom_score_adj instead.
> [  313.497259] ata3.00: configured for UDMA/133 [  313.497262] ata3: 
> EH complete [  314.195827] EXT4-fs (sda1): re-mounted. Opts: commit=0
>
> However, VDR is only able to use the first of the two frontends,
reporting that the second frontend (DVB/T) is busy:
>
> Nov 13 20:04:06 Nutrigrain vdr: [2426] VDR version 1.7.21 started Nov 
> 13 20:04:06 Nutrigrain vdr: [2426] codeset is 'ISO-8859-1' - known Nov

> 13 20:04:06 Nutrigrain vdr: [2426] found 28 locales in ./locale Nov 13

> 20:04:06 Nutrigrain vdr: [2426] loading plugin: 
> ./PLUGINS/lib/libvdr-sc.so.1.7.21 Nov 13 20:04:06 Nutrigrain vdr: 
> [2426] cTimeMs: using monotonic clock (resolution is 1 ns) Nov 13 
> 20:04:06 Nutrigrain vdr: [2426] loading plugin: 
> ./PLUGINS/lib/libvdr-rotor.so.1.7.21
> Nov 13 20:04:06 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/setup.conf Nov 13 20:04:07 Nutrigrain vdr:
[2426] unknown locale: '0'
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/sources.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/diseqc.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/channels.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/timers.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/commands.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/svdrphosts.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/remote.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2426] loading 
> /home/digitalTV/config/keymacros.conf
> Nov 13 20:04:07 Nutrigrain vdr: [2427] video directory scanner thread 
> started (pid=2426, tid=2427) Nov 13 20:04:07 Nutrigrain vdr: [2428] 
> video directory scanner thread started (pid=2426, tid=2428) Nov 13 
> 20:04:07 Nutrigrain vdr: [2426] reading EPG data from 
> /home/digitalTV/video/epg.data Nov 13 20:04:07 Nutrigrain vdr: [2427] 
> video directory scanner thread ended (pid=2426, tid=2427) Nov 13
20:04:07 Nutrigrain vdr: [2428] video directory scanner thread ended
(pid=2426, tid=2428) Nov 13 20:04:07 Nutrigrain vdr: [2426] registered
source parameters for 'A - ATSC'
> Nov 13 20:04:07 Nutrigrain vdr: [2426] registered source parameters
for 'C - DVB-C'
> Nov 13 20:04:07 Nutrigrain vdr: [2426] registered source parameters
for 'S - DVB-S'
> Nov 13 20:04:07 Nutrigrain vdr: [2426] registered source parameters
for 'T - DVB-T'
> Nov 13 20:04:07 Nutrigrain vdr: [2426] probing 
> /dev/dvb/adapter0/frontend0 Nov 13 20:04:07 Nutrigrain vdr: [2426] new

> device number 1 Nov 13 20:04:12 Nutrigrain vdr: [2426] frontend 0/0 
> provides DVB-S2 with QPSK ("Conexant CX24116/CX24118") Nov 13 20:04:12

> Nutrigrain vdr: [2431] tuner on frontend 0/0 thread started (pid=2426,

> tid=2431) Nov 13 20:04:12 Nutrigrain vdr: [2432] section handler 
> thread started (pid=2426, tid=2432) Nov 13 20:04:17 Nutrigrain vdr: 
> [2426] ERROR: /dev/dvb/adapter0/frontend1: Device or resource busy Nov

> 13 20:04:17 Nutrigrain vdr: [2426] found 1 DVB device
>
> I initially tried using the stock drivers that came with  2.6.37.6
which is where I first experienced the problem. I then tried the latest
s2-liplianin- f5cd7d75370e drivers and finally (in the example above)
the latest v4l-dvb drivers, all of which exhibit the same problem. I
have also tried to use the mfe drivers from November 2008 but could not
get them to compile.
>
> Any assistance in resolving this issue would be much appreciated.
>
> Thanks,
>
> Mark Hawes.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"

> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-media"
in the body of a message to majordomo@vger.kernel.org More majordomo
info at  http://vger.kernel.org/majordomo-info.html


