Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51199 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbJZBTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2015 21:19:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>, kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 6/8] [media] v4l: xilinx-tpg: add missing of_node_put
Date: Mon, 26 Oct 2015 03:19:42 +0200
Message-ID: <1798308.03Tu29vvmA@avalon>
In-Reply-To: <1445781427-7110-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1445781427-7110-1-git-send-email-Julia.Lawall@lip6.fr> <1445781427-7110-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Thank you for the patch.

On Sunday 25 October 2015 14:57:05 Julia Lawall wrote:
> for_each_child_of_node performs an of_node_get on each iteration, so
> a break out of the loop requires an of_node_put.
> 
> A simplified version of the semantic patch that fixes this problem is as
> follows (http://coccinelle.lip6.fr):
> 
> // <smpl>
> @@
> expression root,e;
> local idexpression child;
> @@
> 
>  for_each_child_of_node(root, child) {
>    ... when != of_node_put(child)
>        when != e = child
> (
>    return child;
> 
> +  of_node_put(child);
> ?  return ...;
> )
>    ...
>  }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/xilinx/xilinx-tpg.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c
> b/drivers/media/platform/xilinx/xilinx-tpg.c index b5f7d5e..8bd7e37 100644
> --- a/drivers/media/platform/xilinx/xilinx-tpg.c
> +++ b/drivers/media/platform/xilinx/xilinx-tpg.c
> @@ -731,6 +731,7 @@ static int xtpg_parse_of(struct xtpg_device *xtpg)
>  		format = xvip_of_get_format(port);
>  		if (IS_ERR(format)) {
>  			dev_err(dev, "invalid format in DT");
> +			of_node_put(port);
>  			return PTR_ERR(format);
>  		}
> 
> @@ -739,6 +740,7 @@ static int xtpg_parse_of(struct xtpg_device *xtpg)
>  			xtpg->vip_format = format;
>  		} else if (xtpg->vip_format != format) {
>  			dev_err(dev, "in/out format mismatch in DT");
> +			of_node_put(port);
>  			return -EINVAL;
>  		}

-- 
Regards,

Laurent Pinchart

