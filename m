Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:20057 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaGVCKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 22:10:03 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N930038PCOONOA0@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 22:10:00 -0400 (EDT)
Date: Mon, 21 Jul 2014 23:09:56 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] SDR stuff
Message-id: <20140721230956.76886a71.m.chehab@samsung.com>
In-reply-to: <53CDB8C1.8000203@iki.fi>
References: <53C874F8.3020300@iki.fi>
 <20140721205005.28e2e784.m.chehab@samsung.com> <53CDAB73.8050108@iki.fi>
 <20140721215140.35935811.m.chehab@samsung.com> <53CDB8C1.8000203@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Jul 2014 04:05:05 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 07/22/2014 03:51 AM, Mauro Carvalho Chehab wrote:
> > Em Tue, 22 Jul 2014 03:08:19 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> So what. Those were mostly WARNING only and all but long lines were some
> >> new checks added to checkpatch recently. chekcpatch gets all the time
> >> new and new checks, these were added after I have made that driver. I
> >> will surely clean those later when I do some new changes to driver and
> >> my checkpatch updates.
> >
> > Antti,
> >
> > I think you didn't read my comments in the middle of the checkpatch stuff.
> > Please read my email again. I'm not requiring you to fix the newer checkpatch
> > warning (Missing a blank line after declarations), and not even about the
> > 80-cols warning. The thing is that there are two issues there:
> >
> > 1) you're adding API bits at msi2500 driver, instead of moving them
> >     to videodev2.h (or reusing the fourcc types you already added there);
> 
> If you look inside driver code, you will see those defines are not used 
> - but commented out. It is simply dead definition compiler optimizes 
> away. It is code I used on my tests, but finally decided to comment out 
> to leave some time add those later to API. I later moved 2 of those to 
> API, that is done in same patch serie.
> 
> No issue here.
> 
> > 2) you're handling jiffies wrong inside the driver.
> >
> > As you may know, adding a driver at staging is easier than at the main
> > tree, as we don't care much about checkpatch issues (and not even about
> > some more serious issues). However, when moving stuff out of staging,
> > we review the entire driver again, to be sure that it is ok.
> 
> That jiffie check is also rather new and didn't exists time drive was 
> done. Jiffie is used to calculate debug sample rate. There is multiple 
> times very similar code piece, which could be optimized to one. My plan 
> merge all those ~5 functions to one and use jiffies using macros as 
> checkpatch now likes. I don't see meaningful fix it now as you are going 
> to rewrite that stuff in near future in any case.

Ok, I'll apply the remaining patches.

> Silencing all those checkpatch things is not very hard job though. If 
> you merge that stuff to media/master I can do it right away (I am 
> running older kernel and older checkpatch currently).

FYI, I always use the checkpatch available on our tree, no matter what
Kernel I'm running. My scripts just call ./scripts/checkpatch.pl.

Regards,
Mauro

