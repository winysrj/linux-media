Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54283 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030345Ab2AFPpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 10:45:01 -0500
Date: Fri, 6 Jan 2012 17:44:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 1/2] v4l: Add new framesamples field to struct
 v4l2_mbus_framefmt
Message-ID: <20120106154455.GO9323@valkosipuli.localdomain>
References: <201112120131.24192.laurent.pinchart@ideasonboard.com>
 <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
 <1323865388-26994-2-git-send-email-s.nawrocki@samsung.com>
 <201112210120.56888.laurent.pinchart@ideasonboard.com>
 <20111226125301.GQ3677@valkosipuli.localdomain>
 <4EFB4D3D.1080105@gmail.com>
 <20111231131612.GE3677@valkosipuli.localdomain>
 <4F00AC43.6000905@gmail.com>
 <20120104122142.GB9323@valkosipuli.localdomain>
 <4F04D7D4.5050109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F04D7D4.5050109@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Jan 04, 2012 at 11:51:00PM +0100, Sylwester Nawrocki wrote:
> On 01/04/2012 01:21 PM, Sakari Ailus wrote:
> > On Sun, Jan 01, 2012 at 07:56:03PM +0100, Sylwester Nawrocki wrote:
> >> On 12/31/2011 02:16 PM, Sakari Ailus wrote:
> >>>>> Something else that should probably belong there is information on the frame
> >>>>> format: contrary to what I've previously thought, the sensor metadata is
> >>>>> often sent as part of the same CSI-2 channel. There also can be other types
> >>>>> of data, such as dummy data and data for black level calibration. I wouldn't
> >>>>> want to export all this to the user space --- it shouldn't probably need to
> >>>>> care about it.
> >>>>>
> >>>>> The transmitter of the data (sensor) has this information and the CSI-2
> >>>>> receiver needs it. Same for the framesamples, as far as I understand.
> >>>>
> >>>> We could try to design some standard data structure for frame metadata -
> >>>> that's how I understood the meaning of struct v4l2_mbus_framedesc.
> >>>> But I doubt such attempts will be sucessful. And how can we distinguish
> >>>> which data is valid and applicable when there is lots of weird stuff in one
> >>>> data structure ? Using media bus pixel code only ?
> >>>
> >>> I think the media bus pixel code which is exported to the user space should
> >>> not be involved with the metadata.
> >>
> >> Then we need to find some method to distinguish streams with metadata on the
> >> media bus, to be able to discard it before sending to user space.
> >> I assume this is where struct v4l2_mbus_framedesc and related ops would help ?
> > 
> > I'd think so.
> > 
> >> Maybe we could create v4l2_mbus_framedesc with length (framesamples) member
> >> in it and additionally 994 reserved bytes for future extensions ;-), e.g.
> >>
> >> struct v4l2_mbus_framedesc {
> >> 	unsigned int length;
> >> 	unsigned int rserved[994];
> >> };
> > 
> > Do we need to export this to the user space? In the first phase I'd like to
> 
> No, that wasn't my intention. The reserved field was supposed to be a joke,
> we of course don't need any reserved members in the kernel space.

Oh, I have to admit I missed the joke completely. ;)

> > keep that static (i.e. only get op would be supported) and only visible in
> > the kernel. That would leave much more room for changes later on, if needed.
> 
> I'd prefer it to be R/W, i.e. having both get and set ops available. Maybe
> not for all fields though.

I guess we should gather all the requirements and write and RFC based on the
findings. I know at least about three different scenarios:

- metadata as part of the image, receiver writes it to the same buffer,
- metadata as part of the image, receiver writes it to a different buffer and
- metadata arriver through a separate csi or ccp2 channel

All may include metadata at bottom and / or top of the image.

