Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44296 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaK0VqF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 16:46:05 -0500
Message-ID: <54779B97.4060105@iki.fi>
Date: Thu, 27 Nov 2014 23:45:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Ira Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] tda18271: Fix identation
References: <ebd316f3f4f7cefa937562adba8ce60f2057ca9d.1417015567.git.mchehab@osg.samsung.com>	<CAOcJUbwiDEvp3-c+j7B1L9MxFjnrw9mT0116C+Dy9p4hOQNEhg@mail.gmail.com>	<20141127165925.05723c7b@recife.lan> <CAOcJUbzPY8Z2QKVKL+qddvEygUNt-xzmjLn4t7713NhWmmLkUg@mail.gmail.com>
In-Reply-To: <CAOcJUbzPY8Z2QKVKL+qddvEygUNt-xzmjLn4t7713NhWmmLkUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/27/2014 09:04 PM, Michael Ira Krufky wrote:
> On Thu, Nov 27, 2014 at 1:59 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
>> Em Thu, 27 Nov 2014 13:47:09 -0500
>> Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:
>>
>>> On Wed, Nov 26, 2014 at 10:26 AM, Mauro Carvalho Chehab
>>> <mchehab@osg.samsung.com> wrote:
>>>> As reported by smatch:
>>>>          drivers/media/tuners/tda18271-common.c:176 tda18271_read_extended() warn: if statement not indented
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>
>>>> diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
>>>> index 86e5e3110118..6118203543ea 100644
>>>> --- a/drivers/media/tuners/tda18271-common.c
>>>> +++ b/drivers/media/tuners/tda18271-common.c
>>>> @@ -173,12 +173,9 @@ int tda18271_read_extended(struct dvb_frontend *fe)
>>>>
>>>>          for (i = 0; i < TDA18271_NUM_REGS; i++) {
>>>>                  /* don't update write-only registers */
>>>> -               if ((i != R_EB9)  &&
>>>> -                   (i != R_EB16) &&
>>>> -                   (i != R_EB17) &&
>>>> -                   (i != R_EB19) &&
>>>> -                   (i != R_EB20))
>>>> -               regs[i] = regdump[i];
>>>> +               if ((i != R_EB9)  && (i != R_EB16) && (i != R_EB17) &&
>>>> +                   (i != R_EB19) && (i != R_EB20))
>>>> +                       regs[i] = regdump[i];
>>>>          }
>>>>
>>>>          if (tda18271_debug & DBG_REG)
>>>> --
>>>> 1.9.3
>>>>
>>>
>>> Mauro,
>>>
>>> I would actually rather NOT merge this patch.  This hurts the
>>> readability of the code.  If applied already, please revert it.
>>
>> What hurts readability is to not indent regs[i] = regdump[i];
>>
>>>
>>> Cheers,
>>>
>>> Mike
>
>
> If the patch were only fixing the indent of "regs[i] = regdump[i];"
> then it wouldn't bother me.  I don't approve of the whitespace change
> in the if statement.
>
> Please resubmit it as a one-liner that *only* fixes the single bad
> indentation of the assignment to regs[i].

switch-case is most suitable for that kind of comparisons.

regards
Antti

-- 
http://palosaari.fi/
