Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1635 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751237AbdISLiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:38:00 -0400
Date: Tue, 19 Sep 2017 14:37:55 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 05/25] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170919113754.k4ff6un5pw3nk2sa@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170919082015.vt6olgirnvmpcrpa@paasikivi.fi.intel.com>
 <af99e12c-6fb8-a633-eec2-c1eb9d82226a@xs4all.nl>
 <2061043.HYj1Sta8zM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2061043.HYj1Sta8zM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 12:30:34PM +0300, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday, 19 September 2017 11:40:14 EEST Hans Verkuil wrote:
> > On 09/19/2017 10:20 AM, Sakari Ailus wrote:
> > > On Tue, Sep 19, 2017 at 10:03:27AM +0200, Hans Verkuil wrote:
> > >> On 09/15/2017 04:17 PM, Sakari Ailus wrote:
> > >>> Add two functions for parsing devices graph endpoints:
> > >>> v4l2_async_notifier_parse_fwnode_endpoints and
> > >>> v4l2_async_notifier_parse_fwnode_endpoints_by_port. The former iterates
> > >>> over all endpoints whereas the latter only iterates over the endpoints
> > >>> in a given port.
> > >>> 
> > >>> The former is mostly useful for existing drivers that currently
> > >>> implement the iteration over all the endpoints themselves whereas the
> > >>> latter is especially intended for devices with both sinks and sources:
> > >>> async sub-devices for external devices connected to the device's sources
> > >>> will have already been set up, or they are part of the master device.
> > >>> 
> > >>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >>> ---
> > >>> 
> > >>>  drivers/media/v4l2-core/v4l2-async.c  |  30 ++++++
> > >>>  drivers/media/v4l2-core/v4l2-fwnode.c | 185 +++++++++++++++++++++++++++
> > >>>  include/media/v4l2-async.h            |  24 ++++-
> > >>>  include/media/v4l2-fwnode.h           | 117 +++++++++++++++++++++
> > >>>  4 files changed, 354 insertions(+), 2 deletions(-)
> 
> [snip]
> 
> > >>> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > >>> index 68eb22ba571b..83afac48ea6b 100644
> > >>> --- a/include/media/v4l2-fwnode.h
> > >>> +++ b/include/media/v4l2-fwnode.h
> > >>> @@ -25,6 +25,8 @@
> > >>> 
> > >>>  #include <media/v4l2-mediabus.h>
> > >>>  
> > >>>  struct fwnode_handle;
> > >>> +struct v4l2_async_notifier;
> > >>> +struct v4l2_async_subdev;
> > >>> 
> > >>>  #define V4L2_FWNODE_CSI2_MAX_DATA_LANES	4
> > >>> 
> > >>> @@ -201,4 +203,119 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> > >>> *fwnode,
> > >>>   */
> > >>>  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> > >>> 
> > >>> +/**
> > >>> + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode
> > >>> endpoints in a
> > >>> + *						device node
> > >>> + * @dev: the device the endpoints of which are to be parsed
> > >>> + * @notifier: notifier for @dev
> > >>> + * @asd_struct_size: size of the driver's async sub-device struct,
> > >>> including
> > >>> + *		     sizeof(struct v4l2_async_subdev). The &struct
> > >>> + *		     v4l2_async_subdev shall be the first member of
> > >>> + *		     the driver's async sub-device struct, i.e. both
> > >>> + *		     begin at the same memory address.
> > >>> + * @parse_endpoint: Driver's callback function called on each V4L2
> > >>> fwnode
> > >>> + *		    endpoint. Optional.
> > >>> + *		    Return: %0 on success
> > >>> + *			    %-ENOTCONN if the endpoint is to be skipped but this
> > >>> + *				       should not be considered as an error
> > >>> + *			    %-EINVAL if the endpoint configuration is invalid
> > >>> + *
> > >>> + * Parse the fwnode endpoints of the @dev device and populate the async
> > >>> sub-
> > >>> + * devices array of the notifier. The @parse_endpoint callback function
> > >>> is
> > >>> + * called for each endpoint with the corresponding async sub-device
> > >>> pointer to
> > >>> + * let the caller initialize the driver-specific part of the async sub-
> > >>> device
> > >>> + * structure.
> > >>> + *
> > >>> + * The notifier memory shall be zeroed before this function is called
> > >>> on the
> > >>> + * notifier.
> > >>> + *
> > >>> + * This function may not be called on a registered notifier and may be
> > >>> called on
> > >>> + * a notifier only once.
> > >>> + *
> > >>> + * Do not change the notifier's subdevs array, take references to the
> > >>> subdevs
> > >>> + * array itself or change the notifier's num_subdevs field. This is
> > >>> because this
> > >>> + * function allocates and reallocates the subdevs array based on
> > >>> parsing
> > >>> + * endpoints.
> > >>> + *
> > >>> + * The @struct v4l2_fwnode_endpoint passed to the callback function
> > >>> + * @parse_endpoint is released once the function is finished. If there
> > >>> is a need
> > >>> + * to retain that configuration, the user needs to allocate memory for
> > >>> it.
> > >>> + *
> > >>> + * Any notifier populated using this function must be released with a
> > >>> call to
> > >>> + * v4l2_async_notifier_release() after it has been unregistered and the
> > >>> async
> > >>> + * sub-devices are no longer in use, even if the function returned an
> > >>> error.
> > >>> + *
> > >>> + * Return: %0 on success, including when no async sub-devices are found
> > >>> + *	   %-ENOMEM if memory allocation failed
> > >>> + *	   %-EINVAL if graph or endpoint parsing failed
> > >>> + *	   Other error codes as returned by @parse_endpoint
> > >>> + */
> > >>> +int v4l2_async_notifier_parse_fwnode_endpoints(
> > >>> +	struct device *dev, struct v4l2_async_notifier *notifier,
> > >>> +	size_t asd_struct_size,
> > >>> +	int (*parse_endpoint)(struct device *dev,
> > >>> +			      struct v4l2_fwnode_endpoint *vep,
> > >>> +			      struct v4l2_async_subdev *asd));
> > >>> +
> > >>> +/**
> > >>> + * v4l2_async_notifier_parse_fwnode_endpoints_by_port - Parse V4L2
> > >>> fwnode
> > >>> + *							endpoints of a port in a
> > >>> + *							device node
> > >>> + * @dev: the device the endpoints of which are to be parsed
> > >>> + * @notifier: notifier for @dev
> > >>> + * @asd_struct_size: size of the driver's async sub-device struct,
> > >>> including
> > >>> + *		     sizeof(struct v4l2_async_subdev). The &struct
> > >>> + *		     v4l2_async_subdev shall be the first member of
> > >>> + *		     the driver's async sub-device struct, i.e. both
> > >>> + *		     begin at the same memory address.
> > >>> + * @port: port number where endpoints are to be parsed
> > >>> + * @parse_endpoint: Driver's callback function called on each V4L2
> > >>> fwnode
> > >>> + *		    endpoint. Optional.
> > >>> + *		    Return: %0 on success
> > >>> + *			    %-ENOTCONN if the endpoint is to be skipped but this
> > >>> + *				       should not be considered as an error
> > >>> + *			    %-EINVAL if the endpoint configuration is invalid
> > >>> + *
> > >>> + * This function is just like
> > >>> @v4l2_async_notifier_parse_fwnode_endpoints with 
> > >>> + * the exception that it only parses endpoints in a given port. This is
> > >>> useful
> > >>> + * on devices that have both sinks and sources: the async sub-devices
> > >>> connected
> > >> 
> > >> on -> for
> > >> 
> > >>> + * to sources have already been set up by another driver (on capture
> > >>> devices).
> > >> 
> > >> on -> for
> > > 
> > > Agreed on both.
> > > 
> > >> So if I understand this correctly for devices with both sinks and sources
> > >> you use this function to just parse the sink ports. And you have to give
> > >> explicit port numbers since you can't tell from parsing the device tree
> > >> if a port is a sink or source port, right? Only the driver knows this.
> > > 
> > > Correct. The graph data structure in DT isn't directed, so this is only
> > > known by the driver.
> > 
> > I think this should be clarified.
> > 
> > I wonder if there is any way around it. I don't have time to dig into this,
> > but isn't it possible to tell that the source ports are already configured?
> 
> Please also note that it's not always source ports, it depends in which 
> direction we want to traverse the graph. The usual way is from master to 
> slave, so from source to sink for capture devices but from sink to source for 
> output devices.
> 
> It's a bit of a mess, and this is part of the reason why I don't think sub-
> notifiers are the best idea. It would be better in my opinion to maintain a 
> single list of async matches, which would be gradually enriched by subdevices 
> as they are probed. This would help detecting and handling duplicates.

Well, there are indeed corner cases looming ahead where a driver might not
have enough information on what to parse and what not to. What I'd still do
is to proceed with what likely addresses more than 95 % of the cases
imaginable, and all we have today.

In the future setting up async sub-devices and parsing endpoints need to be
separated. With that, drivers won't need to know anymore which ports to
parse and which ones not. Creating links to the newly V4L2 async registered
sub-devices could be added to this. This will be more complicated than just
expressing an idea though. :-)

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