> >> struct v4l2_subdev_pad_ops {
> >> 	  ....
> >> 	int get_framedesc(int pad, struct v4l2_framedesc *fdesc);
> >> 	int set_framedesc(int pad, struct v4l2_framedesc fdesc);
> >> };
> >>
> >> This would ensure same media bus format code regardless of frame meta data
> >> presence.
> >>
> >> In case metadata is sent in same CSI channel, the required buffer length
> >> might be greater than what would width/height and pixel code suggest.
> > 
> > Partly for this reason we have g_skip_top_lines() op in sensor ops. It
> > instructs the receiver to discard the metadata, and possibly other data
> > which isn't as interesting --- could be just dummy.
> 
> I see.
> 
> > Some CSI-2 receivers are able to write this to a different memory location;
> > we could expose this as a different video node. I'm proposing a different
> > video node since this is a separate queue: the format (in-memory pixel
> > format and dimensions) is different, and it is beneficial to have access to
> > this data as soon as possible. There is a caveat, though, if we also wish to
> > support metadata which is appended to the frame, rather than prependeded.
> 
> I think it is recurring topic in our discussions, I guess nobody really needs
> it since it haven't been implemented yet. ;)

It is needed, especially if you have camera control algorithms in the user
space. You can get around it in some cases, but the end result isn't pretty
nor reliable.

> Multi-planar buffers were meant also for handling meta data, only variable
> number of planes support would need to be added. For instance the driver could
> pass only the buffer with meta data plane if required.

Multi-planar buffers are definitely a part of the solution when the metadata
is part of the same memory buffer.

What I think would be needed is separation of pixel formats of different
planes: we do not want to create new pixel format out of every possible
combination of metadata and pixel format.

> >>> The metadata is something that the user is likely interested only in the
> >>> form it is in the system memory. It won't be processed in any way before
> >>> it gets written to memory. The chosen mbus code may affect the format of the
> >>> metadata, but that's something the sensor driver knows  -- and I've yet to
> >>> see a case where the user could choose the desired metadata format.
> >>
> >>> Alternatively we could make the metadata path a separate path from the image
> >>> data. I wonder how feasible that approach would be --- the subdevs would
> >>> still be the same.
> >>
> >> I was also considering metadata as sensor specific data structure retrieved
> >> by the host after a frame has been captured and appending that data to a user
> >> buffer. For such buffers a separate fourcc would be needed.
> > 
> > Why after?
> 
> Because there is no way to retrieve it before ? :)
> 
> > There are benefits in getting this to the user space without extra delays?
> 
> It doesn't matter that much because image data is already post-processed.
> And the case I was mentioning was about still capture, asisted in the sensor
> (SoC).

Your use case is different and it might not make a difference in that one.
However, I'm thinking of camera control algorithms; they need to know how
the frame is exposes so they can program new setting for the sensor. To
avoid introducing unnecessary delays in the process, this needs to be done
as soon as possible.

> >>>>> Pixelrate is also used to figure out whether a pipeline can do streaming or
> >>>>> not; the pixel rate originating from the sensor could be higher than the
> >>>>> maximum of the ISP. For this reason, as well as for providing timing
> >>>>> information, access to pixelrate is reequired in the user space.
> >>>>>
> >>>>> Configuring the framesamples could be done on the sensor using a control if
> >>>>> necessary.
> >>>>
> >>>> Sure, that could work. But as I mentioned before, the host drivers would have
> >>>> to be getting such control internally from subdevs. Not so nice IMHO. Although
> >>>> I'm not in big opposition to that too.
> >>>>
> >>>> Grepping for v4l2_ctrl_g_ctrl() all the drivers appear to use it locally only.
> >>>
> >>> I don't think there's anything that really would prohibit doing this. There
> >>> would need to be a way for the host to make a control read-only, to prevent
> >>> changing framesamples while streaming.
> >>
> >> I would rather make subdev driver to ensure all negotiated paramaters, which
> >> changed during streaming could crash the system, stay unchanged after streaming
> >> started. It's as simple as checking entity stream_count in s_ctrl() and
> >> prohibiting change of control value if stream_count > 0.
> > 
> > That's easy, but the values of these controls could still change between
> > pipeline validation and stream startup: the sensor driver always will be the
> > last one to start streaming.
> 
> Are you sure ? The host first calls media_pipeline_start(), this increments
> stream_count on all subdevs, and only after that the host performs pipeline
> validation. At streamoff media_pipeline_stop() is called and the controls
> may be changed again. It only requires special treatment of stream_count
> at the subdevs.

