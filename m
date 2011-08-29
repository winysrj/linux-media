Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61381 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1H2JgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 05:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <201108291050.59109.laurent.pinchart@ideasonboard.com>
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1313746626-23845-2-git-send-email-laurent.pinchart@ideasonboard.com>
	<CAMuHMdV-JxK1Pp1aHmEG7N8G8u_un-G7zGZa+KNzGx2D37EbKQ@mail.gmail.com>
	<201108291050.59109.laurent.pinchart@ideasonboard.com>
Date: Mon, 29 Aug 2011 11:36:07 +0200
Message-ID: <CAMuHMdW9KPBJpTPYmCTmFG=G_7_tiFti-b3wzTM9Q5J7U9+JWg@mail.gmail.com>
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

On Mon, Aug 29, 2011 at 10:50, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 29 August 2011 10:13:07 Geert Uytterhoeven wrote:
>> On Fri, Aug 19, 2011 at 11:37, Laurent Pinchart wrote:
>
> [snip]
>
>> > +- FB_TYPE_PACKED_PIXELS
>> > +
>> > +Color components (usually RGB or YUV) are packed together into
>> > macropixels +that are stored in a single plane. The exact color
>> > components layout is +described in a visual-dependent way.
>> > +
>> > +Frame buffer visuals that don't use multiple color components per pixel
>> > +(such as monochrome and pseudo-color visuals) are reported as packed
>> > frame +buffer types, even though they don't stricly speaking pack color
>> > components +into macropixels.
>>
>> That's because the "packing" is not about the color components, but about
>> the bits that represent a single pixel.
>>
>> I.e. the bits that make up the pixel (the macropixel) are stored next
>> to each other
>> in memory.
>
> OK, I've modified that last sentence to read
>
> "Frame buffer visuals that don't use multiple color components per pixel (such
> as monochrome and pseudo-color visuals) are also reported as packed frame
> buffer types, as the bits that make up individual pixels are packed next to
> each other in memory."

Still not correct, as you don't grasp the concept of e.g. bitplanes
yet (see below).
The visual doesn't have anything to do with how the macropixels are stored in
memory.

>> > +- FB_TYPE_PLANES
>> > +
>> > +Color components are stored in separate planes. Planes are located
>> > +contiguously in memory.
>>
>> The bits that make up a pixel are stored in separate planes. Planes are
>> located contiguously in memory.
>
> I'm not sure to agree with this. You make it sounds like FB_TYPE_PLANES stores
> each bit in a different plane. Is that really the case ?

Yes.

First you store all "first" (fbdev does lack a way to specify little
or big endian here)
bits of each pixel in memory, contiguously. Then the second bit of
each pixel, and so on.

For 8 pixels (A - H) with 4 bits per pixel (0 - 3) (i.e. the first pixel is
[A0 A1 A2 A3]), that would be like:

A0 B0 C0 D0 E0 F0 G0 H0 A1 B1 C1 D1 E1 F1 G1 H1 A2 B2 C2 D2 E2 F2 G2 H2
A3 B3 C3 D3 E3 F3 G3 H3

http://en.wikipedia.org/wiki/Bit_plane
http://en.wikipedia.org/wiki/Planar_(computer_graphics)
http://en.wikipedia.org/wiki/Color_depth

>> - FB_TYPE_INTERLEAVED_PLANES
>>
>> The bits that make up a pixel are stored in separate planes. Planes
>> are interleaved.
>> The interleave factor (the distance in bytes between the planes in
>> memory) is stored in the type_aux field.
>
> That's a bit unclear to me. How are they interleaved ?

Instead of storing the same bits of all pixels contiguously into memory, they
are interleaved. Typically this is done per line (type_aux is the
length of a line in bytes),
or per word (Atari uses 2 bytes interleaving.

E.g. for a 320 x 200 display, with FB_TYPE_PLANES, you would store 320 x 200 =
64000 first bits, followed 64000 second bits, and so on.

With FB_TYPE_INTERLEAVED_PLANES and type_aux = 320 / 8 = 40,
you store the first line of the screen as 320 first bits, followed by
320 second bits, and so on.
Then the next line, as 320 first bits, followed by 320 second bits, and so on...

Hence the bits that make up a pixel are spread across memory. It was
useful in the days
computers couldn't show many colors, and allows things like 5 or 6
bits per pixels.

>> > +- FB_VISUAL_MONO01
>> > +
>> > +Pixels are black or white and stored on one bit. A bit set to 1
>> > represents a +black pixel and a bit set to 0 a white pixel. Pixels are
>> > packed together in +bytes with 8 pixels per byte.
>>
>> Actually we do have drivers that use 8 bits per pixel for a monochrome
>> visual. Hence:
>>
>> "Pixels are black or white. A black pixel is represented by all
>> (typically one) bits set to ones, a white pixel by all bits set to zeroes."
>
> OK. I've rephrased it as
>
> "Pixels are black or white and stored on a number of bits (typically one)
> specified by the variable screen information bpp field.
>
> Black pixels are represented by all bits set to 1 and white pixels by all bits
> set to 0. When the number of bits per pixel is smaller than 8, several pixels
> are packed together in a byte."

OK.

>> > +FB_VISUAL_MONO01 is used with FB_TYPE_PACKED_PIXELS only.
>>
>> ... so this may also not be true (but it is for all current drivers, IIRC).
>> There's a strict orthogonality between type (how is a pixel stored in
>> memory) and visual (how the bits that represent the pixel are interpreted
>> and converted to a color value).
>
> What about
>
> "FB_VISUAL_MONO01 is currently used with FB_TYPE_PACKED_PIXELS only." ?

stifb.c seems to use FB_TYPE_PLANES, but it uses bits_per_pixel is 1, so
FB_TYPE_PACKED_PIXELS, FB_TYPE_PLANES, and FB_TYPE_INTERLEAVED_PLANES
all degenerate to the same case anyway.

>> > +- FB_VISUAL_TRUECOLOR
>> > +
>> > +Pixels are broken into red, green and blue components, and each
>> > component +indexes a read-only lookup table for the corresponding value.
>> > Lookup tables +are device-dependent, and provide linear or non-linear
>> > ramps.
>> > +
>> > +Each component is stored in memory according to the variable screen
>> > +information red, green, blue and transp fields.
>>
>> "Each component is stored in a macropixel according to the variable screen
>> information red, green, blue and transp fields."
>>
>> Storage format in memory is determined by the FB_TYPE_* value.
>
> How so ? With FB_TYPE_PLANES and FB_VISUAL_TRUECOLOR for an RGB format, how
> are the R, G and B planes ordered ? Are color components packed or padded

That's specified by the fb_bitfield structs.

> inside a plane ? I understand that the design goal was to have orthogonal
> FB_TYPE_* and FB_VISUAL_* values, but we're missing too much information for
> that to be truly generic.

The visual specifies how to interprete the fields that make up a pixel (as color
components, indices, ...).
The fb_bitfield structs specify how the fields are laid out in a pixel of size
bits_per_pixel.
The frame buffer type specifies how pixels are laid out in memory.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
