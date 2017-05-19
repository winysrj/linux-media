Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33186 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbdESOl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 10:41:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kbingham@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        John Youn <johnyoun@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/3] device property: Add fwnode_graph_get_port_parent
Date: Fri, 19 May 2017 17:42:07 +0300
Message-ID: <11266116.VtDrNngWRY@avalon>
In-Reply-To: <1d82a0b2-61e7-656c-7df5-17fcb599aa76@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com> <2150794.GUKVLPLrWM@avalon> <1d82a0b2-61e7-656c-7df5-17fcb599aa76@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Friday 19 May 2017 14:34:33 Kieran Bingham wrote:
> On 18/05/17 14:36, Laurent Pinchart wrote:
> > On Wednesday 17 May 2017 16:03:38 Kieran Bingham wrote:
> >> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> 
> >> V4L2 async notifiers can pass the endpoint fwnode rather than the device
> >> fwnode.
> > 
> > I'm not sure I would mention V4L2 in the commit message, as this is
> > generic.
>
> Good point
> 
> >> Provide a helper to obtain the parent device fwnode without first
> >> parsing the remote-endpoint as per fwnode_graph_get_remote_port_parent.
> >> 
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> ---
> >> 
> >>  drivers/base/property.c  | 25 +++++++++++++++++++++++++
> >>  include/linux/property.h |  2 ++
> >>  2 files changed, 27 insertions(+)
> >> 
> >> diff --git a/drivers/base/property.c b/drivers/base/property.c
> >> index 627ebc9b570d..caf4316fe565 100644
> >> --- a/drivers/base/property.c
> >> +++ b/drivers/base/property.c
> >> @@ -1245,6 +1245,31 @@ fwnode_graph_get_next_endpoint(struct
> >> fwnode_handle
> >> *fwnode, EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
> >> 
> >>  /**
> >> 
> >> + * fwnode_graph_get_port_parent - Return device node of a port endpoint
> >> + * @fwnode: Endpoint firmware node pointing of the port
> >> + *
> >> + * Extracts firmware node of the device the @fwnode belongs to.
> > 
> > I'm not too familiar with the fwnode API, but I know it's written in C,
> > where functions don't extract something but return a value :-) How about
> > 
> > Return: the firmware node of the device the @endpoint belongs to.
> 
> I'm not averse to the reword - but it is different to the other functions in
> the same context:
> 
> fwnode_graph_get_remote_endpoint(struct fwnode_handle *fwnode)
>  * Extracts firmware node of a remote endpoint the @fwnode points to.
> 
> struct fwnode_handle *fwnode_graph_get_remote_port(struct fwnode_handle
> *fwnode)
>  * Extracts firmware node of a remote port the @fwnode points to.
> 
> fwnode_graph_get_remote_port_parent(struct fwnode_handle *fwnode)
>  * Extracts firmware node of a remote device the @fwnode points to.
> 
> Then with this function becoming:
> 
> fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
>  * Returns firmware node of the device the @endpoint belongs to.
> 
> 
> I guess those could be changed too ...

My point is that the kerneldoc format documents return values with a "Return:" 
tag. The documentation for the function can still provide extra information.

> >> + */
> >> +struct fwnode_handle *
> >> +fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
> > 
> > This is akin to writing (unsigned int integer)
> 
> Yes, good point there - I was thinking of the fwnode as an object itself,
> but really it's representing the endpoint, and the fwnode is the class type
> :)
>
> > How about calling the variable endpoint ? That would also make the
> > documentation clearer in my opinion, with "the @fwnode belongs to"
> > replaced with "the @endpoint belongs to".
> 
> Agreed
> 
> >> +{
> >> +	struct fwnode_handle *parent = NULL;
> >> +
> >> +	if (is_of_node(fwnode)) {
> >> +		struct device_node *node;
> >> +
> >> +		node = of_graph_get_port_parent(to_of_node(fwnode));
> >> +		if (node)
> >> +			parent = &node->fwnode;
> > 
> > This part looks good to me, with the above small change,
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Thanks,
> 
> I'll add this if the code doesn't change drastically based on Sakari's
> suggestion.
>
> >> +	} else if (is_acpi_node(fwnode)) {
> >> +		parent = acpi_node_get_parent(fwnode);
> > 
> > I can't comment on this one though.
> > 
> >> +	}
> >> +
> >> +	return parent;
> >> +}
> >> +EXPORT_SYMBOL_GPL(fwnode_graph_get_port_parent);
> >> +
> >> +/**
> >> 
> >>   * fwnode_graph_get_remote_port_parent - Return fwnode of a remote
> >>   device
> >>   * @fwnode: Endpoint firmware node pointing to the remote endpoint
> >>   *
> >> 
> >> diff --git a/include/linux/property.h b/include/linux/property.h
> >> index 2f482616a2f2..624129b86c82 100644
> >> --- a/include/linux/property.h
> >> +++ b/include/linux/property.h
> >> @@ -274,6 +274,8 @@ void *device_get_mac_address(struct device *dev, char
> >> *addr, int alen);
> >> 
> >>  struct fwnode_handle *fwnode_graph_get_next_endpoint(
> >>  
> >>  	struct fwnode_handle *fwnode, struct fwnode_handle *prev);
> >> 
> >> +struct fwnode_handle *fwnode_graph_get_port_parent(
> >> +	struct fwnode_handle *fwnode);
> >> 
> >>  struct fwnode_handle *fwnode_graph_get_remote_port_parent(
> >>  
> >>  	struct fwnode_handle *fwnode);
> >>  
> >>  struct fwnode_handle *fwnode_graph_get_remote_port(

-- 
Regards,

Laurent Pinchart
