Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53788 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934099AbdKBCnw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 22:43:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 14/26] media: xilinx: fix a debug printk
Date: Thu, 02 Nov 2017 04:43:51 +0200
Message-ID: <2117711.dO2rQLXOup@avalon>
In-Reply-To: <be86653c5e5641582f65f43780b1fe255e92cdc0.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com> <be86653c5e5641582f65f43780b1fe255e92cdc0.1509569763.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(CC'ing Rob and Sakari)

Thank you for the patch.

On Wednesday, 1 November 2017 23:05:51 EET Mauro Carvalho Chehab wrote:
> Two orthogonal changesets caused a breakage at several printk
> messages inside xilinx. Changeset 859969b38e2e
> ("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")
> made davinci to use struct fwnode_handle instead of
> struct device_node. Changeset 68d9c47b1679
> ("media: Convert to using %pOF instead of full_name")
> changed the printk to not use ->full_name, but, instead,
> to rely on %pOF.
> 
> With both patches applied, the Kernel will do the wrong
> thing, as warned by smatch:
> drivers/media/platform/xilinx/xilinx-vipp.c:108 xvip_graph_build_one()
> error: '%pOF' expects argument of type 'struct device_node*', argument 4
> has type 'void*'
> drivers/media/platform/xilinx/xilinx-vipp.c:117 xvip_graph_build_one()
> error: '%pOF' expects argument of type 'struct device_node*', argument 4 has
> type 'void*'
> drivers/media/platform/xilinx/xilinx-vipp.c:126 xvip_graph_build_one()
> error: '%pOF' expects argument of type 'struct device_node*', argument 4
> has type 'void*'
> drivers/media/platform/xilinx/xilinx-vipp.c:138 xvip_graph_build_one()
> error: '%pOF' expects argument of type 'struct device_node*', argument 3 has
> type 'void*'
> drivers/media/platform/xilinx/xilinx-vipp.c:148 xvip_graph_build_one()
> error: '%pOF' expects argument of type 'struct device_node*', argument 4
> has type 'void*'
> drivers/media/platform/xilinx/xilinx-vipp.c:245 xvip_graph_build_dma()
> error: '%pOF' expects argument of type 'struct device_node*', argument 3 has
> type 'void*'
> drivers/media/platform/xilinx/xilinx-vipp.c:254 xvip_graph_build_dma()
> error: '%pOF' expects argument of type 'struct device_node*', argument 4
> has type 'void*'
> 
> So, change the logic to actually print the device name
> that was obtained before the print logic.

This doesn't seem like a good idea to me. The main point of commit 
68d9c47b1679 is to avoid accessing full_name directly to prepare for removal 
of that field.

to_of_node() is defined as

#define to_of_node(__fwnode)                                            \
        ({                                                              \
                typeof(__fwnode) __to_of_node_fwnode = (__fwnode);      \
                                                                        \
                is_of_node(__to_of_node_fwnode) ?                       \
                        container_of(__to_of_node_fwnode,               \
                                     struct device_node, fwnode) :      \
                        NULL;                                           \
        })

when CONFIG_OF is set, and as

static inline struct device_node *to_of_node(const struct fwnode_handle 
*fwnode)
{
        return NULL;
}

otherwise. I wonder why smatch believes the value is a void *, but in any case 
that should be fixed either in smatch (if it's a smatch bug) or in the 
definition of the to_of_node() macro.

> Fixes: 68d9c47b1679 ("media: Convert to using %pOF instead of full_name")
> Fixes: 859969b38e2e ("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")

When submitting fixes you should CC the author of the original commits. They 
should have more information about the context, and in this case I believe Rob 
would have pointed out that adding back references to full_name would break 
the refactoring he's working on.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/xilinx/xilinx-vipp.c | 31 +++++++++++++-------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c
> b/drivers/media/platform/xilinx/xilinx-vipp.c index
> d881cf09876d..dd777c834c43 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -65,6 +65,9 @@ xvip_graph_find_entity(struct xvip_composite_device *xdev,
> return NULL;
>  }
> 
> +#define LOCAL_NAME(link)	to_of_node(link.local_node)->full_name
> +#define REMOTE_NAME(link)	to_of_node(link.remote_node)->full_name
> +
>  static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  				struct xvip_graph_entity *entity)
>  {
> @@ -103,9 +106,9 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev,
>  		 * the link.
>  		 */
>  		if (link.local_port >= local->num_pads) {
> -			dev_err(xdev->dev, "invalid port number %u for %pOF\n",
> +			dev_err(xdev->dev, "invalid port number %u for %s\n",
>  				link.local_port,
> -				to_of_node(link.local_node));
> +				LOCAL_NAME(link));
>  			v4l2_fwnode_put_link(&link);
>  			ret = -EINVAL;
>  			break;
> @@ -114,8 +117,8 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev, local_pad = &local->pads[link.local_port];
> 
>  		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
> -			dev_dbg(xdev->dev, "skipping sink port %pOF:%u\n",
> -				to_of_node(link.local_node),
> +			dev_dbg(xdev->dev, "skipping sink port %s:%u\n",
> +				LOCAL_NAME(link),
>  				link.local_port);
>  			v4l2_fwnode_put_link(&link);
>  			continue;
> @@ -123,8 +126,8 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev,
> 
>  		/* Skip DMA engines, they will be processed separately. */
>  		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
> -			dev_dbg(xdev->dev, "skipping DMA port %pOF:%u\n",
> -				to_of_node(link.local_node),
> +			dev_dbg(xdev->dev, "skipping DMA port %s:%u\n",
> +				REMOTE_NAME(link),
>  				link.local_port);
>  			v4l2_fwnode_put_link(&link);
>  			continue;
> @@ -134,8 +137,8 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev, ent = xvip_graph_find_entity(xdev,
>  					     to_of_node(link.remote_node));
>  		if (ent == NULL) {
> -			dev_err(xdev->dev, "no entity found for %pOF\n",
> -				to_of_node(link.remote_node));
> +			dev_err(xdev->dev, "no entity found for %s\n",
> +				REMOTE_NAME(link));
>  			v4l2_fwnode_put_link(&link);
>  			ret = -ENODEV;
>  			break;
> @@ -144,8 +147,8 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev, remote = ent->entity;
> 
>  		if (link.remote_port >= remote->num_pads) {
> -			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
> -				link.remote_port, to_of_node(link.remote_node));
> +			dev_err(xdev->dev, "invalid port number %u on %s\n",
> +				link.remote_port, REMOTE_NAME(link));
>  			v4l2_fwnode_put_link(&link);
>  			ret = -EINVAL;
>  			break;
> @@ -241,17 +244,17 @@ static int xvip_graph_build_dma(struct
> xvip_composite_device *xdev) ent = xvip_graph_find_entity(xdev,
>  					     to_of_node(link.remote_node));
>  		if (ent == NULL) {
> -			dev_err(xdev->dev, "no entity found for %pOF\n",
> -				to_of_node(link.remote_node));
> +			dev_err(xdev->dev, "no entity found for %s\n",
> +				REMOTE_NAME(link));
>  			v4l2_fwnode_put_link(&link);
>  			ret = -ENODEV;
>  			break;
>  		}
> 
>  		if (link.remote_port >= ent->entity->num_pads) {
> -			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
> +			dev_err(xdev->dev, "invalid port number %u on %s\n",
>  				link.remote_port,
> -				to_of_node(link.remote_node));
> +				REMOTE_NAME(link));
>  			v4l2_fwnode_put_link(&link);
>  			ret = -EINVAL;
>  			break;

-- 
Regards,

Laurent Pinchart
