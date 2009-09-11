Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2387 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbZIKGfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 02:35:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: RFCv2: Media controller proposal
Date: Fri, 11 Sep 2009 08:35:42 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909100913.09065.hverkuil@xs4all.nl> <19F8576C6E063C45BE387C64729E73940436BA504E@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436BA504E@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909110835.42799.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 11 September 2009 08:16:34 Hiremath, Vaibhav wrote:
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Hans Verkuil
> > Sent: Thursday, September 10, 2009 12:43 PM
> > To: linux-media@vger.kernel.org
> > Subject: RFCv2: Media controller proposal
> >
> > Hi all,
> >
> > Here is the new Media Controller RFC. It is completely rewritten
> > from the
> > original RFC. This original RFC can be found here:
> >
> > http://www.archivum.info/video4linux-list%40redhat.com/2008-
> > 07/00371/RFC:_Add_support_to_query_and_change_connections_inside_a_m
> > edia_device
> >
> [Hiremath, Vaibhav] I could see implementation has changed/evolved a lot here from last RFC.

Yes it has. The global idea remains the same, but at the time we didn't have
sub-devices and that is (not entirely accidentally) a perfect match for what
we need here.

> I added some quick comments below, try to provide more during weekend.
> 
> > This document will be the basis of the discussions during the
> > Plumbers
> > Conference in two weeks time.
> >
> > Open issue #3 is the main unresolved item, but I hope to come up
> > with something
> > during the weekend.
> >
> > Regards,
> >
> >       Hans
> >
> >
> > RFC: Media controller proposal
> >
> > Version 2.0
> >
> > Background
> > ==========
> >
> > This RFC is a new version of the original RFC that was written in
> > cooperation
> > with and on behalf of Texas Instruments about a year ago.
> >
> > Much work has been done in the past year to put the foundation in
> > place to
> > be able to implement a media controller and now it is time for this
> > updated
> > version. The intention is to discuss this in more detail during this
> > years
> > Plumbers Conference.
> >
> > Although the high-level concepts are the same as in the original
> > RFC, many
> > of the details have changed based on what was learned over the past
> > year.
> >
> > This RFC is based on the original discussions with Manjunath Hadli
> > from TI
> > last year, on discussions during a recent meeting between Laurent
> > Pinchart,
> > Guennadi Liakhovetski and myself, and on recent discussions with
> > Nokia.
> > Thanks to Sakari Ailus for doing an initial review of this RFC.
> >
> > One note regarding terminology: a 'board' is the name I use for the
> > SoC,
> > PCI or USB device that contains the video hardware. Each board has
> > its own
> > driver instance and its own v4l2_device struct. Originally I called
> > it
> > 'device', but that name is already used in too many places.
> >
> >
> > What is a media controller?
> > ===========================
> >
> > In a nutshell: a media controller is a new v4l device node that can
> > be used
> > to discover and modify the topology of the board and to give access
> > to the
> > low-level nodes (such as previewers, resizers, color space
> > converters, etc.)
> > that are part of the topology.
> >
> > It does not do any streaming, that is the exclusive domain of video
> > nodes.
> > It is meant purely for controlling a board as a whole.
> >
> >
> > Why do we need one?
> > ===================
> >
> > There are currently several problems that are impossible to solve
> > within the
> > current V4L2 API:
> >
> > 1) Discovering the various device nodes that are typically created
> > by a video
> > board, such as: video nodes, vbi nodes, dvb nodes, alsa nodes,
> > framebuffer
> > nodes, input nodes (for e.g. webcam button events or IR remotes).
> >
> > It would be very handy if an application can just open an
> > /dev/v4l/mc0 node
> > and be able to figure out where all the nodes are, and to be able to
> > figure
> > out what the capabilities of the board are (e.g. does it support
> > DVB, is the
> > audio going through a loopback cable or is there an alsa device, can
> > it do
> > compressed MPEG video, etc. etc.). Currently the end-user has no
> > choice but to
> > supply the device nodes manually.
> >
> [Hiremath, Vaibhav] I am still confused here, Can we take one common use case, for example say video board has one /de/fb0 and /dev/video0 along with that we have one node for media controller /dev/v4l/mc0
> 
> How are we interacting or talking to /dev/fb0 through media controller node?
> 
> I looked into your presentation you created for LPC I guess, but still I am not clear on this.

The media controller will just tell the application that there is a framebuffer
device and where that node can be found in /dev. In addition, it will show how
it is connected to some sub-device and possibly you can dynamically connect it
to another sub-device instead.

To access the actual framebuffer you still need to go to fbX. That will never
change. The media controller provides the high-level control you need to hook
an OSD up to different outputs for example.

This also means that the v4l driver should have knowledge of (and probably
implement) the OSD. See also the RFC thread with Murali.
 

<snip>

> > The idea is this:
> >
> > // Select a particular target entity
> > ioctl(mc, VIDIOC_S_SUBDEV, &entityID);
> > // Send S_FMT directly to that entity
> > ioctl(mc, VIDIOC_S_FMT, &fmt);
> > // Send a custom ioctl to that entity
> > ioctl(mc, VIDIOC_OMAP3_G_HISTOGRAM, &hist);
> >
> > This requires no API changes and is very easy to implement. One
> > problem is
> > that this is not thread-safe. We can either supply some sort of
> > locking
> > mechanism, or just tell the application programmer to do the locking
> > in the
> > application. I'm not sure what is the correct approach here. A
> > reasonable
> > compromise would be to store the target entity as part of the
> > filehandle.
> > So you can open the media controller multiple times and each handle
> > can set
> > its own target entity.

> [Hiremath, Vaibhav] I am not sure whether you thought of this or not, but I am trying to adjust this topology to fit standalone memory to memory drivers which we were talking some time back.
> 
> I believe with file handle approach we can achieve this functionality, for example -
> 
> User will open media controller and will set the target entity, and then with the help of custom IOCTL any way we are configuring al required parameters.
> 
> If you could remember we had stuck to some of the custom configuration parameters like coefficients and stuff, how to configure them? Can we standardize it?
> 
> I think here we can make use of custom IOCTL which is going through media controller to sub-device directly. for example -
> 
> // Send a custom ioctl to that entity
> ioctl(mc, VIDIOC_OMAP3_S_FILTCOEFF, &coeff);
> 
> Is that correct?

That's exactly the idea.

> All rest of the configuration like, input/output pixel configuration will still be happening through standard IOCTL.
> 
> We can achieve this by adding one more link,
> 
> One of original possible link -
> 
>                                         Media
>                                         Processor
>                                         |           |
> output device --> Decoder --> | Reszier | --> memory/encoder
>                                         |           |
> 
> New link required to be supported -
> 
>                                     Media
>                                     Processor
>                                    |           |
> output device (memory) --> | Reszier | --> memory
>                                    |           |
> 
> Please let me know your thoughts here.

Yes, that's correct. Basically you can hook up the output of the resizer to
either another sub-device (e.g. a colorspace converter) or to a video device
node to send the output to memory. It's just a matter of manipulating the
links.

Note that the media processor concept is no longer there. It has been replaced
by the sub-device concept. Pretty much the same purpose in the end, though.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
