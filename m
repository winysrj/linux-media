Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42260 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755797AbcKYTed (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 14:34:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Fri, 25 Nov 2016 21:34:56 +0200
Message-ID: <3007760.0ebxS8fqmr@avalon>
In-Reply-To: <Pine.LNX.4.44L0.1611251014130.1509-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1611251014130.1509-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Friday 25 Nov 2016 10:21:21 Alan Stern wrote:
> On Fri, 25 Nov 2016, Sakari Ailus wrote:
> > On Thu, Nov 24, 2016 at 09:15:39PM -0500, Alan Stern wrote:
> >> On Fri, 25 Nov 2016, Laurent Pinchart wrote:
> >>> Dear linux-pm developers, what's the suggested way to ensure that a
> >>> runtime- pm-enabled driver can run fine on a system with CONFIG_PM
> >>> disabled ?
> >>
> >> The exact point of your question isn't entirely clear.  In the most
> >> literal sense, the best ways to ensure this are (1) audit the code, and
> >> (2) actually try it.
> >> 
> >> I have a feeling this doesn't quite answer your question, however.  :-)
> > 
> > The question is related to devices that require certain power-up and
> > power-down sequences that are now implemented as PM runtime hooks that,
> > without CONFIG_PM defined, will not be executed. Is there a better way
> > than to handle this than have an implementation in the driver for the PM
> > runtime and non-PM runtime case separately?
> 
> Yes, there is a better way.  For the initial power-up and final
> power-down sequences, don't rely on the PM core to invoke the
> callbacks.  Just call them directly, yourself.
> 
> For example, as part of the probe routine, instead of doing this:
> 
> 	pm_runtime_set_suspended(dev);
> 	pm_runtime_enable(dev);
> 	pm_runtime_get_sync(dev);
> 
> Do this:
> 
> 	pm_runtime_set_active(dev);
> 	pm_runtime_get_noresume(dev);
> 	pm_runtime_enable(dev);
> 	/*
> 	 * In case CONFIG_PM is disabled, invoke the runtime-resume
> 	 * callback directly.
> 	 */
> 	my_runtime_resume(dev);

Wouldn't it be cleaner for drivers not to have to handle this manually (which 
gives an opportunity to get it wrong) but instead have pm_runtime_enable() 
call the runtime resume callback when CONFIG_PM is disabled ?

-- 
Regards,

Laurent Pinchart

