Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48882 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S937806AbdEWViD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 17:38:03 -0400
Date: Wed, 24 May 2017 00:37:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 1/2] device property: Add fwnode_graph_get_port_parent
Message-ID: <20170523213756.GF29527@valkosipuli.retiisi.org.uk>
References: <cover.33d4457de9c9f4e5285e7b1d18a8a92345c438d3.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <cce043f797174561fe49350a66b56ce07059716c.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170523125856.GD29527@valkosipuli.retiisi.org.uk>
 <79865ffc-ba02-3a6c-7355-1a37c11dbdd2@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79865ffc-ba02-3a6c-7355-1a37c11dbdd2@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, May 23, 2017 at 06:15:42PM +0100, Kieran Bingham wrote:
> 
> 
> On 23/05/17 13:58, Sakari Ailus wrote:
> > Hi Kieran,
> > 
> > On Mon, May 22, 2017 at 06:36:37PM +0100, Kieran Bingham wrote:
> >> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >>
> >> Provide a helper to obtain the parent device fwnode without first
> >> parsing the remote-endpoint as per fwnode_graph_get_remote_port_parent.
> >>
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >>
> >> ---
> >> v2:
> >>  - Rebase on top of Sakari's acpi-graph-clean branch and simplify
> >>
> >> v3:
> >>  - Fix up kerneldoc
> >>  - Get the 'port' of the endpoint to find the parent of the port
> >>
> >>  drivers/base/property.c  | 15 +++++++++++++++
> >>  include/linux/property.h |  2 ++
> >>  2 files changed, 17 insertions(+)
> >>
> >> diff --git a/drivers/base/property.c b/drivers/base/property.c
> >> index b311a6fa7d0c..fdbc644fd743 100644
> >> --- a/drivers/base/property.c
> >> +++ b/drivers/base/property.c
> >> @@ -1169,6 +1169,21 @@ fwnode_graph_get_next_endpoint(struct fwnode_handle *fwnode,
> >>  EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
> >>  
> >>  /**
> >> + * fwnode_graph_get_port_parent - Return the device fwnode of a port endpoint
> >> + * @endpoint: Endpoint firmware node of the port
> >> + *
> >> + * Return: the firmware node of the device the @endpoint belongs to.
> >> + */
> >> +struct fwnode_handle *
> >> +fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
> >> +{
> >> +	struct fwnode_handle *port = fwnode_get_next_parent(endpoint);
> >> +
> >> +	return fwnode_call_ptr_op(port, graph_get_port_parent);
> > 
> > I missed one thing: the reference to port obtained in
> > fwnode_get_next_parent() needs to be released.
> > 
> > I can do the change while applying the patch on top of the set if you're ok
> > with that.
> 
> Yes, that would be great thanks.

Thanks! The patch actually came out in this form:

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=acpi-graph-cleaned&id=6c9e58006e73de03441337f3ca6247afed28cf0a>

I'll post it to list once I've rebased the set again, I hope you're ok with
that. :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
