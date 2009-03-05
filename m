Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3173 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZCEHjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 02:39:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
Date: Thu, 5 Mar 2009 08:39:26 +0100
Cc: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE89442E296F69@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E296F69@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903050839.26606.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 March 2009 00:30:24 Aguirre Rodriguez, Sergio Alberto wrote:
> > -----Original Message-----
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: Wednesday, March 04, 2009 4:45 PM
> > To: Aguirre Rodriguez, Sergio Alberto
> > Cc: sakari.ailus@maxwell.research.nokia.com; DongSoo(Nathaniel) Kim;
> > Hiremath, Vaibhav; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
> > omap@vger.kernel.org; Nagalla, Hari; linux-media@vger.kernel.org
> > Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
> >
> > On Wednesday 04 March 2009 22:46:07 Aguirre Rodriguez, Sergio Alberto
> >
> > wrote:
> > > > -----Original Message-----
> > > > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > > > Sent: Wednesday, March 04, 2009 3:06 PM
> > > > To: sakari.ailus@maxwell.research.nokia.com
> > > > Cc: DongSoo(Nathaniel) Kim; Hiremath, Vaibhav; Toivonen Tuukka.O
> > > > (Nokia- D/Oulu); Aguirre Rodriguez, Sergio Alberto;
> > > > linux-omap@vger.kernel.org; Nagalla, Hari;
> > > > linux-media@vger.kernel.org Subject: Re: [REVIEW PATCH 11/14]
> > > > OMAP34XXCAM: Add driver
> > > >
> > > > On Wednesday 04 March 2009 20:22:04 Sakari Ailus wrote:
> > > > > Hans Verkuil wrote:
> > > > > > On Wednesday 04 March 2009 01:42:13 DongSoo(Nathaniel) Kim 
wrote:
> > > > > >> Thank you for your kind explanation Hans.
> > > > > >>
> > > > > >> Problem is omap3 camera subsystem is making device node for
> > > > > >> every int device attached to it.
> > > > > >
> > > > > > That's wrong. Multiple devices should only be created if they
> > > > > > can all be used at the same time. Otherwise there should be
> > > > > > just one device that uses S_INPUT et al to select between the
> > > > > > inputs.
> > > > >
> > > > > There might be situations where multiple device nodes would be
> > > > > beneficial even if they cannot be used simultaneously in all
> > > > > cases.
> > > > >
> > > > > Currently the omap34xxcam camera driver creates one device per
> > > > > camera. A camera in this case contains an isp (or camera
> > > > > controller), image sensor, lens and flash. The properties like
> > > > > maximum frame rate or resolution of a camera are usually (almost)
> > > > > completely defined by those of the sensor, lens and flash. This
> > > > > affects also cropping capabilities.
> > > > >
> > > > > Several programs can access video devices simultaneously. What
> > > > > happens if another program switches the input when the first one
> > > > > doesn't expect it? The original user won't notice the change,
> >
> > instead
> >
> > > > > of getting -EBUSY when trying to open the other video device.
> > > >
> > > > It is actually quite common to be able to switch inputs using one
> > > > program (e.g. v4l2-ctl) while another program also has the video
> > > > node open. This will typically be used for debugging or
> > > > experimenting. Depending on the hardware, switching inputs while
> > > > capturing is in progress may or may not be
> > > > allowed (the driver might just return -EBUSY in that case).
> > > >
> > > > In addition the application can also call VIDIOC_S_PRIORITY to
> > > > protect it against outside interference, provided the driver
> > > > supports this ioctl.
> > > >
> > > > As an aside: many applications don't use VIDIOC_S_PRIORITY since
> > > > whether a driver implements it is hit-and-miss. As part of the new
> >
> > v4l2
> >
> > > > framework I have a struct v4l2_fh planned that will integrate
> > > > support of this ioctl in the framework, thus making it generic for
> > > > all drivers. But this won't be available any time soon.
> > >
> > > As what I understand, we have 2 possible situations for multiple
> > > opens here:
> > >
> > > Situation 1
> > >  - Instance1: Select sensor 1, and Do queue/dequeue of buffers.
> > >  - Instance2: If sensor 1 is currently selected, Begin loop
> > > requesting internally collected OMAP3ISP statistics (with V4L2
> > > private based
> >
> > IOCTLs)
> >
> > > for performing user-side Auto-exposure, Auto White Balance, Auto
> > > Focus algorithms. And Adjust gains (with S_CTRL) accordingly on
> > > sensor as a result.
> >
> > Question: if you have multiple sensors, and sensor 1 is selected, can
> > you still get statistics from sensor 2? Or is all this still limited to
> > the selected sensor? Just want to make sure I understand it all.
>
> Everytime a RAW10 Bayer formatted frame is received on the OMAP3ISP,
> statistics are being generated and when done, stored in buffers allocated
> internally on the driver (last 5 frames only), marking every stats buffer
> with the frame number associated.
>
> When requesting stats, the user needs to specify the frame number (since
> last streamon call) to the which he needs the statistics. Receives in
> return the associated buffer.
>
> So, going back to answering directly your question, the stats are related
> to the frame_number since last stream on call, making it impossible to
> request from one specific sensor.
>
> > > Situation 2
> > >  - Instance1: Select sensor1 as input. Begin streaming.
> > >  - Instance2: Select sensor2 as input. Attempt to begin streaming.
> > >
> > > So, if I understood right, on Situation 2, if you attempt to do a
> >
> > S_INPUT
> >
> > > to sensor2 while capturing from sensor1, it should return a -EBUSY,
> > > right?
> >
> > That is probably what the driver should do, yes. The V4L2 spec leaves
> > it up
> > to the driver whether you can switch inputs while a capture is in
> > progress. In this case I think it is perfectly reasonably for the
> > driver to return -EBUSY.
>
> Ok, makes sense.
>
> > > I mean, the app should consciously make sure the input (sensor) is
> > > the correct one before performing any adjustments.
> >
> > Can you elaborate? I don't follow this, I'm afraid.
>
> Normally an app already knows what are the capabilities/limitations for
> /dev/video0, and that wont change in our current approach, right?
> (Because video0 node always points to the same sensor)
>
> But with your suggested approach, if a switching happens, the
> capabilities could vary between sensors, and the app should need to re
> request capabilities everytime it attempts to adjust something. So this
> is the _consciousness_ I'm talking about.. (Constantly making sure of
> sensor capabilities before sending S_CTRL calls)
>
> Did I made myself clear?
>
> > > I think our current approach avoids the user to be constantly
> > > checking
> >
> > if
> >
> > > the input is still the same before updating gains...
> >
> > If I understand it correctly, the normal approach would be one
> > application that might have a separate thread to do the gain
> > adjustments, etc. Or do it
> > all in the same thread, for example by doing the adjustments after
> > every X frames captured. Doing this in two separate applications seems
> > awkward to me. Usually the streaming thread and the adjustment thread
> > need to communicate with one another or be directed from some the main
> > application.
>
> Hmm... Ok, got your point.
>
> I guess we can leave all responsibility of correct
> settings<->sensor association to the user app threads then.
>
> > > I'm not clear if this single-node idea is really helping the user to
> >
> > have
> >
> > > a simpler usage in Situation 1, which I feel will become pretty
> > > common
> >
> > on
> >
> > > this driver...
> >
> > The spec is pretty clear about this, and existing v4l2 applications
> > also expect this behavior. Also, suppose you have two video nodes, what
> > happens when you want to use the inactive node? How can you tell it is
> > inactive?
>
> Sorry, I think I'm not very clear on your intention...
>
> You mean that how can an app know if streaming is ongoing in a device
> node?
>
> If that's the case, then I think we'll need to have an IOCTL for knowing
> if the node is streaming or not.
>
> Please clarify.

You have two video nodes, one for each sensor. But only one is 'active' at a 
time (i.e. is the current omap input). How do you determine which one that 
is? And what happens when you set a format or control on the inactive one? 
All this is much easier if you use S_INPUT to select between inputs.

Note that changing the input using S_INPUT will have side-effects that the 
application should consider. The spec mentions it in passing:

"To select a video input applications store the number of the desired input 
in an integer and call the VIDIOC_S_INPUT ioctl with a pointer to this 
integer. Side effects are possible. For example inputs may support 
different video standards, so the driver may implicitly switch the current 
standard. It is good practice to select an input before querying or 
negotiating any other parameters."

This should be more prominent, since if you are dealing with e.g. a camera 
input and a composite video input, then changing inputs will also change 
the available formats, resolutions, controls, etc.

I think all existing v4l drivers with multiple inputs just choose between 
tuner, composite and S-Video in. There are no side-effects to speak of in 
that case, so omap is probably the first driver that will have to deal with 
this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
