Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:34112 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbeEUUoy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 16:44:54 -0400
Received: by mail-vk0-f47.google.com with SMTP id t63-v6so9584434vkb.1
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 13:44:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180521171415.00c56487@vento.lan>
References: <20180521193951.GA16659@embeddedor.com> <20180521171415.00c56487@vento.lan>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 21 May 2018 16:44:52 -0400
Message-ID: <CAGoCfiwHPPJZABCtMgPzqvHNprnLn8qG9R0aT0b3Y8VfR_ta+g@mail.gmail.com>
Subject: Re: [media] duplicate code in media drivers
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> diff -u -p drivers/media/dvb-frontends/au8522_decoder.c /tmp/nothing/media/dvb-frontends/au8522_decoder.c
>> --- drivers/media/dvb-frontends/au8522_decoder.c
>> +++ /tmp/nothing/media/dvb-frontends/au8522_decoder.c
>> @@ -280,14 +280,9 @@ static void setup_decoder_defaults(struc
>>                         AU8522_TOREGAAGC_REG0E5H_CVBS);
>>         au8522_writereg(state, AU8522_REG016H, AU8522_REG016H_CVBS);
>>
>> -       if (is_svideo) {
>>                 /* Despite what the table says, for the HVR-950q we still need
>>                    to be in CVBS mode for the S-Video input (reason unknown). */
>>                 /* filter_coef_type = 3; */
>> -               filter_coef_type = 5;
>> -       } else {
>> -               filter_coef_type = 5;
>> -       }
>
> Better ask Devin about this (c/c).

This was a case where the implementation didn't match the datasheet,
and it wasn't clear why the filter coefficients weren't working
properly.  Essentially I should have labeled that as a TODO or FIXME
when I disabled the "right" value and forced it to always be five.  It
was also likely that the filter coefficients would need to differ if
taking video over the IF interface as opposed to CVBS/S-video, which
is why I didn't want to get rid of the logic entirely.  That said, the
only product I've ever seen with the tda18271 mated to the au8522 will
likely never be supported for analog video under Linux for unrelated
reasons.

That said, it's worked "good enough" since I wrote the code nine years
ago, so if somebody wants to submit a patch to either get rid of the
if() statement or mark it as a FIXME that will likely never actually
get fixed, I wouldn't have an objection to either.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
