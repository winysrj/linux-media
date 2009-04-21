Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33517 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752849AbZDUMEL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 08:04:11 -0400
Date: Tue, 21 Apr 2009 14:04:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Ailus Sakari <sakari.ailus@nokia.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?iso-8859-1?Q?=B1=E8=C7=FC=C1=D8?= <riverful.kim@samsung.com>
Subject: Re: Applying SoC camera framework on multi-functional camera     
 interface
In-Reply-To: <39337.62.70.2.252.1240314423.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0904211359540.6551@axis700.grange>
References: <39337.62.70.2.252.1240314423.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Apr 2009, Hans Verkuil wrote:

> > Well, you might look at drivers/media/video/soc_camera_platform.c for an
> > example of a simple "pseudo" camera driver. Of course, with your two
> > additional devices you don't want to add extra platform devices and extra
> > probing. In fact, you can do this with the "old" (currently in the
> > mainline) soc-camera model, where client drivers actively report
> > themselves to the soc-camera core using soc_camera_device_register() /
> > soc_camera_device_unregister() and the core doesn't care about the nature
> > of those drivers. This is not going to be the case with the new platform /
> > v4l2-subdev infrastructure, which is pretty tightly bound to i2c... So,
> > we'll have to extend it too.
> 
> Not true. v4l2-device and v4l2-subdev are bus-independent. Only the
> v4l2-i2c-* helper functions in v4l2-common.c are i2c dependent. For
> example, ivtv uses v4l2_subdev to control devices connected via gpio,
> while cx18 uses it for a logical video decoder block on the main asic.
> 
> Other than initialization and possibly cleanup there should be NO
> bus-dependencies.

Sorry, what I wrote above wasn't clear enough. By "platform / v4l2-subdev 
infrastructure" I meant the current (as of my patch from a couple of hours 
ago) soc-camera - platform stack linked to v4l2-subdev the way it is 
implemented there. In that patch soc-camera uses the i2c interface of 
v4l2-subdev directly and is thus rather i2c-centric. So, we will have to 
extend soc-camera to also support the bus-neutral v4l2-subdev API.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
