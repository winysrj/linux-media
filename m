Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37539 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaBPNo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 08:44:58 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so6597697eek.13
        for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 05:44:56 -0800 (PST)
Received: from [192.168.1.100] ([188.24.66.62])
        by mx.google.com with ESMTPSA id k41sm44853539een.19.2014.02.16.05.44.54
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 16 Feb 2014 05:44:55 -0800 (PST)
Message-ID: <5300C0D5.3050704@gmail.com>
Date: Sun, 16 Feb 2014 15:44:53 +0200
From: ZRADU <zradu1100@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Help with Compro VideoMate M330F PCI Analog TV/FM Capture Card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have this card Compro VideoMate M330F
Hardware

     Analog TV and FM can tuner design
     Support PAL/SECAM BG+DK, DK+I, or NTSC system
     Advanced NXP(Philips) SAA713x 9-bit ADC chip with TV stereo 
(SAP/NICAM/A2/EIAJ) support
     IR remote control
     Card dimensions: 120 x 100 mm

Connectors

     TV input
     FM input
     S-Video input
     Composite input
     IR sensor input
     Audio input
     Audio output

This car is autodetected as Compro VideoMate Gold+ Pal (card 49)
I set tuner all available tuner type here not have sound in TV only on 
RADIO when I use patch cable Line-in

I use regspy to get same registry in xp:

SAA7134 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7134
Subsystem ID:        0xc200185b


5 states dumped

---------------------------------------------------------------------------------- 


