Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:16578 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZD2Jrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 05:47:53 -0400
Received: by qw-out-2122.google.com with SMTP id 5so937768qwd.37
        for <linux-media@vger.kernel.org>; Wed, 29 Apr 2009 02:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240939480.3731.27.camel@pc07.localdom.local>
References: <5e20e5fc0904280902h12e62b0dq51e21c2945665f5f@mail.gmail.com>
	<1240939480.3731.27.camel@pc07.localdom.local>
From: Sam Spilsbury <smspillaz@gmail.com>
Date: Wed, 29 Apr 2009 17:47:32 +0800
Message-ID: <5e20e5fc0904290247o276f8bai7011a2bd9232f2ed@mail.gmail.com>
Subject: Re: ASUS 'My Cinema Europa Hybrid' (P7131 DVB-T) [SAA7134] Firmware
	oddities
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 29, 2009 at 1:24 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> Hello,
>
> you seem to have a card which is not in the database of the saa7134
> driver yet.

OK. Are the steps below necessary to put into a text file somewhere to
add it to the database?

>
> Am Mittwoch, den 29.04.2009, 00:02 +0800 schrieb Sam Spilsbury:
>> Hi everyone,
>>
>> So It's my first time to LinuxTV hacking, debugging etc, so I
>> apologize if I've failed to provide anything essential.
>>
>> Anyways, I've just bought a ASUS 'My Cinema Europa Hybrid' (P7131
>> DVB-T) which has the Phillips saa7131 chipset in it (supported by the
>> saa7131 module et al). There is a problem getting the firmware in this
>> card to boot correctly - I may have the wrong card number and I cannot
>> use i2c because it detects it as UNKNOWN/GENERIC (i.e type 0) which
>> doesn't work.
>
> The driver detects a saa7134 chip on it.
>
>> According to /usr/share/doc/linux/video4linux etc my card number
>> should be either 78, 111 or 112. Specifying card=x seems to make the
>> module somewhat recognize the card, and even though I have the
>> firmware - it won't actually boot. This is shown by the fact that all
>> dvb operations essentially just time out and the fact that I cannot
>> scan channels in software like tvtime. I might be wrong though.
>
> None of these above cards can work for you.

OK. They all looked pretty close (ASUS P7131) so I thought I might
give them a try. (P7131 is what it said on the box of my card - but
interestingly enough even though the specs on the box say it comes
with composite and composite inputs it doesn't - do you think this
might be a case of shipping muckup or just a lower model of the card?)

>
>> Here is relevant output which might assist in helping the problem:
>>
>> ==== dmesg log ====c
>>
>> saa7130/34: v4l2 driver version 0.2.14 loaded
>> saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
>> 0xeb007000
>> saa7134[0]: subsystem: 1043:4847, board: ASUSTeK P7131 Dual
>
> Here we see a new Asus card with subdevice 0x4847.
>
>> [card=78,insmod option]
>> saa7134[0]: board init: gpio is 200000
>
> Was board init gpio the same for card=0 UNKNOWN/GENERIC before you tried
> any other card?

This is basically what I got with dmesg with UNKNOWN/GENERIC
[card=0,autodetected]

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
0xeb007000
saa7134[0]: subsystem: 1043:4847, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7134[0]: board init: gpio is 0
saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c scan: found device @ 0x10  [???]
saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0

>
>> input: saa7134 IR (ASUSTeK P7131 Dual) as
>> /devices/pci0000:00/0000:00:09.0/input/input7
>> tuner' 3-0043: chip found @ 0x86 (saa7134[0])
>> tda9887 3-0043: creating new instance
>> tda9887 3-0043: tda988[5/6/7] found
>
> There is likely not only the tda9885/6/7 analog IF demodulator, but also
> an old style can tuner at 0xc2. With i2c_scan=1, try "modinfo saa7134",
> it might be detected.

Not sure how to check for that - but here is the output of "modinfo saa7134"

