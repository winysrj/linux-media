Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52756 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab1FUUtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 16:49:15 -0400
MIME-Version: 1.0
In-Reply-To: <1308670579-15138-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <4DDAE63A.3070203@gmx.de>
	<1308670579-15138-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Tue, 21 Jun 2011 22:49:14 +0200
Message-ID: <BANLkTim6wUaeZCya=9dMvU7iHj4W4E57Fg@mail.gmail.com>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, FlorianSchandinat@gmx.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On Tue, Jun 21, 2011 at 17:36, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> +The following types and visuals are supported.
> +
> +- FB_TYPE_PACKED_PIXELS
> +
> +- FB_TYPE_PLANES

You forgot FB_TYPE_INTERLEAVED_PLANES, FB_TYPE_TEXT, and
FB_TYPE_VGA_PLANES. Ah, that's the "feel free to extend the API doc"  :-)

> +The FOURCC-based API replaces format descriptions by four character codes
> +(FOURCC). FOURCCs are abstract identifiers that uniquely define a format
> +without explicitly describing it. This is the only API that supports YUV
> +formats. Drivers are also encouraged to implement the FOURCC-based API for RGB
> +and grayscale formats.
> +
> +Drivers that support the FOURCC-based API report this capability by setting
> +the FB_CAP_FOURCC bit in the fb_fix_screeninfo capabilities field.
> +
> +FOURCC definitions are located in the linux/videodev2.h header. However, and
> +despite starting with the V4L2_PIX_FMT_prefix, they are not restricted to V4L2
> +and don't require usage of the V4L2 subsystem. FOURCC documentation is
> +available in Documentation/DocBook/v4l/pixfmt.xml.
> +
> +To select a format, applications set the FB_VMODE_FOURCC bit in the
> +fb_var_screeninfo vmode field, and set the fourcc field to the desired FOURCC.
> +The bits_per_pixel, red, green, blue, transp and nonstd fields must be set to
> +0 by applications and ignored by drivers. Note that the grayscale and fourcc
> +fields share the same memory location. Application must thus not set the
> +grayscale field to 0.

These are the only parts I don't like: (ab)using the vmode field (this
isn't really a
vmode flag), and the union of grayscale and fourcc (avoid unions where
possible).

What about storing the FOURCC value in nonstd instead?
As FOURCC values are always 4 ASCII characters (hence all 4 bytes must
be non-zero),
I don't think there are any conflicts with existing values of nonstd.
To make it even safer and easier to parse, you could set bit 31 of
nonstd as a FOURCC
indicator.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
