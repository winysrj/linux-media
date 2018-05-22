Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.150.114]:44772 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbeEVR6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 13:58:09 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id B3C546EDCF
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 12:11:55 -0500 (CDT)
Subject: Re: [media] duplicate code in media drivers
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@linuxtv.org>
References: <20180521193951.GA16659@embeddedor.com>
 <20180521171415.00c56487@vento.lan>
 <CAGoCfiwHPPJZABCtMgPzqvHNprnLn8qG9R0aT0b3Y8VfR_ta+g@mail.gmail.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <eda3980d-0464-b030-448a-bc60fab75f97@embeddedor.com>
Date: Tue, 22 May 2018 12:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwHPPJZABCtMgPzqvHNprnLn8qG9R0aT0b3Y8VfR_ta+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/21/2018 03:44 PM, Devin Heitmueller wrote:
>>> diff -u -p drivers/media/dvb-frontends/au8522_decoder.c /tmp/nothing/media/dvb-frontends/au8522_decoder.c
>>> --- drivers/media/dvb-frontends/au8522_decoder.c
>>> +++ /tmp/nothing/media/dvb-frontends/au8522_decoder.c
>>> @@ -280,14 +280,9 @@ static void setup_decoder_defaults(struc
>>>                          AU8522_TOREGAAGC_REG0E5H_CVBS);
>>>          au8522_writereg(state, AU8522_REG016H, AU8522_REG016H_CVBS);
>>>
>>> -       if (is_svideo) {
>>>                  /* Despite what the table says, for the HVR-950q we still need
>>>                     to be in CVBS mode for the S-Video input (reason unknown). */
>>>                  /* filter_coef_type = 3; */
>>> -               filter_coef_type = 5;
>>> -       } else {
>>> -               filter_coef_type = 5;
>>> -       }
>>
>> Better ask Devin about this (c/c).
> 
> This was a case where the implementation didn't match the datasheet,
> and it wasn't clear why the filter coefficients weren't working
> properly.  Essentially I should have labeled that as a TODO or FIXME
> when I disabled the "right" value and forced it to always be five.  It
> was also likely that the filter coefficients would need to differ if
> taking video over the IF interface as opposed to CVBS/S-video, which
> is why I didn't want to get rid of the logic entirely.  That said, the
> only product I've ever seen with the tda18271 mated to the au8522 will
> likely never be supported for analog video under Linux for unrelated
> reasons.
> 
> That said, it's worked "good enough" since I wrote the code nine years
> ago, so if somebody wants to submit a patch to either get rid of the
> if() statement or mark it as a FIXME that will likely never actually
> get fixed, I wouldn't have an objection to either.
> 

Devin,

I've sent a patch based on your feedback.

Thanks!
--
Gustavo
