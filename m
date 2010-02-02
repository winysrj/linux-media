Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab0BBLuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 06:50:32 -0500
Message-ID: <4B681173.1030404@redhat.com>
Date: Tue, 02 Feb 2010 09:50:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: hermann pitton <hermann-pitton@arcor.de>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135    variants
References: <20100127120211.2d022375@hyperion.delvare>	<4B630179.3080006@redhat.com>	<1264812461.16350.90.camel@localhost>	<20100130115632.03da7e1b@hyperion.delvare>	<1264986995.21486.20.camel@pc07.localdom.local>	<20100201105628.77057856@hyperion.delvare>	<1265075273.2588.51.camel@localhost> <20100202085415.38a1e362@hyperion.delvare>
In-Reply-To: <20100202085415.38a1e362@hyperion.delvare>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> Hi Hermann,
> 
> On Tue, 02 Feb 2010 02:47:53 +0100, hermann pitton wrote:
>> Hi Jean,
>>
>> Am Montag, den 01.02.2010, 10:56 +0100 schrieb Jean Delvare:
>>> Hi Hermann,
>>>
>>> On Mon, 01 Feb 2010 02:16:35 +0100, hermann pitton wrote:
>>>> For now, I only faked a P7131 Dual with a broken IR receiver on a 2.6.29
>>>> with recent, you can see that gpio 0x40000 doesn't go high, but your
>>>> patch should enable the remote on that P7131 analog only.
>>> I'm not sure why you had to fake anything? What I'd like to know is
>>> simply if my first patch had any negative effect on other cards.
>> because I simply don't have that Asus My Cinema analog only in question.
>>
>> To recap, you previously announced a patch, tested by Daro, claiming to
>> get the remote up under auto detection for that device and I told you
>> having some doubts on it.
> 
> My first patch was not actually tested by Daro. What he tested was
> loading the driver with card=146. At first I thought it was equivalent,
> but since then I have realized it wasn't. That's the reason why the
> "Tested-by:" was turned into a mere "Cc:" on my second and third
> patches.
> 
>> Mauro prefers to have a fix for that single card in need for now.
>>
>> Since nobody else cares, "For now", see above, I can confirm that your
>> last patch for that single device should work to get IR up with auto
>> detection in delay after we change the card such late with eeprom
>> detection.
>>
>> The meaning of that byte in use here is unknown to me, we should avoid
>> such as much we can! It can turn out to be only some pseudo service.
>>
>> If your call for testers on your previous attempt, really reaches some
>> for some reason, I'm with you, but for now I have to keep the car
>> operable within all such snow.
> 
> That I understand. What I don't understand is: if you have a
> SAA7134-based card, why don't you test my second patch (the one moving
> the call to saa7134_input_init1 to saa7134_hwinit2) on it, without
> faking anything? This would be a first, useful data point.

The init1 code has 107 boards listed:

