Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6165 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbeIMRyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 13:54:17 -0400
Date: Thu, 13 Sep 2018 15:44:25 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 06/17] media: v4l2-fwnode: Add a convenience function
 for registering subdevs with notifiers
Message-ID: <20180913124425.h5vfjyr3b44j4nxv@paasikivi.fi.intel.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-7-git-send-email-steve_longerbeam@mentor.com>
 <20180913103727.GB28160@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180913103727.GB28160@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Sep 13, 2018 at 12:37:27PM +0200, jacopo mondi wrote:
> Hi Steve,
> 
> On Mon, Jul 09, 2018 at 03:39:06PM -0700, Steve Longerbeam wrote:
> > Adds v4l2_async_register_fwnode_subdev(), which is a convenience function
> > for parsing a sub-device's fwnode port endpoints for connected remote
> > sub-devices, registering a sub-device notifier, and then registering
> > the sub-device itself.
> >
> > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> > ---
> > Changes since v5:
> > - add call to v4l2_async_notifier_init().
> > Changes since v4:
> > - none
> > Changes since v3:
> > - remove support for port sub-devices, such sub-devices will have to
> >   role their own.
> > Changes since v2:
> > - fix error-out path in v4l2_async_register_fwnode_subdev() that forgot
> >   to put device.
> > Changes since v1:
> > - add #include <media/v4l2-subdev.h> to v4l2-fwnode.h for
> >   'struct v4l2_subdev' declaration.
> > ---
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 64 +++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-fwnode.h           | 38 +++++++++++++++++++++
> >  2 files changed, 102 insertions(+)
> >
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> > index 67ad333..94d867a 100644
> > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > @@ -872,6 +872,70 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
> >
> > +int v4l2_async_register_fwnode_subdev(
> 
> The meat of this function is to register a subdev with a notifier,
> so I would make it clear in the function name which is otherwise
> misleading
> 
> > +	struct v4l2_subdev *sd, size_t asd_struct_size,
> > +	unsigned int *ports, unsigned int num_ports,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			      struct v4l2_fwnode_endpoint *vep,
> > +			      struct v4l2_async_subdev *asd))
> > +{
> > +	struct v4l2_async_notifier *notifier;
> > +	struct device *dev = sd->dev;
> > +	struct fwnode_handle *fwnode;
> > +	int ret;
> > +
> > +	if (WARN_ON(!dev))
> > +		return -ENODEV;
> > +
> > +	fwnode = dev_fwnode(dev);
> > +	if (!fwnode_device_is_available(fwnode))
> > +		return -ENODEV;
> > +
> > +	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
> > +	if (!notifier)
> > +		return -ENOMEM;
> > +
> > +	v4l2_async_notifier_init(notifier);
> > +
> > +	if (!ports) {
> > +		ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > +			dev, notifier, asd_struct_size, parse_endpoint);
> > +		if (ret < 0)
> > +			goto out_cleanup;
> > +	} else {
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < num_ports; i++) {
> 
> It's not particularly exciting to iterate on pointers received from
> callers without checking for num_ports first.

The loop is not executed if num_ports is zero, so I don't see a problem
with that.

> 
> Also the caller has to allocate an array of "ports" and keep track of it
> just to pass it to this function and I don't see a way to set the
> notifier's ops before the notifier gets registered here below.

True; this can be seen as an omission but quite a few drivers have no need
for this either. It could be added later on --- I think it'd make perfect
sense.

> 
> > +			ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> > +				dev, notifier, asd_struct_size,
> > +				ports[i], parse_endpoint);
> > +			if (ret < 0)
> > +				goto out_cleanup;
> > +		}
> > +	}
> > +
> > +	ret = v4l2_async_subdev_notifier_register(sd, notifier);
> > +	if (ret < 0)
> > +		goto out_cleanup;
> > +
> > +	ret = v4l2_async_register_subdev(sd);
> > +	if (ret < 0)
> > +		goto out_unregister;
> > +
> > +	sd->subdev_notifier = notifier;
> 
> This is set already by v4l2_async_subdev_notifier_register()

The same pattern is actually present in
v4l2_async_register_subdev_sensor_common(). It's used in unregistration
that can only happen after the registration, i.e. this function, has
completed.

> 
> In general, I have doubts this function is really needed. It requires
> the caller to reserve memory just to pass down a list of intergers,
> and there is no way to set subdev ops.
> 
> Could you have a look at how drivers/media/platform/rcar-vin/rcar-csi2.c
> registers a subdevice and an associated notifier and see if in your
> opinion it can be implemented in the same way in your imx csi/csi2 driver,
> or you still like this one most?

I was actually thinking of changing this later on a bit. I came to think of
this after picking up the patchset to my tree... oh well.

This function is meant for cases where you have multiple ports. That's not
working very nicely at the moment, and even with my patches, you can't pass
default configuration to e.g. v4l2_async_notifier_parse_fwnode_endpoints().
So there's definitely work to do. I'd like to move the details of parsing
out of drivers; every driver is doing almost the same but just in a little
bit different way.

The arguments should to be put into a struct. That way we get rid of a very
long series of hard-to-read function arguments, as well as we don't need to
change every caller when the function gets something new and interesting to
do.

Right now the entire patchset is so big (40 patches) that I'd prefer to get
it in unless serious issues are found, and proceed the development on top.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
