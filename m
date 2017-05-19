Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46202 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756453AbdESVvy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 17:51:54 -0400
Date: Sat, 20 May 2017 00:51:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kbingham@kernel.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v2 1/2] device property: Add fwnode_graph_get_port_parent
Message-ID: <20170519215147.GE3227@valkosipuli.retiisi.org.uk>
References: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6d3ca9a2f4af281191b6672489f6d2a6d036d372.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d3ca9a2f4af281191b6672489f6d2a6d036d372.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, May 19, 2017 at 05:16:02PM +0100, Kieran Bingham wrote:
> +struct fwnode_handle *
> +fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
> +{
> +	return fwnode_call_ptr_op(endpoint, graph_get_port_parent);

graph_get_port_parent op will actually get the parent of the port. But it
expects a port node, not an endpoint node. This is implemented so in order
to center the ops around primitives rather than end user APIs that may
change over time.

I think you'll need:

	return fwnode_call_ptr_op(fwnode_graph_get_next_parent(endpoint),
				  graph_get_port_parent);

Or something like that.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
