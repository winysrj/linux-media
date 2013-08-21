Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54885 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751550Ab3HUNes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 09:34:48 -0400
Date: Wed, 21 Aug 2013 16:34:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
Message-ID: <20130821133413.GF20717@valkosipuli.retiisi.org.uk>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F05361697BA@server10.irisys.local>
 <51EF9EAD.4010804@samsung.com>
 <A683633ABCE53E43AFB0344442BF0F054C632AA7@server10.irisys.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F054C632AA7@server10.irisys.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Tue, Aug 06, 2013 at 04:26:56PM +0000, Thomas Vajzovic wrote:
> Hi,
> 
> On 24 July 2013 10:30 Sylwester Nawrocki wrote:
> > On 07/22/2013 10:40 AM, Thomas Vajzovic wrote:
> >> On 21 July 2013 21:38 Sylwester Nawrocki wrote:
> >>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
> >>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
> >>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
> >>>>>
> >>>>>> The hardware reads AxB sensor pixels from its array, resamples
> >>>>>> them to CxD image pixels, and then compresses them to ExF bytes.
> >>
> >> If the sensor driver is only told the user's requested sizeimage, it
> >> can be made to factorize (ExF) into (E,F) itself, but then both the
> >> parallel interface and the 2D DMA peripheral need to be told the
> >> particular factorization that it has chosen.
> >>
> >> If the user requests sizeimage which cannot be satisfied (eg: a prime
> >> number) then it will need to return (E,F) to the bridge driver which
> >> does not multiply exactly to sizeimage.  Because of this the bridge
> >> driver must set the corrected value of sizeimage which it returns to
> >> userspace to the product ExF.
> >
> > Ok, let's consider following data structure describing the frame:
> >
> > struct v4l2_frame_desc_entry {
> >   u32 flags;
> >   u32 pixelcode;
> >   u32 samples_per_line;
> >   u32 num_lines;
> >   u32 size;
> > };
> >
> > I think we could treat the frame descriptor to be at lower lever in
> > the protocol stack than struct v4l2_mbus_framefmt.
> >
> > Then the bridge would set size and pixelcode and the subdev would
> > return (E, F) in (samples_per_frame, num_lines) and adjust size if
> > required. Number of bits per sample can be determined by pixelcode.
> >
> > It needs to be considered that for some sensor drivers it might not
> > be immediately clear what samples_per_line, num_lines values are.
> > In such case those fields could be left zeroed and bridge driver
> > could signal such condition as a more or less critical error. In
> > end of the day specific sensor driver would need to be updated to
> > interwork with a bridge that requires samples_per_line, num_lines.
> 
> I think we ought to try to consider the four cases:
> 
> 1D sensor and 1D bridge: already works
> 
> 2D sensor and 2D bridge: my use case
> 
> 1D sensor and 2D bridge, 2D sensor and 1D bridge:

Are there any bridge devices that CANNOT receive 2D images? I've never seen
any.

> Perhaps both of these cases could be made to work by setting:
> num_lines = 1; samples_per_line = ((size * 8) / bpp);
> 
> (Obviously this would also require the appropriate pull-up/down
> on the second sync input on a 2D bridge).

And typically also 2D-only bridges have very limited maximum image width
which is unsuitable for any decent images. I'd rather like to only support
cases that we actually have right now.

> Since the frame descriptor interface is still new and used in so
> few drivers, is it reasonable to expect them all to be fixed to
> do this?
> 
> > Not sure if we need to add image width and height in pixels to the
> > above structure. It wouldn't make much sensor when single frame
> > carries multiple images, e.g. interleaved YUV and compressed image
> > data at different resolutions.
> 
> If image size were here then we are duplicating get_fmt/set_fmt.
> But then, by having pixelcode here we are already duplicating part
> of get_fmt/set_fmt.  If the bridge changes pixelcode and calls

Pixelcode would be required to tell which other kind of data is produced by
the device. But I agree in principle --- there could (theoretically) be
multiple pixelcodes that you might want to configure on a sensor. We don't
have a way to express that currently.

I think we'd need one additional level of abstraction to express that; in
that case pads could have several media bus formats associated with them
(which we'd need to enumerate, too). One additional field to struct
v4l2_subdev_format might suffice.

I think frame descriptors would still be needed: there's information such as
the line number on which the particular piece of image begins etc.

> set_frame_desc then is this equivalent to calling set_fmt?
> I would like to see as much data normalization as possible and
> eliminate the redundancy.
> 
> >> Whatever mechanism is chosen needs to have corresponding get/set/try
> >> methods to be used when the user calls
> >> VIDIOC_G_FMT/VIDIOC_S_FMT/VIDIOC_TRY_FMT.
> >
> > Agreed, it seems we need some sort of negotiation of those low
> > level parameters.
> 
> Should there be set/get/try function pointers, or should the struct
> include an enum member like v4l2_subdev_format.which to determine
> which operation is to be perfomed?

Do you have an example of something you'd like to set (or try) in frame
descriptors outside struct v4l2_subdev_format?

> Personally I think that it is a bit ugly having two different
> function pointers for set_fmt/get_fmt but then a structure member
> to determine between set/try.  IMHO it should be three function
> pointers or one function with a three valued enum in the struct.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
