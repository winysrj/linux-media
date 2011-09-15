Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:36418 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab1IORcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 13:32:55 -0400
Message-ID: <4E723701.60104@iki.fi>
Date: Thu, 15 Sep 2011 20:33:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
References: <CACKLOr3GB-WO2p3+pQPdyXsipvTGFuj-wATgv=FSxtge=_Pq2g@mail.gmail.com>
In-Reply-To: <CACKLOr3GB-WO2p3+pQPdyXsipvTGFuj-wATgv=FSxtge=_Pq2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

javier Martin wrote:
> Hi,

Hi Javier,

> we are planning to add support to H.264/MPEG4 encoder inside the
> i.MX27 to v4l2. It is mainly a hardware module that has the following
> features:
> 
> - It needs two input buffers (current frame and previous frame).
> - It produces a third buffer as output, containing the encoded frame,
> and generates an IRQ when that happens.
> - Previous three buffers need contiguous physical memory addresses and
> probably some alignment requirements.

CMA (contiguous memory allocator). This isn't in mainline yet, so so'll
need to wait a little bit.

> - It needs an external firmware to be loaded in another contiguous
> memory buffer.

This needs to be loaded using request_firmware().

> I would like to know what is your opinion on this, what v4l2 framework
> should we use to deal with it, etc... I guess Multi Format Codec 5.1
> driver for s5pv210 and exynos4 SoC is the most similar piece of HW
> I've found so far but it has not yet entered mainline [1]

It sounds to me like that this device should be supported using the V4L2
interface.

> Note that mx2_camera driver is still using soc-camera framework and
> soc-camera doesn't seem to be ready for integration with pad level API
> [2]. For that reason we think we could develop this VPU driver
> separately.
> 
> [1] http://www.spinics.net/lists/linux-media/msg35040.html
> [2] http://www.open-technology.de/index.php?/categories/2-SoC-camera

As Guennadi noted, the Media controller framework should be used to
expose the control of more complex devices to user space than SoC camera
can support.

However, it sounds like to me that the video produced by the camera has
to be written to the system memory before it is processed by the
H.264/MPEG4 encoder. For this reason, I don't see there would be a need
to connect the camera driver to the encoder in kernel. Or am I wrong in
thinking that these two are separate devices?

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
