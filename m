Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab2GEPye (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 11:54:34 -0400
Message-ID: <4FF5B8AE.803@redhat.com>
Date: Thu, 05 Jul 2012 12:54:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org, pomidorabelisima@gmail.com
Subject: Re: [PATCH v5 1/5] rtl2832 ver. 0.5: support for RTL2832 demod
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com> <1337366864-1256-2-git-send-email-thomas.mair86@googlemail.com> <4FF5A582.7070908@redhat.com> <4FF5A617.90200@iki.fi>
In-Reply-To: <4FF5A617.90200@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2012 11:35, Antti Palosaari escreveu:
> On 07/05/2012 05:32 PM, Mauro Carvalho Chehab wrote:
>> Em 18-05-2012 15:47, Thomas Mair escreveu:

>>> +static const int reg_mask[32] = {
>>> +    0x00000001,
>>> +    0x00000003,
>>> +    0x00000007,
>>> +    0x0000000f,
>>> +    0x0000001f,
>>> +    0x0000003f,
>>> +    0x0000007f,
>>> +    0x000000ff,
>>> +    0x000001ff,
>>> +    0x000003ff,
>>> +    0x000007ff,
>>> +    0x00000fff,
>>> +    0x00001fff,
>>> +    0x00003fff,
>>> +    0x00007fff,
>>> +    0x0000ffff,
>>> +    0x0001ffff,
>>> +    0x0003ffff,
>>> +    0x0007ffff,
>>> +    0x000fffff,
>>> +    0x001fffff,
>>> +    0x003fffff,
>>> +    0x007fffff,
>>> +    0x00ffffff,
>>> +    0x01ffffff,
>>> +    0x03ffffff,
>>> +    0x07ffffff,
>>> +    0x0fffffff,
>>> +    0x1fffffff,
>>> +    0x3fffffff,
>>> +    0x7fffffff,
>>> +    0xffffffff
>>> +};
>>
>> It would be better to use a macro here like:
>>
>> #define REG_MASK(b)    ((1 << ((b) + 1)) -1)
>>
>> Even better, you could use the bitops.h BIT() macro:
>>
>> #define REG_MASK(b)    (BIT(b + 1) - 1)
> 
> I said also that once for Thomas during review but he didn't changed it :)

As those findings are minor ones, I'll just apply the patch series
and add a patch replacing reg_mask table by a macro like above.

>>> +static int rtl2832_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>>> +{
>>> +    *strength = 0;
>>> +    return 0;
>>> +}
>>
>> Why to implement the above, if they're doing nothing?
> 
> Other your findings were correct but for that I would like to comment.
> 
> Have you ever tested what happens you lest those without stub implementation? IIRC ugly errors are seen for example zap and femon outputs. Some kind of DVB-core changes are needed. And IIRC there was some error code defined too for API - but such code does not exists.
> 

I'll keep those stubs for now, but we should really fix the core and not allow/add
crap things like that.

Regards,
Mauro
