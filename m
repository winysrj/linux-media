Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:41000 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751142AbaKZBto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 20:49:44 -0500
Message-ID: <1416966580.8358.17.camel@perches.com>
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog.c: fix quoted strings
 split across lines
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: linux-kernel@vger.kernel.org, jarod@wilsonet.com,
	m.chehab@samsung.com, gregkh@linuxfoundation.org,
	mahfouz.saif.elyazal@gmail.com, dan.carpenter@oracle.com,
	tuomas.tynkkynen@iki.fi, gulsah.1004@gmail.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 25 Nov 2014 17:49:40 -0800
In-Reply-To: <20141125211428.GA12346@biggie>
References: <20141125201905.GA10900@biggie>
	 <1416947244.8358.12.camel@perches.com> <20141125204056.GA12162@biggie>
	 <1416949207.8358.14.camel@perches.com> <20141125211428.GA12346@biggie>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2014-11-25 at 21:14 +0000, Luis de Bethencourt wrote:
> On Tue, Nov 25, 2014 at 01:00:07PM -0800, Joe Perches wrote:
> > In the future, you might consider being more
> > comprehensive with your patches.
> 
> Wasn't sure about the scope of the style fixing
> patches. I've been reading Kernel Newbies and
> this looked like a good way to start
> contributing. Good to know more exhaustive
> changes are welcome.
> > 
> > This code could be neatened a bit by:
> > 
> > o using another set of logging macros
> > o removing the unnecessary ftrace like logging
> > o realigning arguments
> 
> Great ideas.
> Should this have been all included in one patch,
> or each as part of a series with the previous
> one?
> Want to take the opportunity to learn about the
> process.

Hello again Luis.

I think the suggestion I posted here is suitable
for a single change.

Ideally, you'd make individual patches each with
a single "type" of change.

There is a script I posted a while back that
groups various checkpatch "types" together and
makes it a bit easier to do cleanup style
patches.

https://lkml.org/lkml/2014/7/11/794

But don't just use checkpatch as the sole
decider of what's appropriate to fix or neaten.

checkpatch is a stupid, brainless little script.
So is the automation script that uses checkpatch.

For instance, checkpatch would not have suggested
creating and using another logging macro.

Please use your own taste to best figure out what
to fix and how.

Using checkpatch to get familiar with kernel
development is fine and all, but fixing actual
defects and submitting new code is way more
useful.

cheers, welcome, Joe

