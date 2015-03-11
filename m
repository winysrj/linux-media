Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39285 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbbCKSJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 14:09:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4] media: i2c: add support for omnivision's ov2659 sensor
Date: Wed, 11 Mar 2015 20:09:11 +0200
Message-ID: <1908816.bn3vefYTH3@avalon>
In-Reply-To: <20150311110443.GJ11954@valkosipuli.retiisi.org.uk>
References: <1425814407-22766-1-git-send-email-prabhakar.csengg@gmail.com> <20150311110443.GJ11954@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 11 March 2015 13:04:43 Sakari Ailus wrote:
> On Sun, Mar 08, 2015 at 11:33:27AM +0000, Lad Prabhakar wrote:
> > From: Benoit Parrot <bparrot@ti.com>
> > 
> > this patch adds support for omnivision's ov2659
> > sensor, the driver supports following features:
> > 1: Asynchronous probing
> > 2: DT support
> > 3: Media controller support
> > 
> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > ---
> > 
> >  Sorry quick new version, I need to get this merged for next
> >  merge window.
> >  
> >  Changes for v4:
> >  1: Renamed target frequency property to 'link-frequencies'
> >     as per Sakari's suggestion.
> >  
> >  2: Changed the copyright to "GPL v2"
> >  
> >  v3: https://patchwork.kernel.org/patch/5959401/
> >  v2: https://patchwork.kernel.org/patch/5859801/
> >  v1: https://patchwork.linuxtv.org/patch/27919/
> >  
> >  .../devicetree/bindings/media/i2c/ov2659.txt       |   38 +
> >  MAINTAINERS                                        |   10 +
> >  drivers/media/i2c/Kconfig                          |   11 +
> >  drivers/media/i2c/Makefile                         |    1 +
> >  drivers/media/i2c/ov2659.c                         | 1439 +++++++++++++++
> >  include/media/ov2659.h                             |   33 +
> >  6 files changed, 1532 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2659.txt
> >  create mode 100644 drivers/media/i2c/ov2659.c
> >  create mode 100644 include/media/ov2659.h
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov2659.txt
> > b/Documentation/devicetree/bindings/media/i2c/ov2659.txt new file mode
> > 100644
> > index 0000000..a655500
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/ov2659.txt
> > @@ -0,0 +1,38 @@
> > +* OV2659 1/5-Inch 2Mp SOC Camera
> > +
> > +The Omnivision OV2659 is a 1/5-inch SOC camera, with an active array size
> > of +1632H x 1212V. It is programmable through a SCCB. The OV2659 sensor
> > supports +multiple resolutions output, such as UXGA, SVGA, 720p. It also
> > can support +YUV422, RGB565/555 or raw RGB output formats.
> > +
> > +Required Properties:
> > +- compatible: Must be "ovti,ov2659"
> > +- reg: I2C slave address
> > +- clocks: reference to the xvclk input clock.
> > +- clock-names: should be "xvclk".
> > +- link-frequencies: target pixel clock frequency.
> > +
> > +For further reading on port node refer to
> > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +
> > +Example:
> > +
> > +	i2c0@1c22000 {
> > +		...
> > +		...
> > +		 ov2659@30 {
> > +			compatible = "ovti,ov2659";
> > +			reg = <0x30>;
> > +
> > +			clocks = <&clk_ov2659 0>;
> > +			clock-names = "xvclk";
> > +
> > +			port {
> > +				ov2659_0: endpoint {
> > +					remote-endpoint = <&vpfe_ep>;
> > +					link-frequencies = <70000000>;
> 
> link-frequencies = /bits/ 64 <70000000>;
> 
> > +				};
> > +			};
> > +		};
> > +		...
> > +	};

[snip]

> > new file mode 100644
> > index 0000000..487cb19
> > --- /dev/null
> > +++ b/include/media/ov2659.h
> > @@ -0,0 +1,33 @@
> > +/*
> > + * Omnivision OV2659 CMOS Image Sensor driver
> > + *
> > + * Copyright (C) 2015 Texas Instruments, Inc.
> > + *
> > + * Benoit Parrot <bparrot@ti.com>
> > + * Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > + *
> > + * This program is free software; you may redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + */
> > +
> > +#ifndef OV2659_H
> > +#define OV2659_H
> > +
> > +/**
> > + * struct ov2659_platform_data - ov2659 driver platform data
> > + * @link_frequency: target pixel clock frequency
> > + */
> > +struct ov2659_platform_data {
> > +	unsigned int link_frequency;
> 
> Shouldn't you have xvclk_frequency here as well? In most cases you need to
> set explicitly to a certain value in order to achieve the required link
> frequency.

I'm not sure about that. In the DT case setting the xvclk clock frequency is 
done outside of the driver (through assigned-clock-rates for instance). 
Wouldn't it make sense to apply the same logic for non-DT platforms and let 
the platform configure the clock ?

> > +};
> > +#endif /* OV2659_H */

-- 
Regards,

Laurent Pinchart

