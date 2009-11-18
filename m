Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:46872 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbZKRXLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 18:11:33 -0500
Subject: Re: saa7134  (not very) new board 5168:0307
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B03F15D.1090907@gmail.com>
References: <4B03F15D.1090907@gmail.com>
Content-Type: text/plain
Date: Thu, 19 Nov 2009 00:08:39 +0100
Message-Id: <1258585719.3275.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

Am Mittwoch, den 18.11.2009, 14:06 +0100 schrieb tomlohave@gmail.com:
> Hello list,
> 
> looking from saa7134.h, this board  5168:0307  is not included
> This cars is on some asus laptop and some medion laptop
> It was previously working with this settings (1) card=55 tuner=54
> or (2) with tuner = 86
> ok, so with this settings, nothing :
> 
> with card = 55 :
> 
> [  109.375445] Linux video capture interface: v2.00
> [  109.410546] saa7130/34: v4l2 driver version 0.2.14 loaded
> [  109.410606] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, latency: 181, mmio: 0xb4007800
> [  109.410614] saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T DUO / MSI TV@nywhere Duo [card=55,insmod option]
> [  109.410674] saa7133[0]: board init: gpio is 10000
> [  109.410743] input: saa7134 IR (LifeView FlyDVB-T D as /devices/pci0000:00/0000:00:1e.0/0000:06:03.0/input/input9
> [  109.587912] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [  109.587924] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
> [  109.587934] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e7 ff ff ff ff
> [  109.587944] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.587953] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 22 15 ff ff ff ff
> [  109.587963] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.587972] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.587982] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.587992] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.588024] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.588034] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.588043] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.588053] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.588062] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.588072] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.588081] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [  109.596023] saa7133[0]: i2c scan: found device @ 0x10  [???]
> [  109.612379] saa7133[0]: i2c scan: found device @ 0x96  [???]
> [  109.620016] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [  109.984237] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
> [  110.064028] tda829x 0-004b: setting tuner address to 61
> [  110.144024] tda829x 0-004b: type set to tda8290+75
> [  114.804413] saa7133[0]: registered device video0 [v4l2]
> [  114.804463] saa7133[0]: registered device vbi0
> [  114.804509] saa7133[0]: registered device radio0
> [  114.891645] saa7134 ALSA driver for DMA sound loaded
> [  114.891706] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 registered as card -2
> [  115.705042] dvb_init() allocating 1 frontend
> [  115.756244] DVB: registering new adapter (saa7133[0])
> [  115.756254] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> [  115.940033] tda1004x: setting up plls for 48MHz sampling clock
> [  116.106914] tda1004x: found firmware revision ff -- invalid
> [  116.106921] tda1004x: trying to boot from eeprom
> [  116.572024] tda1004x: found firmware revision 23 -- ok
> [  117.016161] tda827x_probe_version: could not read from tuner at addr: 0xc0
> 
> 
> [ 3969.562904] saa7130/34: v4l2 driver version 0.2.14 loaded
> [ 3969.562994] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, latency: 181, mmio: 0xb4007800
> [ 3969.563007] saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T / Genius VideoWonder DVB-T [card=86,insmod option]
> [ 3969.563091] saa7133[0]: board init: gpio is 10000
> [ 3969.563219] input: saa7134 IR (LifeView FlyDVB-T / as /devices/pci0000:00/0000:00:1e.0/0000:06:03.0/input/input9
> [ 3969.738045] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [ 3969.738069] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
> [ 3969.738090] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e7 ff ff ff ff
> [ 3969.738111] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738132] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 22 15 ff ff ff ff
> [ 3969.738152] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738173] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738194] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738214] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738235] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738256] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738276] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738297] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738318] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738338] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.738359] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3969.748030] saa7133[0]: i2c scan: found device @ 0x10  [???]
> [ 3969.789056] saa7133[0]: i2c scan: found device @ 0x96  [???]
> [ 3969.796023] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [ 3969.920245] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
> [ 3970.004029] tda829x 0-004b: setting tuner address to 61
> [ 3970.084367] tda829x 0-004b: type set to tda8290+75
> [ 3971.680487] saa7133[0]: registered device video0 [v4l2]
> [ 3971.680538] saa7133[0]: registered device vbi0
> [ 3971.808176] saa7134 ALSA driver for DMA sound loaded
> [ 3971.808213] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 registered as card -2
> [ 3971.840321] dvb_init() allocating 1 frontend
> [ 3971.880155] DVB: registering new adapter (saa7133[0])
> [ 3971.880160] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> [ 3971.952041] tda1004x: setting up plls for 48MHz sampling clock
> [ 3974.200031] tda1004x: timeout waiting for DSP ready
> [ 3974.240038] tda1004x: found firmware revision 0 -- invalid
> [ 3974.240044] tda1004x: trying to boot from eeprom
> [ 3976.572028] tda1004x: timeout waiting for DSP ready
> [ 3976.612115] tda1004x: found firmware revision 0 -- invalid
> [ 3976.612121] tda1004x: waiting for firmware upload...
> [ 3976.612129] saa7134 0000:06:03.0: firmware: requesting dvb-fe-tda10046.fw
> [ 3989.140029] tda1004x: found firmware revision 20 -- ok
> [ 3989.428167] tda827x_probe_version: could not read from tuner at addr: 0xc0
> [ 4044.132025] tda1004x: setting up plls for 48MHz sampling clock
> [ 4046.096030] tda1004x: found firmware revision 23 -- ok
> [ 4046.368159] tda827x_probe_version: could not read from tuner at addr: 0xc0
> [ 4049.464171] tda827x_probe_version: could not read from tuner at addr: 0xc0
> [ 4061.800027] tda1004x: setting up plls for 48MHz sampling clock
> [ 4063.764038] tda1004x: found firmware revision 23 -- ok
> [ 4064.036167] tda827x_probe_version: could not read from tuner at addr: 0xc0
> [ 4064.172178] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4065.380178] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4066.612273] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4067.660166] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4068.920158] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4070.136168] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4071.308169] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4072.540174] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4073.776186] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4074.684166] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4075.916169] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4077.124179] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4078.164246] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4079.396166] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4080.628168] tda827xo_set_params: could not write to tuner at addr: 0xc0
> [ 4081.780174] tda827x_probe_version: could not read from tuner at addr: 0xc0
> [ 4907.134088] saa7134 ALSA driver for DMA sound unloaded
> 
> 
> ok
> 
> so i modified :
> ##################### saa7134.h
> 
> #define SAA7134_BOARD_FLYDVBTDUO_MEDION 176
> 
> ##################### saa7134-dvb.c
> 
> case SAA7134_BOARD_FLYDVBTDUO_MEDION:
>         if (configure_tda827x_fe(dev, &tda827x_flydvbtduo_medion_config,
>                      &tda827x_cfg_0) < 0)
>             goto dettach_frontend;
>         break;
> 
> and
> 
> static struct tda1004x_config tda827x_flydvbtduo_medion_config = {
>     .demod_address = 0x08,
>     .invert        = 1,
>     .invert_oclk   = 0,
>     .xtal_freq     = TDA10046_XTAL_16M,
>     .agc_config    = TDA10046_AGC_TDA827X,
>     .gpio_config   = TDA10046_GP11_I,
>     .if_freq       = TDA10046_FREQ_045,
>     .tuner_address = 0x61,
>     .request_firmware = philips_tda1004x_request_firmware
> 
> ###################### saa7134-card.c
> 
>     [SAA7134_BOARD_FLYDVBTDUO_MEDION] = {
>         .name           = "LifeView FlyDVB-T DUO Medion",
>         .audio_clock    = 0x00187de7,
>         .tuner_type     = TUNER_PHILIPS_TDA8290,
>         .radio_type     = UNSET,
>         .tuner_addr    = ADDR_UNSET,
>         .radio_addr    = ADDR_UNSET,
> /*        .gpiomask    = 0x00200000,*/
>         .mpeg           = SAA7134_MPEG_DVB,
>         .inputs         = {{
>             .name = name_tv,
>             .vmux = 1,
>             .amux = TV,
> /*            .gpio = 0x200000,    */ /* GPIO21=High for TV input */
>             .tv   = 1,
>         },{
>             .name = name_comp1,    /* Composite signal on S-Video input */
>             .vmux = 0,
>             .amux = LINE2,
>         },{
>             .name = name_comp2,    /* Composite input */
>             .vmux = 3,
>             .amux = LINE2,
>         },{
>             .name = name_svideo,    /* S-Video signal on S-Video input */
>             .vmux = 8,
>             .amux = LINE2,
>         }},
>         .radio = {
>             .name = name_radio,
>             .amux = TV,
>             .gpio = 0x000000,    /* GPIO21=Low for FM radio antenna */
>         },
>     },
> };
> 
> and
> 
>         .vendor       = PCI_VENDOR_ID_PHILIPS,
>         .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
>         .subvendor    = 0x5168,        
>         .subdevice    = 0x0307,        
>         .driver_data  = SAA7134_BOARD_FLYDVBTDUO_MEDION,
> 
> 
> 
> With tuner_address = 0x61, no error on log but no dvb
> 
> [   12.498255] saa7130/34: v4l2 driver version 0.2.15 loaded
> [   12.498429] saa7134 0000:06:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [   12.498435] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, latency: 181, mmio: 0xb4007800
> [   12.498443] saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T DUO Medion [card=176,autodetected]
> [   12.498516] saa7133[0]: board init: gpio is 10000
> [   12.656021] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [   12.656033] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
> [   12.656042] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e7 ff ff ff ff
> [   12.656052] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656062] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 22 15 ff ff ff ff
> [   12.656071] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656081] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656090] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656100] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656109] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656119] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656129] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656138] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656148] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656157] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.656167] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   12.817084] tuner 0-004b: chip found @ 0x96 (saa7133[0])
> [   12.896023] tda829x 0-004b: setting tuner address to 61
> [   12.968053] tda829x 0-004b: type set to tda8290+75
> [   17.692221] saa7133[0]: registered device video0 [v4l2]
> [   17.692323] saa7133[0]: registered device vbi0
> [   17.692439] saa7133[0]: registered device radio0
> [   17.710523] saa7134 ALSA driver for DMA sound loaded
> [   17.710556] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 registered as card -2
> [   17.784447] dvb_init() allocating 1 frontend
> [   17.828176] DVB: registering new adapter (saa7133[0])
> [   17.828182] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> [   17.900022] tda1004x: setting up plls for 48MHz sampling clock
> [   20.148018] tda1004x: timeout waiting for DSP ready
> [   20.188232] tda1004x: found firmware revision 0 -- invalid
> [   20.188236] tda1004x: trying to boot from eeprom
> [   22.516008] tda1004x: timeout waiting for DSP ready
> [   22.556185] tda1004x: found firmware revision 0 -- invalid
> [   22.556189] tda1004x: waiting for firmware upload...
> [   22.556194] saa7134 0000:06:03.0: firmware: requesting dvb-fe-tda10046.fw
> [   35.064055] tda1004x: found firmware revision 20 -- ok
> [  223.588029] tda1004x: setting up plls for 48MHz sampling clock
> [  225.552027] tda1004x: found firmware revision 23 -- ok
> [  235.160031] tda1004x: setting up plls for 48MHz sampling clock
> [  237.124041] tda1004x: found firmware revision 23 -- ok
> 
> 
> 
> any ideas, please ?
> 
> (1) http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025786.html
> (2) 
> http://archives.devshed.com/forums/linux-97/flyduodvb-t-dvbscan-problem-2041600.html

just some note, helping further or not.

IIRC, nobody ever claimed to have DVB-T working on it.

It is listed in the m$ drivers as a DUO card, for LifeView at this time
it means for sure it has two tuners, but we don't have a trace to a
second tuner yet.

The other old DUO cards, PCI and cardbus, do find it.
A tda8274 at 0x60 for DVB-T and a first generation tda8275 for analog
TV.

In the current situation, I do suggest to physically inspect that Mini
PCI for the presence of two tuners and of course everything else you can
gather. Two eeproms? Firmware load looks inconsistent too and you should
try to provide a later revision, since it finally loads from host/file.

If you find, and you should, two different tuners physically, then this
is at least some ground to start further thinking about RF input
switching, i2c gates and such.

Cheers,
Hermann


