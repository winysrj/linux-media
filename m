Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51202 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2IPAhR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 20:37:17 -0400
Message-ID: <50551F27.7070608@iki.fi>
Date: Sun, 16 Sep 2012 03:36:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: David Waring <david.waring@rd.bbc.co.uk>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] DVB API: LNA documentation
References: <1345167310-8738-1-git-send-email-crope@iki.fi> <1345167310-8738-7-git-send-email-crope@iki.fi> <504F851B.5040600@redhat.com> <50506B9C.5080705@rd.bbc.co.uk> <505083DB.2010608@redhat.com>
In-Reply-To: <505083DB.2010608@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2012 03:45 PM, Mauro Carvalho Chehab wrote:
> Em 12-09-2012 08:01, David Waring escreveu:
>> On 11/09/12 19:38, Mauro Carvalho Chehab wrote:
>>> Em 16-08-2012 22:35, Antti Palosaari escreveu:
>>>> [snip]
>>>> +	<para>Possible values: 0, 1, INT_MIN</para>
>>>
>>> Hmm... INT_MIN... are you sure it is portable on all Linux compilers?
>>>
>>> I don't like the idea on trusting on whatever C/C++/Java/... compiler (or some interpreter)
>>> would define as "INT_MIN".
>>>
>>> The better is to define a value for that, or, instead, to define something
>>> at the API header file that won't cause troubles with 32 bits or 64 bits
>>> userspace, like defining it as:
>>>
>>> #define DVB_AUTO_LNA ((u32)~0)
>>>
>> INT_MIN is defined in limits.h which is an ISO standard header. Other
>> parts of the kernel also use INT_MIN, e.g. linux/cpu.h and
>> linux/netfilter_ipv4.h both reference INT_MIN from limits.h.
>
> The linux/cpu.h is a Kernel internal header. There's no public userspace API
> there. So, it uses kernel's own definition for INT_MIN.
>
> You're right with regards to netfilter. Btw, it is only places where INT_MIN
> is used on an userspace-filtered headers are at the netfilter interface :
>
> /usr/include/linux/netfilter_ipv6.h:#include <limits.h> /* for INT_MIN, INT_MAX */
> /usr/include/linux/netfilter_ipv6.h:	NF_IP6_PRI_FIRST = INT_MIN,
> /usr/include/linux/netfilter_ipv4.h:#include <limits.h> /* for INT_MIN, INT_MAX */
> /usr/include/linux/netfilter_ipv4.h:	NF_IP_PRI_FIRST = INT_MIN,
> /usr/include/linux/netfilter_decnet.h:#include <limits.h> /* for INT_MIN, INT_MAX */
> /usr/include/linux/netfilter_decnet.h:	NF_DN_PRI_FIRST = INT_MIN,
>
> Even so, it got renamed inside a priorities enum:
>
> enum nf_ip_hook_priorities {
> 	NF_IP_PRI_FIRST = INT_MIN,
>
> In the case of netfilter, as this is just a priority number, it actually
> make sense to use INT_MIN as the lowest priority, as INT_MIN is the lowest
> number that can be represented there.
>
> What we're doing here is something else: we're defining a special value to be
> interpreted as "AUTO". In this case, if Kernel and userspace disagrees on what
> value should be used, the KAPI will be deadly broken.
>
> I might be wrong, but some C compilers on a few architectures (Tru64 C compiler comes
> on my mind) define "int" as 64 bit integers, with will affect the definition of INT_MIN.
> Ok, in this case, the definition will be compatible, but I'm wondering if some other
> compiler might be doing something else here.
>
> That's why I'm in favor of defining some constant for "AUTO" at the kernel headers,
> in a way that we'll be sure that we won't have any bad surprises on userspace.

Could you say clearly what it should be as I am not very familiar with 
API changes?

Also you mentioned with multistream support API changes that those 
values are unsigned numbers => not negative which makes me more unsure.
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50772.html

I can say I tested it with Python script using value -2147483648 and it 
worked. Maybe it was still due to signed => unsigned conversion.

Antti

-- 
http://palosaari.fi/
