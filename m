Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2JHVOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 17:14:15 -0400
Date: Mon, 8 Oct 2012 23:14:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Stephen Warren <swarren@wwwdotorg.org>,
	Rob Herring <robherring2@gmail.com>, linux-sh@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
In-Reply-To: <4043536.qVaHVXMbPA@avalon>
Message-ID: <Pine.LNX.4.64.1210082312570.14454@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1210021626220.15778@axis700.grange> <507330E6.1010409@wwwdotorg.org>
 <4043536.qVaHVXMbPA@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Oct 2012, Laurent Pinchart wrote:

> On Monday 08 October 2012 14:00:38 Stephen Warren wrote:
> > On 10/02/2012 08:33 AM, Guennadi Liakhovetski wrote:
> > > On Tue, 2 Oct 2012, Rob Herring wrote:
> > >> On 09/27/2012 09:07 AM, Guennadi Liakhovetski wrote:
> > >>> This patch adds a document, describing common V4L2 device tree bindings.
> > >>> 
> > >>> diff --git a/Documentation/devicetree/bindings/media/v4l2.txt
> > >>> b/Documentation/devicetree/bindings/media/v4l2.txt>> 
> > >> One other comment below:
> > >>> +
> > >>> +General concept
> > >>> +---------------
> > >>> +
> > >>> +Video pipelines consist of external devices, e.g. camera sensors,
> > >>> controlled +over an I2C, SPI or UART bus, and SoC internal IP blocks,
> > >>> including video DMA +engines and video data processors.
> > >>> +
> > >>> +SoC internal blocks are described by DT nodes, placed similarly to
> > >>> other SoC +blocks. External devices are represented as child nodes of
> > >>> their respective bus +controller nodes, e.g. I2C.
> > >>> +
> > >>> +Data interfaces on all video devices are described by "port" child DT
> > >>> nodes. +Configuration of a port depends on other devices participating
> > >>> in the data +transfer and is described by "link" DT nodes, specified as
> > >>> children of the +"port" nodes:
> > >>> +
> > >>> +/foo {
> > >>> +	port@0 {
> > >>> +		link@0 { ... };
> > >>> +		link@1 { ... };
> > >>> +	};
> > >>> +	port@1 { ... };
> > >>> +};
> > >>> +
> > >>> +If a port can be configured to work with more than one other device on
> > >>> the same +bus, a "link" child DT node must be provided for each of
> > >>> them. If more than one +port is present on a device or more than one
> > >>> link is connected to a port, a +common scheme, using "#address-cells,"
> > >>> "#size-cells" and "reg" properties is +used.
> > >>> +
> > >>> +Optional link properties:
> > >>> +- remote: phandle to the other endpoint link DT node.
> > >> 
> > >> This name is a little vague. Perhaps "endpoint" would be better.
> > > 
> > > "endpoint" can also refer to something local like in USB case. Maybe
> > > rather the description of the "remote" property should be improved?
> > 
> > The documentation doesn't show up in all the .dts files that use it; it
> > might be useful to try and make the .dts file as obviously readable as
> > possible.
> > 
> > Perhaps "remote-port" or "connected-port" would be sufficiently descriptive.
> 
> I like remote-port better than the already proposed remote-link.

Yes, remote-port sounds better, than remote-link, but might be more 
difficult to correlate with the fact, that the phandle value of this 
property points to a link DT node, and not to a port.

Thanks
Guennadi

> > (and yes, I know I'm probably bike-shedding now).
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
