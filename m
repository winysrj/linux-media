Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33206 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1FVIur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 04:50:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
Date: Wed, 22 Jun 2011 10:50:47 +0200
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <4DDAE63A.3070203@gmx.de> <201106220031.57972.laurent.pinchart@ideasonboard.com> <4E018189.3020305@gmx.de>
In-Reply-To: <4E018189.3020305@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221050.48057.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Florian,

On Wednesday 22 June 2011 07:45:45 Florian Tobias Schandinat wrote:
> On 06/21/2011 10:31 PM, Laurent Pinchart wrote:
> > On Tuesday 21 June 2011 22:49:14 Geert Uytterhoeven wrote:
> >> On Tue, Jun 21, 2011 at 17:36, Laurent Pinchart wrote:
> >>> +The FOURCC-based API replaces format descriptions by four character
> >>> codes +(FOURCC). FOURCCs are abstract identifiers that uniquely define
> >>> a format +without explicitly describing it. This is the only API that
> >>> supports YUV +formats. Drivers are also encouraged to implement the
> >>> FOURCC-based API for RGB +and grayscale formats.
> >>> +
> >>> +Drivers that support the FOURCC-based API report this capability by
> >>> setting +the FB_CAP_FOURCC bit in the fb_fix_screeninfo capabilities
> >>> field. +
> >>> +FOURCC definitions are located in the linux/videodev2.h header.
> >>> However, and +despite starting with the V4L2_PIX_FMT_prefix, they are
> >>> not restricted to V4L2 +and don't require usage of the V4L2 subsystem.
> >>> FOURCC documentation is +available in
> >>> Documentation/DocBook/v4l/pixfmt.xml.
> >>> +
> >>> +To select a format, applications set the FB_VMODE_FOURCC bit in the
> >>> +fb_var_screeninfo vmode field, and set the fourcc field to the desired
> >>> FOURCC. +The bits_per_pixel, red, green, blue, transp and nonstd fields
> >>> must be set to +0 by applications and ignored by drivers. Note that the
> >>> grayscale and fourcc +fields share the same memory location.
> >>> Application must thus not set the +grayscale field to 0.
> >> 
> >> These are the only parts I don't like: (ab)using the vmode field (this
> >> isn't really a vmode flag), and the union of grayscale and fourcc (avoid
> >> unions where possible).
> > 
> > I've proposed adding a FB_NONSTD_FORMAT bit to the nonstd field as a
> > FOURCC mode indicator in my initial RFC. Florian Tobias Schandinat
> > wasn't very happy with that, and proposed using the vmode field instead.
> > 
> > Given that there's virtually no fbdev documentation, whether the vmode
> > field and/or nonstd field are good fit for a FOURCC mode indicator is
> > subject to interpretation.
> 
> The reason for my suggestion is that the vmode field is accepted to contain
> only flags and at least to me there is no hard line what is part of the
> video mode and what is not.

Lacks of documentation indeed makes that line fuzzy. I really hope that 
api.txt will be extended to cover the full fbdev API :-)

> In contrast the nonstd field is already used in a lot of different
> (incompatible) ways. I think if we only use the nonstd field for handling
> FOURCC it is likely that some problems will appear.
> 
> >> What about storing the FOURCC value in nonstd instead?
> > 
> > Wouldn't that be a union of nonstd and fourcc ? :-) FOURCC-based format
> > setting will be a standard fbdev API, I'm not very keen on storing it in
> > the nonstd field without a union.
> > 
> >> As FOURCC values are always 4 ASCII characters (hence all 4 bytes must
> >> be non-zero), I don't think there are any conflicts with existing values
> >> of nonstd. To make it even safer and easier to parse, you could set bit
> >> 31 of nonstd as a FOURCC indicator.
> > 
> > I would then create a union between nonstd and fourcc, and document
> > nonstd as being used for the legacy API only. Most existing drivers use
> > a couple of nonstd bits only. The driver that (ab)uses nonstd the most
> > is pxafb and uses bits 22:0. Bits 31:24 are never used as far as I can
> > tell, so nonstd& 0xff000000 != 0 could be used as a FOURCC mode test.
> > 
> > This assumes that FOURCCs will never have their last character set to
> > '\0'. Is that a safe assumption for the future ?
> 
> Yes, I think. The information I found indicates that space should be used
> for padding, so a \0 shouldn't exist.
> I think using only the nonstd field and requiring applications to check the
> capabilities would be possible, although not fool proof ;)
> 
> Great work, Laurent, do you have plans to modify fbset to allow using this
> format API from the command line?

Once we agree on an API, I will implement it in a driver and update fbset.

-- 
Regards,

Laurent Pinchart
