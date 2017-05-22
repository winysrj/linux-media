Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46390 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752117AbdEVGSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 02:18:31 -0400
Date: Mon, 22 May 2017 09:18:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kieran.bingham@ideasonboard.com,
        Kieran Bingham <kbingham@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        John Youn <johnyoun@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/3] device property: Add fwnode_graph_get_port_parent
Message-ID: <20170522061818.GF3227@valkosipuli.retiisi.org.uk>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2150794.GUKVLPLrWM@avalon>
 <1d82a0b2-61e7-656c-7df5-17fcb599aa76@ideasonboard.com>
 <11266116.VtDrNngWRY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11266116.VtDrNngWRY@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Kieran,

On Fri, May 19, 2017 at 05:42:07PM +0300, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Friday 19 May 2017 14:34:33 Kieran Bingham wrote:
> > On 18/05/17 14:36, Laurent Pinchart wrote:
> > > On Wednesday 17 May 2017 16:03:38 Kieran Bingham wrote:
> > >> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > >> 
> > >> V4L2 async notifiers can pass the endpoint fwnode rather than the device
> > >> fwnode.
> > > 
> > > I'm not sure I would mention V4L2 in the commit message, as this is
> > > generic.
> >
> > Good point
> > 
> > >> Provide a helper to obtain the parent device fwnode without first
> > >> parsing the remote-endpoint as per fwnode_graph_get_remote_port_parent.
> > >> 
> > >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > >> ---
> > >> 
> > >>  drivers/base/property.c  | 25 +++++++++++++++++++++++++
> > >>  include/linux/property.h |  2 ++
> > >>  2 files changed, 27 insertions(+)
> > >> 
> > >> diff --git a/drivers/base/property.c b/drivers/base/property.c
> > >> index 627ebc9b570d..caf4316fe565 100644
> > >> --- a/drivers/base/property.c
> > >> +++ b/drivers/base/property.c
> > >> @@ -1245,6 +1245,31 @@ fwnode_graph_get_next_endpoint(struct
> > >> fwnode_handle
> > >> *fwnode, EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
> > >> 
> > >>  /**
> > >> 
> > >> + * fwnode_graph_get_port_parent - Return device node of a port endpoint
> > >> + * @fwnode: Endpoint firmware node pointing of the port
> > >> + *
> > >> + * Extracts firmware node of the device the @fwnode belongs to.
> > > 
> > > I'm not too familiar with the fwnode API, but I know it's written in C,
> > > where functions don't extract something but return a value :-) How about
> > > 
> > > Return: the firmware node of the device the @endpoint belongs to.
> > 
> > I'm not averse to the reword - but it is different to the other functions in
> > the same context:
> > 
> > fwnode_graph_get_remote_endpoint(struct fwnode_handle *fwnode)
> >  * Extracts firmware node of a remote endpoint the @fwnode points to.
> > 
> > struct fwnode_handle *fwnode_graph_get_remote_port(struct fwnode_handle
> > *fwnode)
> >  * Extracts firmware node of a remote port the @fwnode points to.
> > 
> > fwnode_graph_get_remote_port_parent(struct fwnode_handle *fwnode)
> >  * Extracts firmware node of a remote device the @fwnode points to.
> > 
> > Then with this function becoming:
> > 
> > fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
> >  * Returns firmware node of the device the @endpoint belongs to.
> > 
> > 
> > I guess those could be changed too ...
> 
> My point is that the kerneldoc format documents return values with a "Return:" 
> tag. The documentation for the function can still provide extra information.

Yeah, let's do this right and then fix the rest. I've already submitted the
pull request on this one --- the origin of that text is actually the V4L2 OF
framework. Feel free to submit a patch that fixes it, I can do it as well.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
