Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:52578 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZJOS5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 14:57:16 -0400
Received: by qyk2 with SMTP id 2so940839qyk.21
        for <linux-media@vger.kernel.org>; Thu, 15 Oct 2009 11:56:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <156a113e0910141524m348b7fa6u807cf11324328c60@mail.gmail.com>
References: <156a113e0910130955w428d536i7fc3ac8355293030@mail.gmail.com>
	 <156a113e0910140541y1fc5025fx3ce84352e3fdf5a2@mail.gmail.com>
	 <156a113e0910141524m348b7fa6u807cf11324328c60@mail.gmail.com>
Date: Thu, 15 Oct 2009 20:56:39 +0200
Message-ID: <156a113e0910151156l75ec4d3dma073f7ec67682c47@mail.gmail.com>
Subject: Re: More about "Winfast TV USB Deluxe"
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

yay

[ 2478.224015] tda9887 4-0043: configure for: Radio Stereo
[ 2478.224017] tda9887 4-0043: writing: b=0xcc c=0x90 e=0x3d

/Magnus

2009/10/15 Magnus Alm <magnus.alm@gmail.com>:
> Strange, but changeing the tvaudio_addr = 0xb0 to 88, (half of the
> decimal value of b0) made tvaudio find my tda9874.
>
> [ 1186.725140] tvaudio: TV audio decoder + audio/video mux driver
> [ 1186.725142] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
> tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
> pic16c54 (PV951), ta8874z
> [ 1186.725151] tvaudio 4-0058: chip found @ 0xb0
> [ 1186.736444] tvaudio 4-0058: chip_read2: reg254=0x11
> [ 1186.749704] tvaudio 4-0058: chip_read2: reg255=0x2
> [ 1186.749708] tvaudio 4-0058: tda9874a_checkit(): DIC=0x11, SIC=0x2.
> [ 1186.749710] tvaudio 4-0058: found tda9874a.
> [ 1186.749712] tvaudio 4-0058: tda9874h/a/ah found @ 0xb0 (em28xx #0)
> [ 1186.749714] tvaudio 4-0058: matches:.
> [ 1186.749716] tvaudio 4-0058: chip_write: reg0=0x0
> [ 1186.760012] tvaudio 4-0058: chip_write: reg1=0xc0
> [ 1186.772014] tvaudio 4-0058: chip_write: reg2=0x2
> [ 1186.784013] tvaudio 4-0058: chip_write: reg11=0x80
> [ 1186.796010] tvaudio 4-0058: chip_write: reg12=0x0
> [ 1186.808013] tvaudio 4-0058: chip_write: reg13=0x0
> [ 1186.820012] tvaudio 4-0058: chip_write: reg14=0x1
> [ 1186.832015] tvaudio 4-0058: chip_write: reg15=0x0
> [ 1186.844012] tvaudio 4-0058: chip_write: reg16=0x14
> [ 1186.856018] tvaudio 4-0058: chip_write: reg17=0x50
> [ 1186.868011] tvaudio 4-0058: chip_write: reg18=0xf9
> [ 1186.880745] tvaudio 4-0058: chip_write: reg19=0x80
> [ 1186.892347] tvaudio 4-0058: chip_write: reg20=0x80
> [ 1186.904015] tvaudio 4-0058: chip_write: reg24=0x80
> [ 1186.916011] tvaudio 4-0058: chip_write: reg255=0x0
> [ 1186.928021] tvaudio 4-0058: tda9874a_setup(): A2, B/G [0x00].
> [ 1186.928091] tvaudio 4-0058: thread started
>
> Now I probably need to set some gpio's too....
>
> /Magnus
>
> 2009/10/14 Magnus Alm <magnus.alm@gmail.com>:
>> Loaded em28xx with i2c_scan and i2c_debug and tvaudio with tda9874a
>> option and debug.
>>
>> sudo modprobe -v em28xx i2c_scan=1 i2c_debug=1
>> sudo modprobe -v tvaudio tda9874a=1 debug=1
>>
>> And got this ouput:
>>
>> [91083.588182] em28xx #0: found i2c device @ 0x30 [???]
>> [91083.590179] em28xx #0: found i2c device @ 0x3e [???]
>> [91083.590804] em28xx #0: found i2c device @ 0x42 [???]
>> [91083.600308] em28xx #0: found i2c device @ 0x86 [tda9887]
>> [91083.603805] em28xx #0: found i2c device @ 0xa0 [eeprom]
>> [91083.606183] em28xx #0: found i2c device @ 0xb0 [tda9874]
>> [91083.608808] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
>> [91083.617682] em28xx #0: Identified as Leadtek Winfast USB II Deluxe (card=28)
>> [91083.617684] em28xx #0:
>> [91083.617684]
>> [91083.617687] em28xx #0: The support for this board weren't valid yet.
>> [91083.617688] em28xx #0: Please send a report of having this working
>> [91083.617690] em28xx #0: not to V4L mailing list (and/or to other addresses)
>> [91083.617691]
>> [91083.980702] saa7115 4-0021: saa7114 found (1f7114d0e000000) @ 0x42
>> (em28xx #0)
>> [91086.173114] tvaudio: TV audio decoder + audio/video mux driver
>> [91086.173116] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
>> tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
>> pic16c54 (PV951), ta8874z
>> [91086.173125] tvaudio 4-00b0: chip found @ 0x160
>> [91086.173127] tvaudio 4-00b0: no matching chip description found
>> [91086.173131] tvaudio: probe of 4-00b0 failed with error -5
>>
>>
>> It seems to be a tda9874 there -> em28xx #0: found i2c device @ 0xb0 [tda9874]
>>
>> But does tvaudio stop @ 0x160 (decimal value of 0xa0 rigth? ) and
>> doesn't look further?
>> I mean does tvaudio find my boards eeprom, cant talk to it and gives up?
>>
>>
>> /Magnus
>>
>>
>> 2009/10/13 Magnus Alm <magnus.alm@gmail.com>:
>>> Hi!
>>>
>>> Thanks to Devin's moral support I  now have sound in television. ;-)
>>>
>>> Thanks!!
>>>
>>> I pooked around some more managed to get radio to function with these settings:
>>>
>>> [EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE] = {
>>>                .name         = "Leadtek Winfast USB II Deluxe",
>>>                .valid        = EM28XX_BOARD_NOT_VALIDATED,
>>>                .tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,
>>>                .tda9887_conf = TDA9887_PRESENT |
>>>                                TDA9887_PORT1_ACTIVE,
>>>                .decoder      = EM28XX_SAA711X,
>>>                .input        = { {
>>>                        .type     = EM28XX_VMUX_TELEVISION,
>>>                        .vmux     = SAA7115_COMPOSITE4,
>>>                        .amux     = EM28XX_AMUX_AUX,
>>>                }, {
>>>                        .type     = EM28XX_VMUX_COMPOSITE1,
>>>                        .vmux     = SAA7115_COMPOSITE5,
>>>                        .amux     = EM28XX_AMUX_LINE_IN,
>>>                }, {
>>>                        .type     = EM28XX_VMUX_SVIDEO,
>>>                        .vmux     = SAA7115_SVIDEO3,
>>>                        .amux     = EM28XX_AMUX_LINE_IN,
>>>                } },
>>>                        .radio    = {
>>>                        .type     = EM28XX_RADIO,
>>>                        .amux     = EM28XX_AMUX_AUX,
>>>                }
>>>        },
>>>
>>> I tested with different settings on tda9887 and modprobe "tda9887
>>> port1=1" seemed to work be best.
>>>
>>> One odd thing when the modules is load is this:
>>>
>>> [15680.459343] tuner 4-0000: chip found @ 0x0 (em28xx #0)
>>> [15680.473017] tuner 4-0043: chip found @ 0x86 (em28xx #0)
>>> [15680.473089] tda9887 4-0043: creating new instance
>>> [15680.473091] tda9887 4-0043: tda988[5/6/7] found
>>> [15680.485719] tuner 4-0061: chip found @ 0xc2 (em28xx #0)
>>> [15680.486169] tuner-simple 4-0000: unable to probe Alps TSBE1,
>>> proceeding anyway.                            <-- What is that?
>>> [15680.486171] tuner-simple 4-0000: creating new instance
>>>                                                       <--
>>> [15680.486174] tuner-simple 4-0000: type set to 10 (Alps TSBE1)
>>>                                                    <--
>>> [15680.496562] tuner-simple 4-0061: creating new instance
>>> [15680.496566] tuner-simple 4-0061: type set to 38 (Philips PAL/SECAM
>>> multi (FM1216ME MK3))
>>>
>>>
>>> Another question, my box has a tda9874ah chip and if  understand the
>>> data sheet it gives support for stereo (even Nicam if that is still
>>> used anymore.).
>>> So I tried to configure my box the same way as
>>> [EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU] by adding these lines:
>>>
>>> .tvaudio_addr = 0xb0,                             <---- address of
>>> tda9874 according to ic2-addr.h
>>> .adecoder     = EM28XX_TVAUDIO,
>>>
>>> But it didnt work, got the following message when I plugged it in:
>>>
>>> [15677.928972] em28xx #0: Please send a report of having this working
>>> [15677.928974] em28xx #0: not to V4L mailing list (and/or to other addresses)
>>> [15677.928975]
>>> [15678.288360] saa7115 4-0021: saa7114 found (1f7114d0e000000) @ 0x42
>>> (em28xx #0)
>>> [15680.457094] tvaudio: TV audio decoder + audio/video mux driver
>>> [15680.457097] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
>>> tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
>>> pic16c54 (PV951), ta8874z
>>> [15680.457105] tvaudio 4-00b0: chip found @ 0x160
>>> [15680.457107] tvaudio 4-00b0: no matching chip description found
>>> [15680.457111] tvaudio: probe of 4-00b0 failed with error -5
>>> [15680.459343] tuner 4-0000: chip found @ 0x0 (em28xx #0)
>>> [15680.473017] tuner 4-0043: chip found @ 0x86 (em28xx #0)
>>> [15680.473089] tda9887 4-0043: creating new instance
>>>
>>>
>>> It might be so that my box is not wired to fully utilize the chip or I
>>> did something wrong.
>>>
>>>
>>> /Magnus
>>>
>>
>
