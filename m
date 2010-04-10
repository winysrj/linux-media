Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0DJAnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 20:43:15 -0400
Message-ID: <4BBFC99E.6010707@infradead.org>
Date: Fri, 09 Apr 2010 21:43:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Teach drivers/media/IR/ir-raw-event.c to use durations
References: <20100408161000.GA23119@hardeman.nu> <1270848998.3038.47.camel@palomino.walls.org>
In-Reply-To: <1270848998.3038.47.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Thu, 2010-04-08 at 18:10 +0200, David Härdeman wrote:
> 
>> With this patch:
>>
>> s64 int's are used to represent pulse/space durations in ns
> 
> If performing divides on 64 bit numbers, please check to make sure your
> code compiles, links, and loads on a 32-bit system.
> 
> We've had problems in the past in where gcc will build the module to
> reference __udivdi3 under 32-bit kernels; but that symbol is not in the
> kernel.

Good catch!

> Search for 'do_div' in:
> 
> 	linux/drivers/media/video/cx18/cx18-av-core.c
> 
> for a simple example divide that works on both 64 and 32 bit machines.

Unfortunately, not all gcc versions complain about the lack of the __udivi32
library. Some (like the one I run on my desktop), will add some inlined
assembler code for it, instead of requiring some library to do the division.

We'll likely only discover such bugs only after sending the code to linux-next
(done later yesterday - but I suspect that it were pulled only today from
my tree) and receiving a complain for the ones that run those robots that
test hundreds of different CONFIG_foo options.

So, I suspect that we'll have some of such complaints by tomorrow...

-- 

Cheers,
Mauro
