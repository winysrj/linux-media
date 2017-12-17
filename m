Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:42194 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbdLQQnA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 11:43:00 -0500
Date: Sun, 17 Dec 2017 17:42:54 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] v4l2: async: Add debug output to v4l2-async module
Message-ID: <20171217164254.GF20926@w540>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
 <1513189580-32202-6-git-send-email-jacopo+renesas@jmondi.org>
 <20171215161704.lnsaut4d2nxliaca@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171215161704.lnsaut4d2nxliaca@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Fri, Dec 15, 2017 at 06:17:04PM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
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

So you suggest to just use the full node name for OF. What about ACPI?

>From your other reply I got that I can print the single node name for
"device ACPI nodes" but not for "non-device ACPI nodes". Should I build
the full device name in drivers/acpi/properties.c for ACPI devices
like I'm doing here for fwnodes?

>
> > ---
> >
> >  drivers/media/v4l2-core/Kconfig      |  8 ++++
> >  drivers/media/v4l2-core/v4l2-async.c | 81 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 89 insertions(+)
> >
> > diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> > index a35c336..8331736 100644
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

So I will use a symbol defined in the module to enable/disable debug
(maybe the "DEBUG" symbol itself?)

>
> > +	default n
> > +	---help---
> > +	  Say Y here to enable debug output in V4L2 async module.
> > +	  In doubt, say N.
> > +
> >  config VIDEO_FIXED_MINOR_RANGES
> >  	bool "Enable old-style fixed minor ranges on drivers/video devices"
> >  	default n
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index c13a781..307e1a5 100644
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

No dev_dbg() otherwise, isn't it?

>
> > +#endif
> > +
> >  #include <linux/device.h>
> >  #include <linux/err.h>
> >  #include <linux/i2c.h>
> > @@ -25,6 +29,52 @@
> >  #include <media/v4l2-fwnode.h>
> >  #include <media/v4l2-subdev.h>
> >
> > +#if defined(CONFIG_VIDEO_V4L2_ASYNC_DEBUG)
> > +#define V4L2_ASYNC_FWNODE_NAME_LEN	512
> > +
> > +static void __v4l2_async_fwnode_full_name(char *name,
> > +					  unsigned int len,
> > +					  unsigned int max_depth,
> > +					  struct fwnode_handle *fwnode)
> > +{
> > +	unsigned int buf_len = len < V4L2_ASYNC_FWNODE_NAME_LEN ?
> > +			       len : V4L2_ASYNC_FWNODE_NAME_LEN;
> > +	char __tmp[V4L2_ASYNC_FWNODE_NAME_LEN];
>
> That's a bit too much to allocate from the stack I think.

For an full name do you think 128 is enough? 256 maybe?

Thanks
  j
