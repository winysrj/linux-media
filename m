Return-path: <mchehab@pedra>
Received: from dilga.instanthosting.com.au ([116.0.23.207]:47194 "EHLO
	dilga.instanthosting.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab1DQPL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Apr 2011 11:11:28 -0400
Received: from localhost ([127.0.0.1] helo=www.neatherweb.com)
	by dilga.instanthosting.com.au with esmtpa (Exim 4.69)
	(envelope-from <jason@neatherweb.com>)
	id 1QBT5k-0001kG-Tx
	for linux-media@vger.kernel.org; Mon, 18 Apr 2011 00:36:48 +1000
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Apr 2011 01:36:48 +1100
From: <jason@neatherweb.com>
To: <linux-media@vger.kernel.org>
Subject: HVR-2210 saa7164 driver - subsystem 0070:8953
Message-ID: <66c6eac24f21982dde80df1db37531ee@neatherweb.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 Hi,
 I have a Hauppauge HVR-2210 tv tuner card that is not currently 
 supported by V4L saa7164 driver.
 The card is recognised but is reported as unsupported
    CORE saa7164[0]: subsystem: 0070:8953, board: Unknown 
 [card=0,autodetected]

 I found some support for this subsystem in what I assume to be a old 
 dev tree at
    http://kernellabs.com/hg/~stoth/saa7164-dev/
 So perhaps it was something lost in porting saa7164 module to the v4l 
 tree, or perhaps there was some issue, I couldn't work out the history 
 around this.

 I have used that code (without any understanding of it) to patch the 
 saa7164 driver as below, and this has been successful - I have been 
 using the card with MythTV happily for about a month now.
 So my question is how do I ask developers to consider including support 
 for this card in future releases ?

 This is my first time reaching out to the Linux community and I am 
 merely a Linux enthusiast/user (not a programmer) - so apologies if I 
 have taken the wrong tact for such a request.

 Appreciate any help.
 Jason

 Two patch files I use ...

 # -------- v4l-dvb-saa7164.patch --------

 diff -crB v4l-dvb/linux/drivers/media/video/saa7164/saa7164-cards.c 
 v4l-dvb-JN/linux/drivers/media/video/saa7164/saa7164-cards.c
 *** 
 v4l-dvb/linux/drivers/media/video/saa7164/saa7164-cards.c	2011-01-03 
 15:39:28.065355788 +1100
 --- 
 v4l-dvb-JN/linux/drivers/media/video/saa7164/saa7164-cards.c	2011-01-03 
 16:25:00.377588988 +1100
 ***************
 *** 369,374 ****
 --- 369,430 ----
   			.i2c_reg_len	= REGLEN_8bit,
   		} },
   	},
 + 	[SAA7164_BOARD_HAUPPAUGE_HVR2200_5] = {
 + 		.name		= "Hauppauge WinTV-HVR2200",
 + 		.porta		= SAA7164_MPEG_DVB,
 + 		.portb		= SAA7164_MPEG_DVB,
 + 		.chiprev	= SAA7164_CHIP_REV3,
 + 		.unit		= {{
 + 			.id		= 0x23,
 + 			.type		= SAA7164_UNIT_EEPROM,
 + 			.name		= "4K EEPROM",
 + 			.i2c_bus_nr	= SAA7164_I2C_BUS_0,
 + 			.i2c_bus_addr	= 0xa0 >> 1,
 + 			.i2c_reg_len	= REGLEN_8bit,
 + 		}, {
 + 			.id		= 0x04,
 + 			.type		= SAA7164_UNIT_TUNER,
 + 			.name		= "TDA18271-1",
 + 			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
 + 			.i2c_bus_addr	= 0xc0 >> 1,
 + 			.i2c_reg_len	= REGLEN_8bit,
 + 		}, {
 + 			.id		= 0x05,
 + 			.type		= SAA7164_UNIT_ANALOG_DEMODULATOR,
 + 			.name		= "TDA8290-1",
 + 			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
 + 			.i2c_bus_addr	= 0x84 >> 1,
 + 			.i2c_reg_len	= REGLEN_8bit,
 + 		}, {
 + 			.id		= 0x21,
 + 			.type		= SAA7164_UNIT_TUNER,
 + 			.name		= "TDA18271-2",
 + 			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
 + 			.i2c_bus_addr	= 0xc0 >> 1,
 + 			.i2c_reg_len	= REGLEN_8bit,
 + 		}, {
 + 			.id		= 0x22,
 + 			.type		= SAA7164_UNIT_ANALOG_DEMODULATOR,
 + 			.name		= "TDA8290-2",
 + 			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
 + 			.i2c_bus_addr	= 0x84 >> 1,
 + 			.i2c_reg_len	= REGLEN_8bit,
 + 		}, {
 + 			.id		= 0x24,
 + 			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
 + 			.name		= "TDA10048-1",
 + 			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
 + 			.i2c_bus_addr	= 0x10 >> 1,
 + 			.i2c_reg_len	= REGLEN_8bit,
 + 		}, {
 + 			.id		= 0x25,
 + 			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
 + 			.name		= "TDA10048-2",
 + 			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
 + 			.i2c_bus_addr	= 0x12 >> 1,
 + 			.i2c_reg_len	= REGLEN_8bit,
 + 		} },
 + 	},
   };
   const unsigned int saa7164_bcount = ARRAY_SIZE(saa7164_boards);

 ***************
 *** 408,413 ****
 --- 464,473 ----
   		.subvendor = 0x0070,
   		.subdevice = 0x8851,
   		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2250_2,
 + 	}, {
 + 		.subvendor = 0x0070,
 + 		.subdevice = 0x8953,
 + 		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2200_5,
   	},
   };
   const unsigned int saa7164_idcount = ARRAY_SIZE(saa7164_subids);
 ***************
 *** 463,468 ****
 --- 523,529 ----
   	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
   	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
   	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
 + 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_5:
   #if 0
   		/* Disable the DIF */
   		saa7164_api_dif_write(&dev->i2c_bus[0], 0xc0, 8, &b4[0]);
 ***************
 *** 560,565 ****
 --- 621,627 ----
   	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
   	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
   	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
 + 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_5:
   		hauppauge_eeprom(dev, &eeprom[0]);
   		break;
   	}
 diff -crB v4l-dvb/linux/drivers/media/video/saa7164/saa7164-dvb.c 
 v4l-dvb-JN/linux/drivers/media/video/saa7164/saa7164-dvb.c
 *** v4l-dvb/linux/drivers/media/video/saa7164/saa7164-dvb.c	2011-01-03 
 15:39:28.067355454 +1100
 --- 
 v4l-dvb-JN/linux/drivers/media/video/saa7164/saa7164-dvb.c	2011-01-03 
 16:26:53.059795030 +1100
 ***************
 *** 522,527 ****
 --- 522,528 ----
   	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
   	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
   	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
 + 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_5:
   		i2c_bus = &dev->i2c_bus[port->nr + 1];
   		switch (port->nr) {
   		case 0:
 diff -crB v4l-dvb/linux/drivers/media/video/saa7164/saa7164.h 
 v4l-dvb-JN/linux/drivers/media/video/saa7164/saa7164.h
 *** v4l-dvb/linux/drivers/media/video/saa7164/saa7164.h	2011-01-03 
 15:39:28.069355120 +1100
 --- v4l-dvb-JN/linux/drivers/media/video/saa7164/saa7164.h	2011-01-03 
 16:28:13.055451489 +1100
 ***************
 *** 74,79 ****
 --- 74,81 ----
   #define SAA7164_BOARD_HAUPPAUGE_HVR2200_3	6
   #define SAA7164_BOARD_HAUPPAUGE_HVR2250_2	7
   #define SAA7164_BOARD_HAUPPAUGE_HVR2250_3	8
 + #define SAA7164_BOARD_HAUPPAUGE_HVR2200_5	10
 +

   #define SAA7164_MAX_UNITS		8
   #define SAA7164_TS_NUMBER_OF_LINES	312



 #--------- v4l-dvb-saa7164-cardist.patch ------------

 diff -crB v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7164 
 v4l-dvb-JN/linux/Documentation/video4linux/CARDLIST.saa7164
 *** v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7164	2011-01-03 
 15:39:27.352474772 +1100
 --- 
 v4l-dvb-JN/linux/Documentation/video4linux/CARDLIST.saa7164	2011-01-03 
 15:48:54.200953545 +1100
 ***************
 *** 7,9 ****
 --- 7,10 ----
     6 -> Hauppauge WinTV-HVR2200                             
 [0070:8901]
     7 -> Hauppauge WinTV-HVR2250                             
 [0070:8891,0070:8851]
     8 -> Hauppauge WinTV-HVR2250                             
 [0070:88A1]
 +  10 -> Hauppauge WinTV-HVR2200                             
 [0070:8953]

