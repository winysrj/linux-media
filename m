Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2JEJni (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 05:43:38 -0400
Date: Fri, 5 Oct 2012 11:43:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rob Herring <robherring2@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Philipp Zabel <pza@pengutronix.de>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
In-Reply-To: <506CA5F7.3060807@gmail.com>
Message-ID: <Pine.LNX.4.64.1210051119420.13761@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de> <506AF706.3090003@gmail.com>
 <Pine.LNX.4.64.1210021626220.15778@axis700.grange> <506CA5F7.3060807@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Oct 2012, Rob Herring wrote:

> On 10/02/2012 09:33 AM, Guennadi Liakhovetski wrote:
> > Hi Rob
> > 
> > On Tue, 2 Oct 2012, Rob Herring wrote:
> > 
> >> On 09/27/2012 09:07 AM, Guennadi Liakhovetski wrote:
> >>> This patch adds a document, describing common V4L2 device tree bindings.
> >>>
> >>> Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>> ---
> >>>  Documentation/devicetree/bindings/media/v4l2.txt |  162 ++++++++++++++++++++++
> >>>  1 files changed, 162 insertions(+), 0 deletions(-)
> >>>  create mode 100644 Documentation/devicetree/bindings/media/v4l2.txt
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/media/v4l2.txt b/Documentation/devicetree/bindings/media/v4l2.txt
> >>> new file mode 100644
> >>> index 0000000..b8b3f41
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/media/v4l2.txt
> >>> @@ -0,0 +1,162 @@
> >>> +Video4Linux Version 2 (V4L2)
> >>
> >> DT describes the h/w, but V4L2 is Linux specific. I think the binding
> >> looks pretty good in terms of it is describing the h/w and not V4L2
> >> components or settings. So in this case it's really just the name of the
> >> file and title I have issue with.
> > 
> > Hm, I see your point, then, I guess, you'd also like the file name 
> > changed. What should we use then? Just "video?" But there's already a 
> > whole directory Documentation/devicetree/bindings/video dedicated to 
> > graphics output (drm, fbdev). "video-camera" or "video-capture?" But this 
> > file shall also be describing video output. Use "video.txt" and describe 
> > inside what exactly this file is for?
> 
> Video output will probably have a lot of overlap with the graphics side.
> How about video-interfaces.txt?

Hm, that's a bit too vague for me. Somewhere on the outskirts of my mind 
I'm still considering making just one standard for both V4L2 and fbdev / 
DRM? Just yesterday we were discussing some common properties with what is 
being proposed in

http://www.mail-archive.com/linux-media@vger.kernel.org/index.html#53322

Still, I think, these two subsystems deserve two separate standards and 
should just try to re-use properties wherever that makes sense. 
video-stream seems a bit better, but this too is just a convention - 
talking about video cameras and TV output as video streaming devices and 
considering displays more static devices. In principle displays can be 
considered taking streaming data just as well as TV encoders. What if we 
just call this camera-tv.txt?

> >> One other comment below:
> >>
> >>> +
> >>> +General concept
> >>> +---------------
> >>> +
> >>> +Video pipelines consist of external devices, e.g. camera sensors, controlled
> >>> +over an I2C, SPI or UART bus, and SoC internal IP blocks, including video DMA
> >>> +engines and video data processors.
> >>> +
> >>> +SoC internal blocks are described by DT nodes, placed similarly to other SoC
> >>> +blocks. External devices are represented as child nodes of their respective bus
> >>> +controller nodes, e.g. I2C.
> >>> +
> >>> +Data interfaces on all video devices are described by "port" child DT nodes.
> >>> +Configuration of a port depends on other devices participating in the data
> >>> +transfer and is described by "link" DT nodes, specified as children of the
> >>> +"port" nodes:
> >>> +
> >>> +/foo {
> >>> +	port@0 {
> >>> +		link@0 { ... };
> >>> +		link@1 { ... };
> >>> +	};
> >>> +	port@1 { ... };
> >>> +};
> >>> +
> >>> +If a port can be configured to work with more than one other device on the same
> >>> +bus, a "link" child DT node must be provided for each of them. If more than one
> >>> +port is present on a device or more than one link is connected to a port, a
> >>> +common scheme, using "#address-cells," "#size-cells" and "reg" properties is
> >>> +used.
> >>> +
> >>> +Optional link properties:
> >>> +- remote: phandle to the other endpoint link DT node.
> >>
> >> This name is a little vague. Perhaps "endpoint" would be better.
> > 
> > "endpoint" can also refer to something local like in USB case. Maybe 
> > rather the description of the "remote" property should be improved?
> 
> remote-endpoint?

Sorry, I really don't want to pull in yet another term here. We've got 
ports and links already, now you're proposing to also use "endpoind." 
Until now everyone was happy with "remote," any more opinions on this?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
