Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36512 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762Ab3EGCMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 22:12:00 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrzej Hajda <a.hajda@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"hj210.choi@samsung.com" <hj210.choi@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [RFC 0/2] V4L2 API for exposing flash subdevs as LED class
 device
Date: Tue, 7 May 2013 02:11:27 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5C879@DQHE06.ent.ti.com>
References: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

> -----Original Message-----
> From: linux-leds-owner@vger.kernel.org [mailto:linux-leds-
> owner@vger.kernel.org] On Behalf Of Andrzej Hajda
> Sent: Monday, May 06, 2013 6:34 PM
> To: linux-media@vger.kernel.org; linux-leds@vger.kernel.org;
> devicetree-discuss@lists.ozlabs.org
> Cc: Laurent Pinchart; Sylwester Nawrocki; Sakari Ailus; Kyungmin Park;
> hj210.choi@samsung.com; sw0312.kim@samsung.com; Bryan Wu; Richard
> Purdie; Andrzej Hajda
> Subject: [RFC 0/2] V4L2 API for exposing flash subdevs as LED class
> device
> 
> This RFC proposes generic API for exposing flash subdevices via LED
> framework.
> 
> Rationale
> 
> Currently there are two frameworks which are used for exposing LED
> flash to
> user space:
> - V4L2 flash controls,
> - LED framework(with custom sysfs attributes).
> 
> The list below shows flash drivers in mainline kernel with initial
> commit date
> and typical chip application (according to producer):
> 
> LED API:
>     lm3642: 2012-09-12, Cameras
>     lm355x: 2012-09-05, Cameras
>     max8997: 2011-12-14, Cameras (?)
>     lp3944: 2009-06-19, Cameras, Lights, Indicators, Toys
>     pca955x: 2008-07-16, Cameras, Indicators (?)
> V4L2 API:
>     as3645a:  2011-05-05, Cameras
>     adp1653: 2011-05-05, Cameras
> 
> V4L2 provides richest functionality, but there is often demand from
> application
> developers to provide already established LED API.
> We would like to have an unified user interface for flash devices. Some
> of
> devices already have the LED API driver exposing limited set of a Flash
> IC
> functionality. In order to support all required features the LED API
> would
> have to be extended or the V4L2 API would need to be used. However when
> switching from a LED to a V4L2 Flash driver existing LED API interface
> would
> need to be retained.
> 
> Proposed solution
> 
> This patch adds V4L2 helper functions to register existing V4L2 flash
> subdev
> as LED class device.
> After registration via v4l2_leddev_register appropriate entry in
> /sys/class/leds/ is created.
> During registration all V4L2 flash controls are enumerated and
> corresponding
> attributes are added.
> 
> I have attached also patch with new max77693-led driver using
> v4l2_leddev.
> This patch requires presence of the patch "max77693: added device tree
> support":
> https://patchwork.kernel.org/patch/2414351/ .
> 
> Additional features
> 
> - simple API to access all V4L2 flash controls via sysfs,
> - V4L2 subdevice should not be registered by V4L2 device to use it,
> - LED triggers API can be used to control the device,
> - LED device is optional - it will be created only if V4L2_LEDDEV
> configuration
>   option is enabled and the subdev driver calls v4l2_leddev_register.
> 
> Doubts
> 
> This RFC is a result of a uncertainty which API developers should
> expose by
> their flash drivers. It is a try to gluing together both APIs.
> I am not sure if it is the best solution, but I hope there will be some
> discussion and hopefully some decisions will be taken which way we
> should follow.

The LED subsystem provides similar APIs for the Camera driver.
With LED trigger event, flash and torch are enabled/disabled.
I'm not sure this is applicable for you.
Could you take a look at LED camera trigger feature?

For the camera LED trigger,
https://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git/commit/?h=f
or-next&id=48a1d032c954b9b06c3adbf35ef4735dd70ab757

Example of camera flash driver,
https://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git/commit/?h=f
or-next&id=313bf0b1a0eaeaac17ea8c4b748f16e28fce8b7a

Thanks,
Milo
