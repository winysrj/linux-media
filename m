Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41760 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1KJVBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 16:01:44 -0500
Date: Thu, 10 Nov 2011 23:01:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com
Subject: Re: [RFC] SUBDEV_S/G_SELECTION IOCTLs
Message-ID: <20111110210138.GR22159@valkosipuli.localdomain>
References: <20111108215514.GJ22159@valkosipuli.localdomain>
 <4EBBBC16.2030303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBBBC16.2030303@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the comments!

On Thu, Nov 10, 2011 at 12:57:10PM +0100, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 11/08/2011 10:55 PM, Sakari Ailus wrote:
> > Hi all,
> > 
> > This RFC discusses the SUBDEV_S_SELECTION/SUBDEV_G_SELECTION API which is
> > intended to amend and replace the existing SUBDEV_[SG]_CROP API. These
> > IOCTLs have previously been discussed in the Cambridge V4L2 brainstorming
> > meeting [0] and their intent is to provide more configurability for subdevs,
> > including cropping on the source pads and composing for a display.
> > 
> > The S_SELECTION patches for V4L2 nodes are available here [1] and the
> > existing documentation for the V4L2 subdev pad format configuration can be
> > found in [2].
> > 
> > SUBDEV_[SG]_SELECTION is intended to fully replace SUBDEV_[SG]_CROP in
> > drivers as the latter can be implemented in SUBDEV_[SG]_SELECTION using
> > active CROP target on sink pads. That can be done in v4l2-ioctl.c so drivers
> > only will need to implement SUBDEV_[SG]_SELECTION.
> > 
> > 
> > Questions, comments and thoughts are welcome, especially regarding new use
> > cases.
> > 
> > 
> > Order of configuration
> > ======================
> > 
> > The proposed order of the subdev configuration is as follows. Individual
> > steps may be omitted since any of the steps will reset the rectangles /
> > sizes for any following step.
> > 
> > 1. SUBDEV_S_FMT on the SINK pad. The user will issue SUBDEV_S_FMT to set the
> > subdev sink pad image size and media bus format code and other parameters in
> > v4l2_mbus_framefmt as necessary.
> > 
> > 2. SUBDEV_S_SELECTION with CROP target on the SINK pad. The crop rectangle
> > is set related to the image size given in step 1).
> > 
> > 3. SUBDEV_S_SELECTION with COMPOSE target on the SINK pad. The size of the
> > compose rectangle, if it differs from the size of the rectangle given in 2),
> > signifies user's wish to perform scaling.
> > 
> > 4. SUBDEV_S_SELECTION with CROP target on the SOURCE pad. Configure cropping
> > performed by the subdev after scaling.
> > 
> > 5. SUBDEV_S_SELECTION with COMPOSE target on the SOURCE pad. This configures
> > composition on the display if relevant for the subdevice. (In this case the
> > COMPOSE bounds will yield to the size of the display.)
> > 
> > 6. SUBDEV_S_FMT on the SOURCE pad. The size of the image is defined by
> > setting CROP on the SOURCE pad, so SUBDEV_S_FMT only has an effect of
> > changing other parameters than size.
> > 
> > As defined in [2], when performing any of the configuration phases above,
> > the formats and selections are reset to defaults from each phase onwards.
> > For example, SUBDEV_S_SELECTION with CROP target on the SINK pad will
> > --- beyond its obvious function of setting CROP selection target on the SINK
> > pad --- reset the COMPOSE selection target on SINK pad, as well as the CROP
> > selection target and format on the SOURCE pad.
> 
> I thought we agreed that the spec will not be enforcing resetting parameters
> to defaults from each phase onwards. Also I couldn't find anything explicitly
> telling this in [2]. Let's consider simple use case: video pipeline with image
> sensor, scaler, composer and DMA engine.
> Initially user performs the configuration in the above described order.
> Then video stream is started and user wants to change the area cropped at
> image sensor, which will then appear in the configured compose window. We assume
> the H/W supports changing crop window position during streaming.
> 
> We can't reset existing configuration below/after CROP phase at the scaler sink
> pad, because we want the compose window unchanged. 
> 
> I guess this is where we need the flag to disable propagating the configuration
> inside single subdev, don't we ?

Yes, the intent is to define one. See open question number 1.

I think a note of the behaviour must be added to the spec. It might have
been left open on purpose since no consensus had been reached on how to best
handle it.

I'll make the needed changes to the next version of the RFC.

> 
> [snip]
> 
> > Open questions
> > ==============
> > 
> > 1. Keep subdev configuration flag. In Cambourne meeting the case of the OMAP
> > 3 ISP resizer configuration dilemma was discussed, and the proposal was to
> > add a flag to disable propagating the configuration inside a single subdev.
> > Propagating inside a single subdev is the default. Where do we need this
> > flag; is just SUBDEV_S_SELECTION enough? [0]
> > 
> > 2. Are PADDED targets relevant for media bus formats? [3]
> > 
> > 
> > References
> > ==========
> > 
> > [0] http://www.mail-archive.com/linux-media@vger.kernel.org/msg35361.html
> > 
> > [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36206.html
> > 
> > [2] http://hverkuil.home.xs4all.nl/spec/media.html#subdev
> > 
> > [3] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36203.html
> 
> ---
> Regards,
> Sylwester

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
