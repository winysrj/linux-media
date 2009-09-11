Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39048 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZIKG3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 02:29:22 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 11 Sep 2009 11:59:21 +0530
Subject: RE: RFCv2: Media controller proposal
Message-ID: <19F8576C6E063C45BE387C64729E73940436BA5067@dbde02.ent.ti.com>
References: <200909100913.09065.hverkuil@xs4all.nl>
 <200909102227.12340.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE401550D0873@dlee06.ent.ti.com>
 <200909110820.51421.hverkuil@xs4all.nl>
In-Reply-To: <200909110820.51421.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hans Verkuil
> Sent: Friday, September 11, 2009 11:51 AM
> To: Karicheri, Muralidharan
> Cc: Patrick Boettcher; Linux Media Mailing List
> Subject: Re: RFCv2: Media controller proposal
> 
> On Friday 11 September 2009 01:08:30 Karicheri, Muralidharan wrote:
> >
> > Hans,
> >
> > Thanks for your reply..
> > >>
> > >>
<snip>

> >
> > Right. That case (2 above) is easily taken care by v4l2 device
> driver. We used FBDev driver to drive OSD Layer because that way
> VPBE can be used by user space applications like x-windows? What is
> the alternative for this?
> > Is there a example v4l2 device using OSD like hardware and running
> x-windows or other traditional graphics application? I am not aware
> of any and the solution seems to be the right one here.
> >
> > So the solution we used (case 3)involves FBDev to drive the OSD
> layers and V4L2 to drive the video layer.
> 
> As usual, ivtv is doing all that. The ivtv driver is the main
> controller of
> the hardware. The ivtvfb driver provides the FB API towards the OSD.
> The
> X driver for the OSD is available here:
> 
> http://dl.ivtvdriver.org/xf86-video-ivtv/archive/1.0.x/xf86-video-
> ivtv-1.0.2.tar.gz
> 
> This is the way to handle it.
> 
> >
> > >
> > >This is very similar to the ivtv and ivtvfb drivers: if the
> framebuffer is
> > >in
> > >use, then you cannot change the output standard (you'll get an
> EBUSY error)
> > >through a video device node.
> > >
> >
> > Does the ivtvfb and ivtv works with the same set of v4l2 sub
> devices for output? In our case, VPBE can work with any sub device
> that can accept a BT.656/BT1120/RGB bus interface. So the FBDev
> device and V4L2 device( either as standalone device or as co-
> existent device) should work with the same set of sub devices. So
> the question is, how both these bridge device can work on the same
> sub device? If both can work with the same sub device, then what you
> say is true and can be handled. That is the reason we used the
> sysfs/Encoder manager as explained in my earlier email.
> 
> Look at ivtvfb.c (it's in media/video/ivtv). The ivtvfb_init
> function will just
[Hiremath, Vaibhav] I think our mail crossed each other.

Interesting, and is something new for me. Let me understand the implementation here first then I can provide some comments on this.

Thanks,
Vaibhav

> find any ivtv driver instances and register itself with them. Most
> of the
> hard work is actually done by ivtv and ivtvfb is just the front-end
> that
> implements the FB API. The video and OSD hardware is usually if not
> always
> so intertwined that it should be controlled by one driver, not two.
> 
> This way ivtv keeps full control over the sub-devices as well and
> all output
> changes will go to the same encoder, regardless of whether they
> originated
> from the fb or a video device node.
> 
> >
> > >That's exactly what you would expect. If the framebuffer isn't
> used, then
> > >you
> > >can just use the normal V4L2 API to change the output standard.
> > >
> > >In practice, I think that you can only change the resolution in
> the FB API.
> > >Not things like the framerate, let alone precise pixelclock,
> porch and sync
> > >widths.
> >
> >
> > There are 3 use cases
> >
> > 1) Pure FBDev device driving graphics to VPBE OSD layers -> sub
> devices -> Display (LCD/TV)
> >
> > 	This would require FBDev loading a required v4l2 the sub
> device (Not sure if FBDev community like this approach) and using it
> to drive the output. We will not be able to change the output. But
> output resolutions and timing can be controlled through fbset
> command which allow you to change pixel clock, porch, sync etc.
> 
> Bad idea. The fb API and framework is not really able to deal with
> the
> complexity of combined video and OSD devices. The v4l2 framework can
> (esp.
> when we have a media controller).
> 
> > 2)Pure V4L2 device driving video to VPBE video layers -> sub
> devices
> > ->Display (LCD/TV)
> > 	- No issues here
> >
> > 3)v4l2 and FBDev nodes co-exists. V4l2 drives video and FBDev
> drives OSD layers and the combined out ->VPBE ->sub devices ->
> Display (LCD/TV)
> > 	- Not sure which bridge device should load up and manage the
> sub devices. If V4l2 manages the sub devices, how FBDev driver can
> set the timings in the current sub device since it has no knowledge
> of the v4l2 device and the sub device it owns/manages.
> 
> You should not attempt to artificially separate the two. You can't
> since both
> v4l and fb share the same hardware. You need one v4l driver that
> will take
> care of both and the FB driver just delegates the core OSD low-level
> work to
> the v4l driver.
> 
> >
> > >
> > >Much better to let the two cooperate: you can use both APIs, but
> you can't
> > >change the resolution in the fb if streaming is going on, and you
> can't
> > >change the output standard of a video device node if that changes
> the
> > >resolution while the framebuffer is in used.
> > That is what I mean by use case 3). We can live with the
> restriction. But sub device model currently is v4l2 specific and I
> am not sure if there is a way same sub device can be accessed by
> both bridge devices. Any help here is appreciated.
> >
> > >
> > >No need for additional sysfs entries.
> > >
> >
> > If we can use sub devices framework, we wouldn't need sysfs
> >
> > >>
> > >> There is an encoder manager to which all available encoders
> registers
> > >(using internally developed interface) and based on commands
> received at
> > >Fbdev/sysfs interfaces, the current encoder is selected by the
> encoder
> > >manager and current standard is selected. The encoder manager
> provides API
> > >to retrieve current timing information from the current encoder.
> FBDev and
> > >V4L2 drivers uses this API to configure OSD/video layers for
> streaming.
> > >>
> > >> As you can see, controlling output/mode is a common function
> required for
> > >both v4l2 and FBDev devices.
> > >>
> > >> One way to do this to modify the encoder manager such that it
> load up the
> > >encoder sub devices. This will allow our customers to migrate to
> this
> > >driver on GIT kernel with minimum effort. If v4l2 display bridge
> driver
> > >load up the sub devices, it will make FBDev driver useless unless
> media
> > >controller has some way to handle this scenario. Any idea if
> media
> > >controller RFC address this? I will go over the RFC in details,
> but if you
> > >have a ready answer, let me know.
> > >
> > >I don't think this has anything to do with the media controller.
> It sounds
> > >more like a driver design issue to me.
> > >
> > Not really :(
> >
> > When we talk about media controller, it should allow multiple
> > streaming nodes to work with the same output or multiple outputs
> right? Here an entity can have FB device and V4L2 device nodes and
> both should be able
> > to stream onto the same output managed by a sub device.
> >
> > /dev/fb0    --> VPBE-OSD0 ->|-> VPBE ->analog output
> (NTSC/PAL/1080i/720P)
> > /dev/fb2    --> VPBE-OSD1 ->|        ->digital LCD port
> > 				    |		       -
> >BT.656/BT.1120/VGA/VISA->
> > 				    |                    -> encoders
> > /dev/video2 --> VPBE-VID0 ->|
> > /dev/video3 --> VPBE-VID1 ->|
> >
> > Current sub device frame work doesn't seems to work with this
> configuration.
> > Or Am I missing something? Is there an example of this
> implementation in ivtv or other platforms?
> 
> It's no problem as long as the v4l driver remains in control of both
> the
> video and OSD.
> 
> Regards,
> 
> 	Hans
> 
> >
> > Murali
> > >Regards,
> > >
> > >	Hans
> > >
> > >--
> > >Hans Verkuil - video4linux developer - sponsored by TANDBERG
> Telecom
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

