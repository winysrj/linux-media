Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:57456 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753827Ab2C0RwE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Mar 2012 13:52:04 -0400
From: Nils Kassube <kassube@gmx.net>
To: linux-media@vger.kernel.org
Subject: Possible fix for radio issue with bttv driver  (card=24)
Date: Tue, 27 Mar 2012 19:46:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203271946.39670.kassube@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

while I was testing the upcoming Kubuntu 12.04 version (kernel 3.2.0), I
found that the radio mode of my TV/FM card doesn't work any longer.
There is only noise and no station is tuned. Until now I used Kubuntu
10.04 with kernel 2.6.32 and radio works. This is a rather old card (~10
years) detected as card type 24 and the only additional information I
have about it is the sticker on the tuner which reads "FM1216/PH".

I compiled the latest mainline kernel (3.3.0) and the media_build tree 
to verify that the problem still exists. With debug options enabled I 
found this line in the syslog when I try to use the radio mode:

tuner 0-0060: Tuner doesn't support mode 1. Putting tuner to sleep

The line is written by function set_mode in tuner-core.c if check_mode 
returns -EINVAL. If I bypass the check_mode function (always return 0), 
the radio works. However, bypassing the check is certainly not a useful 
solution, so I tried to find the reason for the issue.

During the initialization of the btty driver, this is written to the
syslog:

 1 bttv: driver version 0.9.19 loaded
 2 bttv: using 8 buffers with 2080k (520 pages) each for capture
 3 bttv: Bt8xx card found (0)
 4 bttv: 0: Bt878 (rev 2) at 0000:0c:07.0, irq: 21, latency: 132, mmio: 0xd2000000
 5 bttv: 0: detected: (Askey Magic/others) TView99 CPH05x [card=24], PCI subsystem ID is 144f:3002
 6 bttv: 0: using: Askey CPH05X/06X (bt878) [many vendors] [card=24,autodetected]
 7 bttv: 0: radio detected by subsystem id (CPH05x)
 8 bttv: 0: tuner type=5
 9 i2c-core: driver [msp3400] using legacy suspend method
10 i2c-core: driver [msp3400] using legacy resume method
11 bttv: 0: audio absent, no audio device found!
12 i2c-core: driver [tuner] using legacy suspend method
13 i2c-core: driver [tuner] using legacy resume method
14 All bytes are equal. It is not a TEA5767
15 tuner 0-0060: Setting mode_mask to 0x06
16 tuner 0-0060: tuner 0x60: Tuner type absent
17 tuner 0-0060: Tuner -1 found with type(s) Radio TV.
18 tuner 0-0060: Calling set_type_addr for type=5, addr=0xff, mode=0x04, config=0xffff8800
19 tuner 0-0060: defining GPIO callback
20 tuner-simple 0-0060: creating new instance
21 tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
22 tuner-simple 0-0060: tuner 0 atv rf input will be autoselected
23 tuner-simple 0-0060: tuner 0 dtv rf input will be autoselected
24 tuner 0-0060: type set to Philips PAL_BG (FI1216 and compatibles)
25 tuner 0-0060: tv freq set to 400.00
26 tuner-simple 0-0060: using tuner params #0 (pal)
27 tuner-simple 0-0060: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x90
28 tuner-simple 0-0060: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
29 tuner-simple 0-0060: tv 0x1b 0x6f 0x8e 0x90
30 tuner 0-0060: bt878 #0 [sw] tuner I2C addr 0xc0 with type 5 used for 0x04
31 bttv: 0: registered device video0
32 bttv: 0: registered device vbi0
33 bttv: 0: registered device radio0

While the driver has found both radio and TV according to line 17, the 
call to tuner_s_type_addr (line 18) is using mode=4 which means TV only. 
The function tuner_s_type_addr is called from function bttv_init_tuner 
in bttv-cards.c with this code snippet:

		tun_setup.mode_mask = T_ANALOG_TV;
		tun_setup.type = btv->tuner_type;
		tun_setup.addr = addr;

		if (bttv_tvcards[btv->c.type].has_radio)
			tun_setup.mode_mask |= T_RADIO;

		bttv_call_all(btv, tuner, s_type_addr, &tun_setup);

Well, the card definition for card 24 (0x18) doesn't set the has_radio 
option. Therefore a possible fix would be to add a line

                .has_radio      = 1,

at the end of the card definition for this card. But I have no idea, if
there are other boards of the same card type but without radio, so this
might be a wrong approach.

OTOH, shouldn't the has_radio option be taken from the btv struct
instead of the card definition? After all, the btv struct has the
has_radio otion correctly set at this point (at least for my card). Then
the modified code snippet above should look like this:

		tun_setup.mode_mask = T_ANALOG_TV;
		tun_setup.type = btv->tuner_type;
		tun_setup.addr = addr;

		if (btv->has_radio)
			tun_setup.mode_mask |= T_RADIO;

		bttv_call_all(btv, tuner, s_type_addr, &tun_setup);

This version might also fix the problem mentioned at [1].


Nils

[1] <https://lkml.org/lkml/2011/11/11/257>

