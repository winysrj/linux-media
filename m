Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50236 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1IFP0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 11:26:42 -0400
Date: Tue, 6 Sep 2011 17:26:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
In-Reply-To: <CACKLOr3GB-WO2p3+pQPdyXsipvTGFuj-wATgv=FSxtge=_Pq2g@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109061715380.14818@axis700.grange>
References: <CACKLOr3GB-WO2p3+pQPdyXsipvTGFuj-wATgv=FSxtge=_Pq2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Tue, 6 Sep 2011, javier Martin wrote:

> Hi,
> we are planning to add support to H.264/MPEG4 encoder inside the
> i.MX27 to v4l2. It is mainly a hardware module that has the following
> features:
> 
> - It needs two input buffers (current frame and previous frame).
> - It produces a third buffer as output, containing the encoded frame,
> and generates an IRQ when that happens.
> - Previous three buffers need contiguous physical memory addresses and
> probably some alignment requirements.
> - It needs an external firmware to be loaded in another contiguous
> memory buffer.
> 
> I would like to know what is your opinion on this, what v4l2 framework
> should we use to deal with it, etc... I guess Multi Format Codec 5.1
> driver for s5pv210 and exynos4 SoC is the most similar piece of HW
> I've found so far but it has not yet entered mainline [1]
> 
> Note that mx2_camera driver is still using soc-camera framework and
> soc-camera doesn't seem to be ready for integration with pad level API
> [2]. For that reason we think we could develop this VPU driver
> separately.

(The following is my understanding and opinion, all corrections welcome)

The MC API is important, when data can be passed directly between modules, 
using some internal busses. I.e., if you could just configure your VPU to 
receive the data directly from the camera capture module, without the use 
of memory buffers, then yes, you would want an MC-like API, and an ability 
to connect the camera module to the VPU using pads and links and configure 
each entity from the user-space separately, maintaining the format 
compatibility along the links.

In your case, however, the VPU uses memory buffers. I.e., what you want is 
some zero-copy buffer passing from the camera module to the VPU. I don't 
think the MC API is very helpful in this situation. With the currently 
available options you want to use USERPTR buffers and pass them from the 
source to the sink in your user-space application. There are also some 
buffer-sharing options approaching, but as long as this is just one 
application, that tosses buffers between two devices, you, probably, don't 
need those very much either. So, this looks like a "simple" mem2mem driver 
case to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
