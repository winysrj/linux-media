Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52731
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933205AbdCaSEl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 14:04:41 -0400
Date: Fri, 31 Mar 2017 15:04:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Silvio Fricke <silvio.fricke@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/9] genericirq.tmpl: convert it to ReST
Message-ID: <20170331150429.2e4e5ffe@vento.lan>
In-Reply-To: <20170331085711.5ff4a550@lwn.net>
References: <cover.1490904090.git.mchehab@s-opensource.com>
        <de437318af3e6384319aba8d9e199a4645108822.1490904090.git.mchehab@s-opensource.com>
        <20170331085711.5ff4a550@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 31 Mar 2017 08:57:11 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 30 Mar 2017 17:11:30 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> [Reordering things a bit]
> 
> > +==========================
> > +Linux generic IRQ handling
> > +==========================
> > +
> > +:Copyright: |copy| 2005-2010: Thomas Gleixner
> > +:Copyright: |copy| 2005-2006:  Ingo Molnar  
> 
> It seems maybe they should have been CC'd on this one?  Adding them now
> (and leaving the full patch for their amusement).
> 
> > Brainless conversion of genericirq.tmpl book to ReST, via
> > 	Documentation/sphinx/tmplcvt  
> 
> In general this seems good, but I have to wonder how current this material
> is at this point?  The last substantive change was in 2013 (3.11), and I've
> seen a certain amount of IRQ work going by since then.  I'm not opposed to
> this move at all, but perhaps if it's outdated we should add a note to that
> effect?

Looking on the amount of c:func: references that got solved:
	http://www.infradead.org/~mchehab/kernel_docs/core-api/genericirq.html

I'd say that it doesn't seem outdated.

It mentions a __do_IRQ() function, with I was unable to found, but
I was able to find arch-dependent do_IRQ() functions, with seems to
match the concepts explained at the doc. I almost did a
	s/__do_IRQ/do_IRQ/
but, as I wasn't 100% sure, I opted to keep it as-is for others to touch.

It also mentions a request_irq() function, with is there, just without
kernel-doc markups.

Finally, it includes several core-api files with kernel-doc markups.

So, IMHO, it is worth merging it. Yet, it would be great if the ones
working on that part of the core could review and update it.

Regards,
Mauro
