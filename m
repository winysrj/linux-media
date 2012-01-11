Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45686 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2AKNTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 08:19:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [PATCHv4 1/2] v4l: Add new framesamples field to struct v4l2_mbus_framefmt
Date: Wed, 11 Jan 2012 14:20:15 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <201112120131.24192.laurent.pinchart@ideasonboard.com> <20111231131612.GE3677@valkosipuli.localdomain> <4F00AC43.6000905@gmail.com>
In-Reply-To: <4F00AC43.6000905@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111420.15539.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Sakari,

On Sunday 01 January 2012 19:56:03 Sylwester Nawrocki wrote:
> On 12/31/2011 02:16 PM, Sakari Ailus wrote:
> >>> I could think of an in-kernel counterpart for v4l2_mbus_framefmt, say,
> >>> v4l2_mbus_framedesc. This could then be passed from subdev to another
> >>> using a new subdev op.
> >> 
> >> That might be needed eventually. But I'm not a great fan in general of
> >> yet another set of callbacks for media bus frame format set up.
> >> 
> >>> Something else that should probably belong there is information on the
> >>> frame format: contrary to what I've previously thought, the sensor
> >>> metadata is often sent as part of the same CSI-2 channel. There also
> >>> can be other types of data, such as dummy data and data for black
> >>> level calibration. I wouldn't want to export all this to the user
> >>> space --- it shouldn't probably need to care about it.
> >>> 
> >>> The transmitter of the data (sensor) has this information and the CSI-2
> >>> receiver needs it. Same for the framesamples, as far as I understand.
> >> 
> >> We could try to design some standard data structure for frame metadata -
> >> that's how I understood the meaning of struct v4l2_mbus_framedesc.
> >> But I doubt such attempts will be sucessful. And how can we distinguish
> >> which data is valid and applicable when there is lots of weird stuff in
> >> one data structure ? Using media bus pixel code only ?
> > 
> > I think the media bus pixel code which is exported to the user space
> > should not be involved with the metadata.
> 
> Then we need to find some method to distinguish streams with metadata on
> the media bus, to be able to discard it before sending to user space.
> I assume this is where struct v4l2_mbus_framedesc and related ops would
> help ?
> 
> Maybe we could create v4l2_mbus_framedesc with length (framesamples) member
> in it and additionally 994 reserved bytes for future extensions ;-), e.g.
> 
> struct v4l2_mbus_framedesc {
> 	unsigned int length;
> 	unsigned int rserved[994];
> };
> 
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
> 
> > The metadata is something that the user is likely interested only in the
> > form it is in the system memory. It won't be processed in any way before
> > it gets written to memory. The chosen mbus code may affect the format of
> > the metadata, but that's something the sensor driver knows  -- and I've
> > yet to see a case where the user could choose the desired metadata
> > format.
> > 
> > Alternatively we could make the metadata path a separate path from the
> > image data. I wonder how feasible that approach would be --- the subdevs
> > would still be the same.
> 
> I was also considering metadata as sensor specific data structure retrieved
> by the host after a frame has been captured and appending that data to a
> user buffer. For such buffers a separate fourcc would be needed.
> 
> >>> Pixelrate is also used to figure out whether a pipeline can do
> >>> streaming or not; the pixel rate originating from the sensor could be
> >>> higher than the maximum of the ISP. For this reason, as well as for
> >>> providing timing information, access to pixelrate is reequired in the
> >>> user space.
> >>> 
> >>> Configuring the framesamples could be done on the sensor using a
> >>> control if necessary.
> >> 
> >> Sure, that could work. But as I mentioned before, the host drivers would
> >> have to be getting such control internally from subdevs. Not so nice
> >> IMHO. Although I'm not in big opposition to that too.
> >> 
> >> Grepping for v4l2_ctrl_g_ctrl() all the drivers appear to use it locally
> >> only.
> > 
> > I don't think there's anything that really would prohibit doing this.
> > There would need to be a way for the host to make a control read-only,
> > to prevent changing framesamples while streaming.
> 
> I would rather make subdev driver to ensure all negotiated paramaters,
> which changed during streaming could crash the system, stay unchanged
> after streaming started. It's as simple as checking entity stream_count in
> s_ctrl() and prohibiting change of control value if stream_count > 0.
> 
> > Pad-specific controls likely require more work than this.
> 
> Hym, I'd forgotten, the fact framesamples are per pad was an argument
> against using v4l2 control for this parameter. We still need per pad
> controls for the blanking controls, but for framesamples maybe it's better
> to just add subdev callback, as acessing this parameter on subdevs
> directly from space isn't really essential..

All this has moved around my mind for some time now, and I'm starting to see 
the situation from a slightly different point of view. I'll try to explain 
that first, and then we'll see what kind of APIs we need.

With the media devices being split into subdevs, the V4L/MC APIs have evolved 
quite a lot lately. We have subdev-level controls and pad-level formats, and 
will soon get pad-level selections. If you take a step back, we essentially 
have 3 logical elements (entities, pads and links) and properties associated 
with those elements. Those properties are currently classified into

- subdev properties: controls and old-style (pad-unaware) formats and crop 
restangles

- pad properties: pad-level formats and crop rectangles, and soon pad-level 
selections

- link properties: just a couple of flags for now

Recent discussions showed that we will need pad-level controls, and that some 
controls (such as setting the AF area) would be better handled by the 
selection API than the control API.

Controls are usually exposed to userspace, but we're seeing an increasing need 
to have in-kernel controls that should not be exposed to applications.

If I had to redesign all this right now, I would create an in-kernel 
properties API with a way to expose selected properties to userspace. This 
would also solve the control/format relationships an atomicity issues.

Is this something we should consider for the in-kernel APIs ? I'm of course 
not advocating dropping our current interfaces, or even deprecating them, but 
maybe this should be seen as a target to keep in mind for all APIs we add or 
modify.

Or maybe I should just spend my nights sleeping instead of thinking :-)

> >>> Just my 5 euro cents. Perhaps we could discuss the topic on
> >>> #v4l-meeting some time?
> >> 
> >> I'm available any time this week. :)
> > 
> > I think the solution could be related to frame metadata if we intend to
> > specify the frame format. Btw. how does the framesamples relate to
> > blanking?
> 
> Framesamples and blanking are on completely different levels. Framesamples
> takes into account only active frame data, so H/V blanking doesn't matter
> here. Framesamples is not intended for raw formats where blanking is
> applicable.
> 
> Framesamples only determines length of compressed stream, and blanking
> doesn't really affect the data passed to and generated by a jpeg encoder.
> 
> > The metadata in a regular frame spans a few lines in the top and
> > sometimes also on the bottom of that frame.
> 
> How do you handle it now, i.e. how the host finds out how much memory it
> needs for a frame ? Or is the metadata just overwriting "valid" lines ?
> 
> > Late next week is fine for me.
> 
> Ok, I'll try to reserve some time then.

-- 
Regards,

Laurent Pinchart
