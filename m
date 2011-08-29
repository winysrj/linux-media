Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50142 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1H2Iud (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 04:50:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC v2 1/3] fbdev: Add FOURCC-based format configuration API
Date: Mon, 29 Aug 2011 10:50:58 +0200
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com> <1313746626-23845-2-git-send-email-laurent.pinchart@ideasonboard.com> <CAMuHMdV-JxK1Pp1aHmEG7N8G8u_un-G7zGZa+KNzGx2D37EbKQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV-JxK1Pp1aHmEG7N8G8u_un-G7zGZa+KNzGx2D37EbKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291050.59109.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thanks for the review.

On Monday 29 August 2011 10:13:07 Geert Uytterhoeven wrote:
> On Fri, Aug 19, 2011 at 11:37, Laurent Pinchart wrote:

[snip]

> > +- FB_TYPE_PACKED_PIXELS
> > +
> > +Color components (usually RGB or YUV) are packed together into
> > macropixels +that are stored in a single plane. The exact color
> > components layout is +described in a visual-dependent way.
> > +
> > +Frame buffer visuals that don't use multiple color components per pixel
> > +(such as monochrome and pseudo-color visuals) are reported as packed
> > frame +buffer types, even though they don't stricly speaking pack color
> > components +into macropixels.
> 
> That's because the "packing" is not about the color components, but about
> the bits that represent a single pixel.
> 
> I.e. the bits that make up the pixel (the macropixel) are stored next
> to each other
> in memory.

OK, I've modified that last sentence to read

"Frame buffer visuals that don't use multiple color components per pixel (such 
as monochrome and pseudo-color visuals) are also reported as packed frame
buffer types, as the bits that make up individual pixels are packed next to
each other in memory."

> > +- FB_TYPE_PLANES
> > +
> > +Color components are stored in separate planes. Planes are located
> > +contiguously in memory.
> 
> The bits that make up a pixel are stored in separate planes. Planes are
> located contiguously in memory.

I'm not sure to agree with this. You make it sounds like FB_TYPE_PLANES stores 
each bit in a different plane. Is that really the case ?

> - FB_TYPE_INTERLEAVED_PLANES
> 
> The bits that make up a pixel are stored in separate planes. Planes
> are interleaved.
> The interleave factor (the distance in bytes between the planes in
> memory) is stored in the type_aux field.

That's a bit unclear to me. How are they interleaved ?

> > +- FB_VISUAL_MONO01
> > +
> > +Pixels are black or white and stored on one bit. A bit set to 1
> > represents a +black pixel and a bit set to 0 a white pixel. Pixels are
> > packed together in +bytes with 8 pixels per byte.
> 
> Actually we do have drivers that use 8 bits per pixel for a monochrome
> visual. Hence:
> 
> "Pixels are black or white. A black pixel is represented by all
> (typically one) bits set to ones, a white pixel by all bits set to zeroes."

OK. I've rephrased it as

"Pixels are black or white and stored on a number of bits (typically one)
specified by the variable screen information bpp field. 

Black pixels are represented by all bits set to 1 and white pixels by all bits
set to 0. When the number of bits per pixel is smaller than 8, several pixels 
are packed together in a byte."

> > +FB_VISUAL_MONO01 is used with FB_TYPE_PACKED_PIXELS only.
> 
> ... so this may also not be true (but it is for all current drivers, IIRC).
> There's a strict orthogonality between type (how is a pixel stored in
> memory) and visual (how the bits that represent the pixel are interpreted
> and converted to a color value).

What about

"FB_VISUAL_MONO01 is currently used with FB_TYPE_PACKED_PIXELS only." ?

> Same comments for FB_VISUAL_MONO10

Fixed the same way.