Good point. The driver itself could make these controls return EBUSY.

> Btw, for setting controls busy the V4L2_CTRL_FLAG_GRABBED flag can be used.
> However, IMHO it shouldn't be the host's business to mess with its subdevs'
> control properties. If controls aren't inherited by the host and they belong
> to a subdev it's probably better to leave the low level control operations
> to the subdev driver only.

There is no other way in some cases I can see --- Scott Jiang had such a
case: the parallel receiver cannot tolerate changes to blanking while
streaming. All other such receivers can, so it definitely musn't be sensor's
decision to deny such changes.

> >>> Pad-specific controls likely require more work than this.
> >>
> >> Hym, I'd forgotten, the fact framesamples are per pad was an argument against
> >> using v4l2 control for this parameter. We still need per pad controls for the
> >> blanking controls, but for framesamples maybe it's better to just add subdev
> >> callback, as acessing this parameter on subdevs directly from space isn't
> >> really essential..
> > 
> > Blanking controls are subdev-specific, not pad-specific. In practice the
> > pixel array subdevs will always have just one pad, but there is still the
> > principal difference. :-)
> 
> Yeah, that makes sense. :-) Even in case when we have two output pads from
> a MIPI-CSI  transmitter, each for a separate channel, and per pad media bus
> formats the per pad blanking wouldn't rather make sense.

Should we have more pads in that case? There's still just a single bus...

> > Pixel rate could be another per-pad control. That might have to be checked
> > before stream startup, just like framesamples. That's information which is
> > mostly needed in the kernel space, but the user space still would sometimes
> > like to take a look at it. Giving the responsibility to the user to carry
> > the pixel rate through the whole pipeline without a way to even modify would
> > be is a little excessive.
> 
> But it's supposed to be read-only ? What would be a reason to propagate it then ?

It is read-only but it still has to be propagated. It is used to configure
subdevs along the pipeline, as well as to check the pixel rate isn't too
high for some of them.

If it is not propagated by the user, the subdevs that need the information
will never get it since no propagation will be done by the kernel.

> >>>>> Just my 5 euro cents. Perhaps we could discuss the topic on #v4l-meeting
> >>>>> some time?
> >>>>
> >>>> I'm available any time this week. :)
> >>>
> >>> I think the solution could be related to frame metadata if we intend to
> >>> specify the frame format. Btw. how does the framesamples relate to blanking?
> >>
> >> Framesamples and blanking are on completely different levels. Framesamples
> >> takes into account only active frame data, so H/V blanking doesn't matter here.
> >> Framesamples is not intended for raw formats where blanking is applicable.
> >>
> >> Framesamples only determines length of compressed stream, and blanking doesn't
> >> really affect the data passed to and generated by a jpeg encoder.
> > 
> > So in fact the blanking controls make no difference, but the hardware might
> 
> Yeah.
> 
> > add some extra blanking, say, if it's not able to send the whole image over
> > the bus as one chunk?
> 
> Concept of blanking really doesn???t make sense on media bus when sending compressed
> stream. The transmission of one frame could be performed in any number of bursts
> of any length.
> 
> >>> The metadata in a regular frame spans a few lines in the top and sometimes
> >>> also on the bottom of that frame.
> >>
> >> How do you handle it now, i.e. how the host finds out how much memory it needs
> >> for a frame ? Or is the metadata just overwriting "valid" lines ?
> > 
> > Well... we don't handle it. ;-) All that's being done is that it's
> > discarded.
> 
> OK, that's the simpler way then:)

>From drivers' point of view, yes. However, this causes issues elsewhere,
including extra delays and needing to know detailed hardware specific timing
information in user space.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
