Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753968AbdIDUak (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 16:30:40 -0400
Date: Mon, 4 Sep 2017 23:30:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v7 04/18] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170904203036.aeyz335w7eypxj4m@valkosipuli.retiisi.org.uk>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-5-sakari.ailus@linux.intel.com>
 <e07f9b4d-e8dc-5598-98ee-3c69e3100b81@xs4all.nl>
 <20170904155415.nak4dofd2k6ytupa@valkosipuli.retiisi.org.uk>
 <cad608c6-93b6-d791-a14a-a5b38fe6e1bf@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cad608c6-93b6-d791-a14a-a5b38fe6e1bf@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 04, 2017 at 07:37:09PM +0200, Hans Verkuil wrote:
> On 09/04/2017 05:54 PM, Sakari Ailus wrote:
> >>> +/**
> >>> + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints in a
> >>> + *						device node
> >>> + * @dev: the device the endpoints of which are to be parsed
> >>> + * @notifier: notifier for @dev
> >>> + * @asd_struct_size: size of the driver's async sub-device struct, including
> >>> + *		     sizeof(struct v4l2_async_subdev). The &struct
> >>> + *		     v4l2_async_subdev shall be the first member of
> >>> + *		     the driver's async sub-device struct, i.e. both
> >>> + *		     begin at the same memory address.
> >>> + * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
> >>> + *		    endpoint. Optional.
> >>> + *		    Return: %0 on success
> >>> + *			    %-ENOTCONN if the endpoint is to be skipped but this
> >>> + *				       should not be considered as an error
> >>> + *			    %-EINVAL if the endpoint configuration is invalid
> >>> + *
> >>> + * Parse the fwnode endpoints of the @dev device and populate the async sub-
> >>> + * devices array of the notifier. The @parse_endpoint callback function is
> >>> + * called for each endpoint with the corresponding async sub-device pointer to
> >>> + * let the caller initialize the driver-specific part of the async sub-device
> >>> + * structure.
> >>> + *
> >>> + * The notifier memory shall be zeroed before this function is called on the
> >>> + * notifier.
> >>> + *
> >>> + * This function may not be called on a registered notifier and may be called on
> >>> + * a notifier only once. When using this function, the user may not access the
> >>> + * notifier's subdevs array nor change notifier's num_subdevs field, these are
> >>> + * reserved for the framework's internal use only.
> >>
> >> I don't think the sentence "When using...only" makes any sense. How would you
> >> even be able to access any of the notifier fields? You don't have access to it
> >> from the parse_endpoint callback.
> > 
> > Not from the parse_endpoint callback. The notifier is first set up by the
> > driver, and this text applies to that --- whether or not parse_endpoint is
> > given.
> 
> What you mean is "After calling this function..." since v4l2_async_notifier_release()
> needs this to release all the memory.

Right, that's a good point.

notifier->subdevs may be allocated by the driver as well, so
v4l2_async_notifier_release() must take that into account.
notifier->max_subdevs should be good for that.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