SAA7134 Card - State 0:
SAA7134_GPIO_GPMODE:             808c1800   (10000000 10001100 00011000 
00000000)
SAA7134_GPIO_GPSTATUS:           00c4103f * (00000000 11000100 00010000 
00111111)
SAA7134_ANALOG_IN_CTRL1:         83 * (10000011)
SAA7134_ANALOG_IO_SELECT:        07 * (00000111)
SAA7134_AUDIO_CLOCK:             02187de7   (00000010 00011000 01111101 
11100111)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00 (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00 (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       01 * (00000001)
SAA7134_I2S_OUTPUT_LEVEL:        00 (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        01 (00000001)
SAA7134_TS_PARALLEL:             04 (00000100)
SAA7134_TS_PARALLEL_SERIAL:      00 (00000000)
SAA7134_TS_SERIAL0:              00 (00000000)
SAA7134_TS_SERIAL1:              00 (00000000)
SAA7134_TS_DMA0:                 00 (00000000)
SAA7134_TS_DMA1:                 00 (00000000)
SAA7134_TS_DMA2:                 00 (00000000)
SAA7134_SPECIAL_MODE:            01 (00000001)


Changes: State 0 -> State 1:
SAA7134_GPIO_GPSTATUS:           00c4103f -> 04c0003f  (-----0-- 
-----1-- ---1---- --------)
SAA7134_ANALOG_IN_CTRL1:         83       -> 81 (------1-)
SAA7134_ANALOG_IO_SELECT:        07       -> 02 (-----1-1)
SAA7134_I2S_OUTPUT_FORMAT:       01       -> 00 (-------1)

4 changes


---------------------------------------------------------------------------------- 


SAA7134 Card - State 1:
SAA7134_GPIO_GPMODE:             808c1800   (10000000 10001100 00011000 
00000000)
SAA7134_GPIO_GPSTATUS:           04c0003f * (00000100 11000000 00000000 
00111111)  (was: 00c4103f)
SAA7134_ANALOG_IN_CTRL1:         81 * 
(10000001)                             (was: 83)
SAA7134_ANALOG_IO_SELECT:        02 * 
(00000010)                             (was: 07)
SAA7134_AUDIO_CLOCK:             02187de7   (00000010 00011000 01111101 
11100111)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00 (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00 (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       00 * 
(00000000)                             (was: 01)
SAA7134_I2S_OUTPUT_LEVEL:        00 (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        01 (00000001)
SAA7134_TS_PARALLEL:             04 (00000100)
SAA7134_TS_PARALLEL_SERIAL:      00 (00000000)
SAA7134_TS_SERIAL0:              00 (00000000)
SAA7134_TS_SERIAL1:              00 (00000000)
SAA7134_TS_DMA0:                 00 (00000000)
SAA7134_TS_DMA1:                 00 (00000000)
SAA7134_TS_DMA2:                 00 (00000000)
SAA7134_SPECIAL_MODE:            01 (00000001)


Changes: State 1 -> State 2:
SAA7134_GPIO_GPSTATUS:           04c0003f -> 02c0103f  (-----10- 
-------- ---0---- --------)
SAA7134_ANALOG_IN_CTRL1:         81       -> 83 
(------0-)                             (same as 0)
SAA7134_ANALOG_IO_SELECT:        02       -> 00 (------1-)
SAA7134_I2S_OUTPUT_FORMAT:       00       -> 01 
(-------0)                             (same as 0)

4 changes


---------------------------------------------------------------------------------- 


SAA7134 Card - State 2:
SAA7134_GPIO_GPMODE:             808c1800   (10000000 10001100 00011000 
00000000)
SAA7134_GPIO_GPSTATUS:           02c0103f * (00000010 11000000 00010000 
00111111)  (was: 04c0003f)
SAA7134_ANALOG_IN_CTRL1:         83 * 
(10000011)                             (was: 81)
SAA7134_ANALOG_IO_SELECT:        00 
(00000000)                             (was: 02)
SAA7134_AUDIO_CLOCK:             02187de7   (00000010 00011000 01111101 
11100111)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00 (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00 (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       01 
(00000001)                             (was: 00)
SAA7134_I2S_OUTPUT_LEVEL:        00 (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        01 (00000001)
SAA7134_TS_PARALLEL:             04 (00000100)
SAA7134_TS_PARALLEL_SERIAL:      00 (00000000)
SAA7134_TS_SERIAL0:              00 (00000000)
SAA7134_TS_SERIAL1:              00 (00000000)
SAA7134_TS_DMA0:                 00 (00000000)
SAA7134_TS_DMA1:                 00 (00000000)
SAA7134_TS_DMA2:                 00 (00000000)
SAA7134_SPECIAL_MODE:            01 (00000001)


Changes: State 2 -> State 3:
SAA7134_GPIO_GPSTATUS:           02c0103f -> 00c0083f  (------1- 
-------- ---10--- --------)
SAA7134_ANALOG_IN_CTRL1:         83       -> 86 (-----0-1)

2 changes


---------------------------------------------------------------------------------- 


SAA7134 Card - State 3:
SAA7134_GPIO_GPMODE:             808c1800   (10000000 10001100 00011000 
00000000)
SAA7134_GPIO_GPSTATUS:           00c0083f * (00000000 11000000 00001000 
00111111)  (was: 02c0103f)
SAA7134_ANALOG_IN_CTRL1:         86 * 
(10000110)                             (was: 83)
SAA7134_ANALOG_IO_SELECT:        00 * (00000000)
SAA7134_AUDIO_CLOCK:             02187de7   (00000010 00011000 01111101 
11100111)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00 (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00 (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       01 (00000001)
SAA7134_I2S_OUTPUT_LEVEL:        00 (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        01 (00000001)
SAA7134_TS_PARALLEL:             04 (00000100)
SAA7134_TS_PARALLEL_SERIAL:      00 (00000000)
SAA7134_TS_SERIAL0:              00 (00000000)
SAA7134_TS_SERIAL1:              00 (00000000)
SAA7134_TS_DMA0:                 00 (00000000)
SAA7134_TS_DMA1:                 00 (00000000)
SAA7134_TS_DMA2:                 00 (00000000)
SAA7134_SPECIAL_MODE:            01 (00000001)


Changes: State 3 -> Register Dump:
SAA7134_GPIO_GPSTATUS:           00c0083f -> 06c4103f  (-----00- 
-----0-- ---01--- --------)
SAA7134_ANALOG_IN_CTRL1:         86       -> 83 
(-----1-0)                             (same as 0, 2)
SAA7134_ANALOG_IO_SELECT:        00       -> 07 
(-----000)                             (same as 0)

3 changes


================================================================================= 


SAA7134 Card - Register Dump:
SAA7134_GPIO_GPMODE:             808c1800   (10000000 10001100 00011000 
00000000)
SAA7134_GPIO_GPSTATUS:           06c4103f   (00000110 11000100 00010000 
00111111)  (was: 00c0083f)
SAA7134_ANALOG_IN_CTRL1:         83 
(10000011)                             (was: 86)
SAA7134_ANALOG_IO_SELECT:        07 
(00000111)                             (was: 00)
SAA7134_AUDIO_CLOCK:             02187de7   (00000010 00011000 01111101 
11100111)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00 (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00 (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       01 (00000001)
SAA7134_I2S_OUTPUT_LEVEL:        00 (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        01 (00000001)
SAA7134_TS_PARALLEL:             04 (00000100)
SAA7134_TS_PARALLEL_SERIAL:      00 (00000000)
SAA7134_TS_SERIAL0:              00 (00000000)
SAA7134_TS_SERIAL1:              00 (00000000)
SAA7134_TS_DMA0:                 00 (00000000)
SAA7134_TS_DMA1:                 00 (00000000)
SAA7134_TS_DMA2:                 00 (00000000)
SAA7134_SPECIAL_MODE:            01 (00000001)

end of dump

Please help gpio set for this card and add to saa7134-cards.c
