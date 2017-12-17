Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51841 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757336AbdLQRGp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 12:06:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] v4l2: async: Add debug output to v4l2-async module
Date: Sun, 17 Dec 2017 19:06:53 +0200
Message-ID: <1992887.AuUDQKKNvA@avalon>
In-Reply-To: <20171215161704.lnsaut4d2nxliaca@paasikivi.fi.intel.com>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org> <1513189580-32202-6-git-send-email-jacopo+renesas@jmondi.org> <20171215161704.lnsaut4d2nxliaca@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, 15 December 2017 18:17:04 EET Sakari Ailus wrote:
> On Wed, Dec 13, 2017 at 07:26:20PM +0100, Jacopo Mondi wrote:
> > The v4l2-async module operations are quite complex to follow, due to the
> > asynchronous nature of subdevices and notifiers registration and
> > matching procedures. In order to help with debugging of failed or
> > erroneous matching between a subdevice and the notifier collected
> > async_subdevice it gets matched against, introduce a few dev_dbg() calls
> > in v4l2_async core operations.
> > 
> > Protect the debug operations with a Kconfig defined symbol, to make sure
> > when debugging is disabled, no additional code or data is added to the
> > module.
> > 
> > Notifiers are identified by the name of the subdevice or v4l2_dev they are
> > registered by, while subdevice matching which now happens on endpoints,
> > need a longer description built walking the fwnode graph backwards
> > collecting parent nodes names (otherwise we would have had printouts
> > like: "Matching "endpoint" with "endpoint"" which are not that useful).
> > 
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > 
> > ---
> > For fwnodes backed by OF, I may have used the "%pOF" format modifier to
> > get the full node name instead of parsing the fwnode graph by myself with
> > "v4l2_async_fwnode_full_name()". Unfortunately I'm not aware of anything
> > like "%pOF" for ACPI backed fwnodes. Also, walking the fwnode graph by
> > myself allows me to reduce the depth, to reduce the debug messages output
> > length which is anyway long enough to result disturbing on a 80columns
> > terminal window.
> 
> ACPI doesn't have such at the moment. I think printing the full path would
> still be better. There isn't that much more to print after all.
> 
> > ---
> > 
> >  drivers/media/v4l2-core/Kconfig      |  8 ++++
> >  drivers/media/v4l2-core/v4l2-async.c | 81 +++++++++++++++++++++++++++++++
> >  2 files changed, 89 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/Kconfig
> > b/drivers/media/v4l2-core/Kconfig index a35c336..8331736 100644
> > --- a/drivers/media/v4l2-core/Kconfig
> > +++ b/drivers/media/v4l2-core/Kconfig
> > @@ -17,6 +17,14 @@ config VIDEO_ADV_DEBUG
> >  	  V4L devices.
> >  	  In doubt, say N.
> > 
> > +config VIDEO_V4L2_ASYNC_DEBUG
> > +	bool "Enable debug functionalities for V4L2 async module"
> > +	depends on VIDEO_V4L2
> 
> I'm not sure I'd add a Kconfig option. This is adding a fairly simple
> function only to the kernel.
> 
> > +	default n
> > +	---help---
> > +	  Say Y here to enable debug output in V4L2 async module.
> > +	  In doubt, say N.
> > +
> >  config VIDEO_FIXED_MINOR_RANGES
> >  	bool "Enable old-style fixed minor ranges on drivers/video devices"
> >  	default n
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index c13a781..307e1a5 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -8,6 +8,10 @@
> >   * published by the Free Software Foundation.
> >   */
> > 
> > +#if defined(CONFIG_VIDEO_V4L2_ASYNC_DEBUG)
> > +#define DEBUG
> 
> Do you need this?

No this isn't needed. Debugging can be enabled through dynamic debug without 
requiring the Kconfig option. A Kconfig option might be useful to avoid 
compiling the debug code in kernels that have dynamic debug enabled, but those 
are large already and the amount of debug code here is limited, so I don't 
think it's worth it.

> > +#endif
> > +
> > 
> >  #include <linux/device.h>
> >  #include <linux/err.h>
> >  #include <linux/i2c.h>

[snip]

-- 
Regards,

Laurent Pinchart
