Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout0.thls.bbc.co.uk ([132.185.240.35]:59149 "EHLO
	mailout0.thls.bbc.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2ILLZZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 07:25:25 -0400
Message-ID: <50506B9C.5080705@rd.bbc.co.uk>
Date: Wed, 12 Sep 2012 12:01:48 +0100
From: David Waring <david.waring@rd.bbc.co.uk>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] DVB API: LNA documentation
References: <1345167310-8738-1-git-send-email-crope@iki.fi> <1345167310-8738-7-git-send-email-crope@iki.fi> <504F851B.5040600@redhat.com>
In-Reply-To: <504F851B.5040600@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/09/12 19:38, Mauro Carvalho Chehab wrote:
> Em 16-08-2012 22:35, Antti Palosaari escreveu:
>> [snip]
>> +	<para>Possible values: 0, 1, INT_MIN</para>
> 
> Hmm... INT_MIN... are you sure it is portable on all Linux compilers?
> 
> I don't like the idea on trusting on whatever C/C++/Java/... compiler (or some interpreter)
> would define as "INT_MIN".
> 
> The better is to define a value for that, or, instead, to define something
> at the API header file that won't cause troubles with 32 bits or 64 bits
> userspace, like defining it as:
> 
> #define DVB_AUTO_LNA ((u32)~0)
> 
INT_MIN is defined in limits.h which is an ISO standard header. Other
parts of the kernel also use INT_MIN, e.g. linux/cpu.h and
linux/netfilter_ipv4.h both reference INT_MIN from limits.h.

-- 
David Waring, Software Engineer, BBC Research & Development

