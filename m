Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50300 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbcK1H6S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 02:58:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Mon, 28 Nov 2016 09:58:29 +0200
Message-ID: <2882556.Uxbj3HAuQA@avalon>
In-Reply-To: <Pine.LNX.4.44L0.1611261451230.32289-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1611261451230.32289-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Saturday 26 Nov 2016 15:10:28 Alan Stern wrote:
> On Fri, 25 Nov 2016, Laurent Pinchart wrote:
> > On Friday 25 Nov 2016 10:21:21 Alan Stern wrote:
> >> On Fri, 25 Nov 2016, Sakari Ailus wrote:
> >>> On Thu, Nov 24, 2016 at 09:15:39PM -0500, Alan Stern wrote:
> >>>> On Fri, 25 Nov 2016, Laurent Pinchart wrote:
> >>>>> Dear linux-pm developers, what's the suggested way to ensure that a
> >>>>> runtime- pm-enabled driver can run fine on a system with CONFIG_PM
> >>>>> disabled ?
> >>>> 
> >>>> The exact point of your question isn't entirely clear.  In the most
> >>>> literal sense, the best ways to ensure this are (1) audit the code,
> >>>> and (2) actually try it.
> >>>> 
> >>>> I have a feeling this doesn't quite answer your question, however. 
> >>>> :-)
> >>> 
> >>> The question is related to devices that require certain power-up and
> >>> power-down sequences that are now implemented as PM runtime hooks
> >>> that, without CONFIG_PM defined, will not be executed. Is there a
> >>> better way than to handle this than have an implementation in the
> >>> driver for the PM runtime and non-PM runtime case separately?
> >> 
> >> Yes, there is a better way.  For the initial power-up and final
> >> power-down sequences, don't rely on the PM core to invoke the
> >> callbacks.  Just call them directly, yourself.
> >> 
> >> For example, as part of the probe routine, instead of doing this:
> >> 	pm_runtime_set_suspended(dev);
> >> 	pm_runtime_enable(dev);
> >> 	pm_runtime_get_sync(dev);
> >> 
> >> Do this:
> >> 	pm_runtime_set_active(dev);
> >> 	pm_runtime_get_noresume(dev);
> >> 	pm_runtime_enable(dev);
> >> 	/*
> >> 	 * In case CONFIG_PM is disabled, invoke the runtime-resume
> >> 	 * callback directly.
> >> 	 */
> >> 	my_runtime_resume(dev);
> > 
> > Wouldn't it be cleaner for drivers not to have to handle this manually
> > (which gives an opportunity to get it wrong) but instead have
> > pm_runtime_enable() call the runtime resume callback when CONFIG_PM is
> > disabled ?
> 
> Well, I admit it would be nicer if drivers didn't have to worry about
> whether or not CONFIG_PM was enabled.  A slightly cleaner approach
> from the one outlined above would have the probe routine do this:
> 
> 	my_power_up(dev);
> 	pm_runtime_set_active(dev);
> 	pm_runtime_get_noresume(dev);
> 	pm_runtime_enable(dev);
> 
> and have the runtime-resume callback routine call my_power_up() to do
> its work.  (Or make my_power_up() actually be the runtime-resume
> callback routine.)  That's pretty straightforward and hard to mess up.

You'd be surprised how easy drivers can mess simple things up ;-) We'd still 
have to get the message out there, that would be the most difficult part.

> In theory, we could have pm_runtime_enable() invoke the runtime-resume
> callback when CONFIG_PM is disabled.  In practice, it would be rather
> awkward.  drivers/base/power/runtime.c, which is where
> pm_runtime_enable() is defined and the runtime-PM callbacks are
> invoked, doesn't even get compiled if CONFIG_PM is off.

Sure, but that can easily be fixed.

> (Also, it would run against the grain.  CONFIG_PM=n means the kernel
> ignores runtime PM, so pm_runtime_enable() shouldn't do anything.)

I'd argue that CONFIG_PM=n should mean that the runtime PM API doesn't perform 
runtime PM, not that it should do absolutely nothing. If semantics is the 
biggest concern, we could introduce a helper (whose name is TBD) that would 
enable runtime PM when CONFIG_PM=y or power on the device when CONFIG_PM=n

I want to make it as easy as possible for drivers to make sure they won't get 
this wrong, which in my opinion requires a simple and straightforward API with 
no code in the driver that would depend on the value of CONFIG_PM.

> There's a corollary aspect to this.  If you depend on runtime PM for
> powering up your device during probe, does that mean you also depend on
> runtime PM for powering down the device during remove?  That is likely
> not to work, because the user can prevent runtime suspends by writing
> to /sys/.../power/control.

Yes, I do, and I expect most runtime PM-enabled driver to do the same. When 
runtime suspend is disabled through /sys/.../power/control does 
pm_runtime_disable() invoke the runtime PM suspend handler if the device is 
powered on ?

-- 
Regards,

Laurent Pinchart

