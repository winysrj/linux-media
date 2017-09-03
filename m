Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46250 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751030AbdICHnm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 03:43:42 -0400
Date: Sun, 3 Sep 2017 10:43:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 5/5] v4l: fwnode: Support generic parsing of graph
 endpoints in a single port
Message-ID: <20170903074339.vswbczv2lfxykssq@valkosipuli.retiisi.org.uk>
References: <20170830114946.17743-1-sakari.ailus@linux.intel.com>
 <95945222-3562-a330-609f-ad1a64034dd3@xs4all.nl>
 <20170901225748.ygk35gzmt6vrtetw@valkosipuli.retiisi.org.uk>
 <1981884.TcuAFemERJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1981884.TcuAFemERJ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Sep 02, 2017 at 12:52:47PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Saturday, 2 September 2017 01:57:48 EEST Sakari Ailus wrote:
> > On Fri, Sep 01, 2017 at 01:28:40PM +0200, Hans Verkuil wrote:
> > >> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > >> index d063ab4ff67b..dd13604178b4 100644
> > >> --- a/include/media/v4l2-fwnode.h
> > >> +++ b/include/media/v4l2-fwnode.h
> > >> @@ -249,4 +249,53 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
> > >>  			    struct v4l2_fwnode_endpoint *vep,
> > >>  			    struct v4l2_async_subdev *asd));
> > >> 
> > >> +/**
> > >> + * v4l2_async_notifier_parse_fwnode_endpoint - Set up async notifier
> > >> for an
> > >> + *					       fwnode based sub-device
> > >> + * @dev: @struct device pointer
> > >> + * @notifier: pointer to &struct v4l2_async_notifier
> > >> + * @port_id: port number
> > >> + * @endpoint_id: endpoint number
> > >> + * @asd_struct_size: size of the driver's async sub-device struct,
> > >> including
> > >> + *		     sizeof(struct v4l2_async_subdev). The &struct
> > >> + *		     v4l2_async_subdev shall be the first member of
> > >> + *		     the driver's async sub-device struct, i.e. both
> > >> + *		     begin at the same memory address.
> > >> + * @parse_single: driver's callback function called on each V4L2 fwnode
> > >> endpoint
> > >> + *
> > >> + * Parse the fwnode endpoint of the @dev device corresponding to the
> > >> given port
> > >> + * and endpoint numbres and populate the async sub- devices array of
> > >> the
> > > 
> > > numbers
> > > no space after sub-
> > > 
> > > > + * notifier. The @parse_endpoint callback function is called for the
> > > > endpoint
> > > 
> > > parse_single, but (as in the previous patch) I actually prefer
> > > parse_endpoint.
> > > 
> > >> + * with the corresponding async sub-device pointer to let the caller
> > >> initialize
> > >> + * the driver-specific part of the async sub-device structure.
> > >> + *
> > >> + * The notifier memory shall be zeroed before this function is called
> > >> on the
> > >> + * notifier.
> > > 
> > > Should it? Doesn't this add additional subdevs?
> > > 
> > > I'm lost. What's the relationship between
> > > v4l2_async_notifier_parse_fwnode_endpoints and this function? When do you
> > > use which? When you should zero the notifier?
> > I thought there would be advantages in this approach as it lets you to
> > choose which endpoints specifically you want to parse. That said, the
> > expectation is that the device has no endpoints that aren't supported in
> > hardware either.
> > 
> > Some drivers currently iterate over all the endpoints and then validate
> > them whereas others poke for some endpoints only (port 0, endpoint 0, for
> > the rcar-vin driver, for instance). In DT binding documentation the
> > endpoint numbers are currently not specified nor drivers have checked them.
> > Common sense tells to use zero if there's no reason to do otherwise, but
> > still this hasn't been documented nor validated in the past. So if we add
> > that now, there could be a chance of breaking something.
> > 
> > Additionally, specifying the endpoints to parse explicitly has been seen
> > beneficial (or even necessary) in parsing endpoints for devices that have
> > both input and output interfaces. Perhaps Niklas can comment on that.
> > 
> > What I though was to introduce a specific error code (EPERM, better
> > suggestions are taken)
> 
> Maybe ENOTCONN ?

Sounds good to me.

> 
> > for the driver callback function (parse_endpoint) to silently skip endpoints
> > the driver doesn't like for reason or another. This lets drivers to use the
> > endpoint parser function added by the previous patch and still maintain the
> > old behaviour, i.e. ignore endpoints that aren't explicitly recognised by
> > the driver.
> > 
> > I'll drop this patch from the next version.
> 
> Parsing a specific endpoint of a specific port is probably indeed a bit too 
> fine-grained, but I think there are use cases for parsing at the port level 
> instead of parsing all ports.

Could you elaborate?

If a driver would be interested in skipping endpoints in a subset of ports,
in which case only a single port would be excluded from this?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
