Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:33611 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751752AbdIAJFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 05:05:08 -0400
Date: Fri, 1 Sep 2017 12:04:35 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 4/5] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170901090434.5xyjz5ooswbx2kt2@paasikivi.fi.intel.com>
References: <20170829110313.19538-1-sakari.ailus@linux.intel.com>
 <2739432.dQ1BSg1MPy@avalon>
 <20170829143121.6sjdx3lgcoxm6mva@valkosipuli.retiisi.org.uk>
 <4764194.MvKE5XMHvq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4764194.MvKE5XMHvq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Sep 01, 2017 at 11:55:43AM +0300, Laurent Pinchart wrote:
...
> > >> +static int parse_endpoint(
> > >> +	struct device *dev, struct v4l2_async_notifier *notifier,
> > >> +	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
> > >> +	int (*parse_single)(struct device *dev,
> > >> +			    struct v4l2_fwnode_endpoint *vep,
> > >> +			    struct v4l2_async_subdev *asd))
> > >> +{
> > >> +	struct v4l2_async_subdev *asd;
> > >> +	struct v4l2_fwnode_endpoint *vep;
> > >> +	int ret = 0;
> > >> +
> > >> +	asd = kzalloc(asd_struct_size, GFP_KERNEL);
> > >> +	if (!asd)
> > >> +		return -ENOMEM;
> > >> +
> > >> +	asd->match.fwnode.fwnode =
> > >> +		fwnode_graph_get_remote_port_parent(endpoint);
> > >> +	if (!asd->match.fwnode.fwnode) {
> > >> +		dev_warn(dev, "bad remote port parent\n");
> > >> +		ret = -EINVAL;
> > >> +		goto out_err;
> > >> +	}
> > >> +
> > >> +	/* Ignore endpoints the parsing of which failed. */
> > > 
> > > You don't ignore them anymore, the comment should be updated.
> > 
> > Hmm. I actually intended to do something else about this. :-) As there's a
> > single error code, handling that would need to be done a little bit
> > differently right now.
> > 
> > I'd print a warning and proceed. What do you think?
> > 
> > Even if there's a bad DT endpoint, that shouldn't prevent the rest from
> > working, right?
> 
> I think it should, to make sure we catch DT issues. We both know how many 
> vendors don't care about warnings, so I'd rather fail completely to ensure DT 
> will be fixed (and even ten I wouldn't be surprised if some vendors patched 
> the code to remove the check instead of fixing their DT ;-)).

If they test the DTS, they should find out that the device does not work.

If they do not, some devices will work even if others fail.

Therefore I don't see why everything should fail when a part of faulty.
Extending that a little, you should also halt the system to make sure the
problem will be noticed. :-)

> > >> @@ -121,6 +122,21 @@ int v4l2_async_notifier_register(struct v4l2_device
> > >> *v4l2_dev, void v4l2_async_notifier_unregister(struct
> > >> v4l2_async_notifier *notifier);
> > >> 
> > >>  /**
> > >> + * v4l2_async_notifier_release - release notifier resources
> > >> + * @notifier: pointer to &struct v4l2_async_notifier
> > > 
> > > That's quite obvious given the type of the argument. It would be much more
> > > useful to tell which notifier pointer this function expects (although in
> > > this case it should be obvious too): "(pointer to )?the notifier whose
> > > resources will be released".
> > 
> > This fully matches to the documentation elsewhere in the same file. :-)
> 
> Feel free to fix the rest of the file :-)

That's out of scope of this patch.

> > > "The function can be called multiple times to populate the same notifier
> > > from endpoints of different @dev devices before registering the notifier.
> > > It can't be called anymore once the notifier has been registered."
> > 
> > I don't think there's really a use case for calling this for more than one
> > device, is there?
> 
> I don't have one in mind, but I was wondering. If there isn't then you don't 
> need notifier_realloc(), which could be moved to the next patch.

I don't think there's even benefit from moving it to the next patch, it
just adds to the reviewable code, nothing else.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
