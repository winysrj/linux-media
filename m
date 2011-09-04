Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60482 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1IDJAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2011 05:00:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Date: Sun, 4 Sep 2011 11:01:04 +0200
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Ravi, Deepthy" <deepthy.ravi@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com> <201108241525.47332.laurent.pinchart@ideasonboard.com> <4E62A872.7070808@infradead.org>
In-Reply-To: <4E62A872.7070808@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109041101.05028.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sunday 04 September 2011 00:21:38 Mauro Carvalho Chehab wrote:
> Em 24-08-2011 10:25, Laurent Pinchart escreveu:
> > On Wednesday 24 August 2011 14:19:01 Hiremath, Vaibhav wrote:
> >> On Wednesday, August 24, 2011 5:00 PM Laurent Pinchart wrote:
> >>> On Wednesday 24 August 2011 13:21:27 Ravi, Deepthy wrote:
> >>>> On Wed, Aug 24, 2011 at 4:47 PM, Laurent Pinchart wrote:
> >>>>> On Friday 19 August 2011 15:48:45 Deepthy Ravi wrote:
> >>>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
> >>>>>> 
> >>>>>> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
> >>>>>> option is disabled and if any sensor driver has to be used
> >>>>>> between MC and non MC framework compatible devices.
> >>>>>> 
> >>>>>> For example,if tvp514x video decoder driver migrated to
> >>>>>> MC framework is being built without CONFIG_MEDIA_CONTROLLER
> >>>>>> option enabled, the following error messages will result.
> >>>>>> drivers/built-in.o: In function `tvp514x_remove':
> >>>>>> drivers/media/video/tvp514x.c:1285: undefined reference to
> >>>>>> `media_entity_cleanup'
> >>>>>> drivers/built-in.o: In function `tvp514x_probe':
> >>>>>> drivers/media/video/tvp514x.c:1237: undefined reference to
> >>>>>> `media_entity_init'
> >>>>> 
> >>>>> If the tvp514x is migrated to the MC framework, its Kconfig option
> >>>>> should depend on MEDIA_CONTROLLER.
> >>>> 
> >>>> The same TVP514x driver is being used for both MC and non MC
> >>>> compatible devices, for example OMAP3 and AM35x. So if it is made
> >>>> dependent on MEDIA CONTROLLER, we cannot enable the driver for MC
> >>>> independent devices.
> >>> 
> >>> Then you should use conditional compilation in the tvp514x driver
> >>> itself. Or
> >> 
> >> No. I am not in favor of conditional compilation in driver code.
> > 
> > Actually, thinking some more about this, you should make the tvp514x
> > driver depend on CONFIG_MEDIA_CONTROLLER unconditionally. This doesn't
> > mean that the driver will become unusable by applications that are not
> > MC-aware. Hosts/bridges don't have to export subdev nodes, they can just
> > call subdev pad-level operations internally and let applications control
> > the whole device through a single V4L2 video node.
> > 
> >>> better, port the AM35x driver to the MC API.
> >> 
> >> Why should we use MC if I have very simple device (like AM35x) which
> >> only supports single path? I can very well use simple V4L2 sub-dev
> >> based approach (master - slave), isn't it?
> > 
> > The AM35x driver should use the in-kernel MC and V4L2 subdev APIs, but it
> > doesn't have to expose them to userspace.
> 
> I don't agree. If AM35x doesn't expose the MC API to userspace,
> CONFIG_MEDIA_CONTROLLER should not be required at all.
> 
> Also, according with the Linux best practices, when  #if tests for config
> symbols are required, developers should put it into the header files, and
> not inside the code, as it helps to improve code readability. From
> Documentation/SubmittingPatches:
> 
> 	2) #ifdefs are ugly
> 
> 	Code cluttered with ifdefs is difficult to read and maintain.  Don't do
> 	it.  Instead, put your ifdefs in a header, and conditionally define
> 	'static inline' functions, or macros, which are used in the code.
> 	Let the compiler optimize away the "no-op" case.
> 
> So, this patch is perfectly fine on my eyes.

I'm sorry, but I don't agree.

Regarding the V4L2 subdev pad-level API, the goal is to convert all host and 
subdev drivers to it, so that's definitely the way to go. This does *not* mean 
that subdevs must expose a subdev device node. That's entirely optional. What 
I'm talking about is switching from video::*_mbus_fmt operations to pad::*_fmt 
operations. The pad-level format operations are very similar to video-level 
format operations, and more generic. Drivers shouldn't implement both.

Regarding the MC API, drivers are not required to register a media_device 
instance. I have no issue with that. However, drivers should initialized the 
subdev's embedded media_entity, as that's required by subdev pad-level 
operations to get the number of pads for a subdev.

This will result in no modification to the userspace.

-- 
Regards,

Laurent Pinchart
