Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab0FZNf4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 09:35:56 -0400
Message-ID: <4C26022E.5060008@redhat.com>
Date: Sat, 26 Jun 2010 10:35:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [git:v4l-dvb/ivtv] V4L/DVB: tda18271: fix error detection during
 initialization of first instance
References: <E1OSV9v-0001x8-3g@www.linuxtv.org> <1277558644.8545.4.camel@localhost>
In-Reply-To: <1277558644.8545.4.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2010 10:24, Andy Walls escreveu:
> On Sat, 2010-06-26 at 14:51 +0200, Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the 
>> http://git.linuxtv.org/v4l-dvb.git tree:
>>
>> Subject: V4L/DVB: tda18271: fix error detection during initialization of first instance
>> Author:  Michael Krufky <mkrufky@kernellabs.com>
>> Date:    Mon May 3 02:10:15 2010 -0300
> 
> Hi Mauro,
> 
> The e-mail subject line has "ivtv" in it, but no ivtv related changes in
> the email.  I'm guessing this is a branch tag? 
> 
> Regards,
> Andy
> 
Yes, I noticed only after merging upstream... Sorry for the mess.

I have a number of working dirs here, in order to handle each staging tree, but, due to disk 
constraints (each working tree eats about 300Mb, plus extra space when I run make). 
Unfortunately, I currently can't have a one-per-one mapping. Those patches were meant to go
to staging/other. This should cause no big deal, but I really need to buy more disks and an
extra disk case for my Dell machine. On the other hand, reverting the patches at the upstream
tree will be bad, since it may break trees from others that pull from mine.

Cheers,
Mauro
