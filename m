Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45221 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751505Ab3GSUkf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 16:40:35 -0400
Date: Fri, 19 Jul 2013 23:40:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
Message-ID: <20130719203959.GD11823@valkosipuli.retiisi.org.uk>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F0536167CCB@server10.irisys.local>
 <51DDB97C.7060505@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F05361689C0@server10.irisys.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F05361689C0@server10.irisys.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas and Sylwester,

On Mon, Jul 15, 2013 at 09:18:36AM +0000, Thomas Vajzovic wrote:
> On 10 July 2013 20:44 Sylwester Nawrocki wrote:
> >On 07/07/2013 10:18 AM, Thomas Vajzovic wrote:
> >> On 06 July 2013 20:58 Sylwester Nawrocki wrote:
> >>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
> >>>>
> >>>> I am writing a driver for the sensor MT9D131.  This device supports
> >>>> digital zoom and JPEG compression.
> >>>>
> >>>> The hardware reads AxB sensor pixels from its array, resamples them
> >>>> to CxD image pixels, and then compresses them to ExF bytes.
> >>
> >> Yes you are correct that the sensor zero pads the compressed data to a
> >> fixed size.  That size must be specified in two separate registers,
> >> called spoof width and spoof height.  Above CxD is the image size
> >> after binning/skipping and resizing, ExF is the spoof size.
> >>
> >> The reason for two numbers for the number of bytes is that as the
> >> sensor outputs the JPEG bytes the VSYNC and HSYNC lines behave as
> >> though they were still outputting a 2D image with 8bpp.  This means
> >> that no changes are required in the bridge hardware.  I am trying to
> >> make it so very few changes are required in the bridge driver too.
> >> As far as the bridge driver is concerned the only size is ExF, it is
> >> unconcerned with CxD.
> >>
> >> v4l2_pix_format.width        = C;
> >> v4l2_pix_format.height       = D;
> >> v4l2_pix_format.bytesperline = E;
> >> v4l2_pix_format.sizeimage    = (E * F);
> >>
> >> bytesperline < width
> >> (sizeimage % bytesperline) == 0
> >> (sizeimage / bytesperline) < height
> >
> > bytesperline has not much meaning for compressed formats at the video
> > device (DMA) driver side.
> 
> This is not true for the platform I am using.
> 
> The Blackfin has a 2D DMA peripheral, meaning that it does need to
> separately know bytesperline and (sizeimage / bytesperline).
> 
> These values have a physical hardware meaning in terms of the signals
> on the sync lines even though they do not have a logical meaning
> because the data is compressed.

Parallel receivers typically do have such configuration but it's new to me
that a DMA controller also does.

In terms of the original RFC, just setting width, height and bpp accordingly
should do the trick. These are the parameters of the physical, not the
image. Choosing the line width wouldn't be possible, but would it be an
issue to use a constant line width?

> > For compressed streams like JPEG size of the memory buffer to
> > allocate is normally determined by sizeimage.
> 
> It is two numbers in my use case.
> 
> > 'bytesperline' could be less than 'width', that means a "virtual"
> > bits-per-pixel factor is less than 8. But this factor could (should?)
> > be configurable e.g. indirectly through V4L2_CID_JPEG_QUALITY control,
> 
> This is absolutely not a "virtual" width, it is a real physical property
> of the hardware signal.  The hardware signal always has exactly 8 bits
> per sample, but its height and width (ExF) are not related to the image
> height and width (CxD).
> 
> It is not appropriate to group the hardware data size together with
> compression controls for two reasons:
> 
> Firstly, the bridge driver would need to intercept the control and then
> pass it on to the bridge driver because they both need to know E and F.
> 
> Secondly, the pair of numbers (E,F) in my case have exaclty the same
> meaning and are used in exactly the same way as the single number
> (sizeimage) which is used in the cameras that use the current API.
> Logically the two numbers should be passed around and set and modified
> in all the same places that sizeimage currently is, but as a tuple.
> The two cannot be separated with one set using one API and the other
> a different API.
> 
> > and the bridge can query it from the sensor through g_frame_desc subdev
> > op.  The bridge has normally no clue what the compression ratio at the
> > sensor side is.  It could hard code some default "bpp", but then it
> > needs to be ensured the sensor doesn't transmit more data than the size
> > of allocated buffer.
> 
> It has no idea what the true compression ratio size is, but it does have
> to know the padded size.  The sensor will always send exactly that size.
> 
> >> But the question now is how does the bridge device communicate this to
> >> the I2C subdevice?  v4l2_mbus_framefmt doesn't have bytesperline or
> >> sizeimage, and v4l2_mbus_frame_desc_entry has only length (which I
> >> presume is sizeimage) but not both dimensions.
> >
> > That's a good question. The frame descriptors really need more discussion
> > and improvement, to also cover use cases as your JPEG sensor.
> > Currently it is pretty pre-eliminary stuff, used by just a few drivers.
> > Here is the original RFC from Sakari [1].
> 
> The version that has made it to kernel.org is much watered down from this
> proposal.  It could be suitable for doing what I need if an extra member
> were added, or preferably there should be something like:
> 
> enum
> {
>   DMA_1D,
>   DMA_2D,
> };
> 
> union {
>   struct {  // Valid if DMA_1D
>     u32 size;
>   };
>   struct {  // Valid if DMA_2D
>     u32 width;
>     u32 height;
>   };
> };
> 
> > Since we can't add bytesperline/sizeimage to struct v4l2_mbus_framefmt
> 
> Isn't this a sensible case for using some of those reserved bytes?

struct v4l2_mbus_framefmt is part of the user space interface and adding
information to it should be done with care. I'm not sure the end user would
be even interested to know (let alone to configure) how the image is
transferred over the bus since this configuration does not affect the
resulting image.

> If not, why are they there?
> 
> > I think struct v4l2_mbus_frame_desc_entry needs to be extended and
> > interaction between subdev ops like video.{s,g}_mbus_fmt,
> > pad.{set,get}_fmt needs to be specified.
> 
> Failing adding to v4l2_mbus_framefmt, I agree.
> 
> I notice also that there is only set_frame_desc and get_frame_desc, and
> no try_frame_desc.
> 
> In the only bridge driver that currently uses this interface,
> fimc-capture, when the user calls VIDIOC_TRY_FMT, then this is
> translated to a call to subdev.set_frame_desc.  Isn't this wrong?  I
> thought that TRY_* was never meant to modify the actual hardware, but
> only fill out the passed structure with what the device would be able
> to do, so don't we need also try_frame_desc?

I got the very same impression. Sylwester? :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
