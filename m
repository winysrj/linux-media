Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54010 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754775AbcK1Ppo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 10:45:44 -0500
Date: Mon, 28 Nov 2016 10:45:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        <linux-media@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences
 without runtime PM
In-Reply-To: <2882556.Uxbj3HAuQA@avalon>
Message-ID: <Pine.LNX.4.44L0.1611281029070.1967-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 28 Nov 2016, Laurent Pinchart wrote:

> > Well, I admit it would be nicer if drivers didn't have to worry about
> > whether or not CONFIG_PM was enabled.  A slightly cleaner approach
> > from the one outlined above would have the probe routine do this:
> > 
> > 	my_power_up(dev);
> > 	pm_runtime_set_active(dev);
> > 	pm_runtime_get_noresume(dev);
> > 	pm_runtime_enable(dev);
> > 
> > and have the runtime-resume callback routine call my_power_up() to do
> > its work.  (Or make my_power_up() actually be the runtime-resume
> > callback routine.)  That's pretty straightforward and hard to mess up.
> 
> You'd be surprised how easy drivers can mess simple things up ;-)

No -- I wouldn't!  :-)

> We'd still 
> have to get the message out there, that would be the most difficult part.

Agreed.

> > In theory, we could have pm_runtime_enable() invoke the runtime-resume
> > callback when CONFIG_PM is disabled.  In practice, it would be rather
> > awkward.  drivers/base/power/runtime.c, which is where
> > pm_runtime_enable() is defined and the runtime-PM callbacks are
> > invoked, doesn't even get compiled if CONFIG_PM is off.
> 
> Sure, but that can easily be fixed.
> 
> > (Also, it would run against the grain.  CONFIG_PM=n means the kernel
> > ignores runtime PM, so pm_runtime_enable() shouldn't do anything.)
> 
> I'd argue that CONFIG_PM=n should mean that the runtime PM API doesn't perform 
> runtime PM, not that it should do absolutely nothing. If semantics is the 
> biggest concern, we could introduce a helper (whose name is TBD) that would 
> enable runtime PM when CONFIG_PM=y or power on the device when CONFIG_PM=n

Or have the driver call _both_ the helper routine and
pm_runtime_enable() -- the helper would do nothing if CONFIG_PM=y, and
it would invoke the runtime-resume callback if CONFIG_PM=n.

Either way would be a good approach.  Having pm_runtime_enable() call
the runtime-resume handler wouldn't work well if the driver has already
powered-up the device or the device starts out in the power-on state
(which is often the case).

> I want to make it as easy as possible for drivers to make sure they won't get 
> this wrong, which in my opinion requires a simple and straightforward API with 
> no code in the driver that would depend on the value of CONFIG_PM.

Well, the approach I outlined above is pretty simple and it doesn't
depend on the value of CONFIG_PM.

Your proposal is just as simple, but it does require drivers to 
remember to call the new helper routine.

> > There's a corollary aspect to this.  If you depend on runtime PM for
> > powering up your device during probe, does that mean you also depend on
> > runtime PM for powering down the device during remove?  That is likely
> > not to work, because the user can prevent runtime suspends by writing
> > to /sys/.../power/control.
> 
> Yes, I do, and I expect most runtime PM-enabled driver to do the same. When 
> runtime suspend is disabled through /sys/.../power/control does 
> pm_runtime_disable() invoke the runtime PM suspend handler if the device is 
> powered on ?

No, it doesn't, and neither does pm_runtime_put().  After all, if the
user has told the system not to do runtime PM on that device, it
doesn't make sense to call the runtime-suspend handler.  But you can
always blame the user when this happens.  :-)

Alan Stern

