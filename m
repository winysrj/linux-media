Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:49367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1BPQZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 11:25:14 -0500
Date: Wed, 16 Feb 2011 17:25:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Query] Soc_camera: Passing MIPI bus physical link details
In-Reply-To: <A24693684029E5489D1D202277BE894486B1D3BC@dlee02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1102161720010.20711@axis700.grange>
References: <A24693684029E5489D1D202277BE894486B1D3BC@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sergio

On Wed, 16 Feb 2011, Aguirre, Sergio wrote:

> Hi Guennadi,
> 
> I have been working internally in a private 2.6.35.7 kernel with the TI OMAP4
> platform, and as I have a very simple camera support driver (It just enables a
> CSI2 Rx Interface), i decided to go for a soc-camera host implementation.
> 
> Now, I see that there is a set_bus_param callback function for host drivers,
> which if i understand correctly, it tries to negotiate the bus parameters
> between the host and the client.
> 
> But what i notice is that this seems to be mostly oriented towards a parallel
> interface, as most of the things won't make much sense in MIPI CSI2 spec
> (HSYNC_ACTIVE_HIGH, DATAWIDTH_x, etc.)

Please, have a look at this thread:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/27609/focus=28195

> I was wondering what's the best way to be able to tell to the host driver
> MIPI specific details such as, how many datalanes the interface is using, and
> the MIPI Clk speed in which the sensor will be transmitting the data.
> 
> Does it make sense to expand this inside the [query/set]_bus_param APIs? or
> Will it be better to implement a new v4l2_subdev_sensor_ops entry, something
> like g_mipi_params?

Don't think we want to add this to subdev sensor-ops. Currently, AFAICS, 
there is no support in v4l2_subdev_*_ops for bus parameter configuration, 
and we don't want to start adding them chaotically without a general 
concept in place.

Please, have a look at the above thread, if after that you still have 
questions, please, ask again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
