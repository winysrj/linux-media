Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53774 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1H2INI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 04:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <1313746626-23845-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1313746626-23845-2-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Mon, 29 Aug 2011 10:13:07 +0200
Message-ID: <CAMuHMdV-JxK1Pp1aHmEG7N8G8u_un-G7zGZa+KNzGx2D37EbKQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 1/3] fbdev: Add FOURCC-based format configuration API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

My comments are mainly about the documentation of the "legacy" bits.

On Fri, Aug 19, 2011 at 11:37, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> diff --git a/Documentation/fb/api.txt b/Documentation/fb/api.txt
> new file mode 100644
> index 0000000..6808492
> --- /dev/null
> +++ b/Documentation/fb/api.txt

> +2. Types and visuals
> +--------------------
> +
> +Pixels are stored in memory in hardware-dependent formats. Applications need
> +to be aware of the pixel storage format in order to write image data to the
> +frame buffer memory in the format expected by the hardware.
> +
> +Formats are described by frame buffer types and visuals. Some visuals require
> +additional information, which are stored in the variable screen information
> +bits_per_pixel, grayscale, fourcc, red, green, blue and transp fields.
> +
> +The following types and visuals are supported.
> +
> +- FB_TYPE_PACKED_PIXELS
> +
> +Color components (usually RGB or YUV) are packed together into macropixels
> +that are stored in a single plane. The exact color components layout is
> +described in a visual-dependent way.
> +
> +Frame buffer visuals that don't use multiple color components per pixel
> +(such as monochrome and pseudo-color visuals) are reported as packed frame
> +buffer types, even though they don't stricly speaking pack color components
> +into macropixels.

That's because the "packing" is not about the color components, but about the
bits that represent a single pixel.

I.e. the bits that make up the pixel (the macropixel) are stored next
to each other
in memory.

> +- FB_TYPE_PLANES
> +
> +Color components are stored in separate planes. Planes are located
> +contiguously in memory.

The bits that make up a pixel are stored in separate planes. Planes are located
contiguously in memory.

- FB_TYPE_INTERLEAVED_PLANES

The bits that make up a pixel are stored in separate planes. Planes
are interleaved.
The interleave factor (the distance in bytes between the planes in
memory) is stored
in the type_aux field.

> +- FB_VISUAL_MONO01
> +
> +Pixels are black or white and stored on one bit. A bit set to 1 represents a
> +black pixel and a bit set to 0 a white pixel. Pixels are packed together in
> +bytes with 8 pixels per byte.

Actually we do have drivers that use 8 bits per pixel for a monochrome visual.
Hence:

"Pixels are black or white. A black pixel is represented by all
(typically one) bits
set to ones, a white pixel by all bits set to zeroes."

> +FB_VISUAL_MONO01 is used with FB_TYPE_PACKED_PIXELS only.

... so this may also not be true (but it is for all current drivers, IIRC).
There's a strict orthogonality between type (how is a pixel stored in memory)
and visual (how the bits that represent the pixel are interpreted and converted
to a color value).

Same comments for FB_VISUAL_MONO10

> +- FB_VISUAL_TRUECOLOR
> +
> +Pixels are broken into red, green and blue components, and each component
> +indexes a read-only lookup table for the corresponding value. Lookup tables
> +are device-dependent, and provide linear or non-linear ramps.
> +
> +Each component is stored in memory according to the variable screen
> +information red, green, blue and transp fields.

"Each component is stored in a macropixel according to the variable screen
information red, green, blue and transp fields."

Storage format in memory is determined by the FB_TYPE_* value.

> +- FB_VISUAL_PSEUDOCOLOR and FB_VISUAL_STATIC_PSEUDOCOLOR
> +
> +Pixel values are encoded as indices into a colormap that stores red, green and
> +blue components. The colormap is read-only for FB_VISUAL_STATIC_PSEUDOCOLOR
> +and read-write for FB_VISUAL_PSEUDOCOLOR.
> +
> +Each pixel value is stored in the number of bits reported by the variable
> +screen information bits_per_pixel field. Pixels are contiguous in memory.

Whether pixels are contiguous in memory or not is determined by the
FB_TYPE_* value.

> +FB_VISUAL_PSEUDOCOLOR and FB_VISUAL_STATIC_PSEUDOCOLOR are used with
> +FB_TYPE_PACKED_PIXELS only.

Not true. Several drivers use bit planes or interleaved bitplanes.

> +- FB_VISUAL_DIRECTCOLOR
> +
> +Pixels are broken into red, green and blue components, and each component
> +indexes a programmable lookup table for the corresponding value.
> +
> +Each component is stored in memory according to the variable screen
> +information red, green, blue and transp fields.

"Each component is stored in a macropixel according to the variable screen
information red, green, blue and transp fields."

> +- FB_VISUAL_FOURCC
> +
> +Pixels are stored in memory as described by the format FOURCC identifier
> +stored in the variable screen information fourcc field.

... stored in memory and interpreted ...

> +struct fb_var_screeninfo {
> +       __u32 xres;                     /* visible resolution           */
> +       __u32 yres;
> +       __u32 xres_virtual;             /* virtual resolution           */
> +       __u32 yres_virtual;
> +       __u32 xoffset;                  /* offset from virtual to visible */
> +       __u32 yoffset;                  /* resolution                   */
> +
> +       __u32 bits_per_pixel;           /* guess what                   */
> +       union {
> +               struct {                /* Legacy format API            */
> +                       __u32 grayscale; /* != 0 Graylevels instead of colors */
> +                       /* bitfields in fb mem if true color, else only */
> +                       /* length is significant                        */
> +                       struct fb_bitfield red;
> +                       struct fb_bitfield green;
> +                       struct fb_bitfield blue;
> +                       struct fb_bitfield transp;      /* transparency */
> +               };
> +               struct {                /* FOURCC-based format API      */
> +                       __u32 fourcc;           /* FOURCC format        */
> +                       __u32 colorspace;
> +                       __u32 reserved[11];
> +               } format;
> +       };
> +
> +       struct fb_bitfield red;         /* bitfield in fb mem if true color, */
> +       struct fb_bitfield green;       /* else only length is significant */
> +       struct fb_bitfield blue;
> +       struct fb_bitfield transp;      /* transparency                 */

These four are duplicated, cfr. the union above.

> +  Pixel values are bits_per_pixel wide and are split in non-overlapping red,
> +  green, blue and alpha (transparency) components. Location and size of each
> +  component in the pixel value are described by the fb_bitfield offset and
> +  length fields. Offset are computed from the right.

                   Offsets

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
