Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59156 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab1IHKVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 06:21:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] Reserved fields in v4l2_mbus_framefmt, v4l2_subdev_format alignment
Date: Thu, 8 Sep 2011 12:21:29 +0200
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, s.nawrocki@samsung.com
References: <20110905155528.GB1308@valkosipuli.localdomain> <4E667019.9000703@gmail.com> <20110906210743.GA1724@valkosipuli.localdomain>
In-Reply-To: <20110906210743.GA1724@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081221.30031.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Sakari,

On Tuesday 06 September 2011 23:07:43 Sakari Ailus wrote:
> On Tue, Sep 06, 2011 at 09:10:17PM +0200, Sylwester Nawrocki wrote:
> > On 09/05/2011 05:55 PM, Sakari Ailus wrote:
> > > Hi all,
> > > 
> > > I recently came across a few issues in the definitions of
> > > v4l2_subdev_format and v4l2_mbus_framefmt when I was working on sensor
> > > control that I wanted to bring up here. The appropriate structure
> > > right now look like this:
> > > 
> > > include/linux/v4l2-subdev.h:
> > > ---8<---
> > > /**
> > > 
> > >   * struct v4l2_subdev_format - Pad-level media bus format
> > >   * @which: format type (from enum v4l2_subdev_format_whence)
> > >   * @pad: pad number, as reported by the media API
> > >   * @format: media bus format (format code and frame size)
> > >   */
> > > 
> > > struct v4l2_subdev_format {
> > > 
> > >          __u32 which;
> > >          __u32 pad;
> > >          struct v4l2_mbus_framefmt format;
> > >          __u32 reserved[8];
> > > 
> > > };
> > > ---8<---
> > > 
> > > include/linux/v4l2-mediabus.h:
> > > ---8<---
> > > /**
> > > 
> > >   * struct v4l2_mbus_framefmt - frame format on the media bus
> > >   * @width:      frame width
> > >   * @height:     frame height
> > >   * @code:       data format code (from enum v4l2_mbus_pixelcode)
> > >   * @field:      used interlacing type (from enum v4l2_field)
> > >   * @colorspace: colorspace of the data (from enum v4l2_colorspace)
> > >   */
> > > 
> > > struct v4l2_mbus_framefmt {
> > > 
> > >          __u32                   width;
> > >          __u32                   height;
> > >          __u32                   code;
> > >          __u32                   field;
> > >          __u32                   colorspace;
> > >          __u32                   reserved[7];
> > > 
> > > };
> > > ---8<---
> > > 
> > > Offering a lower level interface for sensors which allows better
> > > control of them from the user space involves providing the link
> > > frequency to the user space. While the link frequency will be a
> > > control, together with the bus type and number of lanes (on serial
> > > links), this will define the pixel clock.
> > > 
> > > <URL:http://www.spinics.net/lists/linux-media/msg36492.html>
> > > 
> > > After adding pixel clock to v4l2_mbus_framefmt there will be six
> > > reserved fields left, one of which will be further possibly consumed
> > > by maximum image size:
> > > 
> > > <URL:http://www.spinics.net/lists/linux-media/msg35949.html>
> > 
> > Yes, thanks for remembering about it. I have done some experiments with a
> > sensor producing JPEG data and I'd like to add '__u32 framesamples'
> > field to struct v4l2_mbus_framefmt, even though it solves only part of
> > the problem. I'm not sure when I'll be able to get this finished though.
> > I've just attached the initial patch now.
> > 
> > > Frame blanking (horizontal and vertical) and number of lanes might be
> > > needed in the struct as well in the future, bringing the reserved
> > > count down to two. I find this alarmingly low for a relatively new
> > > structure definition which will potentially have a few different uses
> > > in the future.
> > 
> > Sorry, could you explain why we need to put the blanking information in
> > struct v4l2_mbus_framefmt ? I thought it had been initially agreed that
> > the control framework will be used for this.
> 
> Configuration of blanking will be implemented as controls, yes.
> 
> Bandwidth calculation in the ISP driver may well need to know more detailed
> information than just the maximum pixel rate. Averge rate over certain
> period may also be important.
> 
> For example, take a sensor which is able to produce pixel rate of 200 Mp/s.
> In the OMAP 3 ISP only the CSI2 block will be able to process pixels at
> such rate. The ISP driver needs this information to be able to decide
> whether it's safe to start streaming or not.
> 
> Higher momentary pixel rates are still possible as there are buffers
> between some of the blocks. When using downscaling on sensors this gets
> more tricky. There may be bursts of data which may overflow these buffers
> since the sensors do not output data at amortised rate. Information on the
> sensor (bursts) and size of the buffers is at least required to assess
> this question.
> 
> I have a vague feeling we may need some of this data as part of the
> v4l2_mbus_framefmt before we have a solution.

Do we really need to make all this (including the proposed framesamples field) 
part of v4l2_mbus_framefmt ? My understanding is that the information needs to 
be propagated down the pipeline to verify pipeline validity at streamon time 
and to configure blocks down in the chain. That's an in-kernel requirement, 
wouldn't it be better to use an in-kernel API for that instead of requiring 
userspace to do the job ?

> > > The another issue is that the size of the v4l2_subdev_format struct is
> > > not aligned to a power of two. Instead of the intended 32 u32's, the
> > > size is actually 22 u32's.
> > 
> > hmm, is this really an issue ? What is advantage of having the structure
> > size being the power of 2 ? Isn't multiple of 4 just enough ?
> 
> A power of two has been considered a good practice. It's also how kmalloc
> will allocate memory for the duration of the ioctl call. Typical sizes can
> be found in /proc/slabinfo. For small sizes also some non-power of two
> sizes appear available, at least on my machines.
> 
> I'm not sure about the allocation in user space.
> 
> > > The interface is present in the 3.0 and marked experimental. My
> > > proposal is to add reserved fields to v4l2_mbus_framefmt to extend its
> > > size up to 32 u32's. I understand there are already few which use the
> > > interface right now and thus this change must be done now or left
> > > as-is forever.
> > 
> > hmm, I feel a bit uncomfortable with increasing size of data structure
> > which is quite widely used, not only in sensors, also in TV capture
> > cards, tuners, etc. So far struct v4l2_mbus_framefmt was quite generic.
> > IMHO it might be good to try to avoid extending it widely with
> > properties specific to single subsystem.
> 
> This is why I wanted to bring this up now rather than later. Of course I
> should have realised these issues before we had .39. ;)
> 
> I agree the pixel rate management should be implemented in a way which is
> not specific to sensors.

-- 
Regards,

Laurent Pinchart
