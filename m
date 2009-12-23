Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:38883 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbZLWWzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 17:55:47 -0500
Subject: Re: saa7134  (not very) new board 5168:0307
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
Cc: linux-media@vger.kernel.org, jpnews13@free.fr
In-Reply-To: <4B320A43.4000308@gmail.com>
References: <4B03F15D.1090907@gmail.com>
	 <1258585719.3275.14.camel@pc07.localdom.local> <4B1101B0.5010008@gmail.com>
	 <1259543353.4436.21.camel@pc07.localdom.local> <4B18AE42.6010000@gmail.com>
	 <4B320A43.4000308@gmail.com>
Content-Type: text/plain
Date: Wed, 23 Dec 2009 23:54:04 +0100
Message-Id: <1261608844.7606.9.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

Am Mittwoch, den 23.12.2009, 13:17 +0100 schrieb tomlohave@gmail.com:
> Some news,
> > Hi hermann,
> >
> > we are this results :
> >
> > with
> >
> > &tda827x_cfg_0, &tda827x_cfg_1 or &tda827x_cfg_2
> >
> 
> > we have a perfect image without sound on the analogic part (test with 
> > mplayer),
> > a partial result with dvb-t : we need to initialize first with 
> > analogic (with cold boot, the card doesn't work on dvb)
> > but only for few seconds(sound and image are ok) then re-initialize 
> > with analogic, work for few seconds on dvb and then nothing
> 
> > maybe i am wrong but, the sound part for analogic is a problem of 
> > redirection, isn't it  ?
> fixed
> >
> > here are our configuration for this card :
> >
> > in saa7134-dvb.c
> >
> > static struct tda1004x_config tda827x_flydvbtduo_medion_config = {
> >     .demod_address = 0x08,
> >     .invert        = 1,
> >     .invert_oclk   = 0,
> >     .xtal_freq     = TDA10046_XTAL_16M,
> >     .agc_config    = TDA10046_AGC_TDA827X,
> >     .gpio_config   = TDA10046_GP01_I,
> >     .if_freq       = TDA10046_FREQ_045,
> >     .i2c_gate      = 0x4b,
> >     .tuner_address = 0x61,
> >     .antenna_switch = 2,
> >     .request_firmware = philips_tda1004x_request_firmware
> > };
> >
> > case SAA7134_BOARD_FLYDVBTDUO_MEDION:
> >         if (configure_tda827x_fe(dev, &tda827x_flydvbtduo_medion_config,
> >                      &tda827x_cfg_2) < 0)
> >             goto dettach_frontend;
> >         break;
> >     default:
> >         wprintk("Huh? unknown DVB card?\n");
> >         break;
> >
> >
> > in saa7134-cards.c
> >
> >    [SAA7134_BOARD_FLYDVBTDUO_MEDION] = {
> >        .name           = "LifeView FlyDVB-T DUO Medion",
> 
> >
> >        .audio_clock    = 0x00187de7,
> change with  0x00200000 and there is a perfect sound :)

fine. In README.saa7134 since Gerd wrote it the first time ;)

> >        .tuner_type     = TUNER_PHILIPS_TDA8290,
> >        .radio_type     = UNSET,
> >        .tuner_addr    = ADDR_UNSET,
> >        .radio_addr    = ADDR_UNSET,
> >        .gpiomask    = 0x00200000,
> >        .mpeg           = SAA7134_MPEG_DVB,
> >        .inputs         = {{
> >            .name = name_tv,
> >            .vmux = 1,
> >            .amux = TV,
> >            .gpio = 0x200000,     /* GPIO21=High for TV input */
> >            .tv   = 1,
> >        },{
> >            .name = name_comp1,    /* Composite signal on S-Video input */
> >            .vmux = 3,
> >            .amux = LINE1,
> >        },{
> >            .name = name_svideo,    /* S-Video signal on S-Video input */
> >            .vmux = 8,
> >            .amux = LINE1,
> >        }},
> >        .radio = {
> >            .name = name_radio,
> >            .amux = TV,
> >            .gpio = 0x000000,    /* GPIO21=Low for FM radio antenna */
> >        },
> >
> >
> > .vendor       = PCI_VENDOR_ID_PHILIPS,
> >        .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> >        .subvendor    = 0x5168,               .subdevice    = 0x0307,  
> > /* LR307-N */             .driver_data  = 
> > SAA7134_BOARD_FLYDVBTDUO_MEDION,
> >
> > case SAA7134_BOARD_FLYDVBTDUO_MEDION:
> >    {
> >        /* this is a hybrid board, initialize to analog mode
> >         * and configure firmware eeprom address
> >         */
> >        u8 data[] = { 0x3c, 0x33, 0x60};
> >        struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = 
> > sizeof(data)};
> >        i2c_transfer(&dev->i2c_adap, &msg, 1);
> >        break;
> >
> >
> >
> >
> > What can we do to have dvb fully supported ?
> Can someone point me in the right direction ?
> >

Hmmm, is there not anything with i2c_debug=1 before it fails after a few
seconds?

Gpio pins can trigger cascades of switches, so to know the gpio status
of the card for working DVB-T on m$ might still be a desire. Maybe chips
power off.

Also, for 99.99% only a shot at the dark side of the moon before ever
seen, but I would also try to force TS_SERIAL to have it visited.

Cheers,
Hermann