> > +- FB_VISUAL_TRUECOLOR
> > +
> > +Pixels are broken into red, green and blue components, and each
> > component +indexes a read-only lookup table for the corresponding value.
> > Lookup tables +are device-dependent, and provide linear or non-linear
> > ramps.
> > +
> > +Each component is stored in memory according to the variable screen
> > +information red, green, blue and transp fields.
> 
> "Each component is stored in a macropixel according to the variable screen
> information red, green, blue and transp fields."
> 
> Storage format in memory is determined by the FB_TYPE_* value.

How so ? With FB_TYPE_PLANES and FB_VISUAL_TRUECOLOR for an RGB format, how 
are the R, G and B planes ordered ? Are color components packed or padded 
inside a plane ? I understand that the design goal was to have orthogonal 
FB_TYPE_* and FB_VISUAL_* values, but we're missing too much information for 
that to be truly generic.

> > +- FB_VISUAL_PSEUDOCOLOR and FB_VISUAL_STATIC_PSEUDOCOLOR
> > +
> > +Pixel values are encoded as indices into a colormap that stores red,
> > green and +blue components. The colormap is read-only for
> > FB_VISUAL_STATIC_PSEUDOCOLOR +and read-write for FB_VISUAL_PSEUDOCOLOR.
> > +
> > +Each pixel value is stored in the number of bits reported by the
> > variable +screen information bits_per_pixel field. Pixels are contiguous
> > in memory.
> 
> Whether pixels are contiguous in memory or not is determined by the
> FB_TYPE_* value.

How can they not be contiguous in memory ? Can you please give an example ?

> > +FB_VISUAL_PSEUDOCOLOR and FB_VISUAL_STATIC_PSEUDOCOLOR are used with
> > +FB_TYPE_PACKED_PIXELS only.
> 
> Not true. Several drivers use bit planes or interleaved bitplanes.

How does that work ?

> > +- FB_VISUAL_DIRECTCOLOR
> > +
> > +Pixels are broken into red, green and blue components, and each
> > component +indexes a programmable lookup table for the corresponding
> > value. +
> > +Each component is stored in memory according to the variable screen
> > +information red, green, blue and transp fields.
> 
> "Each component is stored in a macropixel according to the variable screen
> information red, green, blue and transp fields."
> 
> > +- FB_VISUAL_FOURCC
> > +
> > +Pixels are stored in memory as described by the format FOURCC identifier
> > +stored in the variable screen information fourcc field.
> 
> ... stored in memory and interpreted ...
> 
> > +struct fb_var_screeninfo {
> > +       __u32 xres;                     /* visible resolution          
> > */ +       __u32 yres;
> > +       __u32 xres_virtual;             /* virtual resolution          
> > */ +       __u32 yres_virtual;
> > +       __u32 xoffset;                  /* offset from virtual to visible
> > */ +       __u32 yoffset;                  /* resolution                
> >   */ +
> > +       __u32 bits_per_pixel;           /* guess what                  
> > */ +       union {
> > +               struct {                /* Legacy format API          
> >  */ +                       __u32 grayscale; /* != 0 Graylevels instead
> > of colors */ +                       /* bitfields in fb mem if true
> > color, else only */ +                       /* length is significant    
> >                    */ +                       struct fb_bitfield red;
> > +                       struct fb_bitfield green;
> > +                       struct fb_bitfield blue;
> > +                       struct fb_bitfield transp;      /* transparency
> > */ +               };
> > +               struct {                /* FOURCC-based format API    
> >  */ +                       __u32 fourcc;           /* FOURCC format    
> >    */ +                       __u32 colorspace;
> > +                       __u32 reserved[11];
> > +               } format;
> > +       };
> > +
> > +       struct fb_bitfield red;         /* bitfield in fb mem if true
> > color, */ +       struct fb_bitfield green;       /* else only length is
> > significant */ +       struct fb_bitfield blue;
> > +       struct fb_bitfield transp;      /* transparency                
> > */
> 
> These four are duplicated, cfr. the union above.

Oops :-)

-- 
Regards,

Laurent Pinchart
