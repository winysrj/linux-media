Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47234 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbaLWMCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 07:02:21 -0500
Date: Tue, 23 Dec 2014 13:01:37 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Grant Likely <grant.likely@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de, Russell King <rmk+kernel@arm.linux.org.uk>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 3/3] of: Add of_graph_get_port_by_id function
Message-ID: <20141223120137.GA26129@pengutronix.de>
References: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
 <1419261091-29888-4-git-send-email-p.zabel@pengutronix.de>
 <54994D88.3000009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54994D88.3000009@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On Tue, Dec 23, 2014 at 12:10:00PM +0100, Andrzej Hajda wrote:
[...]
> >  /**
> > + * of_graph_get_port_by_id() - get the port matching a given id
> > + * @parent: pointer to the parent device node
> 
> Here you have 'parent' and 'node' in the code.
[...]
> Maybe I miss something but it does not handle optional 'ports' node.

You missed nothing, thank you for the comments! I'll fix both issues
like this:

struct device_node *of_graph_get_port_by_id(struct device_node *parent, u32 id)
{
	struct device_node *node, *port;

	node = of_get_child_by_name(parent, "ports");
	if (node)
		parent = node;

	for_each_child_of_node(parent, port) {
		u32 port_id = 0;

		if (of_node_cmp(port->name, "port") != 0)
			continue;
		of_property_read_u32(port, "reg", &port_id);
		if (id == port_id)
			break;
	}

	of_node_put(node);

	return port;
}

regards
Philipp
