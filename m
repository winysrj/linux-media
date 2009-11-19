Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52692 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754197AbZKSUkm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 15:40:42 -0500
Date: Thu, 19 Nov 2009 21:40:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] soc-camera: tw9910: modify V/H outpit pin setting to
 use VALID
In-Reply-To: <ur5rzz5cn.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911192133310.6767@axis700.grange>
References: <uzl6r6re1.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0911130829360.4601@axis700.grange> <u7htun4tr.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0911131051350.4601@axis700.grange> <ur5rzz5cn.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Nov 2009, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> Thank you
> 
> > Oh, indeed. Ok, but can you add proper support for both high and low 
> > polarities?
> 
> I think your order will be added in next patch.
> "Add polarities support"
> I will send it
> OK ?

Ok, we can do that too.

> By the way.
> Maybe I should ask you about it.
> 
> My question is that who select ACTIVE HI / LOW ?
> 
> ---------------------
> 	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
> 		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_VSYNC_ACTIVE_LOW | SOCAM_HSYNC_ACTIVE_LOW |
> 		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
> ---------------------
> 
> If I add above, and (for example) CEU - tw9910 case,
> tw9910_query_bus_param will be used in
> sh_mobile_ceu_set_bus_param.
> 
> Then, the answer from soc_camera_bus_param_compatible
> have both xSYNC_ACTIVE_HIGH/LOW.
> In this case, CEU behavior will be LOW,
> though it have HIGH.
> Please check it.
> 
> In my opinion, the answer from soc_camera_bus_param_compatible
> should not have both ACTIVE HIGH/LOW.
> This value will be used in tw9910_set_bus_param too.

Right, sh_mobile_ceu_camera.c support for clients, that support both high 
and low polarities of various signals is incorrect. Here's what should 
happen:

1. the host supports both high and low polarity of a specific signal
2. the client also supports both of them
3. the host then should choose one of them, preferably according to 
platform configuration
4. the host should use the chosen polarity to configure the client and 
itself

This is how the pxa_camera.c driver does it in pxa_camera_set_bus_param(). 
What actually happens in sh_mobile_ceu_camera.c, is that it keeps both 
polarities in its call to the client, so, the client picks up randomly one 
of them, then the host does the same. So, with a probability of 1/2 they 
will choose opposite polarities:-)

> I guess, to add your order, we needs more than 2 patches.
> 
> "modify soc_camera_bus_param_compatible behavior"

No. We should fix the sh-CEU driver.

> "tw9910: Add polarities support"

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
