Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58D4kGu007308
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:04:46 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m58D4RHw017190
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:04:28 -0400
Date: Sun, 8 Jun 2008 15:04:04 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Veda N <veda74@gmail.com>
Message-ID: <20080608130404.GA199@daniel.bse>
References: <a5eaedfa0806070650x5daabac2ia12cdee022aa9f9f@mail.gmail.com>
	<20080607142923.GA588@daniel.bse>
	<a5eaedfa0806080407p461e30di1a861a9aa7d240f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5eaedfa0806080407p461e30di1a861a9aa7d240f8@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: pixel sizes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, Jun 08, 2008 at 04:37:00PM +0530, Veda N wrote:
> >>      I guess each LCDs/Display Units have their own pixel sizes.
> >>      In which case how the captured pixels are displayed on the LCD?
> >
> > Depends on the user. Either 1:1 pixelwise or scaled to fit/fill the screen.

> Do you mean to say, scaling means just fill up the screen with
> whatever pixels you have
> it does not matter what thier size are?.
> 
> In which case, If the camera sensor pixel sizes is 4 bytes/pixel and
> LCD supports only 2 bytes per pixel, Then i can fill up only half the
> pixels i have got.

I have the feeling we were talking about different sizes.
I was talking about the dimensions of a pixel.
In meter or inch...

Let me revise my answers for size=bits:

> Are the sizes of each pixels same for all the sensor?

No

> Does each sensor have its own size description for each pixel.

Yes
Some sensors are even analog and require external ADCs that are
available in different bit depths.

> I guess each LCDs/Display Units have their own pixel sizes.
> In which case how the captured pixels are displayed on the LCD?

By adding or removing lower bits to have the same bits per pixel.

When the destination has more bits per pixel:
Either add zero bits or replicate the high bits in the low bits.

When destination has less bits per pixel:
Discard lower bits. If you want you can account for the quantization
error with "error diffusion".

The image data from Bayer pattern sensors needs to be interpolated to
have all three components at every pixel. There are several methods in
use. Dcraw f.ex. implements bilinear, VNG, PPG and AHD interpolation.

> Should the definitions of pixels (sizes & format) of sensor and
> display unit match?

If you don't convert the data, it will look wrong.

> Do video applications have their own definition of how much size
> each pixel should have?

Most video applications handle unknown FourCCs as compressed data and
ask a decompressor to convert it to a known uncompressed format to be
able to do image processing. So if you give a Y210 (10 bit YUV) video to
an application that only understands 8 bit YUV, it will ask a plugin to
convert to Y422. But there are applications that can work natively with
Y210 data.

> Does the size of the pixel size change if it is RGB or YUV422?

As YUV422 has less samples per pixel than RGB and the RGB space is smaller
than the YUV space and YUV usually does not use the complete range of
possible values in a sample, I'd say you need less bits per sample in
RGB than in YUV422. Simple applications will always convert to 8 bit per
sample. Complex applications will probably use more than enough.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