SAA7134_BOARD_10MOONSTVMASTER3
SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
SAA7134_BOARD_ASUST
SAA7134_BOARD_AVACSSMARTTV
SAA7134_BOARD_AVERMEDIA_305
SAA7134_BOARD_AVERMEDIA_307
SAA7134_BOARD_AVERMEDIA_777
SAA7134_BOARD_AVERMEDIA_A169_B
SAA7134_BOARD_AVERMEDIA_A16AR
SAA7134_BOARD_AVERMEDIA_A16D
SAA7134_BOARD_AVERMEDIA_A700_HYBRID
SAA7134_BOARD_AVERMEDIA_A700_PRO
SAA7134_BOARD_AVERMEDIA_CARDBUS
SAA7134_BOARD_AVERMEDIA_CARDBUS_501
SAA7134_BOARD_AVERMEDIA_CARDBUS_506
SAA7134_BOARD_AVERMEDIA_GO_007_FM
SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS
SAA7134_BOARD_AVERMEDIA_M102
SAA7134_BOARD_AVERMEDIA_M103
SAA7134_BOARD_AVERMEDIA_M115
SAA7134_BOARD_AVERMEDIA_M135A
SAA7134_BOARD_AVERMEDIA_STUDIO_305
SAA7134_BOARD_AVERMEDIA_STUDIO_307
SAA7134_BOARD_AVERMEDIA_STUDIO_505
SAA7134_BOARD_AVERMEDIA_STUDIO_507
SAA7134_BOARD_BEHOLD_401
SAA7134_BOARD_BEHOLD_403
SAA7134_BOARD_BEHOLD_403FM
SAA7134_BOARD_BEHOLD_405
SAA7134_BOARD_BEHOLD_405FM
SAA7134_BOARD_BEHOLD_407
SAA7134_BOARD_BEHOLD_407FM
SAA7134_BOARD_BEHOLD_409
SAA7134_BOARD_BEHOLD_409FM
SAA7134_BOARD_BEHOLD_505FM
SAA7134_BOARD_BEHOLD_505RDS_MK3
SAA7134_BOARD_BEHOLD_505RDS_MK5
SAA7134_BOARD_BEHOLD_507_9FM
SAA7134_BOARD_BEHOLD_507RDS_MK3
SAA7134_BOARD_BEHOLD_507RDS_MK5
SAA7134_BOARD_BEHOLD_607FM_MK3
SAA7134_BOARD_BEHOLD_607FM_MK5
SAA7134_BOARD_BEHOLD_607RDS_MK3
SAA7134_BOARD_BEHOLD_607RDS_MK5
SAA7134_BOARD_BEHOLD_609FM_MK3
SAA7134_BOARD_BEHOLD_609FM_MK5
SAA7134_BOARD_BEHOLD_609RDS_MK3
SAA7134_BOARD_BEHOLD_609RDS_MK5
SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
SAA7134_BOARD_BEHOLD_H6
SAA7134_BOARD_BEHOLD_M6
SAA7134_BOARD_BEHOLD_M63
SAA7134_BOARD_BEHOLD_M6_EXTRA
SAA7134_BOARD_BEHOLD_X7
SAA7134_BOARD_CINERGY400
SAA7134_BOARD_CINERGY400_CARDBUS
SAA7134_BOARD_CINERGY600
SAA7134_BOARD_CINERGY600_MK3
SAA7134_BOARD_ECS_TVP3XP
SAA7134_BOARD_ECS_TVP3XP_4CB5
SAA7134_BOARD_ECS_TVP3XP_4CB6
SAA7134_BOARD_ENCORE_ENLTV
SAA7134_BOARD_ENCORE_ENLTV_FM
SAA7134_BOARD_ENCORE_ENLTV_FM53
SAA7134_BOARD_FLYDVBS_LR300
SAA7134_BOARD_FLYDVBTDUO
SAA7134_BOARD_FLYDVBT_DUO_CARDBUS
SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
SAA7134_BOARD_FLYDVBT_LR301
SAA7134_BOARD_FLYTVPLATINUM_FM
SAA7134_BOARD_FLYTVPLATINUM_MINI2
SAA7134_BOARD_FLYVIDEO2000
SAA7134_BOARD_FLYVIDEO3000
SAA7134_BOARD_FLYVIDEO3000_NTSC
SAA7134_BOARD_GENIUS_TVGO_A11MCE
SAA7134_BOARD_GOTVIEW_7135
SAA7134_BOARD_HAUPPAUGE_HVR1110
SAA7134_BOARD_HAUPPAUGE_HVR1120
SAA7134_BOARD_HAUPPAUGE_HVR1150
SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG
SAA7134_BOARD_KWORLD_TERMINATOR
SAA7134_BOARD_KWORLD_VSTREAM_XPERT
SAA7134_BOARD_KWORLD_XPERT
SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S
SAA7134_BOARD_MANLI_MTV001
SAA7134_BOARD_MANLI_MTV002
SAA7134_BOARD_MD2819
SAA7134_BOARD_MD5044
SAA7134_BOARD_MONSTERTV_MOBILE
SAA7134_BOARD_MSI_TVATANYWHERE_PLUS
SAA7134_BOARD_PINNACLE_300I_DVBT_PAL
SAA7134_BOARD_PINNACLE_PCTV_110
SAA7134_BOARD_PINNACLE_PCTV_310
SAA7134_BOARD_PROTEUS_2309
SAA7134_BOARD_REAL_ANGEL_220
SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM
SAA7134_BOARD_RTD_VFG7350
SAA7134_BOARD_SABRENT_SBTTVFM
SAA7134_BOARD_SEDNA_PC_TV_CARDBUS
SAA7134_BOARD_UPMOST_PURPLE_TV
SAA7134_BOARD_VIDEOMATE_DVBT_200
SAA7134_BOARD_VIDEOMATE_DVBT_200A
SAA7134_BOARD_VIDEOMATE_DVBT_300
SAA7134_BOARD_VIDEOMATE_GOLD_PLUS
SAA7134_BOARD_VIDEOMATE_S350
SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII
SAA7134_BOARD_VIDEOMATE_TV_PVR

