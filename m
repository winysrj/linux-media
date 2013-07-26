Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40118 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752149Ab3GZJHW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:07:22 -0400
Date: Fri, 26 Jul 2013 12:06:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
Message-ID: <20130726090646.GJ12281@valkosipuli.retiisi.org.uk>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <20130723222106.GB12281@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F053616A13A@server10.irisys.local>
 <51EF92AF.7040205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF92AF.7040205@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Thomas,

On Wed, Jul 24, 2013 at 10:39:11AM +0200, Sylwester Nawrocki wrote:
> Hi,
> 
> On 07/24/2013 09:47 AM, Thomas Vajzovic wrote:
> >  On 23 July 2013 23:21 Sakari Ailus wrote:
> >> On Sun, Jul 21, 2013 at 10:38:18PM +0200, Sylwester Nawrocki wrote:
> >>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
> >>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
> >>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
> >>>>>
> >>>>>> The hardware reads AxB sensor pixels from its array, resamples them
> >>>>>> to CxD image pixels, and then compresses them to ExF bytes.
> >>>>>>
> >>>>> sensor matrix (AxB pixels) ->  binning/skipping (CxD pixels) ->
> >>>>> ->  JPEG compresion (width = C, height = D, sizeimage ExF bytes)
> >>>>
> >>>> Does the user need to specify ExF, for other purposes than limiting
> >>>> the size of the image? I would leave this up to the sensor driver
> >>>> (with reasonable alignment). The sensor driver would tell about this
> >>>> to the receiver through
> >>>
> >>> AFAIU ExF is closely related to the memory buffer size, so the sensor
> >>> driver itself wouldn't have enough information to fix up ExF, would it ?
> >>
> >> If the desired sizeimage is known, F can be calculated if E is fixed, say
> >> 1024 should probably work for everyone, shoulnd't it?
> > 
> > It's a nice clean idea (and I did already consider it) but it reduces the
> > flexibility of the system as a whole.
> > 
> > Suppose an embedded device wants to send the compressed image over a
> > network in packets of 1500 bytes, and they want to allow 3 packets per
> > frame.  Your proposal limits sizeimage to a multiple of 1K, so they have
> > to set sizeimage to 4K when they want 4.5K, meaning that they waste 500
> > bytes of bandwidth every frame.
> > 
> > You could say "tough luck, extra overhead like this is something you should
> > expect if you want to use a general purpose API like V4L2", but why make
> > it worse if we can make it better?
> 
> I entirely agree with that. Other issue with fixed number of samples
> per line is that internal (FIFO) line buffer size of the transmitter
> devices will vary, and for example some devices might have line buffer
> smaller than the value we have arbitrarily chosen. I'd expect the
> optimal number of samples per line to vary among different devices
> and use cases.

I guess the sensor driver could factor the size as well (provided it can
choose an arbitrary size) but then to be fully generic, I think alignment
must also be taken care of. Many receivers might require width to be even
but some might have tighter requirements. They have a minimum width, too.

To make this working in a generic case might not be worth the time and
effort of being able to shave up to 1 kiB off of video buffer allocations.

Remember v4l2_buffer.length is different from v4l2_pix_format.sizeimage.
Hmm. Yes --- so to the sensor goes desired maximum size, and back you'd get
ExF (i.e. buffer length) AND the size of the image.

What do you think?

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
