Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52124 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751162AbZHaQH5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 12:07:57 -0400
Date: Mon, 31 Aug 2009 18:08:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: bus configuration setup for sub-devices
In-Reply-To: <4A9BF22A.1000608@maxwell.research.nokia.com>
Message-ID: <Pine.LNX.4.64.0908311806530.4189@axis700.grange>
References: <200908291631.13696.hverkuil@xs4all.nl> <4A9BF22A.1000608@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 Aug 2009, Sakari Ailus wrote:

> How would the image format be defined then...? The ISP in this case can mangle
> the image format the way it wants so what's coming from the sensor can be
> quite different from what's coming out of the ISP. Say, sensor produces raw
> bayer and ISP writes YUYV, for example. Usually the format the sensor outputs
> is not defined by the input format the user wants from the device.

It would be good if you could have a look at my recent RFC and the 
following discussion, this kind of format conversion is exactly what is 
handled by it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
