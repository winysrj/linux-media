Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:34115 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZHXT4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 15:56:10 -0400
Received: by ewy3 with SMTP id 3so2725965ewy.18
        for <linux-media@vger.kernel.org>; Mon, 24 Aug 2009 12:56:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250992448.3262.11.camel@pc07.localdom.local>
References: <1250812164.3249.18.camel@pc07.localdom.local>
	 <1250992448.3262.11.camel@pc07.localdom.local>
Date: Mon, 24 Aug 2009 15:56:06 -0400
Message-ID: <37219a840908241256w100e810eva46bf31fa77b2d3c@mail.gmail.com>
Subject: Re: [PATCH] saa7134: start to investigate the LNA mess on 310i and
	hvr1110 products
From: Michael Krufky <mkrufky@kernellabs.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hermann,

On Sat, Aug 22, 2009 at 9:54 PM, hermann pitton<hermann-pitton@arcor.de> wrote:
>
> Am Freitag, den 21.08.2009, 01:49 +0200 schrieb hermann pitton:
>> There is a great maintenance mess for those devices currently.
>>
>> All attempts, to get some further information out of those assumed to be
>> closest to the above manufactures, failed.
>>
>> Against any previous advice, newer products with an additional LNA,
>> which needs to be configured correctly, have been added and we can't
>> make any difference to previous products without LNA.
>>
>> Even more, the type of LNA configuration, either over tuner gain or some
>> on the analog IF demodulator, conflicts within this two devices itself.
>>
>> Since we never had a chance, to see such devices with all details
>> reported to our lists, but might still be able to make eventually a
>> difference, to get out of that mess, we should prefer to start exactly
>> where it started.
>
> Mauro, Douglas,
>
> just mark it as an RFC.
>
> Seems i lose any interest to follow up such further.
>
> Never allow any guys to go out into the wild, ending up with that I have
> to read their personal web blogs ..., out of lists.
>
> Cheers,
> Hermann
>
>
>> Signed-off-by: hermann pitton <hermann-pitton@arcor.de>iff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-cards.c
>> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c       Thu Aug 20
>> 01:30:58 2009 +0000
>> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c       Fri Aug 21
>> 01:28:37 2009 +0200
>> @@ -3242,7 +3242,7 @@
>>               .radio_type     = UNSET,
>>               .tuner_addr     = ADDR_UNSET,
>>               .radio_addr     = ADDR_UNSET,
>> -             .tuner_config   = 1,
>> +             .tuner_config   = 0,
>>               .mpeg           = SAA7134_MPEG_DVB,
>>               .gpiomask       = 0x000200000,
>>               .inputs         = {{
>> @@ -3346,7 +3346,7 @@
>>               .radio_type     = UNSET,
>>               .tuner_addr     = ADDR_UNSET,
>>               .radio_addr     = ADDR_UNSET,
>> -             .tuner_config   = 1,
>> +             .tuner_config   = 0,
>>               .mpeg           = SAA7134_MPEG_DVB,
>>               .gpiomask       = 0x0200100,
>>               .inputs         = {{
>> diff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-dvb.c
>> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c Thu Aug 20
>> 01:30:58 2009 +0000
>> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c Fri Aug 21
>> 01:28:37 2009 +0200
>> @@ -1144,12 +1144,12 @@
>>               break;
>>       case SAA7134_BOARD_PINNACLE_PCTV_310i:
>>               if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
>> -                                      &tda827x_cfg_1) < 0)
>> +                                      &tda827x_cfg_0) < 0)
>>                       goto dettach_frontend;
>>               break;
>>       case SAA7134_BOARD_HAUPPAUGE_HVR1110:
>>               if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
>> -                                      &tda827x_cfg_1) < 0)
>> +                                      &tda827x_cfg_0) < 0)
>>                       goto dettach_frontend;
>>               break;
>>       case SAA7134_BOARD_HAUPPAUGE_HVR1150:
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


NACK.

Please do not change the LNA configuration for the HVR1110 -- I cannot
speak for the PCTV device, but I looked at the schematics for the
HVR1110 -- the LNA configuration should not be changed.

Regards,

Mike
