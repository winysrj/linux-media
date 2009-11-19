Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42826 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754967AbZKSOyz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 09:54:55 -0500
Date: Thu, 19 Nov 2009 15:55:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>
Subject: RE: [PATCH] soc-camera: Add mt9t112 camera support
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155A51366@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0911191546210.6767@axis700.grange>
References: <uzl6ig9iy.wl%morimoto.kuninori@renesas.com>
 <A69FA2915331DC488A831521EAE36FE40155A51366@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Nov 2009, Karicheri, Muralidharan wrote:

> Hi,
> 
> Please make this a generic driver so that it can be used across
> other SoCs as well. BTW, on which SoC have you tested this driver?
> There seems to be a lot of soc-camera specific stuffs here.
> Example, probe() is getting a pointer to struct soc_camera_device *icd. 
> I have been working with Guennadi to make the MT9T031.c driver work for 
> TI's VPFE on DMxxx SOCs. since this is a new driver, I would like to see 
> it de-coupled from soc-camera framework and implemented as a generic 
> v4l2-subdevice driver.

Murali, yes, our aim is to make sensor drivers universally usable, using 
the v4l2-subdev API. But ATM sensor drivers, written and tested to work 
with soc-camera hosts, cannot be absolutely soc-camera free. Although, we 
can (and shall) try to make them at least partially usable outside of the 
soc-camera framework, as I have done with the mt9t031 driver. ATM this 
driver would refuse to work with a non soc-camera host, or even 
misfunction, if that host driver is using i2c client platform data for 
something else. Yes, we'll fix this, but don't expect it to become 
absolutely soc-camera free for now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
