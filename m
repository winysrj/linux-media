Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:44393 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1755219AbcKYPWP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 10:22:15 -0500
Date: Fri, 25 Nov 2016 10:21:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        <linux-media@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences
 without runtime PM
In-Reply-To: <20161125074838.GA16630@valkosipuli.retiisi.org.uk>
Message-ID: <Pine.LNX.4.44L0.1611251014130.1509-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Nov 2016, Sakari Ailus wrote:

> Hi Alan and others,
> 
> On Thu, Nov 24, 2016 at 09:15:39PM -0500, Alan Stern wrote:
> > On Fri, 25 Nov 2016, Laurent Pinchart wrote:
> > 
> > > Dear linux-pm developers, what's the suggested way to ensure that a runtime-
> > > pm-enabled driver can run fine on a system with CONFIG_PM disabled ?
> > 
> > The exact point of your question isn't entirely clear.  In the most 
> > literal sense, the best ways to ensure this are (1) audit the code, and 
> > (2) actually try it.
> > 
> > I have a feeling this doesn't quite answer your question, however.  :-)
> 
> The question is related to devices that require certain power-up and
> power-down sequences that are now implemented as PM runtime hooks that,
> without CONFIG_PM defined, will not be executed. Is there a better way than
> to handle this than have an implementation in the driver for the PM runtime
> and non-PM runtime case separately?

Yes, there is a better way.  For the initial power-up and final 
power-down sequences, don't rely on the PM core to invoke the 
callbacks.  Just call them directly, yourself.

For example, as part of the probe routine, instead of doing this:

	pm_runtime_set_suspended(dev);
	pm_runtime_enable(dev);
	pm_runtime_get_sync(dev);

Do this:

	pm_runtime_set_active(dev);
	pm_runtime_get_noresume(dev);
	pm_runtime_enable(dev);
	/*
	 * In case CONFIG_PM is disabled, invoke the runtime-resume 
	 * callback directly.
	 */
	my_runtime_resume(dev);

Alan Stern

