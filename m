Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:63036 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315Ab0BJSJM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:09:12 -0500
Date: Wed, 10 Feb 2010 19:09:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
 variants
Message-ID: <20100210190907.5c695e4e@hyperion.delvare>
In-Reply-To: <4B681173.1030404@redhat.com>
References: <20100127120211.2d022375@hyperion.delvare>
	<4B630179.3080006@redhat.com>
	<1264812461.16350.90.camel@localhost>
	<20100130115632.03da7e1b@hyperion.delvare>
	<1264986995.21486.20.camel@pc07.localdom.local>
	<20100201105628.77057856@hyperion.delvare>
	<1265075273.2588.51.camel@localhost>
	<20100202085415.38a1e362@hyperion.delvare>
	<4B681173.1030404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Sorry for the late answer. I'm tracking so many things in parallel...

On Tue, 02 Feb 2010 09:50:11 -0200, Mauro Carvalho Chehab wrote:
> The init1 code has 107 boards listed:
> 
> SAA7134_BOARD_10MOONSTVMASTER3
> SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
> SAA7134_BOARD_ASUST
> SAA7134_BOARD_AVACSSMARTTV
> SAA7134_BOARD_AVERMEDIA_305
> SAA7134_BOARD_AVERMEDIA_307
> SAA7134_BOARD_AVERMEDIA_777
> SAA7134_BOARD_AVERMEDIA_A169_B
> SAA7134_BOARD_AVERMEDIA_A16AR
> SAA7134_BOARD_AVERMEDIA_A16D
> SAA7134_BOARD_AVERMEDIA_A700_HYBRID
> SAA7134_BOARD_AVERMEDIA_A700_PRO
> SAA7134_BOARD_AVERMEDIA_CARDBUS
> SAA7134_BOARD_AVERMEDIA_CARDBUS_501
> SAA7134_BOARD_AVERMEDIA_CARDBUS_506
> SAA7134_BOARD_AVERMEDIA_GO_007_FM
> SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS
> SAA7134_BOARD_AVERMEDIA_M102
> SAA7134_BOARD_AVERMEDIA_M103
> SAA7134_BOARD_AVERMEDIA_M115
> SAA7134_BOARD_AVERMEDIA_M135A
> SAA7134_BOARD_AVERMEDIA_STUDIO_305
> SAA7134_BOARD_AVERMEDIA_STUDIO_307
> SAA7134_BOARD_AVERMEDIA_STUDIO_505
> SAA7134_BOARD_AVERMEDIA_STUDIO_507
> SAA7134_BOARD_BEHOLD_401
> SAA7134_BOARD_BEHOLD_403
> SAA7134_BOARD_BEHOLD_403FM
> SAA7134_BOARD_BEHOLD_405
> SAA7134_BOARD_BEHOLD_405FM
> SAA7134_BOARD_BEHOLD_407
> SAA7134_BOARD_BEHOLD_407FM
> SAA7134_BOARD_BEHOLD_409
> SAA7134_BOARD_BEHOLD_409FM
> SAA7134_BOARD_BEHOLD_505FM
> SAA7134_BOARD_BEHOLD_505RDS_MK3
> SAA7134_BOARD_BEHOLD_505RDS_MK5
> SAA7134_BOARD_BEHOLD_507_9FM
> SAA7134_BOARD_BEHOLD_507RDS_MK3
> SAA7134_BOARD_BEHOLD_507RDS_MK5
> SAA7134_BOARD_BEHOLD_607FM_MK3
> SAA7134_BOARD_BEHOLD_607FM_MK5
> SAA7134_BOARD_BEHOLD_607RDS_MK3
> SAA7134_BOARD_BEHOLD_607RDS_MK5
> SAA7134_BOARD_BEHOLD_609FM_MK3
> SAA7134_BOARD_BEHOLD_609FM_MK5
> SAA7134_BOARD_BEHOLD_609RDS_MK3
> SAA7134_BOARD_BEHOLD_609RDS_MK5
> SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
> SAA7134_BOARD_BEHOLD_H6
> SAA7134_BOARD_BEHOLD_M6
> SAA7134_BOARD_BEHOLD_M63
> SAA7134_BOARD_BEHOLD_M6_EXTRA
> SAA7134_BOARD_BEHOLD_X7
> SAA7134_BOARD_CINERGY400
> SAA7134_BOARD_CINERGY400_CARDBUS
> SAA7134_BOARD_CINERGY600
> SAA7134_BOARD_CINERGY600_MK3
> SAA7134_BOARD_ECS_TVP3XP
> SAA7134_BOARD_ECS_TVP3XP_4CB5
> SAA7134_BOARD_ECS_TVP3XP_4CB6
> SAA7134_BOARD_ENCORE_ENLTV
> SAA7134_BOARD_ENCORE_ENLTV_FM
> SAA7134_BOARD_ENCORE_ENLTV_FM53
> SAA7134_BOARD_FLYDVBS_LR300
> SAA7134_BOARD_FLYDVBTDUO
> SAA7134_BOARD_FLYDVBT_DUO_CARDBUS
> SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
> SAA7134_BOARD_FLYDVBT_LR301
> SAA7134_BOARD_FLYTVPLATINUM_FM
> SAA7134_BOARD_FLYTVPLATINUM_MINI2
> SAA7134_BOARD_FLYVIDEO2000
> SAA7134_BOARD_FLYVIDEO3000
> SAA7134_BOARD_FLYVIDEO3000_NTSC
> SAA7134_BOARD_GENIUS_TVGO_A11MCE
> SAA7134_BOARD_GOTVIEW_7135
> SAA7134_BOARD_HAUPPAUGE_HVR1110
> SAA7134_BOARD_HAUPPAUGE_HVR1120
> SAA7134_BOARD_HAUPPAUGE_HVR1150
> SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG
> SAA7134_BOARD_KWORLD_TERMINATOR
> SAA7134_BOARD_KWORLD_VSTREAM_XPERT
> SAA7134_BOARD_KWORLD_XPERT
> SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S
> SAA7134_BOARD_MANLI_MTV001
> SAA7134_BOARD_MANLI_MTV002
> SAA7134_BOARD_MD2819
> SAA7134_BOARD_MD5044
> SAA7134_BOARD_MONSTERTV_MOBILE
> SAA7134_BOARD_MSI_TVATANYWHERE_PLUS
> SAA7134_BOARD_PINNACLE_300I_DVBT_PAL
> SAA7134_BOARD_PINNACLE_PCTV_110
> SAA7134_BOARD_PINNACLE_PCTV_310
> SAA7134_BOARD_PROTEUS_2309
> SAA7134_BOARD_REAL_ANGEL_220
> SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM
> SAA7134_BOARD_RTD_VFG7350
> SAA7134_BOARD_SABRENT_SBTTVFM
> SAA7134_BOARD_SEDNA_PC_TV_CARDBUS
> SAA7134_BOARD_UPMOST_PURPLE_TV
> SAA7134_BOARD_VIDEOMATE_DVBT_200
> SAA7134_BOARD_VIDEOMATE_DVBT_200A
> SAA7134_BOARD_VIDEOMATE_DVBT_300
> SAA7134_BOARD_VIDEOMATE_GOLD_PLUS
> SAA7134_BOARD_VIDEOMATE_S350
> SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII
> SAA7134_BOARD_VIDEOMATE_TV_PVR
> 
> The init2 code has 32 boards listed:
> 
> SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
> SAA7134_BOARD_ADS_INSTANT_HDTV_PCI
> SAA7134_BOARD_ASUS_EUROPA2_HYBRID
> SAA7134_BOARD_ASUS_EUROPA_HYBRID
> SAA7134_BOARD_ASUST
> SAA7134_BOARD_AVERMEDIA_CARDBUS_501
> SAA7134_BOARD_AVERMEDIA_SUPER_007
> SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
> SAA7134_BOARD_BMK_MPEX_NOTUNER
> SAA7134_BOARD_BMK_MPEX_TUNER
> SAA7134_BOARD_CINERGY_HT_PCI
> SAA7134_BOARD_CINERGY_HT_PCMCIA
> SAA7134_BOARD_CREATIX_CTX953
> SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
> SAA7134_BOARD_FLYDVB_TRIO
> SAA7134_BOARD_HAUPPAUGE_HVR1110
> SAA7134_BOARD_HAUPPAUGE_HVR1120
> SAA7134_BOARD_HAUPPAUGE_HVR1150
> SAA7134_BOARD_KWORLD_ATSC110
> SAA7134_BOARD_KWORLD_DVBT_210
> SAA7134_BOARD_MD7134
> SAA7134_BOARD_MEDION_MD8800_QUADRO
> SAA7134_BOARD_PHILIPS_EUROPA
> SAA7134_BOARD_PHILIPS_SNAKE
> SAA7134_BOARD_PHILIPS_TIGER
> SAA7134_BOARD_PHILIPS_TIGER_S
> SAA7134_BOARD_PINNACLE_PCTV_310
> SAA7134_BOARD_TEVION_DVBT_220RF
> SAA7134_BOARD_TWINHAN_DTV_DVB_3056
> SAA7134_BOARD_VIDEOMATE_DVBT_200
> SAA7134_BOARD_VIDEOMATE_DVBT_200A
> SAA7134_BOARD_VIDEOMATE_DVBT_300
> 
> From all those entries, there are 15 boards that are listed on both init1 and init2:
> 
> SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
> SAA7134_BOARD_ASUST
> SAA7134_BOARD_AVERMEDIA_CARDBUS_501
> SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
> SAA7134_BOARD_BMK_MPEX_NOTUNER
> SAA7134_BOARD_BMK_MPEX_TUNER
> SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
> SAA7134_BOARD_HAUPPAUGE_HVR1110
> SAA7134_BOARD_HAUPPAUGE_HVR1120
> SAA7134_BOARD_HAUPPAUGE_HVR1150
> SAA7134_BOARD_PHILIPS_TIGER_S
> SAA7134_BOARD_PINNACLE_PCTV_310
> SAA7134_BOARD_VIDEOMATE_DVBT_200
> SAA7134_BOARD_VIDEOMATE_DVBT_200A
> SAA7134_BOARD_VIDEOMATE_DVBT_300
> 
> So, there are a large set of boards that will be affected by this change.
>
> Your premise that the init1 only cares about GPIO IR is not true. It does contain
> the GPIO initializations to reset, turn on devices and enable i2c bridges for
> those devices. Eventually, on a few boards, the gpio's are only due to IR, but this
> is an exception.
> 
> The current code does that:
> 
>         saa7134_board_init1(dev);
>         saa7134_hwinit1(dev);
>         msleep(100);
>         saa7134_i2c_register(dev);
>         saa7134_board_init2(dev);
>         saa7134_hwinit2(dev);
> 
> What happens is that the saa7134_board_init1(dev) code has lots of gpio codes, 
> and most of those code is needed in order to enable i2c bridges or to turn on/reset 
> some chips that would otherwise be on OFF or undefined state. Without the gpio code, 
> done by init1, you may not be able to read eeprom or to detect the devices as needed
> by saa7134_board_init2().

