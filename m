Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43159 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3JKHoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 03:44:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Andrzej Hajda <a.hajda@samsung.com>,
	"Kim, Milo" <Milo.Kim@ti.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"hj210.choi@samsung.com" <hj210.choi@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [RFC 0/2] V4L2 API for exposing flash subdevs as LED class device
Date: Fri, 11 Oct 2013 09:45 +0200
Message-ID: <3237757.RTKJthVZ2l@avalon>
In-Reply-To: <CAK5ve-LLkGtG9hVcsJgbgT+O-rdhOLNEw-eONSbJWs7aNJ0NOQ@mail.gmail.com>
References: <1367832828-30771-1-git-send-email-a.hajda@samsung.com> <20130521105436.GB2041@valkosipuli.retiisi.org.uk> <CAK5ve-LLkGtG9hVcsJgbgT+O-rdhOLNEw-eONSbJWs7aNJ0NOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

On Thursday 10 October 2013 17:07:22 Bryan Wu wrote:
> On Tue, May 21, 2013 at 3:54 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Tue, May 21, 2013 at 10:34:53AM +0200, Andrzej Hajda wrote:
> >> On 12.05.2013 23:12, Sakari Ailus wrote:
> >> > On Wed, May 08, 2013 at 09:32:17AM +0200, Andrzej Hajda wrote:
> >> >> On 07.05.2013 17:07, Laurent Pinchart wrote:
> >> >>> On Tuesday 07 May 2013 02:11:27 Kim, Milo wrote:
> >> >>>> On Monday, May 06, 2013 6:34 PM Andrzej Hajda wrote:
> >> >>>>> This RFC proposes generic API for exposing flash subdevices via LED
> >> >>>>> framework.
> >> >>>>> 
> >> >>>>> Rationale
> >> >>>>> 
> >> >>>>> Currently there are two frameworks which are used for exposing LED
> >> >>>>> flash to user space:
> >> >>>>> - V4L2 flash controls,
> >> >>>>> - LED framework(with custom sysfs attributes).
> >> >>>>> 
> >> >>>>> The list below shows flash drivers in mainline kernel with initial
> >> >>>>> commit date and typical chip application (according to producer):
> >> >>>>> 
> >> >>>>> LED API:
> >> >>>>>     lm3642: 2012-09-12, Cameras
> >> >>>>>     lm355x: 2012-09-05, Cameras
> >> >>>>>     max8997: 2011-12-14, Cameras (?)
> >> >>>>>     lp3944: 2009-06-19, Cameras, Lights, Indicators, Toys
> >> >>>>>     pca955x: 2008-07-16, Cameras, Indicators (?)
> >> >>>>> 
> >> >>>>> V4L2 API:
> >> >>>>>     as3645a:  2011-05-05, Cameras
> >> >>>>>     adp1653: 2011-05-05, Cameras
> >> >>>>> 
> >> >>>>> V4L2 provides richest functionality, but there is often demand from
> >> >>>>> application developers to provide already established LED API. We
> >> >>>>> would like to have an unified user interface for flash devices.
> >> >>>>> Some of devices already have the LED API driver exposing limited
> >> >>>>> set of a Flash IC functionality. In order to support all required
> >> >>>>> features the LED API would have to be extended or the V4L2 API
> >> >>>>> would need to be used. However when switching from a LED to a V4L2
> >> >>>>> Flash driver existing LED API interface would need to be retained.
> >> >>>>> 
> >> >>>>> Proposed solution
> >> >>>>> 
> >> >>>>> This patch adds V4L2 helper functions to register existing V4L2
> >> >>>>> flash subdev as LED class device. After registration via
> >> >>>>> v4l2_leddev_register appropriate entry in /sys/class/leds/ is
> >> >>>>> created. During registration all V4L2 flash controls are enumerated
> >> >>>>> and corresponding attributes are added.
> >> >>>>> 
> >> >>>>> I have attached also patch with new max77693-led driver using
> >> >>>>> v4l2_leddev. This patch requires presence of the patch "max77693:
> >> >>>>> added device tree support":
> >> >>>>> https://patchwork.kernel.org/patch/2414351/ .
> >> >>>>> 
> >> >>>>> Additional features
> >> >>>>> 
> >> >>>>> - simple API to access all V4L2 flash controls via sysfs,
> >> >>>>> - V4L2 subdevice should not be registered by V4L2 device to use it,
> >> >>>>> - LED triggers API can be used to control the device,
> >> >>>>> - LED device is optional - it will be created only if V4L2_LEDDEV
> >> >>>>>   configuration option is enabled and the subdev driver calls
> >> >>>>>   v4l2_leddev_register.
> >> >>>>> 
> >> >>>>> Doubts
> >> >>>>> 
> >> >>>>> This RFC is a result of a uncertainty which API developers should
> >> >>>>> expose by their flash drivers. It is a try to gluing together both
> >> >>>>> APIs. I am not sure if it is the best solution, but I hope there
> >> >>>>> will be some discussion and hopefully some decisions will be taken
> >> >>>>> which way we should follow.
> >> >>>> 
> >> >>>> The LED subsystem provides similar APIs for the Camera driver.
> >> >>>> With LED trigger event, flash and torch are enabled/disabled.
> >> >>>> I'm not sure this is applicable for you.
> >> >>>> Could you take a look at LED camera trigger feature?
> >> >>>> 
> >> >>>> For the camera LED trigger,
> >> >>>> https://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git
> >> >>>> /commit/ ?h=f or-next&id=48a1d032c954b9b06c3adbf35ef4735dd70ab757
> >> >>>> 
> >> >>>> Example of camera flash driver,
> >> >>>> https://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git
> >> >>>> /commit/ ?h=f or-next&id=313bf0b1a0eaeaac17ea8c4b748f16e28fce8b7a
> >> >>> 
> >> >>> I think we should decide on one API. Implementing two APIs for a
> >> >>> single device is usually messy, and will result in different feature
> >> >>> sets (and different bugs) being implemented through each API,
> >> >>> depending on the driver. Interactions between the APIs are also a
> >> >>> pain point on the kernel side to properly synchronize calls.
> >> > 
> >> > I don't like having two APIs either. Especially we shouldn't have
> >> > multiple drivers implementing different APIs for the same device.
> >> > 
> >> > That said, I wonder if it's possible to support camera-related use
> >> > cases using the LED API: it's originally designed for quite different
> >> > devices. Even if you could handle flash strobing using the LED API, the
> >> > functionality provided by the Media controller and subdev APIs will
> >> > always be missing: device enumeration and association with the right
> >> > camera.
> >> 
> >> Is there a generic way to associate flash and camera subdevs in
> >> current V4L2 API? The only ways I see now are:
> >> - both belongs to the same media controller, but this is not enough if
> >> there is more than one camera subdev in that controller,
> > 
> > Yes, there is. That's the group_id field in struct media_entity_desc. The
> > lens subdev is associated to the rest of the devices the same way.
> > 
> >> - using media links/pads - at first sight it seems to be
> >> overkill/abuse...
> > 
> > No. Links describe the flow of data, not relations between entities.
> > 
> > ...
> > 
> >> >>> The LED API is too limited for torch and flash usage, but I'm
> >> >>> definitely open to moving flash devices to the LED API is we can
> >> >>> extend it in a way that it covers all the use cases.
> >> >> 
> >> >> Extending LED API IMHO seems to be quite straightforward - by adding
> >> >> attributes for supported functionalities. We just need a specification
> >> >> for standard flash/torch attributes.
> >> >> I could prepare an RFC about it if there is a will to explore this
> >> >> direction.
> >> > 
> >> > I'm leaning towards providing a wrapper that provides torch
> >> > functionality using V4L2 flash API unless it's really proven to be
> >> > insane. ;-) The code supporting that in an individual flash driver
> >> > should be minimal --- which is what the patchset essentially already
> >> > does.
> >> 
> >> Providing only torch functionality do not require adding new attributes
> >> (besides the ones already present in the led_classdev), so the patch will
> >> be much simpler.
> > 
> > Yes. Attributes could be added later on to the LED API to support flash
> > and the wrapper could be extended accordingly. My thinking is however that
> > the main use case is torch, not strobing flash, so it would be fulfilled
> > already without extensions to the LED API.
> 
> Sorry for replying so late.
> 
> I think Milo Kim did some work in our LED subsystem by add LED Flash
> trigger for camera device. I agree it doesn't satisfy the usage of
> V4L2 Flash API and what I'm thinking about is expanding the LED Flash
> trigger driver to export a well defined sysfs interface, so user space
> libv4l2 can wrap it for applications.

I've replied to your comment in the media-summit agenda mail thread, but the 
discussion belongs here, so here's a repost. Let's try to keep replies in this 
mail thread.

The biggest reason why we're not fond of sysfs-based APIs for media devices is 
that they can't provide atomicity. There's no way to set multiple parameters 
in a single operation.

We can't get rid of the sysfs LEDs API, but maybe we could have a unified 
kernel LED/flash subsystem that would provide both a sysfs-based API to ensure 
compatibility with current userspace software and an ioctl-based API (possibly 
through V4L2 controls). That way LED/flash devices would be registered with a 
single subsystem, and the corresponding drivers won't have to care about the 
API exposed to userspace. That would require a major refactoring of the in-
kernel APIs though.

-- 
Regards,

Laurent Pinchart

