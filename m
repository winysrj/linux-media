Return-path: <mchehab@gaivota>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:63225 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0LPUZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 15:25:19 -0500
Received: by gwb20 with SMTP id 20so2649136gwb.1
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 12:25:18 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 16 Dec 2010 13:25:17 -0700
Message-ID: <AANLkTikgm8YPzme164cX_wy4btLQPXGDGZdLTCbN2Zxr@mail.gmail.com>
Subject: KWorld ATSC 120 stopped working in Fedora 14
From: Mark Goldberg <marklgoldberg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This card was working in Fedora 12 with the Atrpms V4l from
a 201090401 snapshot. With Fedora 14 kernel 2.6.35.9-64.fc14.x86_64
the tuner does not find any ATSC channels. I two other cards that still
work.

Relevant from dmesg:
[    0.000000] Command line: ro
root=UUID=1a37f5f8-8794-4f5b-af11-5d9b67438bd8
SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
rdblacklist=nouveau vga=31B rdblacklist=cx8800 rdblacklist=cx8802
rdblacklist=cx88-alsa rdblacklist=cx88-dvb
[    0.000000] Kernel command line: ro
root=UUID=1a37f5f8-8794-4f5b-af11-5d9b67438bd8
SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
rdblacklist=nouveau vga=31B rdblacklist=cx8800 rdblacklist=cx8802
rdblacklist=cx88-alsa rdblacklist=cx88-dvb
[   45.098855] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.8 loaded
[   45.101130] cx88[0]: subsystem: 17de:08c1, board: Kworld PlusTV HD
PCI 120 (ATSC 120) [card=67,autodetected], frontend(s): 1
[   45.101972] cx88[0]: TV tuner type 71, Radio tuner type -1
[   45.102825] cx88[0]: cx88_reset
[   45.214124] cx88[0]: i2c register ok
[   45.282964] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
[   45.283837] cx88[0]/2: cx2388x 8802 Driver Manager
[   45.284740] cx88-mpeg driver manager 0000:04:07.2: PCI INT A -> GSI
22 (level, low) -> IRQ 22
[   45.285646] cx88[0]/2: found at 0000:04:07.2, rev: 5, irq: 22,
latency: 64, mmio: 0xfb000000
[   45.294888] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[   45.295784] cx88/2: registering cx8802 driver, type: dvb access: shared
[   45.296700] cx88[0]/2: subsystem: 17de:08c1, board: Kworld PlusTV
HD PCI 120 (ATSC 120) [card=67]
[   45.296714] cx88[0]/2-dvb: cx8802_dvb_probe
[   45.296717] cx88[0]/2-dvb:  ->being probed by Card=67 Name=cx88[0], PCI 04:07
[   45.296719] cx88[0]/2: cx2388x based DVB/ATSC card
[   45.296720] cx8802_alloc_frontends() allocating 1 frontend(s)
[   45.392133] cx88[0]/2: xc3028 attached
[   45.394621] DVB: registering new adapter (cx88[0])
[  106.834823] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[  106.834835] cx88[0]/2-mpeg: cx8802_request_acquire() Post acquire GPIO=ff
<above two lines repeat many times>
[  182.752026] cx88[0]: Calling XC2028/3028 callback
<above line repeats many times>
[ 1164.358595] cx88[0]/2-dvb: cx8802_dvb_advise_release
[ 1164.358599] cx88[0]/2-mpeg: cx8802_request_release() Post release GPIO=ff
[ 2829.664271] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[ 2829.664283] cx88[0]/2-mpeg: cx8802_request_acquire() Post acquire GPIO=ff
<above four lines repeat many times>

I generally followed http://linuxtv.org/wiki/index.php/KWorld_ATSC_120
and blacklisted the drivers and loaded cx88-dvb. You don't have to move
the blacklist out of the way for Fedora and it seems that the right set
of modules get loaded. From the wiki it calls for dvb-fe-xc5000-1.1.fw
but that does not seem to be used for this card and a newer
version is in Fedora 14. Firmware xc3028-v27.fw seems to be
loaded.

>From lsmod | grep cx88:
cx88_dvb               23891  1
cx88_vp3054_i2c         2048  1 cx88_dvb
cx8802                 12810  1 cx88_dvb
cx88xx                 73785  2 cx88_dvb,cx8802
i2c_algo_bit            5205  2 cx88_vp3054_i2c,cx88xx
btcx_risc               3738  2 cx8802,cx88xx
videobuf_dvb            5242  2 cx88_dvb,saa7134_dvb
dvb_core               89889  3 cx88_dvb,videobuf_dvb,pvrusb2
v4l2_common            16581  8
cx88xx,saa7134,wm8775,tuner,cx25840,hdpvr,pvrusb2,cx2341x
videodev               41889  8
cx88xx,saa7134,wm8775,tuner,cx25840,hdpvr,pvrusb2,v4l2_common
videobuf_dma_sg         9613  6
cx88_dvb,cx8802,cx88xx,saa7134_alsa,saa7134_dvb,saa7134
videobuf_core          15769  5
cx8802,cx88xx,videobuf_dvb,saa7134,videobuf_dma_sg
ir_common               5132  2 cx88xx,saa7134
ir_core                16339  12
cx88xx,saa7134,ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,rc_rc6_mce,ir_rc5_decoder,mceusb,ir_common,ir_nec_decoder
tveeprom               13145  3 cx88xx,saa7134,pvrusb2
i2c_core               26900  22
tuner_xc2028,s5h1409,cx88_dvb,cx88_vp3054_i2c,cx88xx,i2c_algo_bit,nxt200x,saa7134_dvb,nvidia,tuner_simple,tda9887,tda8290,saa7134,wm8775,tuner,cx25840,hdpvr,pvrusb2,v4l2_common,videodev,i2c_piix4,tveeprom

>From /etc/modprobe.d/local.conf:
blacklist cx8800
blacklist cx8802
blacklist cx88-alsa
blacklist cx88-dvb
options cx88_dvb adapter_nr=2 debug=1
options cx88xx core_debug=1 disable_ir=1 i2c_debug=1
options cx8802 debug=1

Any suggestions are welcome.

Mark