[root@Foxconn-F10 Sam]# modinfo saa7134
filename:
/lib/modules/2.6.27.21-170.2.56.fc10.i686/kernel/drivers/media/video/saa7134/saa7134.ko
license:        GPL
author:         Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
description:    v4l2 driver module for saa7130/34 based TV cards
srcversion:     04662F13D538E5E62B3A188
alias:          pci:v00001131d00007135sv*sd*bc*sc*i*
alias:          pci:v00001131d00007134sv*sd*bc*sc*i*
alias:          pci:v00001131d00007133sv*sd*bc*sc*i*
alias:          pci:v00001131d00007130sv*sd*bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00000000bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00000000bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F636bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006290bc*sc*i*
alias:          pci:v00001131d00007133sv00005169sd00001502bc*sc*i*
alias:          pci:v00001131d00007133sv0000185Bsd0000C900bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000A836bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F936bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F436bc*sc*i*
alias:          pci:v00001131d00007133sv00001462sd00008625bc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd00000010bc*sc*i*
alias:          pci:v00001131d00007133sv00001822sd00000022bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00003502bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006191bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006193bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006190bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006093bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006092bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006091bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006090bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006073bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006072bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006071bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006070bc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00005201bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00005090bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00005070bc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd0000507Bbc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00005071bc*sc*i*
alias:          pci:v00001131d00007130sv00005ACEsd00005050bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd0000505Bbc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd00005051bc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00004090bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004071bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004070bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd00004051bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd00004050bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004037bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004036bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd00004016bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F01Dbc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002304bc*sc*i*
alias:          pci:v00001131d00007134sv00000919sd00002003bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004857bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004871bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00000306bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F31Ebc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001175bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd0000230Fbc*sc*i*
alias:          pci:v00001131d00007130sv00003016sd00002344bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002341bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002342bc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001172bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006705bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006704bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006703bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006702bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006701bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006700bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004876bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd00009715bc*sc*i*
alias:          pci:v00001131d00007133sv000011BDsd0000002Fbc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004860bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00002C00bc*sc*i*
alias:          pci:v00001131d00007130sv00000919sd00002003bc*sc*i*
alias:          pci:v00001131d00007133sv00001489sd00000502bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd00002C05bc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd0000000Dbc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd00000008bc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd00000007bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00003307bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00003502bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00003306bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000304bc*sc*i*
alias:          pci:v00001131d00007134sv00001489sd00000301bc*sc*i*
alias:          pci:v00001131d00007134sv00004E42sd00000300bc*sc*i*
alias:          pci:v00001131d00007134sv00005168sd00000300bc*sc*i*
alias:          pci:v00001131d00007134sv000016BEsd00000005bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00006360bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00007360bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007352bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007350bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007250bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007201bc*sc*i*
alias:          pci:v00001131d00007133sv00000331sd00001421bc*sc*i*
alias:          pci:v00001131d00007134sv00005168sd00000301bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00002C05bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000319bc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001160bc*sc*i*
alias:          pci:v00001131d00007133sv00001462sd00008624bc*sc*i*
alias:          pci:v00001131d00007133sv00001462sd00006231bc*sc*i*
alias:          pci:v00001131d00007133sv00001131sd00002018bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004862bc*sc*i*
alias:          pci:v00001131d00007133sv000011BDsd0000002Ebc*sc*i*
alias:          pci:v00001131d00007133sv00001131sd00004EE9bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd00001044bc*sc*i*
alias:          pci:v00001131d00007133sv00001435sd00007330bc*sc*i*
alias:          pci:v00001131d00007133sv00001435sd00007350bc*sc*i*
alias:          pci:v00001131d00007130sv0000185Bsd0000C901bc*sc*i*
alias:          pci:v00001131d00007134sv0000185Bsd0000C900bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00002004bc*sc*i*
alias:          pci:v00001131d00007133sv00005456sd00007135bc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00004091bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00000210bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00000210bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00000502bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00001370bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00000370bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00000351bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00000350bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002004bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F31Fbc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000306bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000502bc*sc*i*
alias:          pci:v00001131d00007134sv00001540sd00009524bc*sc*i*
alias:          pci:v00001131d00007134sv0000185Bsd0000C200bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000A70Abc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00009715bc*sc*i*
alias:          pci:v00001131d00007130sv0000185Bsd0000C100bc*sc*i*
alias:          pci:v00001131d00007130sv0000153Bsd00001152bc*sc*i*
alias:          pci:v00001131d00007133sv000012ABsd00000800bc*sc*i*
alias:          pci:v00001131d00007134sv00001019sd00004CB6bc*sc*i*
alias:          pci:v00001131d00007133sv00001019sd00004CB5bc*sc*i*
alias:          pci:v00001131d00007134sv00001019sd00004CB4bc*sc*i*
alias:          pci:v00001131d00007134sv000011BDsd0000002Dbc*sc*i*
alias:          pci:v00001131d00007134sv000011BDsd0000002Bbc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd0000050Cbc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000D6EEbc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd000010FFbc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd00002108bc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd00002115bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000A7A2bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000A7A1bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000A70Bbc*sc*i*
alias:          pci:v00001131d00007130sv0000102Bsd000048D0bc*sc*i*
alias:          pci:v00001131d00007133sv0000185Bsd0000C100bc*sc*i*
alias:          pci:v00001131d00007133sv0000185Bsd0000C100bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002001bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00007133bc*sc*i*
alias:          pci:v00001131d00007134sv00001894sd0000A006bc*sc*i*
alias:          pci:v00001131d00007134sv00001894sd0000FE01bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd0000FE01bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004840bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004843bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004830bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004845bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004842bc*sc*i*
alias:          pci:v00001131d00007130sv00001048sd0000226Cbc*sc*i*
alias:          pci:v00001131d00007130sv00001048sd0000226Abc*sc*i*
alias:          pci:v00001131d00007130sv00001048sd0000226Bbc*sc*i*
alias:          pci:v00001131d00007134sv000016BEsd00000003bc*sc*i*
alias:          pci:v00001131d00007133sv00001489sd00000214bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00005214bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000214bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00000212bc*sc*i*
alias:          pci:v00001131d00007133sv000014C0sd00001212bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000212bc*sc*i*
alias:          pci:v00001131d00007130sv00004E42sd00000138bc*sc*i*
alias:          pci:v00001131d00007130sv00005168sd00000138bc*sc*i*
alias:          pci:v00001131d00007134sv00004E42sd00000138bc*sc*i*
alias:          pci:v00001131d00007134sv00005168sd00000138bc*sc*i*
alias:          pci:v00001131d00007134sv00005169sd00000138bc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001162bc*sc*i*
alias:          pci:v00001131d00007134sv0000153Bsd00001158bc*sc*i*
alias:          pci:v00001131d00007134sv0000153Bsd00001143bc*sc*i*
alias:          pci:v00001131d00007134sv0000153Bsd00001142bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00004E85bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00006752bc*sc*i*
alias:          pci:v00001131d00007133sv00001131sd00002001bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00002001bc*sc*i*
depends:
videobuf-core,videobuf-dma-sg,i2c-core,ir-common,videodev,tveeprom,v4l2-common,compat_ioctl32
vermagic:       2.6.27.21-170.2.56.fc10.i686 SMP mod_unload 686 4KSTACKS
parm:           disable_ir:disable infrared remote support (int)
parm:           ir_debug:enable debug messages [IR] (int)
parm:           pinnacle_remote:Specify Pinnacle PCTV remote:
0=coloured, 1=grey (defaults to 0) (int)
parm:           ir_rc5_remote_gap:int
parm:           ir_rc5_key_timeout:int
parm:           repeat_delay:delay before key repeat started (int)
parm:           repeat_period:repeat period between keypresses when
key is down (int)
parm:           disable_other_ir:disable full codes of alternative
remotes from other manufacturers (int)
parm:           video_debug:enable debug messages [video] (int)
parm:           gbuffers:number of capture buffers, range 2-32 (int)
parm:           noninterlaced:capture non interlaced video (int)
parm:           secam:force SECAM variant, either DK,L or Lc (string)
parm:           vbi_debug:enable debug messages [vbi] (int)
parm:           vbibufs:number of vbi buffers, range 2-32 (int)
parm:           audio_debug:enable debug messages [tv audio] (int)
parm:           audio_ddep:audio ddep overwrite (int)
parm:           audio_clock_override:int
parm:           audio_clock_tweak:Audio clock tick fine tuning for
cards with audio crystal that's slightly off (range [-1024 .. 1024])
(int)
parm:           ts_debug:enable debug messages [ts] (int)
parm:           tsbufs:number of ts buffers, range 2-32 (int)
parm:           ts_nr_packets:size of a ts buffers (in ts packets) (int)
parm:           i2c_debug:enable debug messages [i2c] (int)
parm:           i2c_scan:scan i2c bus at insmod time (int)
parm:           irq_debug:enable debug messages [IRQ handler] (int)
parm:           core_debug:enable debug messages [core] (int)
parm:           gpio_tracking:enable debug messages [gpio] (int)
parm:           alsa:enable ALSA DMA sound [dmasound] (int)
parm:           oss:enable OSS DMA sound [dmasound] (int)
parm:           latency:pci latency timer (int)
parm:           no_overlay:allow override overlay default (0 disables,
1 enables) [some VIA/SIS chipsets are known to have problem with
overlay] (int)
parm:           video_nr:video device number (array of int)
parm:           vbi_nr:vbi device number (array of int)
parm:           radio_nr:radio device number (array of int)
parm:           tuner:tuner type (array of int)
parm:           card:card type (array of int)

