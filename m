Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60922 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1FUWbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 18:31:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
Date: Wed, 22 Jun 2011 00:31:57 +0200
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, FlorianSchandinat@gmx.de
References: <4DDAE63A.3070203@gmx.de> <1308670579-15138-1-git-send-email-laurent.pinchart@ideasonboard.com> <BANLkTim6wUaeZCya=9dMvU7iHj4W4E57Fg@mail.gmail.com>
In-Reply-To: <BANLkTim6wUaeZCya=9dMvU7iHj4W4E57Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106220031.57972.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Geert,

On Tuesday 21 June 2011 22:49:14 Geert Uytterhoeven wrote:
> On Tue, Jun 21, 2011 at 17:36, Laurent Pinchart wrote:
> > +The following types and visuals are supported.
> > +
> > +- FB_TYPE_PACKED_PIXELS
> > +
> > +- FB_TYPE_PLANES
> 
> You forgot FB_TYPE_INTERLEAVED_PLANES, FB_TYPE_TEXT, and
> FB_TYPE_VGA_PLANES. Ah, that's the "feel free to extend the API doc"  :-)

To be honest, I don't know how they work. That's why I haven't documented 
them.

> > +The FOURCC-based API replaces format descriptions by four character
> > codes +(FOURCC). FOURCCs are abstract identifiers that uniquely define a
> > format +without explicitly describing it. This is the only API that
> > supports YUV +formats. Drivers are also encouraged to implement the
> > FOURCC-based API for RGB +and grayscale formats.
> > +
> > +Drivers that support the FOURCC-based API report this capability by
> > setting +the FB_CAP_FOURCC bit in the fb_fix_screeninfo capabilities
> > field. +
> > +FOURCC definitions are located in the linux/videodev2.h header. However,
> > and +despite starting with the V4L2_PIX_FMT_prefix, they are not
> > restricted to V4L2 +and don't require usage of the V4L2 subsystem.
> > FOURCC documentation is +available in
> > Documentation/DocBook/v4l/pixfmt.xml.
> > +
> > +To select a format, applications set the FB_VMODE_FOURCC bit in the
> > +fb_var_screeninfo vmode field, and set the fourcc field to the desired
> > FOURCC. +The bits_per_pixel, red, green, blue, transp and nonstd fields
> > must be set to +0 by applications and ignored by drivers. Note that the
> > grayscale and fourcc +fields share the same memory location. Application
> > must thus not set the +grayscale field to 0.
> 
> These are the only parts I don't like: (ab)using the vmode field (this
> isn't really a vmode flag), and the union of grayscale and fourcc (avoid
> unions where possible).

I've proposed adding a FB_NONSTD_FORMAT bit to the nonstd field as a FOURCC 
mode indicator in my initial RFC. Florian Tobias Schandinat wasn't very happy 
with that, and proposed using the vmode field instead.

Given that there's virtually no fbdev documentation, whether the vmode field 
and/or nonstd field are good fit for a FOURCC mode indicator is subject to 
interpretation.

> What about storing the FOURCC value in nonstd instead?

Wouldn't that be a union of nonstd and fourcc ? :-) FOURCC-based format 
setting will be a standard fbdev API, I'm not very keen on storing it in the 
nonstd field without a union.

> As FOURCC values are always 4 ASCII characters (hence all 4 bytes must
> be non-zero), I don't think there are any conflicts with existing values of
> nonstd. To make it even safer and easier to parse, you could set bit 31 of
> nonstd as a FOURCC indicator.

I would then create a union between nonstd and fourcc, and document nonstd as 
being used for the legacy API only. Most existing drivers use a couple of 
nonstd bits only. The driver that (ab)uses nonstd the most is pxafb and uses 
bits 22:0. Bits 31:24 are never used as far as I can tell, so nonstd & 
0xff000000 != 0 could be used as a FOURCC mode test.

This assumes that FOURCCs will never have their last character set to '\0'. Is 
that a safe assumption for the future ?

-- 
Regards,

Laurent Pinchart
