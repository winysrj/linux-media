Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56446 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754515Ab0CHTUF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Mar 2010 14:20:05 -0500
Date: Mon, 8 Mar 2010 20:20:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org
Subject: Re: Question regarding soc-camera v4l subdev status.
In-Reply-To: <eedb5541003080121t283d5549w3496573c8383703a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1003082014220.5387@axis700.grange>
References: <eedb5541003080121t283d5549w3496573c8383703a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Mar 2010, javier Martin wrote:

> Hi,
> I know that soc-camera has been recently added support for v4l subdev.
> But, this does mean that now old encoder and sensor drivers like:
> http://lxr.linux.no/#linux+v2.6.33/drivers/media/video/tvp5150.c
> http://lxr.linux.no/#linux+v2.6.33/drivers/media/video/ov7670.c
> are now compatible with host camera drivers?
> 
> Or, on the other hand, is the subdev support partially implemented right now?

Please, see this thread:

http://www.spinics.net/lists/linux-media/index.html#16237

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
