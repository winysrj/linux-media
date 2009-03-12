Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57866 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751230AbZCLIko (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 04:40:44 -0400
Date: Thu, 12 Mar 2009 09:40:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pcm990 baseboard: add camera bus width switch setting
In-Reply-To: <1236765976-20581-3-git-send-email-s.hauer@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0903120935570.4896@axis700.grange>
References: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One more thing I noticed while looking at your patch 3/4:

> +static int pcm990_camera_set_bus_param(struct device *dev,
> +		unsigned long flags)
> +{
> +	if (gpio_bus_switch <= 0)
> +		return 0;
> +
> +	if (flags & SOCAM_DATAWIDTH_8)
> +		gpio_set_value(NR_BUILTIN_GPIO + 1, 1);
> +	else
> +		gpio_set_value(NR_BUILTIN_GPIO + 1, 0);

Originally the logic here was "only if flags == SOCAM_DATAWIDTH_8, switch 
to 8 bits, otherwise do 10 bits. I.e., if flags == SOCAM_DATAWIDTH_8 | 
SOCAM_DATAWIDTH_10, it would still do the default (and wider) 10 bits. Do 
you have any reason to change that logic?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
