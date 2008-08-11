Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7BHBme9028203
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 13:11:48 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7BHBa5f021215
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 13:11:36 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: id012c3076@blueyonder.co.uk
In-Reply-To: <489D7781.8030007@blueyonder.co.uk>
References: <488C9266.7010108@blueyonder.co.uk>
	<1217364178.2699.17.camel@pc10.localdom.local>
	<4890BBE8.8000901@blueyonder.co.uk>
	<1217457895.4433.52.camel@pc10.localdom.local>
	<48921FF9.8040504@blueyonder.co.uk>
	<1217542190.3272.106.camel@pc10.localdom.local>
	<48942E42.5040207@blueyonder.co.uk>
	<1217679767.3304.30.camel@pc10.localdom.local>
	<4895D741.1020906@blueyonder.co.uk>
	<1217798899.2676.148.camel@pc10.localdom.local>
	<4898C258.4040004@blueyonder.co.uk> <489A0B01.8020901@blueyonder.co.uk>
	<1218059636.4157.21.camel@pc10.localdom.local>
	<489B6E1B.301@blueyonder.co.uk>
	<1218153337.8481.30.camel@pc10.localdom.local>
	<489D7781.8030007@blueyonder.co.uk>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 19:04:19 +0200
Message-Id: <1218474259.2676.42.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld DVB-T 210SE - Capture only in Black/White
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

Am Samstag, den 09.08.2008, 11:54 +0100 schrieb Ian Davidson: 
> Hi Hermann,
> 
> I thought I had had success - but no.
> 
> I did the makes as you described - no difference, so I made the changes 
> to the code.
> I left Composite1 as vmux=3 and assigned Composite and Composite 2-4 to 
> the other vmux values and 'maked' again.  When I went into xawtv, I 
> thought that I saw colour (true colour, not false colour) - but next 
> time I looked, it saw only Black and White.  The changes certainly were 
> applied correctly, because I could choose from all 5 Composite choices - 
> but only Composite1 showed me any picture.

hmm, was Composite with vmux = 0 tested as well? Seems so.

This is usually used for Composite over the s-video input connector.
Some cards have only this one and S-Video.

> What is gpio? Does it have anything to do with the colour?

Usually not at all. We have some about gpio pins on the v4l wiki and you
can read about more saa713x details in publicly available documentation.

In case external vmux chips, video enhancers or Low Noise Amplifiers are
involved, they can play a role and are also on other chips of recent
cards.

The current 210RF has an inconsistency for LNA configuration, since in
saa7134-dvb.c tuner_config = 2 is set, but not in saa7134-cards.c. 

> Below is some extracts from the .inf file on the Windows driver disk.  I 
> see (from the third line) that my card is "3xHybridQ" - based on the 4 
> bytes being reported from the eeprom .  Based on that, certain values 
> would be loaded into the registry - but I have no idea what those values 
> represent.  I don't know if it is of any help.

Mostly the i2c addresses of chips we have already detected, but not
listed, audio connections and a few I don't know exactly either, but are
for sure the same like for a fully operational card=78, Asus P7131 Dual.

For the 0x50 for FM mode I'm not sure, but radio amux is TV.

For antenna input and AGC switching on gpio21, some recent cards use it
also the other way round. Don't see a reason to change it, but
interaction between production plants and multiple manufacturers is
complex.

If you get nothing from radio and TV tuner,
you can also try to swap the gpio values for these keeping the gpio mask
unchanged.

> You will get some peace from me for a week.  I will be away on business.
> 
> Ian

According to the recent Philips driver Kworld distributes, all our vmux
settings are correct as well and follow the previous 210RF card.

But damned again, all silicon tuner cards have amux LINE2 for composite
and s-video, only can tuners have LINE1. This is wrong on 210 and 220RF.
If it is true with the can tuners, the ATSC110/115 is wrong too the
other way round. 

Only cards with a video enhancer, usually a big well visible NEC chip,
have vmux TV = 9, Composite = 4 and S-Video = 6.

>From the driver's side I'm out of ideas for now.

Have a nice week,

Hermann

> 
> 
> %Hybrid.DeviceDescSilicon% 
> =3xHybridP.NTx86,PCI\VEN_1131&DEV_7133&SUBSYS_735117DE
> 
> %Hybrid.DeviceDescSilicon% 
> =3xHybridO.NTx86,PCI\VEN_1131&DEV_7133&SUBSYS_735217DE
> 
> %Hybrid.DeviceDescSilicon% 
> =3xHybridQ.NTx86,PCI\VEN_1131&DEV_7133&SUBSYS_725317DE
> 
> 
> [3xHybridO.AddReg]
> 
> HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x18,0x00,0x00,0x00 ; 
> Tuner ID
> 
> HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC2,0x00,0x00,0x00 ; 
> Tuner slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x86,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data4",0x00010001,0x00,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data5",0x00010001,0xFF,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data6",0x00010001,0x55,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data7",0x00010001,0x55,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data8",0x00010001,0x55,0x00,0x00,0x00 ; 
> FM radio mode.
> 
> HKR, "AudioDecoder", "CVBS Channel",0x00010001,3
> 
> HKR, "AudioDecoder", "SVHS Channel",0x00010001,3
> 
> HKR, "AudioDecoder", "FM Radio Channel",0x00010001,1
> 
> 
> [3xHybridP.AddReg]
> 
> HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x18,0x00,0x00,0x00 ; 
> Tuner ID
> 
> HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC2,0x00,0x00,0x00 ; 
> Tuner slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x86,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data4",0x00010001,0x00,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data5",0x00010001,0x03,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data6",0x00010001,0x21,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data7",0x00010001,0x00,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data8",0x00010001,0x00,0x00,0x00,0x00 ; 
> FM radio mode.
> 
> HKR, "AudioDecoder", "CVBS Channel",0x00010001,3
> 
> HKR, "AudioDecoder", "SVHS Channel",0x00010001,3
> 
> HKR, "AudioDecoder", "FM Radio Channel",0x00010001,1
> 
> 
> [3xHybridQ.AddReg]
> 
> HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x21,0x00,0x00,0x00 ; 
> Tuner ID
> 
> HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC2,0x00,0x00,0x00 ; 
> Tuner slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x96,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data4",0x00010001,0x10,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data5",0x00010001,0x03,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data6",0x00010001,0x32,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data7",0x00010001,0x15,0x00,0x00,0x00 ; 
> Tuner IF PLL slave addr.
> 
> HKR, "I2C Devices", "Device 0, Data8",0x00010001,0x50,0x00,0x00,0x00 ; 
> FM radio mode.
> 
> HKR, "AudioDecoder", "CVBS Channel",0x00010001,3
> 
> HKR, "AudioDecoder", "SVHS Channel",0x00010001,3
> 
> HKR, "AudioDecoder", "FM Radio Channel",0x00010001,1
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
