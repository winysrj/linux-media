Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35523 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2DTOBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 10:01:44 -0400
Received: by wejx9 with SMTP id x9so6091553wej.19
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2012 07:01:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334879437.14608.22.camel@palomino.walls.org>
References: <4F8EB1F1.1030801@gmail.com>
	<1334879437.14608.22.camel@palomino.walls.org>
Date: Fri, 20 Apr 2012 11:01:43 -0300
Message-ID: <CADbd7mHbP0YVQSBo4TgF0ZKqEU5VydWOoHZp__owh2b4k8aZsw@mail.gmail.com>
Subject: Re: [PATCH] TDA9887 PAL-Nc fix
From: "Gonzalo A. de la Vega" <gadelavega@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 19, 2012 at 8:50 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2012-04-18 at 09:22 -0300, Gonzalo de la Vega wrote:
>> The tunner IF for PAL-Nc norm, which AFAIK is used only in Argentina, was being defined as equal to PAL-M but it is not. It actually uses the same video IF as PAL-BG (and unlike PAL-M) but the audio is at 4.5MHz (same as PAL-M). A separate structure member was added for PAL-Nc.
>>
>> Signed-off-by: Gonzalo A. de la Vega <gadelavega@gmail.com>
>
> Hmmm.
>
> The Video IF for N systems is 45.75 MHz according to this popular book
> (see page 29 of the PDF):
> http://www.deetc.isel.ipl.pt/Analisedesinai/sm/downloads/doc/ch08.pdf
>
> The Video IF is really determined by the IF SAW filter used in your
> tuner assembly, and how the tuner data sheet says to program the
> mixer/oscillator chip to mix down from RF to IF.
>
> What model analog tuner assembly are you using?  It could be that the
> linux tuner-simple module is setting up the mixer/oscillator chip wrong.
>
> Regards,
> Andy

Hi Andy,
first of all and to clarify things: I could not tune analog TV without
this patch, or I could barely see a BW image. With the patch applied,
I can see image in full color and with good sound. So it works with
the patch, it does not work without it.

Now, I'm not an expert on TV (I am an electronics engineer thou) so I
am having some trouble trying to put together what I read in the
TDA9887 datasheet and the reference you sent. The thing with PAL-Nc is
that it has a video bandwidth of 4.2MHz not 5.0MHz (page 51) and the
attenuation of color difference signals for >20dB is at 3.6MHz instead
of 4MHz (page 54). You can just search for "Argentina" inside the
document.

So, this works... but now I'm not sure why. I guess cVideoIF_38_90 is
compensating for the bandwidth difference. I need to study this.

Gonzalo

>
>>
>> diff --git a/drivers/media/common/tuners/tda9887.c b/drivers/media/common/tuners/tda9887.c
>> index cdb645d..b560b5d 100644
>> --- a/drivers/media/common/tuners/tda9887.c
>> +++ b/drivers/media/common/tuners/tda9887.c
>> @@ -168,8 +168,8 @@ static struct tvnorm tvnorms[] = {
>>                          cAudioIF_6_5   |
>>                          cVideoIF_38_90 ),
>>       },{
>> -             .std   = V4L2_STD_PAL_M | V4L2_STD_PAL_Nc,
>> -             .name  = "PAL-M/Nc",
>> +             .std   = V4L2_STD_PAL_M,
>> +             .name  = "PAL-M",
>>               .b     = ( cNegativeFmTV  |
>>                          cQSS           ),
>>               .c     = ( cDeemphasisON  |
>> @@ -179,6 +179,17 @@ static struct tvnorm tvnorms[] = {
>>                          cAudioIF_4_5   |
>>                          cVideoIF_45_75 ),
>>       },{
>> +             .std   = V4L2_STD_PAL_Nc,
>> +             .name  = "PAL-Nc",
>> +             .b     = ( cNegativeFmTV  |
>> +                        cQSS           ),
>> +             .c     = ( cDeemphasisON  |
>> +                        cDeemphasis75  |
>> +                        cTopDefault),
>> +             .e     = ( cGating_36     |
>> +                        cAudioIF_4_5   |
>> +                        cVideoIF_38_90 ),
>> +     },{
>>               .std   = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H,
>>               .name  = "SECAM-BGH",
>>               .b     = ( cNegativeFmTV  |
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
