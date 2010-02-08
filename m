Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab0BHRXJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 12:23:09 -0500
Message-ID: <4B70485B.2090600@redhat.com>
Date: Mon, 08 Feb 2010 15:22:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chicken Shack <chicken.shack@gmx.de>,
	Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>, HoP <jpetrous@gmail.com>,
	Francesco Lavra <francescolavra@interfree.it>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	rms@gnu.org, hermann-pitton@arcor.de
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux filter
 (Was: Videotext application crashes the kernel due to DVB-demux patch)
References: <1265546998.9356.4.camel@localhost>  <4B6F72E5.3040905@redhat.com>  <4B700287.5080900@linuxtv.org> <1265636585.5399.47.camel@brian.bconsult.de> <alpine.LFD.2.00.1002080746180.3829@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002080746180.3829@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus Torvalds wrote:

>  - if somebody reports a regression, IT MUST BE FIXED. Not "discussed" for 
>    two weeks. Not talked around. If we have a bisected commit that starts 
>    oopsing with an existing setup that used to work, there is no 
>    discussion. That commit absolutely _has_ to be reverted or fixed. No 
>    ifs, buts, or maybes about it.
>    Anybody who argues anything else is simply totally wrong. And 
>    discussing various semantic changes or asking people to use other 
>    programs instead of the one that causes the problem is totally 
>    irrelevant until the oops has been fixed.
> 
>    An oops is not acceptable in _any_ situation, and saying that the user 
>    program is doing something wrong is totally ludicrous. So is breaking a 
>    program that used to work.
> 
> The fix, btw, for those that haven't seen it, seems to be here:
> 
> 	http://patchwork.kernel.org/patch/77615/

Yes, this patch actually fixed the OOPS, although it were a report From Chicken
saying that a previous patch got fixed it (http://patchwork.kernel.org/patch/76071/).

I submitted you both fixes, plus a third one (http://patchwork.kernel.org/patch/76083/)
for a potential usage of vmalloc during interrupt time.


Cheers,
Mauro
