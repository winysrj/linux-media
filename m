Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1EZAaS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 20:30:18 -0400
Message-ID: <4DDD9F11.20903@redhat.com>
Date: Wed, 25 May 2011 21:30:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Inlined functions should be static.
References: <201105231607.13668.hselasky@c2i.net> <Pine.LNX.4.64.1105232022460.30305@axis700.grange> <4DDAA788.80908@redhat.com> <201105232050.55676.hselasky@c2i.net>
In-Reply-To: <201105232050.55676.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 15:50, Hans Petter Selasky escreveu:
> On Monday 23 May 2011 20:29:28 Mauro Carvalho Chehab wrote:
>> Em 23-05-2011 15:23, Guennadi Liakhovetski escreveu:
>>> On Mon, 23 May 2011, Hans Petter Selasky wrote:
>>>> --HPS
>>>
>>> (again, inlining would save me copy-pasting)
>>
>> Yeah... hard to comment not-inlined patches...
>>
>>>> -inline u32 stb0899_do_div(u64 n, u32 d)
>>>> +static inline u32 stb0899_do_div(u64 n, u32 d)
>>>
>>> while at it you could as well remove the unneeded in a C file "inline"
>>> attribute.
>>
>> hmm... foo_do_div()... it seems to be yet-another-implementation
>> of asm/div64.h. If so, it is better to just remove this thing
>> and use the existing function.
>>
> 
> The reason for this patch is that some version of GCC generated some garbage 
> code on this function under certain conditions. Removing inline completly on 
> this static function in a C file is fine by me. Do I need to create another 
> patch?

Just looked inside the code: it is not re-implementing the wheel. I don't like
such macros, but it should not hurt. 

So, I just applied your patch.

Thanks,
Mauro.
> 
> --HPS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

