Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41881 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbZCDVqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 16:46:20 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
CC: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 4 Mar 2009 15:46:07 -0600
Subject: RE: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
Message-ID: <A24693684029E5489D1D202277BE89442E296E09@dlee02.ent.ti.com>
In-Reply-To: <200903042205.45486.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Wednesday, March 04, 2009 3:06 PM
> To: sakari.ailus@maxwell.research.nokia.com
> Cc: DongSoo(Nathaniel) Kim; Hiremath, Vaibhav; Toivonen Tuukka.O (Nokia-
> D/Oulu); Aguirre Rodriguez, Sergio Alberto; linux-omap@vger.kernel.org;
> Nagalla, Hari; linux-media@vger.kernel.org
> Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
> 
> On Wednesday 04 March 2009 20:22:04 Sakari Ailus wrote:
> > Hans Verkuil wrote:
> > > On Wednesday 04 March 2009 01:42:13 DongSoo(Nathaniel) Kim wrote:
> > >> Thank you for your kind explanation Hans.
> > >>
> > >> Problem is omap3 camera subsystem is making device node for every int
> > >> device attached to it.
> > >
> > > That's wrong. Multiple devices should only be created if they can all
> > > be used at the same time. Otherwise there should be just one device
> > > that uses S_INPUT et al to select between the inputs.
> >
> > There might be situations where multiple device nodes would be
> > beneficial even if they cannot be used simultaneously in all cases.
> >
> > Currently the omap34xxcam camera driver creates one device per camera. A
> > camera in this case contains an isp (or camera controller), image
> > sensor, lens and flash. The properties like maximum frame rate or
> > resolution of a camera are usually (almost) completely defined by those
> > of the sensor, lens and flash. This affects also cropping capabilities.
> >
> > Several programs can access video devices simultaneously. What happens
> > if another program switches the input when the first one doesn't expect
> > it? The original user won't notice the change, instead of getting -EBUSY
> > when trying to open the other video device.
> 
> It is actually quite common to be able to switch inputs using one program
> (e.g. v4l2-ctl) while another program also has the video node open. This
> will typically be used for debugging or experimenting. Depending on the
> hardware, switching inputs while capturing is in progress may or may not
> be
> allowed (the driver might just return -EBUSY in that case).
> 
> In addition the application can also call VIDIOC_S_PRIORITY to protect it
> against outside interference, provided the driver supports this ioctl.
> 
> As an aside: many applications don't use VIDIOC_S_PRIORITY since whether a
> driver implements it is hit-and-miss. As part of the new v4l2 framework I
> have a struct v4l2_fh planned that will integrate support of this ioctl in
> the framework, thus making it generic for all drivers. But this won't be
> available any time soon.

As what I understand, we have 2 possible situations for multiple opens here:

Situation 1
 - Instance1: Select sensor 1, and Do queue/dequeue of buffers.
 - Instance2: If sensor 1 is currently selected, Begin loop requesting internally collected OMAP3ISP statistics (with V4L2 private based IOCTLs) for performing user-side Auto-exposure, Auto White Balance, Auto Focus algorithms. And Adjust gains (with S_CTRL) accordingly on sensor as a result.

Situation 2
 - Instance1: Select sensor1 as input. Begin streaming.
 - Instance2: Select sensor2 as input. Attempt to begin streaming.

So, if I understood right, on Situation 2, if you attempt to do a S_INPUT to sensor2 while capturing from sensor1, it should return a -EBUSY, right? I mean, the app should consciously make sure the input (sensor) is the correct one before performing any adjustments.

I think our current approach avoids the user to be constantly checking if the input is still the same before updating gains...

I'm not clear if this single-node idea is really helping the user to have a simpler usage in Situation 1, which I feel will become pretty common on this driver...

> 
> > In short, it's been just more clear to have one device per camera. There
> > may be other reasons but these come to mind this time.
> 
> I very much disagree here. Having multiple devices ONLY makes sense if you
> can capture from them in parallel. This situation is really just a
> straightforward case of multiple inputs you have to choose from.
> 
> > > BTW, do I understand correctly that e.g. lens drivers also get their
> > > own /dev/videoX node? Please tell me I'm mistaken! Since that would be
> > > so very wrong.
> >
> > Yes, you're mistaken this time. :)
> >
> > The contents of a video devices are defined in platform data.
> >
> > > I hope that the conversion to v4l2_subdev will take place soon. You
> are
> > > basically stuck in a technological dead-end :-(
> >
> > Making things working properly in camera and ISP drivers has taken much
> > more time than was anticipated and v4l2_subdev framework has developed a
> > lot during that time. You're right --- we'll start thinking of how and
> > when to move to v4l2_subdev.
> 
> Just contact me if you have any questions, I'll be happy to help. If you
> think there are missing bits in the framework, or find that you need to
> workaround some limitation, please contact me first. It might well be that
> I need to add something to support these devices, or that you should take
> a
> different approach instead. The sooner such issues are resolved, the less
> time you loose.
> 
> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

