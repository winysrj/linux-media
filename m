Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36971 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752991AbZBOOFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 09:05:46 -0500
Message-ID: <49982130.3000102@gmx.de>
Date: Sun, 15 Feb 2009 15:05:36 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Please help. HVR1300 - no sound on tv input -> wrong tuner initialization?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to use the cx88_blackbird mpeg encoder on a hvr-1300.
I'm able to get a picture if i'm tuning to a tv frequency, but no sound 
(but audio noise, so the mpeg encoder itself works).
Please note: that card supports DVB-T, PAL-{b/g,d/k,-50,-60} and CCIR 
L/L' and FM radio,
see datasheet from other card using the same tuner: 
http://www.creatix.de/support/download/gruppe6/CTX917_spec.pdf

After loading the drivers, i'm initializing the card using v4l2-ctl and 
try to capture using cat:

# setting pal video size
v4l2-ctl -d /dev/video2 -v width=720,height=576
# setting mpeg encoder to pal video norm                     
v4l2-ctl -d /dev/video2 -s pal-b                                         
        
# setting v4l2 device to pal-b(g)
v4l2-ctl -d /dev/video1 -s pal-b
# setting video input to 0 (television)
v4l2-ctl -d /dev/video1 -i 0
# tuning v4l2 dev to known working freq: 245.25MHz
v4l2-ctl -d /dev/video1 -f 245.25
# enshure that audio is not muted
v4l2-ctl -d /dev/video1 -c mute=0
#  setting audio volume to maximum (63)
v4l2-ctl -d /dev/video1 -c volume=63 >>  ~/status.txt
# card should be initialized now, so start capturing using MPEG2-PS format

cat /dev/video2 > ~/test.ps

I can watch the recorded video in vlc, video is okay - but sound is only 
white noise (like mistuned radio or tv)..
I also notice, if i'm moving freq by ~1MHz video nearly disappear, but 
then i can hear at least a little bit audio (but still noisy then).
I therefore think that the audio comes from the tuner and only the tuner 
is misconfigured.

What i found out so far..

Loading of the card seems to be successful:
<snip>
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:00:0c.0: PCI INT A -> Link[LNKD] -> GSI 5 (level, low) -> IRQ 5
cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56,autodetected], frontend(s): 1
cx88[0]: TV tuner type 63, Radio tuner type -1
wm8775' 1-001b: chip found @ 0x36 (cx88[0])
tuner' 1-0043: chip found @ 0x86 (cx88[0])
tda9887 1-0043: creating new instance
tda9887 1-0043: tda988[5/6/7] found
tuner' 1-0061: chip found @ 0xc2 (cx88[0])
tuner' 1-0063: chip found @ 0xc6 (cx88[0])
cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
tveeprom 1-0050: Hauppauge model 96019, rev C2A0, serial# 307652
tveeprom 1-0050: MAC address is 00-0D-FE-04-B1-C4
tveeprom 1-0050: tuner model is Philips FMD1216ME (idx 100, type 63)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) 
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 1-0050: audio processor is CX882 (idx 33)
tveeprom 1-0050: decoder processor is CX882 (idx 25)
tveeprom 1-0050: has radio, has IR receiver, has IR transmitter
cx88[0]: hauppauge eeprom: model=96019
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
cx88[0]/0: found at 0000:00:0c.0, rev: 5, irq: 5, latency: 32, mmio: 
0xe5000000
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi1
cx88[0]/0: registered device radio0
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:00:0c.2: PCI INT A -> Link[LNKD] -> GSI 5 
(level, low) -> IRQ 5
cx88[0]/2: found at 0000:00:0c.2, rev: 5, irq: 5, latency: 32, mmio: 
0xe3000000
cx2388x blackbird driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx23416 based mpeg encoder (blackbird reference design)
cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized or corrupted
cx88-mpeg driver manager 0000:00:0c.2: firmware: requesting 
v4l-cx2341x-enc.fw
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (cx88[0])
DVB: registering adapter 1 frontend 0 (Conexant CX22702 DVB-T)...
cx88[0]/2-bb: Firmware upload successful.
cx88[0]/2-bb: Firmware version is 0x02060039
cx88[0]/2: registered device video2 [mpeg]
</snap>



if i switch on debugging for the driver loaded i can see additional:
<snip>
cx88[0]: TV tuner type 63, Radio tuner type -1                        << 
thats wrong here, Philips FMD1216ME has FM radio support.
...
tuner' 1-0043: type set to tda9887
tuner' 1-0043: tv freq set to 0.00                                       
       << should be set to something *valid* here, not zero.
tuner' 1-0043: TV freq (0.00) out of range (44-958)
tda9887 1-0043: Unsupported tvnorm entry - audio muted      << wrong tv 
norm, may be the reason for no audio?
...
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi1
cx88[0]/0: registered device radio0
cx88[0]: set_tvnorm: "NTSC-M" fsc8=28636360 adc=28636363 vdec=28636360 
db/dr=28636360/28636360                << again, NTSC is wrong here.
...
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0x00 c=0x00 e=0x00
tuner-simple 1-0061: tv 0x1b 0xdc 0x86 0x52
tuner' 1-0063: Tuner doesn't support this mode. Putting tuner to sleep
...
cx88[0]/2-bb: blackbird_mbox_func: 0x91
cx88[0]/2-bb: API Input 0 = 
480                                           << wrong, the mpeg encoder 
is initialized here to 720x480, has to be 720x576 since HVR1300 is a 
PAL/SECAM device
cx88[0]/2-bb: API Input 1 = 720
cx88[0]/2-bb: API result = 0
...
cx88[0]/2: registered device video2 [mpeg]
cx88[0]: set_tvnorm: "NTSC-M" fsc8=28636360 adc=28636363 vdec=28636360 
db/dr=28636360/28636360    << again, thats wrong, the HVR1300 cannot 
handle NTSC.
</snap>

may be somebody can help here

Winfried



