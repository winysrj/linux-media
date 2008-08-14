Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KTm6B-00027q-Ur
	for linux-dvb@linuxtv.org; Fri, 15 Aug 2008 01:19:21 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Tim Farrington <timf@iinet.net.au>
In-Reply-To: <48A4569D.6090608@iinet.net.au>
References: <48A4569D.6090608@iinet.net.au>
Date: Fri, 15 Aug 2008 01:10:30 +0200
Message-Id: <1218755430.2699.18.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: John.Chajecki@leicester.gov.uk, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Saa7134 with Avermedia M1155 hybrid card on
	Ubuntu	8.04
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Tim,

Am Freitag, den 15.08.2008, 00:00 +0800 schrieb Tim Farrington:
> Hi John,
> 
> I will try and help.
> 
> Try this and see if you get anywhere.
> 
> First, you need to install these:
> 
> sudo apt-get install build-essential mercurial
> 
> Next, you need to download v4l-dvb from Linuxtv.org into your home 
> directory:
> 
> hg clone http://linuxtv.org/hg/v4l-dvb
> 
> Next, in Ubuntu 8.04, you will have to remove conflicting modules:
> (beware this may affect things such as a webcam)
> 
> cd /lib/modules/`uname -r`/ubuntu
> sudo rm -rf media
> cd
> 
> Next, modify the source code in ~/v4l-dvb
> 
> In ~/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
> 
> Find this section:
> 
>     [SAA7134_BOARD_AVERMEDIA_M115] = {
>         .name           = "Avermedia M115",
>         .audio_clock    = 0x187de7,
>         .tuner_type     = TUNER_XC2028,
>         .radio_type     = UNSET,
>         .tuner_addr    = ADDR_UNSET,
>         .radio_addr    = ADDR_UNSET,
> /*add this line*/.mpeg           = SAA7134_MPEG_DVB,
>         .inputs         = {{
>             .name = name_tv,
>             .vmux = 1,
>             .amux = TV,
>             .tv   = 1,
>         }, {
>             .name = name_comp1,
>             .vmux = 3,
>             .amux = LINE1,
>         }, {
>             .name = name_svideo,
>             .vmux = 8,
>             .amux = LINE2,
>         } },
>     },
> 
> Find this section:
> 
> static int saa7134_xc2028_callback(struct saa7134_dev *dev,
>                    int command, int arg)
> {
>     switch (command) {
>     case XC2028_TUNER_RESET:
>         saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00000000);
>         saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
>         switch (dev->board) {
>         case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
>         case SAA7134_BOARD_AVERMEDIA_M103:
>             saa7134_set_gpio(dev, 23, 0);
>             msleep(10);
>             saa7134_set_gpio(dev, 23, 1);
>         break;
>         case SAA7134_BOARD_AVERMEDIA_A16D:
> /*add this line*/case SAA7134_BOARD_AVERMEDIA_M115:
>             saa7134_set_gpio(dev, 21, 0);
>             msleep(10);
>             saa7134_set_gpio(dev, 21, 1);
>         break;
>         }
>     return 0;
>     }
>     return -EINVAL;
> }
> 
> Find this section:
> 
> int saa7134_board_init1(struct saa7134_dev *dev)
> ...
>     case SAA7134_BOARD_AVERMEDIA_CARDBUS:
> /*    case SAA7134_BOARD_AVERMEDIA_M115: */ /*comment this line out*/
> #if 1
>         /* power-down tuner chip */
>         saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0);
>         saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0);
> #endif
>         msleep(10);
>         /* power-up tuner chip */
>         saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
>         saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
>         msleep(10);
>         break;
> 
> Find this section:
> 
>     case SAA7134_BOARD_AVERMEDIA_A16D:
>         saa7134_set_gpio(dev, 21, 0);
>         msleep(10);
>         saa7134_set_gpio(dev, 21, 1);
>         msleep(1);
>         dev->has_remote = SAA7134_REMOTE_GPIO;
>         break;
> 
> Create a new case entry below it:
> 
>     case SAA7134_BOARD_AVERMEDIA_M115:
>         saa7134_set_gpio(dev, 21, 0);
>         msleep(10);
>         saa7134_set_gpio(dev, 21, 1);
>         break;
> 
> Find this section:
> 
>         switch (dev->board) {
>         case SAA7134_BOARD_AVERMEDIA_A16D:
>         case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
>         case SAA7134_BOARD_AVERMEDIA_M103:
> /*add this line*/case SAA7134_BOARD_AVERMEDIA_M115:
>             ctl.demod = XC3028_FE_ZARLINK456;
>             break;
> 
> 
> In ~/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
> 
> Find this section:
> 
>     case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
>         dprintk("AverMedia E506R dvb setup\n");
>         saa7134_set_gpio(dev, 25, 0);
>         msleep(10);
>         saa7134_set_gpio(dev, 25, 1);
>         dev->dvb.frontend = dvb_attach(mt352_attach,
>                         &avermedia_xc3028_mt352_dev,
>                         &dev->i2c_adap);
>         attach_xc3028 = 1;
>         break;
> 
> Create a new case entry below it:
> 
>     case SAA7134_BOARD_AVERMEDIA_M115:
>         saa7134_set_gpio(dev, 25, 0);
>         msleep(10);
>         saa7134_set_gpio(dev, 25, 1);
>         dev->dvb.frontend = dvb_attach(mt352_attach,
>                         &avermedia_xc3028_mt352_dev,
>                         &dev->i2c_adap);
>         attach_xc3028 = 1;
>         break;
> 
> Save these files.
> Next, use make to build the modules:
> 
> cd
> cd v4l-dvb
> make
> sudo make install
> 
> Next, you need to extract and install the firmware:
> 
> In ~/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
> 
> you will find instructions on how to use this file to obtain the firmware.
> 
> Then, copy the firmware to /lib:
> 
> sudo cp xc3028-v27.fw /lib/firmware/`uname -r`
> 
> reboot
> 
> check dmesg.
> 
> See if that gets anywhere.
> 
> Regards,
> Timf
> einfaches Textdokument-Anlage (m115.txt)
> First, you need to install these:
> 
> sudo apt-get install build-essential mercurial
> 
> Next, you need to download v4l-dvb from Linuxtv.org into your home directory:
> 
> hg clone http://linuxtv.org/hg/v4l-dvb
> 
> Next, in Ubuntu 8.04, you will have to remove conflicting modules:
> (beware this may affect things such as a webcam)
> 
> cd /lib/modules/`uname -r`/ubuntu
> sudo rm -rf media
> cd
> 
> Next, modify the source code in ~/v4l-dvb
> 
> In ~/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
> 
> Find this section:
> 
> 	[SAA7134_BOARD_AVERMEDIA_M115] = {
> 		.name           = "Avermedia M115",
> 		.audio_clock    = 0x187de7,
> 		.tuner_type     = TUNER_XC2028,
> 		.radio_type     = UNSET,
> 		.tuner_addr	= ADDR_UNSET,
> 		.radio_addr	= ADDR_UNSET,
> /*add this line*/.mpeg           = SAA7134_MPEG_DVB,
> 		.inputs         = {{
> 			.name = name_tv,
> 			.vmux = 1,
> 			.amux = TV,
> 			.tv   = 1,
> 		}, {
> 			.name = name_comp1,
> 			.vmux = 3,
> 			.amux = LINE1,
> 		}, {
> 			.name = name_svideo,
> 			.vmux = 8,
> 			.amux = LINE2,
> 		} },
> 	},
> 
> Find this section:
> 
> static int saa7134_xc2028_callback(struct saa7134_dev *dev,
> 				   int command, int arg)
> {
> 	switch (command) {
> 	case XC2028_TUNER_RESET:
> 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00000000);
> 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> 		switch (dev->board) {
> 		case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
> 		case SAA7134_BOARD_AVERMEDIA_M103:
> 			saa7134_set_gpio(dev, 23, 0);
> 			msleep(10);
> 			saa7134_set_gpio(dev, 23, 1);
> 		break;
> 		case SAA7134_BOARD_AVERMEDIA_A16D:
> /*add this line*/case SAA7134_BOARD_AVERMEDIA_M115:
> 			saa7134_set_gpio(dev, 21, 0);
> 			msleep(10);
> 			saa7134_set_gpio(dev, 21, 1);
> 		break;
> 		}
> 	return 0;
> 	}
> 	return -EINVAL;
> }
> 
> Find this section:
> 
> int saa7134_board_init1(struct saa7134_dev *dev)
> ...
> 	case SAA7134_BOARD_AVERMEDIA_CARDBUS:
> /*	case SAA7134_BOARD_AVERMEDIA_M115: */ /*comment this line out*/
> #if 1
> 		/* power-down tuner chip */
> 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0);
> 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0);
> #endif
> 		msleep(10);
> 		/* power-up tuner chip */
> 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
> 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
> 		msleep(10);
> 		break;
> 
> Find this section:
> 
> 	case SAA7134_BOARD_AVERMEDIA_A16D:
> 		saa7134_set_gpio(dev, 21, 0);
> 		msleep(10);
> 		saa7134_set_gpio(dev, 21, 1);
> 		msleep(1);
> 		dev->has_remote = SAA7134_REMOTE_GPIO;
> 		break;
> 
> Create a new case entry below it:
> 
> 	case SAA7134_BOARD_AVERMEDIA_M115:
> 		saa7134_set_gpio(dev, 21, 0);
> 		msleep(10);
> 		saa7134_set_gpio(dev, 21, 1);
> 		break;
> 
> Find this section:
> 
> 		switch (dev->board) {
> 		case SAA7134_BOARD_AVERMEDIA_A16D:
> 		case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
> 		case SAA7134_BOARD_AVERMEDIA_M103:
> /*add this line*/case SAA7134_BOARD_AVERMEDIA_M115:
> 			ctl.demod = XC3028_FE_ZARLINK456;
> 			break;
> 
> 
> In ~/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
> 
> Find this section:
> 
> 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
> 		dprintk("AverMedia E506R dvb setup\n");
> 		saa7134_set_gpio(dev, 25, 0);
> 		msleep(10);
> 		saa7134_set_gpio(dev, 25, 1);
> 		dev->dvb.frontend = dvb_attach(mt352_attach,
> 						&avermedia_xc3028_mt352_dev,
> 						&dev->i2c_adap);
> 		attach_xc3028 = 1;
> 		break;
> 
> Create a new case entry below it:
> 
> 	case SAA7134_BOARD_AVERMEDIA_M115:
> 		saa7134_set_gpio(dev, 25, 0);
> 		msleep(10);
> 		saa7134_set_gpio(dev, 25, 1);
> 		dev->dvb.frontend = dvb_attach(mt352_attach,
> 						&avermedia_xc3028_mt352_dev,
> 						&dev->i2c_adap);
> 		attach_xc3028 = 1;
> 		break;
> 
> Save these files.
> Next, use make to build the modules:
> 
> cd
> cd v4l-dvb
> make
> sudo make install
> 
> Next, you need to extract and install the firmware:
> 
> In ~/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
> 
> you will find instructions on how to use this file to obtain the firmware.
> 
> Then, copy the firmware to /lib:
> 
> sudo cp xc3028-v27.fw /lib/firmware/`uname -r`
> 
> reboot
> 
> check dmesg.
> 

thanks for helping out.

I'm crawling through my mail backlash and still haven't been on
Australian beaches, but met always very nice people from there on some
fine beaches with great waves on some of the other places.

My doubt here is, the M115 has a digital channel decoder at 0x1e/0x0f in
the eeprom. John's card does not have it.

Nothing is for sure on OEM eeprom stuff, let's see how far we can come
for now. But listing _all_ chips and xtals, yes do unsolder the tuner
shielding if needed :), is still the minimum for a report ;)

Cheers,
Hermann





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
