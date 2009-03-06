Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:47952 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZCFJat (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 04:30:49 -0500
Date: Fri, 6 Mar 2009 01:30:46 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Robert Jarzmik <robert.jarzmik@free.fr>, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <Pine.LNX.4.64.0903052312310.4980@axis700.grange>
Message-ID: <Pine.LNX.4.58.0903051816260.24268@shell2.speakeasy.net>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903052119590.4980@axis700.grange> <873adrekwj.fsf@free.fr>
 <Pine.LNX.4.58.0903051317010.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903052312310.4980@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> On Thu, 5 Mar 2009, Trent Piepho wrote:
> > On Thu, 5 Mar 2009, Robert Jarzmik wrote:
> > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> > > > This is not a review yet - just an explanation why I was suggesting to
> > > > adjust height and width - you say yourself, that YUV422P (I think, this is
> > > > wat you meant, not just YUV422) requires planes to immediately follow one
> > > > another. But you have to align them on 8 byte boundary for DMA, so, you
> > > > violate the standard, right? If so, I would rather suggest to adjust width
> > > > and height for planar formats to comply to the standard. Or have I
> > > > misunderstood you?
> > > No, you understand perfectly.
> > >
> > > And now, what do we do :
> > >  - adjust height ?
> > >  - adjust height ?
> > >  - adjust both ?
> > >
> > > I couldn't decide which one, any hint ?
> >
> > Shame the planes have to be contiguous.  Software like ffmpeg doesn't
> > require this and could handle planes with gaps between them without
> > trouble.  Plans aligned on 8 bytes boundaries would probably be faster in
> > fact.  Be better if v4l2_buffer gave us offsets for each plane.
> >
> > If you must adjust, probably better to adjust both.
>
> Yes, adjusting both is also what I was suggesting in my original review.
> How about aligning the bigger of the two to 4 bytes and the smaller to 2?

In order to 8 byte align the end of the first chroma plane, doesn't the
size need to be a multiple of 32, to take into account the chroma
decimation, assuming yuv 4:2:0?

Here is some code I could put this code into v4l that solves this.

In this case one could say:
v4l_bound_align_image(*width, 48, 640, 2, *height, 32, 480, 0, 5);
That will give you width between 48 and 640 that's a multiple of 4, a
height between 32 and 480, and the image size will be a multiple of 32.  It
will try to adjust the image size as little as possible to get it to work.

For example, give it 175x241 and it comes back with 176x242.  As opposed to
something like 192x241 or 172x240, which are also valid but more different
than the requested size.

/* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
 * and max don't have to be aligned, but there must be at least one valid
 * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
 * of 16 between 17 and 31.  */
static unsigned int clamp_align(unsigned int x, unsigned int min,
                                unsigned int max, unsigned int align)
{
        /* Bits that must be zero to be aligned */
        unsigned int mask = (1 << align) - 1;

        /* Round to nearest aligned value */
        if (x & (1 << (align - 1)))
                x += mask; /* make x&=~mask round up */
        x &= ~mask;

        /* Clamp to aligned value of min and max */
        if (x < min)
                x = (min + mask) & ~mask;
        else if (x > max)
                x = max & ~mask;

        return x;
}

/* Bound an image to have a width between wmin and wmax, and height between
 * hmin and hmax, inclusive.  Additionally, the width will be a multiple of
 * 2^walign, the height will be a multiple of 2^halign, and the overall size
 * (width*height) will be a multiple of 2^salign.  May shrink or enlarge the
 * image to fit the alignment constraints.  The width or height maximum must
 * not be smaller than the corresponding minimum.  The alignments must not be
 * so high there are no possible image sizes within the allowed bounds.
 */
void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
                           unsigned int wmax, unsigned int walign,
                           unsigned int *height, unsigned int hmin,
                           unsigned int hmax, unsigned int halign,
                           unsigned int salign)
{
        *width = clamp_align(*width, wmin, wmax, walign);
        *height = clamp_align(*height, hmin, hmax, halign);

        /* How much alignment do we have? */
        walign = __ffs(*width);
        halign = __ffs(*height);
        /* Enough to satisfy the image alignment? */
        if (walign + halign < salign) {
                /* Max walign where there is still a valid width */
                unsigned int wmaxa = __fls(wmax ^ (wmin - 1));

                salign -= walign + halign;
                /* up the smaller alignment until we have enough */
                do {
                        if (walign <= halign && walign < wmaxa)
                                walign++;
                        else
                                halign++;
                } while(--salign);
                *width = clamp_align(*width, wmin, wmax, walign);
                *height = clamp_align(*height, hmin, hmax, halign);
        }
}
