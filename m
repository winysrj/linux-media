Return-path: <mchehab@pedra>
Received: from ozlabs.org ([203.10.76.45]:36730 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab0ITW7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 18:59:41 -0400
Date: Tue, 21 Sep 2010 08:55:27 +1000
From: Anton Blanchard <anton@samba.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: IR code autorepeat issue?
Message-ID: <20100920225527.GK25306@kryten>
References: <20100829064036.GB22853@kryten>
 <4C7A8056.4070901@infradead.org>
 <4C87BA04.7030908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C87BA04.7030908@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi,

> > > I'm seeing double IR events on 2.6.36-rc2 and a DViCO FusionHDTV DVB-T
> > > Dual Express.
> >
> > There's one issue on touching on this constant: it is currently just one
> > global timeout value that will be used by all protocols. This timeout
> > should be enough to retrieve and proccess the repeat key event on all
> > protocols, and on all devices, or we'll need to do a per-protocol (and
> > eventually per device) timeout init. From
> > http://www.sbprojects.com/knowledge/ir/ir.htm, we see that NEC prococol
> > uses 110 ms for repeat code, and we need some aditional time to wake up the
> > decoding task. I'd say that anything lower than 150-180ms would risk to not
> > decode repeat events with NEC.
> > 
> > I got exactly the same problem when adding RC CORE support at the dib0700
> > driver. At that driver, there's an additional time of sending/receiving
> > URB's from USB. So, we probably need a higher timeout. Even so, I tried to
> > reduce the timeout to 200ms or 150ms (not sure), but it didn't work. So, I
> > ended by just patching the dibcom driver to do dev->rep[REP_DELAY] = 500:
> 
> Ok, just sent a patch adding it to rc-core, and removing from dib0700 driver.

Thanks, tested and confirmed to work!

I originally hit this on Ubuntu Maverick. Would you be OK if I submit it for
backport to 2.6.35 stable?

Anton