The init2 code has 32 boards listed:

SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
SAA7134_BOARD_ADS_INSTANT_HDTV_PCI
SAA7134_BOARD_ASUS_EUROPA2_HYBRID
SAA7134_BOARD_ASUS_EUROPA_HYBRID
SAA7134_BOARD_ASUST
SAA7134_BOARD_AVERMEDIA_CARDBUS_501
SAA7134_BOARD_AVERMEDIA_SUPER_007
SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
SAA7134_BOARD_BMK_MPEX_NOTUNER
SAA7134_BOARD_BMK_MPEX_TUNER
SAA7134_BOARD_CINERGY_HT_PCI
SAA7134_BOARD_CINERGY_HT_PCMCIA
SAA7134_BOARD_CREATIX_CTX953
SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
SAA7134_BOARD_FLYDVB_TRIO
SAA7134_BOARD_HAUPPAUGE_HVR1110
SAA7134_BOARD_HAUPPAUGE_HVR1120
SAA7134_BOARD_HAUPPAUGE_HVR1150
SAA7134_BOARD_KWORLD_ATSC110
SAA7134_BOARD_KWORLD_DVBT_210
SAA7134_BOARD_MD7134
SAA7134_BOARD_MEDION_MD8800_QUADRO
SAA7134_BOARD_PHILIPS_EUROPA
SAA7134_BOARD_PHILIPS_SNAKE
SAA7134_BOARD_PHILIPS_TIGER
SAA7134_BOARD_PHILIPS_TIGER_S
SAA7134_BOARD_PINNACLE_PCTV_310
SAA7134_BOARD_TEVION_DVBT_220RF
SAA7134_BOARD_TWINHAN_DTV_DVB_3056
SAA7134_BOARD_VIDEOMATE_DVBT_200
SAA7134_BOARD_VIDEOMATE_DVBT_200A
SAA7134_BOARD_VIDEOMATE_DVBT_300

>From all those entries, there are 15 boards that are listed on both init1 and init2:

SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
SAA7134_BOARD_ASUST
SAA7134_BOARD_AVERMEDIA_CARDBUS_501
SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
SAA7134_BOARD_BMK_MPEX_NOTUNER
SAA7134_BOARD_BMK_MPEX_TUNER
SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
SAA7134_BOARD_HAUPPAUGE_HVR1110
SAA7134_BOARD_HAUPPAUGE_HVR1120
SAA7134_BOARD_HAUPPAUGE_HVR1150
SAA7134_BOARD_PHILIPS_TIGER_S
SAA7134_BOARD_PINNACLE_PCTV_310
SAA7134_BOARD_VIDEOMATE_DVBT_200
SAA7134_BOARD_VIDEOMATE_DVBT_200A
SAA7134_BOARD_VIDEOMATE_DVBT_300

So, there are a large set of boards that will be affected by this change.

Your premise that the init1 only cares about GPIO IR is not true. It does contain
the GPIO initializations to reset, turn on devices and enable i2c bridges for
those devices. Eventually, on a few boards, the gpio's are only due to IR, but this
is an exception.

The current code does that:

        saa7134_board_init1(dev);
        saa7134_hwinit1(dev);
        msleep(100);
        saa7134_i2c_register(dev);
        saa7134_board_init2(dev);
        saa7134_hwinit2(dev);

What happens is that the saa7134_board_init1(dev) code has lots of gpio codes, 
and most of those code is needed in order to enable i2c bridges or to turn on/reset 
some chips that would otherwise be on OFF or undefined state. Without the gpio code, 
done by init1, you may not be able to read eeprom or to detect the devices as needed
by saa7134_board_init2(). 

That's why I'm saying that, if in the specific case of the board you're dealing with,
you're sure that an unknown GPIO state won't affect the code at saa7134_hwinit1() and
at saa7134_i2c_register(), then you can move the GPIO code for this board to init2.

Moving things between init1 and init2 are very tricky and requires testing on all the
affected boards. So a change like what your patch proposed would require a test of all
the 107 boards that are on init1. I bet you'll break several of them with this change.

-- 

Cheers,
Mauro
