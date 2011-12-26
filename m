Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50454 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1LZMxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 07:53:07 -0500
Date: Mon, 26 Dec 2011 14:53:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 1/2] v4l: Add new framesamples field to struct
 v4l2_mbus_framefmt
Message-ID: <20111226125301.GQ3677@valkosipuli.localdomain>
References: <201112120131.24192.laurent.pinchart@ideasonboard.com>
 <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
 <1323865388-26994-2-git-send-email-s.nawrocki@samsung.com>
 <201112210120.56888.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112210120.56888.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Sylwester,

On Wed, Dec 21, 2011 at 01:20:56AM +0100, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Wednesday 14 December 2011 13:23:07 Sylwester Nawrocki wrote:
> > The purpose of the new field is to allow the video pipeline elements
> > to negotiate memory buffer size for compressed data frames, where
> > the buffer size cannot be derived from pixel width and height and
> > the pixel code.
> > 
> > For VIDIOC_SUBDEV_S_FMT and VIDIOC_SUBDEV_G_FMT ioctls, the
> > framesamples parameter should be calculated by the driver from pixel
> > width, height, color format and other parameters if required and
> > returned to the caller. This applies to compressed data formats only.
> > 
> > The application should propagate the framesamples value, whatever
> > returned at the first sub-device within a data pipeline, i.e. at the
> > pipeline's data source.
> > 
> > For compressed data formats the host drivers should internally
> > validate the framesamples parameter values before streaming is
> > enabled, to make sure the memory buffer size requirements are
> > satisfied along the pipeline.
> > 
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > --
> > There is no changes in this patch comparing to v3.
> > ---
> >  Documentation/DocBook/media/v4l/dev-subdev.xml     |   10 ++++++++--
> >  Documentation/DocBook/media/v4l/subdev-formats.xml |    9 ++++++++-
> >  include/linux/v4l2-mediabus.h                      |    4 +++-
> >  3 files changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
> > b/Documentation/DocBook/media/v4l/dev-subdev.xml index 0916a73..b9d24eb
> > 100644
> > --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> > +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> 
> > @@ -160,7 +160,13 @@
> >        guaranteed to be supported by the device. In particular, drivers
> > guarantee that a returned format will not be further changed if passed to
> > an &VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such
> > as
> > -      formats on other pads or links' configuration are not changed).
> > </para>
> > +      formats on other pads or links' configuration are not changed). When
> > +      a device contains a data encoder, the <structfield>
> > +      <link linkend="v4l2-mbus-framefmt-framesamples">framesamples</link>
> > +      </structfield> field value may be further changed, if parameters of
> > the
> > +      encoding process are changed after the format has been negotiated. In
> > +      such situation applications should use &VIDIOC-SUBDEV-G-FMT; ioctl to
> > +      query an updated format.</para>
> 
> Sorry for answering so late. I've been thinking about this topic (as well as 
> the proposed new pixelclock field) quite a lot, and one question strikes me 
> here (please don't hate me): does userspace need to care about the 
> framesamples field ? It looks like the value is only used inside the kernel, 
> and we're relying on on userspace to propagate those values between subdevs.
> 
> If that's the case, wouldn't it be better to have an in-kernel API to handle 
> this ? I'm a bit concerned about forcing userspace to handle internal 
> information to userspace if there's no reason to do so.

I feel partly the same about pixelrate --- there are sound reasons to export
that to user space still, but the method to do that could be something else
than putting it to v4l2_mbus_framefmt.

I could think of an in-kernel counterpart for v4l2_mbus_framefmt, say,
v4l2_mbus_framedesc. This could then be passed from subdev to another using
a new subdev op.

Something else that should probably belong there is information on the frame
format: contrary to what I've previously thought, the sensor metadata is
often sent as part of the same CSI-2 channel. There also can be other types
of data, such as dummy data and data for black level calibration. I wouldn't
want to export all this to the user space --- it shouldn't probably need to
care about it.

The transmitter of the data (sensor) has this information and the CSI-2
receiver needs it. Same for the framesamples, as far as I understand.

Pixelrate is also used to figure out whether a pipeline can do streaming or
not; the pixel rate originating from the sensor could be higher than the
maximum of the ISP. For this reason, as well as for providing timing
information, access to pixelrate is reequired in the user space.

Configuring the framesamples could be done on the sensor using a control if
necessary.

Just my 5 euro cents. Perhaps we could discuss the topic on #v4l-meeting
some time?

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
