Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753518AbZB1Vzb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 16:55:31 -0500
Date: Sat, 28 Feb 2009 22:55:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
cc: Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH/RFC 1/4] ipu_idmac: code clean-up and robustness improvements
In-Reply-To: <656120.15914.qm@web32107.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0902282253210.20549@axis700.grange>
References: <656120.15914.qm@web32107.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Feb 2009, Agustin wrote:

> 
> Hi Guennadi,
> 
> I am having trouble while probing ipu idmac:
> 
> At boot:
> ipu-core: probe of ipu-core failed with error -22
> 
> Which is apparently happening at ipu_idmac:1706:
>    1695 static int __init ipu_probe(struct platform_device *pdev)
>    ...
>    1703         mem_ipu = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>    1704         mem_ic  = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>    1705         if (!pdata || !mem_ipu || !mem_ic)
>    1706                 return -EINVAL;
> 
> Later on, I get error 16, "Device or resource busy" on VIDIOC_S_FMT, apparently because mx3_camera can't get its dma channel.
> 
> Any clue?

Are you sure it is failing here, have you verified with a printk? If it is 
indeed this place, then you probably didn't register all required 
resources in your platfom code. Look at my platform-bindings patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
