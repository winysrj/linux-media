Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4R6rpEU013787
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 02:53:51 -0400
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4R6rZOf008496
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 02:53:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Tue, 27 May 2008 08:53:31 +0200
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
In-Reply-To: <1211850976.3188.83.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805270853.31287.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>, Michael Schimek <mschimek@gmx.at>
Subject: Re: Need VIDIOC_CROPCAP clarification
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

On Tuesday 27 May 2008 03:16:16 Andy Walls wrote:
> On Mon, 2008-05-26 at 23:26 +0200, Hans Verkuil wrote:
> > Hi all,
> >
> > How should the pixelaspect field of the v4l2_cropcap struct be
> > filled? Looking at existing drivers it can be anything from 0/0,
> > 1/1, 54/59 for PAL/SECAM and 11/10 for NTSC or the horizontal
> > number of samples/the horizontal number of pixels.
> >
> > However, it is my understanding that the last one as used in bttv
> > is the correct interpretation. Meaning that if the horizontal unit
> > used for cropping is equal to a pixel (this is the case for most
> > drivers), then pixelaspect should be 1/1. If the horizontal unit is
> > different from a pixel, then it should be:
> >
> > (total number of horizontal units) / (horizontal pixels)
> >
> > So given a crop coordinate X, the corresponding coordinate in
> > pixels would be:
> >
> > X * pixelaspect.denominator / pixelaspect.numerator
> >
> > This is what bttv does and I'm pretty sure that's when this ioctl
> > was introduced.
>
> The definition of "defrect" for VIDIOC_CROPCAP in the spec seems to
> support this interpretation of "pixelaspect".
>
> > Assuming this is correct, then the Spec needs to be fixed in
> > several places (and drivers too, for that matter):
> >
> > - all references to the term 'pixel aspect' are incorrect: it has
> > nothing to do with the pixel aspect, it is about the ratio between
> > the horizontal sampling frequency and the 'pixel frequency'.
>
> Well, wouldn't changing the luma signal sampling rate (in time), but
> not the number of luma samples per pixel, effectively stretch or
> shrink the "real world" as it is displayed on a horizontal line, thus
> affecting the apparent aspect of a pixel when compared to the
> vertical dimension? Thus, when representing real world features, the
> pixels can have an apparent aspect?

Yes, but then you would no longer be compliant to BT.601. And in the 
case of CROPCAP this field still has nothing to do with the pixel 
aspect.

> >From the ITU-R BT.601-4 (which has been superseded by BT.601-6) that
> > I
>
> found on the 'net:
>
> http://inst.eecs.berkeley.edu/~cs150/Documents/ITU601.PDF
>
>
> BT.601 defines a luma sampling freq of 13.5 MHz, yielding 858 samples
> per NTSC line and 720 samples per active regions of a line.  The
> 11/10 ratio mentioned for NTSC maps to 704/640, which is clearly a
> ratio of active digital pixels to digital pixels scaled for a
> display.  So I'm not sure of the relationship to BT.601-4's 720
> pixels.
>
> That's where this informal document may help:
>
> http://www.arachnotron.nl/videocap/doc/Karl_cap_v1_en.pdf

Nice document. Explains it well. It also clearly shows that the 720 
width should include overscan (which it does for ivtv/cx18), so that 
the actual video part (704x576 for PAL/SECAM) does have a pixel aspect 
of 54/59 (y/x). I.e. the width of a PAL/SECAM pixel is slighly larger 
than its height.

In other words, if the capture device follows BT.601, then the pixel 
aspect is fixed depending on the TV standard. And it has nothing to do 
with what CROPCAP calls 'pixelaspect'.

> He somewhat explains Display Aspect Ratio (DAR) and Pixel Aspect
> Ratio (PAR), where 704 comes from instead of 720, and works some
> examples with numbers on pages 7-9.  He even talks about the BT8xx
> chips on page 10.
>
> Here's some more clarifying/confusing information on pixel aspect:
>
> http://lurkertech.com/lg/pixelaspect/
>
>
>
>
> BTW, 'pixel frequency', as you are calling it, is twice the maximum
> "spatial frequency" that is displayable on a line.  The 'pixel
> frequency', or 'pixels/line' is the Nyquist rate for the highest
> displayable spatial frequency on the line, the highest supported
> spatial cycles/line before aliasing makes features unresolvable.  You
> need to see a light pixel and a dark pixel to have one spatial cycle.

Unfortunately term from my side.

> (IIRC, If you know the focal length and field of view, the highest
> spatial frequency tells you what is the smallest object length you
> can hope to resolve.)
>
> > - the description of 'bounds' is wrong: "Width and height are
> > defined in pixels, the driver writer is free to choose origin and
> > units of the coordinate system in the analog domain." This is
> > contradictory: the width units are up to the driver so the unit for
> > the width is not necessarily a pixel. The way the cropping is setup
> > implies that the height and Y coordinates are ALWAYS in line (aka
> > pixel) units. It cannot be anything else since that's the way
> > analog video works. You can't sample the height of half a line.
> >
> > - pixelaspect: has nothing to do with the pixel aspect. So the
> > references to PAL/SECAM and NTSC are irrelevant.
>
> As the "Karl_cap_v1_en.pdf" points out on page 7, you need to know
> the pixel aspect assumed by the digitization to do a proper
> conversion from a source digital format to a target digital format
> and a crop is part of that conversion.
>
> I think PAR has only an indirect relationship with analog video
> standards.  PAR has more to do with display devices, encoding and
> recording standards, and digitization standards. All of these have
> been influenced by the analog standards, so certain PARs can get tied
> to certain analog standards.
>
>
>
> I think I've added more confusion than clarification.  Oh well...

The problem as I see it is that there doesn't seem to be a V4L API at 
the moment that returns the true pixel aspect. So any application 
basically has to hope the device follows BT.601 and assume the 
corresponding pixel aspect ratios. But this can become problematic with 
webcams etc. that do not follow BT.601.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
