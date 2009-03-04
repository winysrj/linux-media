Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3893 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbZCDVF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 16:05:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: sakari.ailus@maxwell.research.nokia.com
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
Date: Wed, 4 Mar 2009 22:05:45 +0100
Cc: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <5e9665e10903021848u328e0cd4m5186344be15b817@mail.gmail.com> <200903040839.48104.hverkuil@xs4all.nl> <49AED4DC.5050507@nokia.com>
In-Reply-To: <49AED4DC.5050507@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903042205.45486.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 March 2009 20:22:04 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Wednesday 04 March 2009 01:42:13 DongSoo(Nathaniel) Kim wrote:
> >> Thank you for your kind explanation Hans.
> >>
> >> Problem is omap3 camera subsystem is making device node for every int
> >> device attached to it.
> >
> > That's wrong. Multiple devices should only be created if they can all
> > be used at the same time. Otherwise there should be just one device
> > that uses S_INPUT et al to select between the inputs.
>
> There might be situations where multiple device nodes would be
> beneficial even if they cannot be used simultaneously in all cases.
>
> Currently the omap34xxcam camera driver creates one device per camera. A
> camera in this case contains an isp (or camera controller), image
> sensor, lens and flash. The properties like maximum frame rate or
> resolution of a camera are usually (almost) completely defined by those
> of the sensor, lens and flash. This affects also cropping capabilities.
>
> Several programs can access video devices simultaneously. What happens
> if another program switches the input when the first one doesn't expect
> it? The original user won't notice the change, instead of getting -EBUSY
> when trying to open the other video device.

It is actually quite common to be able to switch inputs using one program 
(e.g. v4l2-ctl) while another program also has the video node open. This 
will typically be used for debugging or experimenting. Depending on the 
hardware, switching inputs while capturing is in progress may or may not be 
allowed (the driver might just return -EBUSY in that case).

In addition the application can also call VIDIOC_S_PRIORITY to protect it 
against outside interference, provided the driver supports this ioctl.

As an aside: many applications don't use VIDIOC_S_PRIORITY since whether a 
driver implements it is hit-and-miss. As part of the new v4l2 framework I 
have a struct v4l2_fh planned that will integrate support of this ioctl in 
the framework, thus making it generic for all drivers. But this won't be 
available any time soon.

> In short, it's been just more clear to have one device per camera. There
> may be other reasons but these come to mind this time.

I very much disagree here. Having multiple devices ONLY makes sense if you 
can capture from them in parallel. This situation is really just a 
straightforward case of multiple inputs you have to choose from.

> > BTW, do I understand correctly that e.g. lens drivers also get their
> > own /dev/videoX node? Please tell me I'm mistaken! Since that would be
> > so very wrong.
>
> Yes, you're mistaken this time. :)
>
> The contents of a video devices are defined in platform data.
>
> > I hope that the conversion to v4l2_subdev will take place soon. You are
> > basically stuck in a technological dead-end :-(
>
> Making things working properly in camera and ISP drivers has taken much
> more time than was anticipated and v4l2_subdev framework has developed a
> lot during that time. You're right --- we'll start thinking of how and
> when to move to v4l2_subdev.

Just contact me if you have any questions, I'll be happy to help. If you 
think there are missing bits in the framework, or find that you need to 
workaround some limitation, please contact me first. It might well be that 
I need to add something to support these devices, or that you should take a 
different approach instead. The sooner such issues are resolved, the less 
time you loose.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
