Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36544 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaIRMLx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 08:11:53 -0400
Date: Thu, 18 Sep 2014 09:11:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] si2157: change command for sleep
Message-ID: <20140918091148.348669ce@recife.lan>
In-Reply-To: <541AC97B.1020508@iki.fi>
References: <1408990024-1642-1-git-send-email-olli.salonen@iki.fi>
	<54097579.6000507@iki.fi>
	<20140918082233.16ce4a37@recife.lan>
	<20140918085055.15375d0b@recife.lan>
	<541AC97B.1020508@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Em Thu, 18 Sep 2014 15:00:59 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/18/2014 02:50 PM, Mauro Carvalho Chehab wrote:
> > Sorry, I misunderstood this patch.
> >
> > There are actually two different things, each requiring a different PM
> > setting:
> >
> > 1) to put the tuner to sleep while it is not in usage;
> >
> > 2) put the machine to suspend.
> >
> > This patch is for (1). That's FINE. I'll apply it.
> >
> > Yet, for (2), assuming a suspend to ram, the best is to save more
> > power.
> >
> > In the past, the DVB core didn't make any distinction between those
> > two, but we recently added a hook for suspend there.
> >
> > So, it makes sense to keep the tuner powerdown mode for suspend.
> 
> 
> I think old deep sleep should be used for suspend, whilst on warm state 
> that new is OK.

Agreed.

> I2C driver has suspend/resume support and it is one thing I am going to 
> study in near future.

The problem with an I2C core driven suspend/resume call is that the
suspend/resume order will be random. This will likely break support
on complex devices where resuming require a certain order to happen,
especially if the device is streaming.

> Currently I have 128GB SSD and no swap at all, so 
> I cannot test it now. I have already bought 256GB SSD and I am just 
> waiting for Fedora 21 alpha version, which I will install with proper 
> swap. Unfortunately they have delayed many times already Fedora 21 alpha...

Fedora 21 alpha will likely be too experimental for my taste ;)

The changes on Fedora next means that too much needs to be touched,
so, I'll likely wait for a few months after Fedora 21 release to
migrate most of my machines.

> I am not even sure if DVB frontend needs any special suspend/resume 
> handling, isn't it possible to use standard kernel PM here? (I already 
> added some initial PM to DVB FE ~2 years ago, but IIRC those will only 
> kill threads and so which are not allowed when suspend).

Well, dvb uses the standard Kernel PM. The way PM works on most places
is that the subsystem provides their own PM methods that are called
by the PM subsystem.

> So is there some reason DVB FE needs suspend/resume hooks?

Yes. See above.

Basically, at suspend, the tuner and demod should be stopped (including
all kthreads), and they need to be restarted and firmware may need to be
reloaded at resume time.

Regards,
Mauro
