Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717C2C04EBF
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 09:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36BE420892
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 09:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="S3Geriww"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36BE420892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbeLFJGT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 04:06:19 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:36634 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbeLFJGT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 04:06:19 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AE0EF546;
        Thu,  6 Dec 2018 10:06:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544087176;
        bh=QqaCaru4HlBngyD5EdpUWfAmiiuTniR1cU9xMfAu5BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3GeriwwJAho5vsiiSvHErMwLtt5wDeo2OyXRJF6L6tdsPX/BslsfiRpS1Zd0n8+o
         mvC1iDNXWfTgoTLaWLzGVhexTjh31Wm4OfdOlY4+r8favnyb9TFvp0/uFmZuQxc/ph
         0hRp+uNO8q1hZ7xm98oMUc5oeCHp+euoubNj45Sk=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Benoit Parrot <bparrot@ti.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] media: Use of_node_name_eq for node name comparisons
Date:   Thu, 06 Dec 2018 11:06:53 +0200
Message-ID: <11464259.SYJ8DM9ezq@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181205195050.4759-13-robh@kernel.org>
References: <20181205195050.4759-13-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rob,

Thank you for the patch.

On Wednesday, 5 December 2018 21:50:29 EET Rob Herring wrote:
> Convert string compares of DT node names to use of_node_name_eq helper
> instead. This removes direct access to the node name pointer.
> 
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Benoit Parrot <bparrot@ti.com>
> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Michal Simek <michal.simek@xilinx.com>
> Cc: linux-media@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 12 ++++++------
>  drivers/media/platform/ti-vpe/cal.c           |  4 ++--
>  drivers/media/platform/xilinx/xilinx-tpg.c    |  2 +-
>  drivers/media/v4l2-core/v4l2-fwnode.c         |  6 ++----
>  4 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c
> b/drivers/media/platform/exynos4-is/media-dev.c index
> 870501b0f351..ced14af56606 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -445,7 +445,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  	 */
>  	np = of_get_parent(rem);
> 
> -	if (np && !of_node_cmp(np->name, "i2c-isp"))
> +	if (of_node_name_eq(np, "i2c-isp"))
>  		pd->fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
>  	else
>  		pd->fimc_bus_type = pd->sensor_bus_type;
> @@ -495,7 +495,7 @@ static int fimc_md_register_sensor_entities(struct
> fimc_md *fmd) for_each_available_child_of_node(parent, node) {
>  		struct device_node *port;
> 
> -		if (of_node_cmp(node->name, "csis"))
> +		if (!of_node_name_eq(node, "csis"))
>  			continue;
>  		/* The csis node can have only port subnode. */
>  		port = of_get_next_child(node, NULL);
> @@ -720,13 +720,13 @@ static int fimc_md_register_platform_entities(struct
> fimc_md *fmd, continue;
> 
>  		/* If driver of any entity isn't ready try all again later. */
> -		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
> +		if (of_node_name_eq(node, CSIS_OF_NODE_NAME))
>  			plat_entity = IDX_CSIS;
> -		else if	(!strcmp(node->name, FIMC_IS_OF_NODE_NAME))
> +		else if	(of_node_name_eq(node, FIMC_IS_OF_NODE_NAME))

You might want to s/if\t/if / while at it.

>  			plat_entity = IDX_IS_ISP;
> -		else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
> +		else if (of_node_name_eq(node, FIMC_LITE_OF_NODE_NAME))
>  			plat_entity = IDX_FLITE;
> -		else if	(!strcmp(node->name, FIMC_OF_NODE_NAME) &&
> +		else if	(of_node_name_eq(node, FIMC_OF_NODE_NAME) &&

And here too.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  			 !of_property_read_bool(node, "samsung,lcd-wb"))
>  			plat_entity = IDX_FIMC;
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c
> b/drivers/media/platform/ti-vpe/cal.c index 95a093f41905..fc3c212b96e1
> 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1615,7 +1615,7 @@ of_get_next_port(const struct device_node *parent,
>  				return NULL;
>  			}
>  			prev = port;
> -		} while (of_node_cmp(port->name, "port") != 0);
> +		} while (!of_node_name_eq(port, "port"));
>  	}
> 
>  	return port;
> @@ -1635,7 +1635,7 @@ of_get_next_endpoint(const struct device_node *parent,
> if (!ep)
>  			return NULL;
>  		prev = ep;
> -	} while (of_node_cmp(ep->name, "endpoint") != 0);
> +	} while (!of_node_name_eq(ep, "endpoint"));
> 
>  	return ep;
>  }
> diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c
> b/drivers/media/platform/xilinx/xilinx-tpg.c index
> 851d20dcd550..ce686b8d6cff 100644
> --- a/drivers/media/platform/xilinx/xilinx-tpg.c
> +++ b/drivers/media/platform/xilinx/xilinx-tpg.c
> @@ -725,7 +725,7 @@ static int xtpg_parse_of(struct xtpg_device *xtpg)
>  		const struct xvip_video_format *format;
>  		struct device_node *endpoint;
> 
> -		if (!port->name || of_node_cmp(port->name, "port"))
> +		if (!of_node_name_eq(port, "port"))
>  			continue;
> 
>  		format = xvip_of_get_format(port);
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> b/drivers/media/v4l2-core/v4l2-fwnode.c index 218f0da0ce76..849326241b17
> 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -564,8 +564,7 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> *__fwnode, fwnode = fwnode_get_parent(__fwnode);
>  	fwnode_property_read_u32(fwnode, port_prop, &link->local_port);
>  	fwnode = fwnode_get_next_parent(fwnode);
> -	if (is_of_node(fwnode) &&
> -	    of_node_cmp(to_of_node(fwnode)->name, "ports") == 0)
> +	if (is_of_node(fwnode) && of_node_name_eq(to_of_node(fwnode), "ports"))
>  		fwnode = fwnode_get_next_parent(fwnode);
>  	link->local_node = fwnode;
> 
> @@ -578,8 +577,7 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> *__fwnode, fwnode = fwnode_get_parent(fwnode);
>  	fwnode_property_read_u32(fwnode, port_prop, &link->remote_port);
>  	fwnode = fwnode_get_next_parent(fwnode);
> -	if (is_of_node(fwnode) &&
> -	    of_node_cmp(to_of_node(fwnode)->name, "ports") == 0)
> +	if (is_of_node(fwnode) && of_node_name_eq(to_of_node(fwnode), "ports"))
>  		fwnode = fwnode_get_next_parent(fwnode);
>  	link->remote_node = fwnode;

-- 
Regards,

Laurent Pinchart



