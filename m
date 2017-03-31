Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:42148 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933128AbdCaPpv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 11:45:51 -0400
Date: Fri, 31 Mar 2017 17:45:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Silvio Fricke <silvio.fricke@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/9] genericirq.tmpl: convert it to ReST
In-Reply-To: <20170331085711.5ff4a550@lwn.net>
Message-ID: <alpine.DEB.2.20.1703311742221.1780@nanos>
References: <cover.1490904090.git.mchehab@s-opensource.com> <de437318af3e6384319aba8d9e199a4645108822.1490904090.git.mchehab@s-opensource.com> <20170331085711.5ff4a550@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 31 Mar 2017, Jonathan Corbet wrote:
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

We should take the opportunity and rewrite it proper. I might have an
intern available in the next couple of weeks, but I need to check with the
folks who are tasked to entertain him :)

Thanks,

	tglx
