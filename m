Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:34276 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbcBLXq0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 18:46:26 -0500
Date: Fri, 12 Feb 2016 15:46:23 -0800
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160212234623.GB3500@atomide.com>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi>
 <56BE57FC.3020407@osg.samsung.com>
 <20160212221352.GY3500@atomide.com>
 <56BE5C97.9070607@osg.samsung.com>
 <20160212224018.GZ3500@atomide.com>
 <56BE65F0.8040600@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56BE65F0.8040600@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Javier Martinez Canillas <javier@osg.samsung.com> [160212 15:09]:
> Hello Tony,
> 
> On 02/12/2016 07:40 PM, Tony Lindgren wrote:
> >* Javier Martinez Canillas <javier@osg.samsung.com> [160212 14:29]:
> >>On 02/12/2016 07:13 PM, Tony Lindgren wrote:
> >>>Hmm yeah I wonder if this canned solution helps here too:
> >>>
> >>>1. Check if the driver(s) are using pm_runtime_use_autosuspend()
> >>>
> >>
> >>By driver do you mean the OMAP GPIO driver or the tvp5150 I2C driver?
> >>The latter does not have runtime PM support.
> >
> >Sounds like OMAP GPIO then.
> >
> 
> Ok.
> >>>2. If so, you must use pm_runtime_dont_use_autosuspend() before
> >>>    pm_runtime_put_sync() to make sure that pm_runtime_put_sync()
> >>>    works.
> >>>
> >>>3. Or you can use pm_runtime_put_sync_suspend() instead of
> >>>    pm_runtime_put_sync() for sections of code where the clocks
> >>>    need to be stopped.
> >>>
> >>
> >>I can check if the OMAP GPIO is following these and give a try but
> >>don't have access to the board right now so I'll do it on Monday.
> >
> >It does not seem to be using pm_runtime_autosuspend(). Did you
> >try reverting commit de85b9d57ab ("PM / runtime: Re-init runtime
> >PM states at probe error and driver unbind") and see if that
> >helps?
> >
> 
> Yes, that's the first thing I tried when I noticed your patch:
> 
> ("i2c: omap: Fix PM regression with deferred probe for
> pm_runtime_reinit")
> 
> But neither reverting commit de85b9d57ab nor your fix made a
> difference.
> >If it does, then sounds like we may have some other regression
> >as well.

OK I doubt it's the GPIO driver if reverting 9f924169c035
helps.

I do see some GPIO regressions in current Linux next though,
but sounds like you're using v4.5-rc series.

> It seems that is not related but I hope that given you were
> looking at the runtime PM core lately, maybe you can figure
> out what we are missing.
> 
> I'm far from being familiar with the runtime PM framework
> but I've looked and can't figure out why Wolfram's commit
> make this driver to fail and reverting his commit make its
> work again.

No idea. What kind of PM runtime use case has that one been
tested with?

Regards,

Tony
