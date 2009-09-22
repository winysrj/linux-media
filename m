Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:58440 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZIVHxv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 03:53:51 -0400
Date: Tue, 22 Sep 2009 09:53:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] media: video: Fix build in
	saa7164
Message-ID: <20090922075332.GA32302@elte.hu>
References: <20090919014930.7dd90f77@pedra.chehab.org> <20090921182345.GA25100@elte.hu> <20090921205754.26c59c46@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921205754.26c59c46@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em Mon, 21 Sep 2009 20:23:45 +0200
> Ingo Molnar <mingo@elte.hu> escreveu:
> 
> > 
> > * Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > 
> > > This series also contains several new drivers:
> > > 
> > >    - new driver for NXP saa7164;
> > 
> > -tip testing found that an allyesconfig build buglet found its way into 
> > this driver - find the fix below.
> > 
> 
> > diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
> > index f0dbead..60f3214 100644
> > --- a/drivers/media/video/saa7164/saa7164-core.c
> > +++ b/drivers/media/video/saa7164/saa7164-core.c
> > @@ -45,8 +45,8 @@ MODULE_LICENSE("GPL");
> >   32 bus
> >   */
> >  
> > -unsigned int debug;
> > -module_param(debug, int, 0644);
> > +unsigned int saa_debug;
> > +module_param(saa_debug, int, 0644);
> 
> Hmm... it is better to use module_param_named(debug, saa_debug, int, 0644), to
> keep presenting the parameter as just "debug" to userspace.

ah, yes, fully agreed - i thought i did that but apparently modified it 
in this instance.

> > This is because recent saa7164 changes introduced a global symbol 
> > named 'debug'. The x86 platform code already defines a 'debug' 
> > symbol. (which is named in a too generic way as well - but it can be 
> > used nicely to weed out too generic symbols in drivers ;-
> 
> Agreed.
> 
> Btw, I suggest to do a similar patch also for x86, to avoid such 
> future conflicts.

Actually, Andrew considers it a feature that allows us to filter out too 
generic names early on :-)

	Ingo
