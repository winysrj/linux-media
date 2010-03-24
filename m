Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38143 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754788Ab0CXTaF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 15:30:05 -0400
Date: Wed, 24 Mar 2010 20:30:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Adam Sutton <aps@plextek.co.uk>
cc: linux-media@vger.kernel.org
Subject: Re: SOC camera port for ov7675/ov2640 on i.MX25
In-Reply-To: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF2F1B@plextek3.plextek.lan>
Message-ID: <Pine.LNX.4.64.1003242025000.6783@axis700.grange>
References: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF2F1B@plextek3.plextek.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Wed, 24 Mar 2010, Adam Sutton wrote:

> Hi,
> 
> I'm just beginning a Linux based project running on a Freescale i.MX25.
> One of 
> my jobs is to write a camera driver for the sensor we're going to be
> using 
> (Omnivision 7675). However at present I only have access to an ov2640
> attached 
> to a Freescale 3stack development board. I thought it would be a useful
> and 
> interesting exercise to port the driver provided by Freescale to the new
> 
> soc_camera framework.
> 
> I've written the ov2640 driver, using a variety of other drivers as
> references 
> and I'm using the mx25_camera host driver (with a few mods) posted by
> Arno 
> Euteneuer. After getting over some basic setup/config problems I've now
> got as 
> far as the mx25_camera loading and this then auto loading the ov2640.
> This 
> correctly probes the I2C and detects the sensor.
> 
> However I've now come up against a problem that I'm unsure of how to
> solve and 
> I'm not sure whether its a case of my not properly following the current
> 
> framework. soc_camera_probe() is called and detects the the
> soc_camera_link 
> object contains board information and therefore calls
> soc_camera_init_i2c() this 
> in turn calls v4l2_i2c_new_subdev_board() which then attempts to create
> a new 
> i2c_client (i2c_new_device()) and it is at this point things fail.
> 
> Because an i2c_client already exists (auto created from the static board
> info 
> registered by the platform configuration), the one passed into the
> probe() 
> routine of my chip driver, the i2c_new_device() call fails as it believe
> the 
> device is busy as a client already exists for that I2C address.
> 
> I can only assume that there is something wrong with the way I've set
> things up 
> / used the framework. However I've compared it to several other modules
> and 
> can't see any obvious faults (although its not obvious which drivers
> represent 
> the current "preferred" approach).
> 
> I should say that I'm using a 2.6.31 based kernel (provided by
> Freescale) into 
> which I've grafted the 2.6.33 media drivers (and obvious dependencies)
> so I 
> guess something about this graft could be causing the problem. Though I
> cannot 
> see what from looking at other changes.

Your board shouldn't register static i2c devices for cameras. See any 
(soc-)camera-enabled platform in the _current_ kernel. E.g., 
arch/arm/mach-mx3/mach-pcm037.c. However, for us to be able to really help 
you, you have to base your work on current development kernel, or at least 
on a recent release (2.6.33 / 2.6.34-rc2).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
