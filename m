Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42783 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754321AbZGALkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jul 2009 07:40:16 -0400
Date: Wed, 1 Jul 2009 13:40:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jesko Schwarzer <jesko.schwarzer@jena-optronik.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: Newbe question: How are SOC cameras integrated ? How to connect
 an FPGA to the video interface ?
In-Reply-To: <"4430.30631246444116.hermes.jena-optronik.de*"@MHS>
Message-ID: <Pine.LNX.4.64.0907011334450.5609@axis700.grange>
References: <"4430.30631246444116.hermes.jena-optronik.de*"@MHS>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(moving to the new v4l2 mailing list, added int-device maintainer (?) to 
CC)

On Wed, 1 Jul 2009, Jesko Schwarzer wrote:

> Hello,
> 
> we currently use an OMAP Zoom board and want to connect an FPGA board to the
> video interface.
> One idea is to simulate an SOC camera like the MT9V022 device, but we don't
> know exacly how it is managed to from driver view.
> We use a 2.6.28 kernel and managed to integrate v4l2 and the SOC devices;
> but we did not get an /dev/video device ...
> And then, how to get a virtual MT9V022 running ? How to select ?

I don't think there's support for soc-camera for OMAP SoCs, or have you 
implemented that? AFAIK, OMAP are using int-device, currently also 
transitioning to v4l2-subdev.

If it is correct, then your best bet would be to wait until both 
soc-camera and int-device are converted to v4l2-subdev, then you'll be 
able to use OMAP's camera host driver with the mt9v022 driver, originally 
from soc-camera. Instead of passively waiting you can help with the work 
too of course.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
