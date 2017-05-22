Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43484 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760488AbdEVRD1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 13:03:27 -0400
Subject: Re: [PATCH v2 1/2] device property: Add fwnode_graph_get_port_parent
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6d3ca9a2f4af281191b6672489f6d2a6d036d372.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170519215147.GE3227@valkosipuli.retiisi.org.uk>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <4a0d7fa1-f93c-35d5-d7de-8f42800f05c6@ideasonboard.com>
Date: Mon, 22 May 2017 18:03:08 +0100
MIME-Version: 1.0
In-Reply-To: <20170519215147.GE3227@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 19/05/17 22:51, Sakari Ailus wrote:
> Hi Kieran,
> 
> On Fri, May 19, 2017 at 05:16:02PM +0100, Kieran Bingham wrote:
>> +struct fwnode_handle *
>> +fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
>> +{
>> +	return fwnode_call_ptr_op(endpoint, graph_get_port_parent);
> 
> graph_get_port_parent op will actually get the parent of the port. But it
> expects a port node, not an endpoint node. This is implemented so in order
> to center the ops around primitives rather than end user APIs that may
> change over time.
> 
> I think you'll need:
> 
> 	return fwnode_call_ptr_op(fwnode_graph_get_next_parent(endpoint),
> 				  graph_get_port_parent);
> 
> Or something like that.

Aha - that explains why I remember thinking to ask you if the implementation of
graph_get_port_parent checked enough levels up :)

I've added the fwnode_graph_get_next_parent() call, but separated it out so that
the code fits cleanly:

struct fwnode_handle *
fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
{
	struct fwnode_handle *port = fwnode_get_next_parent(endpoint);

	return fwnode_call_ptr_op(port, graph_get_port_parent);
}
EXPORT_SYMBOL_GPL(fwnode_graph_get_port_parent);

I will include this in my testing and rebasing before I repost.
--
Regards

Kieran
