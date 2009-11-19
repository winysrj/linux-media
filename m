Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52150 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751910AbZKSPKt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 10:10:49 -0500
Date: Thu, 19 Nov 2009 16:11:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>
Subject: RE: [PATCH] soc-camera: Add mt9t112 camera support
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155A51397@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0911191607130.6767@axis700.grange>
References: <uzl6ig9iy.wl%morimoto.kuninori@renesas.com>
 <A69FA2915331DC488A831521EAE36FE40155A51366@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0911191546210.6767@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155A51397@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Nov 2009, Karicheri, Muralidharan wrote:

> Guennadi,
> 
> I am not sure what you mean by ATM sensor.

ATM = "At the moment."

> Is it not a
> Aptina/Micron sensor giving Raw Bayer RGB or Yuv data?

I presume it is.

> Not sure what prevents it from interfacing with VPFE.
> In otherwords, how is this different from mt9t031/mt9t001
> in terms of hardware signals available to interface to
> a SOC?

It is not. It just has been developed for a host, using soc-camera. And so 
you have to use soc-camera functionality, like query/set_bus_param, not 
yet available in v4l2-subdev, to get this client driver to work with that 
host driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
