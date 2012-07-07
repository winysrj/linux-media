Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45875 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2GGPpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2012 11:45:25 -0400
Received: by wibhq12 with SMTP id hq12so1467657wib.1
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2012 08:45:23 -0700 (PDT)
Message-ID: <4FF8598C.1030800@gmail.com>
Date: Sat, 07 Jul 2012 17:45:16 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v5 1/5] rtl2832 ver. 0.5: support for RTL2832 demod
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com> <1337366864-1256-2-git-send-email-thomas.mair86@googlemail.com> <4FF5A582.7070908@redhat.com> <4FF5A617.90200@iki.fi> <4FF5B8AE.803@redhat.com>
In-Reply-To: <4FF5B8AE.803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/2012 05:54 PM, Mauro Carvalho Chehab wrote:
> Em 05-07-2012 11:35, Antti Palosaari escreveu:
>> On 07/05/2012 05:32 PM, Mauro Carvalho Chehab wrote:
>>> Em 18-05-2012 15:47, Thomas Mair escreveu:
> 
>>>> +static const int reg_mask[32] = {
>>>> +    0x00000001,
>>>> +    0x00000003,
>>>> +    0x00000007,
>>>> +    0x0000000f,
>>>> +    0x0000001f,
>>>> +    0x0000003f,
>>>> +    0x0000007f,
>>>> +    0x000000ff,
>>>> +    0x000001ff,
>>>> +    0x000003ff,
>>>> +    0x000007ff,
>>>> +    0x00000fff,
>>>> +    0x00001fff,
>>>> +    0x00003fff,
>>>> +    0x00007fff,
>>>> +    0x0000ffff,
>>>> +    0x0001ffff,
>>>> +    0x0003ffff,
>>>> +    0x0007ffff,
>>>> +    0x000fffff,
>>>> +    0x001fffff,
>>>> +    0x003fffff,
>>>> +    0x007fffff,
>>>> +    0x00ffffff,
>>>> +    0x01ffffff,
>>>> +    0x03ffffff,
>>>> +    0x07ffffff,
>>>> +    0x0fffffff,
>>>> +    0x1fffffff,
>>>> +    0x3fffffff,
>>>> +    0x7fffffff,
>>>> +    0xffffffff
>>>> +};
>>>
>>> It would be better to use a macro here like:
>>>
>>> #define REG_MASK(b)    ((1 << ((b) + 1)) -1)
>>>
>>> Even better, you could use the bitops.h BIT() macro:
>>>
>>> #define REG_MASK(b)    (BIT(b + 1) - 1)
>>
>> I said also that once for Thomas during review but he didn't changed it :)
> 
> As those findings are minor ones, I'll just apply the patch series
> and add a patch replacing reg_mask table by a macro like above.
>

Thank you!
Have a nice vacation.

cheers,
poma