I don't think I ever said otherwise. I never said that init1 as a whole
only cared about GPIO IR. That's what I said of function
saa7134_input_init1() and only this function!

My first proposed patch didn't move all of init1 to init2. It was only
moving saa7134_input_init1 (which doesn't yet have a counterpart in
init2), and it is moving it from the end of init1 to the beginning of
init2, so the movement isn't as big as it may sound. The steps
saa7134_input_init1() is moving over are, in order:
* saa7134_hw_enable1
* request_irq
* saa7134_i2c_register

So my point was that none of these 3 functions seemed to be dependent
on saa7134_input_init1() having been called beforehand. Which is why I
strongly question the fact that moving saa7134_input_init1() _after_
these 3 other initialization steps can have any negative effect. I
wouldn't have claimed that moving saa7134_input_init1() _earlier_ in
the init sequence would be safe, because there's nothing obvious about
that. But moving it forward where I had put it did not seem terrific.

I really would like a few users of this driver to just give it a try
and report, because it seems a much more elegant fix to the bug at
hand, than the workaround you'd accept instead.

> That's why I'm saying that, if in the specific case of the board you're dealing with,
> you're sure that an unknown GPIO state won't affect the code at saa7134_hwinit1() and
> at saa7134_i2c_register(), then you can move the GPIO code for this board to init2.
> 
> Moving things between init1 and init2 are very tricky and requires testing on all the
> affected boards. So a change like what your patch proposed would require a test of all
> the 107 boards that are on init1. I bet you'll break several of them with this change.

Under the assumption that saa7134_hwinit1() only touches GPIOs
connected to IR receivers (and it certainly looks like this to me) I
fail to see how these pins not being initialized could have any effect
on non-IR code.

Now, please don't get me wrong. I don't have any of these devices. I've
posted that patch because a user incidentally pointed me to a problem
and I had an idea how it could be fixed. I prefer my initial proposal
because it looks better in the long run. If you don't like it and
prefer the second proposal even though I think it's more of a
workaround than a proper fix, it's really up to you. You're maintaining
the subsystem and I am not, so you're the one deciding.

Thanks,
-- 
Jean Delvare
