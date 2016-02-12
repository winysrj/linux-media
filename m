Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:34208 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbcBLWNz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 17:13:55 -0500
Date: Fri, 12 Feb 2016 14:13:52 -0800
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160212221352.GY3500@atomide.com>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi>
 <56BE57FC.3020407@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56BE57FC.3020407@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

* Javier Martinez Canillas <javier@osg.samsung.com> [160212 14:10]:
> Hello,
> 
> On 02/08/2016 07:54 AM, Wolfram Sang wrote:
> >On Wed, Feb 03, 2016 at 10:46:51AM -0300, Javier Martinez Canillas wrote:
> >>Hello Wolfram,
> >>
> >>I've a issue with a I2C video decoder driver (drivers/media/i2c/tvp5150.c).
> >>
> >>In v4.5-rc1, the driver gets I2C read / writes timeouts when accessing the
> >>device I2C registers:
> >>
> >>tvp5150 1-005c: i2c i/o error: rc == -110
> >>tvp5150: probe of 1-005c failed with error -110
> >>
> >>The driver used to work up to v4.4 so this is a regression in v4.5-rc1:
> >>
> >>tvp5150 1-005c: tvp5151 (1.0) chip found @ 0xb8 (OMAP I2C adapter)
> >>tvp5150 1-005c: tvp5151 detected.
> >>
> >>I tracked down to commit 9f924169c035 ("i2c: always enable RuntimePM for
> >>the adapter device") and reverting that commit makes things to work again.
> >>
> >>The tvp5150 driver doesn't have runtime PM support but the I2C controller
> >>driver does (drivers/i2c/busses/i2c-omap.c) FWIW.
> >>
> >>I tried adding runtime PM support to tvp5150 (basically calling pm_runtime
> >>enable/get on probe before the first I2C read to resume the controller) but
> >>that it did not work.
> >>
> >>Not filling the OMAP I2C driver's runtime PM callbacks does not help either.
> >>
> >>Any hints about the proper way to fix this issue?
> >
> >Asking linux-pm for help:
> >
> >The commit in question enables RuntimePM for the logical adapter device
> >which sits between the HW I2C controller and the I2C client device. This
> >adapter device has been used with pm_runtime_no_callbacks before
> >enabling RPM. Now, Alan explained to me that "suspend events will
> >propagate from the I2C clients all the way up to the adapter's parent."
> >with RPM enabled for the adapter device. Which should be a no-op if the
> >client doesn't do any PM at all? What do I miss?
> 
> I'm adding Tony Lindgren to the cc list as well since he is the OMAP
> maintainer and I see that has struggled lately with runtime PM issues
> so maybe he has more ideas.

Hmm yeah I wonder if this canned solution helps here too:

1. Check if the driver(s) are using pm_runtime_use_autosuspend()

2. If so, you must use pm_runtime_dont_use_autosuspend() before
   pm_runtime_put_sync() to make sure that pm_runtime_put_sync()
   works.

3. Or you can use pm_runtime_put_sync_suspend() instead of
   pm_runtime_put_sync() for sections of code where the clocks
   need to be stopped.

Regards,

Tony
