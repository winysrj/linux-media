Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:10766 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZJNMm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 08:42:57 -0400
Received: by qw-out-2122.google.com with SMTP id 9so1195831qwb.37
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 05:41:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <156a113e0910130955w428d536i7fc3ac8355293030@mail.gmail.com>
References: <156a113e0910130955w428d536i7fc3ac8355293030@mail.gmail.com>
Date: Wed, 14 Oct 2009 14:41:50 +0200
Message-ID: <156a113e0910140541y1fc5025fx3ce84352e3fdf5a2@mail.gmail.com>
Subject: Re: More about "Winfast TV USB Deluxe"
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Loaded em28xx with i2c_scan and i2c_debug and tvaudio with tda9874a
option and debug.

sudo modprobe -v em28xx i2c_scan=1 i2c_debug=1
sudo modprobe -v tvaudio tda9874a=1 debug=1

And got this ouput:

[91083.588182] em28xx #0: found i2c device @ 0x30 [???]
[91083.590179] em28xx #0: found i2c device @ 0x3e [???]
[91083.590804] em28xx #0: found i2c device @ 0x42 [???]
[91083.600308] em28xx #0: found i2c device @ 0x86 [tda9887]
[91083.603805] em28xx #0: found i2c device @ 0xa0 [eeprom]
[91083.606183] em28xx #0: found i2c device @ 0xb0 [tda9874]
[91083.608808] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[91083.617682] em28xx #0: Identified as Leadtek Winfast USB II Deluxe (card=28)
[91083.617684] em28xx #0:
[91083.617684]
[91083.617687] em28xx #0: The support for this board weren't valid yet.
[91083.617688] em28xx #0: Please send a report of having this working
[91083.617690] em28xx #0: not to V4L mailing list (and/or to other addresses)
[91083.617691]
[91083.980702] saa7115 4-0021: saa7114 found (1f7114d0e000000) @ 0x42
(em28xx #0)
[91086.173114] tvaudio: TV audio decoder + audio/video mux driver
[91086.173116] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
pic16c54 (PV951), ta8874z
[91086.173125] tvaudio 4-00b0: chip found @ 0x160
[91086.173127] tvaudio 4-00b0: no matching chip description found
[91086.173131] tvaudio: probe of 4-00b0 failed with error -5


It seems to be a tda9874 there -> em28xx #0: found i2c device @ 0xb0 [tda9874]

But does tvaudio stop @ 0x160 (decimal value of 0xa0 rigth? ) and
doesn't look further?
I mean does tvaudio find my boards eeprom, cant talk to it and gives up?


/Magnus


2009/10/13 Magnus Alm <magnus.alm@gmail.com>:
> Hi!
>
> Thanks to Devin's moral support I  now have sound in television. ;-)
>
> Thanks!!
>
> I pooked around some more managed to get radio to function with these settings:
>
> [EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE] = {
>                .name         = "Leadtek Winfast USB II Deluxe",
>                .valid        = EM28XX_BOARD_NOT_VALIDATED,
>                .tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,
>                .tda9887_conf = TDA9887_PRESENT |
>                                TDA9887_PORT1_ACTIVE,
>                .decoder      = EM28XX_SAA711X,
>                .input        = { {
>                        .type     = EM28XX_VMUX_TELEVISION,
>                        .vmux     = SAA7115_COMPOSITE4,
>                        .amux     = EM28XX_AMUX_AUX,
>                }, {
>                        .type     = EM28XX_VMUX_COMPOSITE1,
>                        .vmux     = SAA7115_COMPOSITE5,
>                        .amux     = EM28XX_AMUX_LINE_IN,
>                }, {
>                        .type     = EM28XX_VMUX_SVIDEO,
>                        .vmux     = SAA7115_SVIDEO3,
>                        .amux     = EM28XX_AMUX_LINE_IN,
>                } },
>                        .radio    = {
>                        .type     = EM28XX_RADIO,
>                        .amux     = EM28XX_AMUX_AUX,
>                }
>        },
>
> I tested with different settings on tda9887 and modprobe "tda9887
> port1=1" seemed to work be best.
>
> One odd thing when the modules is load is this:
>
> [15680.459343] tuner 4-0000: chip found @ 0x0 (em28xx #0)
> [15680.473017] tuner 4-0043: chip found @ 0x86 (em28xx #0)
> [15680.473089] tda9887 4-0043: creating new instance
> [15680.473091] tda9887 4-0043: tda988[5/6/7] found
> [15680.485719] tuner 4-0061: chip found @ 0xc2 (em28xx #0)
> [15680.486169] tuner-simple 4-0000: unable to probe Alps TSBE1,
> proceeding anyway.                            <-- What is that?
> [15680.486171] tuner-simple 4-0000: creating new instance
>                                                       <--
> [15680.486174] tuner-simple 4-0000: type set to 10 (Alps TSBE1)
>                                                    <--
> [15680.496562] tuner-simple 4-0061: creating new instance
> [15680.496566] tuner-simple 4-0061: type set to 38 (Philips PAL/SECAM
> multi (FM1216ME MK3))
>
>
> Another question, my box has a tda9874ah chip and if  understand the
> data sheet it gives support for stereo (even Nicam if that is still
> used anymore.).
> So I tried to configure my box the same way as
> [EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU] by adding these lines:
>
> .tvaudio_addr = 0xb0,                             <---- address of
> tda9874 according to ic2-addr.h
> .adecoder     = EM28XX_TVAUDIO,
>
> But it didnt work, got the following message when I plugged it in:
>
> [15677.928972] em28xx #0: Please send a report of having this working
> [15677.928974] em28xx #0: not to V4L mailing list (and/or to other addresses)
> [15677.928975]
> [15678.288360] saa7115 4-0021: saa7114 found (1f7114d0e000000) @ 0x42
> (em28xx #0)
> [15680.457094] tvaudio: TV audio decoder + audio/video mux driver
> [15680.457097] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
> tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
> pic16c54 (PV951), ta8874z
> [15680.457105] tvaudio 4-00b0: chip found @ 0x160
> [15680.457107] tvaudio 4-00b0: no matching chip description found
> [15680.457111] tvaudio: probe of 4-00b0 failed with error -5
> [15680.459343] tuner 4-0000: chip found @ 0x0 (em28xx #0)
> [15680.473017] tuner 4-0043: chip found @ 0x86 (em28xx #0)
> [15680.473089] tda9887 4-0043: creating new instance
>
>
> It might be so that my box is not wired to fully utilize the chip or I
> did something wrong.
>
>
> /Magnus
>
