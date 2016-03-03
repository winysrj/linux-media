Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:53849 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075AbcCCRwt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 12:52:49 -0500
Date: Thu, 3 Mar 2016 18:52:45 +0100
From: Philippe De Muyter <phdm@macq.eu>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
Message-ID: <20160303175245.GA20427@frolo.macqel>
References: <20160223114943.GA10944@frolo.macqel> <20160223141258.GA5097@frolo.macqel> <4956050.OLrYA1VK2G@avalon> <56D79B49.50009@mentor.com> <56D7E59B.6050605@xs4all.nl> <20160303083643.GA4303@frolo.macqel> <56D87824.8000707@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56D87824.8000707@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 03, 2016 at 09:45:08AM -0800, Steve Longerbeam wrote:
> Hi Philippe,
> 
> On 03/03/2016 12:36 AM, Philippe De Muyter wrote:
> >
> > Just to be sure : do you mean  https://github.com/slongerbeam/mediatree.git
> > or something else ?
> 
> Sorry, yes I meant https://github.com/slongerbeam/mediatree.git.
> 
> >
> >>> So far I have retested video capture with the SabreAuto/ADV7180 and
> >>> the SabreSD/OV5640-mipi-csi2, and video capture is working fine on
> >>> those platforms.
> >>>
> >>> There is also a mem2mem that should work fine, but haven't tested yet.
> >>>
> >>> I removed camera preview support. At Mentor Graphics we have made
> >>> quite a few changes to ipu-v3 driver to allow camera preview to initialize
> >>> and control an overlay display plane independently of imx-drm, by adding
> >>> a subsystem independent ipu-plane sub-unit. Note we also have a video
> >>> output overlay driver that also makes use of ipu-plane. But those changes are
> >>> extensive and touch imx-drm as well as ipu-v3, so I am leaving camera preview
> >>> and the output overlay driver out (in fact, camera preview is not of much
> >>> utility so I probably won't bring it back in upstream version).
> >>>
> >>> The video capture driver is not quite ready for upstream review yet. It still:
> >>>
> >>> - uses the old cropping APIs but should move forward to selection APIs.
> >>>
> >>> - uses custom sensor subdev drivers for ADV7180 and OV564x. Still
> >>>   need to switch to upstream subdevs.
> > Is it only a problem of those sensor drivers (which exact files ?) or
> > is it a problem of the capture driver itself ?
> 
> The camera interface driver (drivers/staging/media/imx6/capture/mx6-camif.c)
> is binding to these subdevs:
> 
> drivers/staging/media/imx6/capture/adv7180.c
> drivers/staging/media/imx6/capture/ov5642.c
> drivers/staging/media/imx6/capture/ov5640-mipi.c
> 
> But instead should use the subdevs under drivers/media/i2c, specifically:
> 
> drivers/media/i2c/adv7180.c (and adding whatever standard subdev features
> the imx6 interface driver requires).
> 
> There is a drivers/media/i2c/soc_camera/ov5642.c, but there is no mipi-csi2
> capable subdev for the ov5640 with the mipi-csi2 interface, so that would have
> to be created.
> 
> 
> 
> > I must update a sensor driver I wrote for the intdev interface found
> > in the freescale kernel, and I'd like to start from a working subdev
> > example.  Which driver should I choose as an example ?
> 
> There's lots of good examples under drivers/media/i2c/.

OK.  Thank you

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
