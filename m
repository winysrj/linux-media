Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48250 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2ADMVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 07:21:47 -0500
Date: Wed, 4 Jan 2012 14:21:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 1/2] v4l: Add new framesamples field to struct
 v4l2_mbus_framefmt
Message-ID: <20120104122142.GB9323@valkosipuli.localdomain>
References: <201112120131.24192.laurent.pinchart@ideasonboard.com>
 <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
 <1323865388-26994-2-git-send-email-s.nawrocki@samsung.com>
 <201112210120.56888.laurent.pinchart@ideasonboard.com>
 <20111226125301.GQ3677@valkosipuli.localdomain>
 <4EFB4D3D.1080105@gmail.com>
 <20111231131612.GE3677@valkosipuli.localdomain>
 <4F00AC43.6000905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F00AC43.6000905@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Jan 01, 2012 at 07:56:03PM +0100, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 12/31/2011 02:16 PM, Sakari Ailus wrote:
> >>> I could think of an in-kernel counterpart for v4l2_mbus_framefmt, say,
> >>> v4l2_mbus_framedesc. This could then be passed from subdev to another using
> >>> a new subdev op.
> >>
> >> That might be needed eventually. But I'm not a great fan in general of yet
> >> another set of callbacks for media bus frame format set up.
> >>
> >>> Something else that should probably belong there is information on the frame
> >>> format: contrary to what I've previously thought, the sensor metadata is
> >>> often sent as part of the same CSI-2 channel. There also can be other types
> >>> of data, such as dummy data and data for black level calibration. I wouldn't
> >>> want to export all this to the user space --- it shouldn't probably need to
> >>> care about it.
> >>>
> >>> The transmitter of the data (sensor) has this information and the CSI-2
> >>> receiver needs it. Same for the framesamples, as far as I understand.
> >>
> >> We could try to design some standard data structure for frame metadata -
> >> that's how I understood the meaning of struct v4l2_mbus_framedesc.
> >> But I doubt such attempts will be sucessful. And how can we distinguish
> >> which data is valid and applicable when there is lots of weird stuff in one
> >> data structure ? Using media bus pixel code only ?
> > 
> > I think the media bus pixel code which is exported to the user space should
> > not be involved with the metadata.
> 
> Then we need to find some method to distinguish streams with metadata on the
> media bus, to be able to discard it before sending to user space.
> I assume this is where struct v4l2_mbus_framedesc and related ops would help ?

I'd think so.

> Maybe we could create v4l2_mbus_framedesc with length (framesamples) member
> in it and additionally 994 reserved bytes for future extensions ;-), e.g.
> 
> struct v4l2_mbus_framedesc {
> 	unsigned int length;
> 	unsigned int rserved[994];
> };

Do we need to export this to the user space? In the first phase I'd like to
keep that static (i.e. only get op would be supported) and only visible in
the kernel. That would leave much more room for changes later on, if needed.

> struct v4l2_subdev_pad_ops {
> 	  ....
> 	int get_framedesc(int pad, struct v4l2_framedesc *fdesc);
> 	int set_framedesc(int pad, struct v4l2_framedesc fdesc);
> };
> 
> This would ensure same media bus format code regardless of frame meta data
> presence.
> 
> In case metadata is sent in same CSI channel, the required buffer length
> might be greater than what would width/height and pixel code suggest.

Partly for this reason we have g_skip_top_lines() op in sensor ops. It
instructs the receiver to discard the metadata, and possibly other data
which isn't as interesting --- could be just dummy.

Some CSI-2 receivers are able to write this to a different memory location;
we could expose this as a different video node. I'm proposing a different
video node since this is a separate queue: the format (in-memory pixel
format and dimensions) is different, and it is beneficial to have access to
this data as soon as possible. There is a caveat, though, if we also wish to
support metadata which is appended to the frame, rather than prependeded.

> > The metadata is something that the user is likely interested only in the
> > form it is in the system memory. It won't be processed in any way before
> > it gets written to memory. The chosen mbus code may affect the format of the
> > metadata, but that's something the sensor driver knows  -- and I've yet to
> > see a case where the user could choose the desired metadata format.
> 
> > Alternatively we could make the metadata path a separate path from the image
> > data. I wonder how feasible that approach would be --- the subdevs would
> > still be the same.
> 
> I was also considering metadata as sensor specific data structure retrieved
> by the host after a frame has been captured and appending that data to a user
> buffer. For such buffers a separate fourcc would be needed.

Why after?

There are benefits in getting this to the user space without extra delays?

> >>> Pixelrate is also used to figure out whether a pipeline can do streaming or
> >>> not; the pixel rate originating from the sensor could be higher than the
> >>> maximum of the ISP. For this reason, as well as for providing timing
> >>> information, access to pixelrate is reequired in the user space.
> >>>
> >>> Configuring the framesamples could be done on the sensor using a control if
> >>> necessary.
> >>
> >> Sure, that could work. But as I mentioned before, the host drivers would have
> >> to be getting such control internally from subdevs. Not so nice IMHO. Although
> >> I'm not in big opposition to that too.
> >>
> >> Grepping for v4l2_ctrl_g_ctrl() all the drivers appear to use it locally only.
> > 
> > I don't think there's anything that really would prohibit doing this. There
> > would need to be a way for the host to make a control read-only, to prevent
> > changing framesamples while streaming.
> 
> I would rather make subdev driver to ensure all negotiated paramaters, which
> changed during streaming could crash the system, stay unchanged after streaming
> started. It's as simple as checking entity stream_count in s_ctrl() and
> prohibiting change of control value if stream_count > 0.

That's easy, but the values of these controls could still change between
pipeline validation and stream startup: the sensor driver always will be the
last one to start streaming.

> > Pad-specific controls likely require more work than this.
> 
> Hym, I'd forgotten, the fact framesamples are per pad was an argument against
> using v4l2 control for this parameter. We still need per pad controls for the
> blanking controls, but for framesamples maybe it's better to just add subdev
> callback, as acessing this parameter on subdevs directly from space isn't
> really essential..

Blanking controls are subdev-specific, not pad-specific. In practice the
pixel array subdevs will always have just one pad, but there is still the
principal difference. :-)

Pixel rate could be another per-pad control. That might have to be checked
before stream startup, just like framesamples. That's information which is
mostly needed in the kernel space, but the user space still would sometimes
like to take a look at it. Giving the responsibility to the user to carry
the pixel rate through the whole pipeline without a way to even modify would
be is a little excessive.

> >>> Just my 5 euro cents. Perhaps we could discuss the topic on #v4l-meeting
> >>> some time?
> >>
> >> I'm available any time this week. :)
> > 
> > I think the solution could be related to frame metadata if we intend to
> > specify the frame format. Btw. how does the framesamples relate to blanking?
> 
> Framesamples and blanking are on completely different levels. Framesamples
> takes into account only active frame data, so H/V blanking doesn't matter here.
> Framesamples is not intended for raw formats where blanking is applicable.
> 
> Framesamples only determines length of compressed stream, and blanking doesn't
> really affect the data passed to and generated by a jpeg encoder.

So in fact the blanking controls make no difference, but the hardware might
add some extra blanking, say, if it's not able to send the whole image over
the bus as one chunk?

> > The metadata in a regular frame spans a few lines in the top and sometimes
> > also on the bottom of that frame.
> 
> How do you handle it now, i.e. how the host finds out how much memory it needs
> for a frame ? Or is the metadata just overwriting "valid" lines ?

Well... we don't handle it. ;-) All that's being done is that it's
discarded.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
