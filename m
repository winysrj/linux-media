Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751674AbZH0I6W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 04:58:22 -0400
Date: Thu, 27 Aug 2009 10:58:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908271051380.4808@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>   
 <200908270851.27073.hverkuil@xs4all.nl>    <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
    <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.0908271017280.4808@axis700.grange>
 <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2009, Hans Verkuil wrote:

> For example a sensor connected to an fpga (doing e.g. color space
> conversion or some other type of image processing/image improvement) which
> in turn is connected to the bridge.
> 
> How you setup the sensor and how you setup the bridge might not have an
> obvious 1-to-1 mapping. While I have not seen setups like this for
> sensors, I have seen them for video encoder devices.
> 
> You assume that a sensor is connected directly to a bridge, but that
> assumption is simply not true. There may be all sorts of ICs in between.

No, I do not assume that, that's why in my original RFC I used "source" 
and "sink" instead of camera and SoC. In your example you your FPGA is a 
subdev to the SoC, and the sensor is a subdev to FPGA, right? So, what 
stops you from applying my format enumeration twice? Say, first the FPGA 
enumerates sensor formats and synthesises a list of output formats - 
again, as "source" formats, not "user" formats, because the data is going 
to be transferred to the host over the image bus, right? It would be a 
different configuration if you first transfer the data from FPGA to RAM 
and then let your SoC camera host take the data from there. That would be 
a different configuration for the host. So, I don't see how your example 
requires platform data.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
