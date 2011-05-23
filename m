Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab1EWS3i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 14:29:38 -0400
Message-ID: <4DDAA788.80908@redhat.com>
Date: Mon, 23 May 2011 15:29:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Petter Selasky <hselasky@c2i.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Inlined functions should be static.
References: <201105231607.13668.hselasky@c2i.net> <Pine.LNX.4.64.1105232022460.30305@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105232022460.30305@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 15:23, Guennadi Liakhovetski escreveu:
> On Mon, 23 May 2011, Hans Petter Selasky wrote:
> 
>> --HPS
>>
> 
> (again, inlining would save me copy-pasting)

Yeah... hard to comment not-inlined patches...

> 
>> -inline u32 stb0899_do_div(u64 n, u32 d)
>> +static inline u32 stb0899_do_div(u64 n, u32 d)
> 
> while at it you could as well remove the unneeded in a C file "inline" 
> attribute.

hmm... foo_do_div()... it seems to be yet-another-implementation
of asm/div64.h. If so, it is better to just remove this thing
and use the existing function.

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