>
> It is also not the Asus Europa2 hybrid design here and not a Philips
> FMD1216ME MK3 hybrid. On this card tda9887 and the tuner PLL chip are
> not visible on the bus until the i2c bridge of the tda10046 DVB-T demod
> is opened.

Strange. Do you know what it might be? (The box says it's a Europa Hybrid)

>
>> saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>> saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
>> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
>
> This sequence here is the same for the SAA7134_BOARD_VIDEOMATE_DVBT_200A
> and it has some sort of Philips TD1316 tuner. Analog tuner support is
> not enabled on this card.

So the card says it comes with analog tuner support but it's not enabled?

>
>> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7134[0]: registered device video0 [v4l2]
>> saa7134[0]: registered device vbi0
>> saa7134[0]: registered device radio0
>> DVB: registering new adapter (saa7134[0])
>> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
>> tda1004x: setting up plls for 48MHz sampling clock
>> tda1004x: timeout waiting for DSP ready
>> tda1004x: found firmware revision 0 -- invalid
>> tda1004x: trying to boot from eeprom
>> tda1004x: found firmware revision 26 -- ok
>> saa7134[0]/dvb: could not access tda8290 I2C gate
>> tda827x_probe_version: could not read from tuner at addr: 0xc2
>
> You get this, because on your card are no such silicon analog demod and
> tuner chips.
>
>> ===== Relevant bits of lspci =====
>>
>> 00:09.0 Multimedia controller: Philips Semiconductors
>> SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
>>        Subsystem: ASUSTeK Computer Inc. Device 4847
>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 32 (21000ns min, 8000ns max)
>>        Interrupt: pin A routed to IRQ 18
>>        Region 0: Memory at eb007000 (32-bit, non-prefetchable) [size=1K]
>>        Capabilities: [40] Power Management version 1
>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>        Kernel driver in use: saa7134
>>        Kernel modules: saa7134
>>
>>
>> Any help would be greatly appreciated however I understand if this
>> isn't a fixable issue. If so it would be nice to know where I could
>> buy (online) TV Tuner cards with a composite input, are the old PCI
>> type and of course work well with Linux (Fedora 10 at least).
>
> You might try to force the Compro DVB-T 200A card=103 and see what
> happens for DVB-T. Composite input you will get to work in any case.

Here is what I get when I specify card=103

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
0xeb007000
saa7134[0]: subsystem: 1043:4847, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7134[0]: board init: gpio is 0
saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c scan: found device @ 0x10  [???]
saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
0xeb007000
saa7134[0]: subsystem: 1043:4847, board: Compro Videomate DVB-T200A
[card=103,insmod option]
saa7134[0]: board init: gpio is 0
saa7134[0]: Oops: IR config error [card=103]
saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
DVB: registering new adapter (saa7134[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok

I've waited about 5 minutes after loading the module and no errors
have been reported so far. However I don't seem to be getting anything
from dvbdate, dvbsnoop etc.

kdetv displays static but I can't seem to tune any channels.


>
> Good Luck,
>
> Hermann
>
>


Cheers,

Sam

>



-- 
Sam Spilsbury
