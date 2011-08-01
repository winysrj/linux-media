Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59822 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1HAOLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 10:11:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
Date: Mon, 1 Aug 2011 16:11:46 +0200
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <4DDAE63A.3070203@gmx.de> <201108010128.13832.laurent.pinchart@ideasonboard.com> <4E35EC23.1010701@gmx.de>
In-Reply-To: <4E35EC23.1010701@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108011611.46930.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Monday 01 August 2011 01:58:27 Florian Tobias Schandinat wrote:
> On 07/31/2011 11:28 PM, Laurent Pinchart wrote:
> > On Monday 01 August 2011 00:54:48 Florian Tobias Schandinat wrote:
> >> On 07/31/2011 08:32 PM, Geert Uytterhoeven wrote:
> >>> On Thu, Jul 28, 2011 at 12:51, Laurent Pinchart wrote:
> >>>>> As for struct fb_var_screeninfo fields to support switching to a
> >>>>> FOURCC mode, I also prefer an explicit dedicated flag to specify
> >>>>> switching to it. Even though using FOURCC doesn't fit under the
> >>>>> notion of a videomode, using one of .vmode bits is too tempting, so,
> >>>>> I would actually take the plunge and use FB_VMODE_FOURCC.
> >>>> 
> >>>> Another option would be to consider any grayscale>   1 value as a
> >>>> FOURCC. I've briefly checked the in-tree drivers: they only assign
> >>>> grayscale with 0 or 1, and check whether grayscale is 0 or different
> >>>> than 0. If a userspace application only sets grayscale>   1 when
> >>>> talking to a driver that supports the FOURCC-based API, we could get
> >>>> rid of the flag.
> >>>> 
> >>>> What can't be easily found out is whether existing applications set
> >>>> grayscale to a>   1 value. They would break when used with
> >>>> FOURCC-aware drivers if we consider any grayscale>   1 value as a
> >>>> FOURCC. Is that a risk we can take ?
> >>> 
> >>> I think we can. I'd expect applications to use either 1 or -1 (i.e.
> >>> all ones), both are
> >>> invalid FOURCC values.
> >>> 
> >>> Still, I prefer the nonstd way.
> >>> And limiting traditional nonstd values to the lowest 24 bits (there
> >>> are no in-tree
> >>> drivers using the highest 8 bits, right?).
> >> 
> >> Okay, it would be okay for me to
> >> - write raw FOURCC values in nonstd, enable FOURCC mode if upper byte !=
> >> 0 - not having an explicit flag to enable FOURCC
> >> - in FOURCC mode drivers must set visual to FB_VISUAL_FOURCC
> >> - making support of FOURCC visible to userspace by capabilites |=
> >> FB_CAP_FOURCC
> >> 
> >> The capabilities is not strictly necessary but I think it's very useful
> >> as - it allows applications to make sure the extension is supported
> >> (for example to adjust the UI)
> >> - it allows applications to distinguish whether a particular format is
> >> not supported or FOURCC at all
> >> - it allows signaling further extensions of the API
> >> - it does not hurt, one line per driver and still some bytes in fixinfo
> >> free
> > 
> > Without a FOURCC capability applications will need to try FOURCCs
> > blindly. Drivers that are not FOURCC aware would then risk interpreting
> > the FOURCC as something else. As you mention below applications will
> > need that check that visual == FB_VISUAL_FOURCC, so it's less of an
> > issue than I initially thought, but it doesn't become a non-issue. The
> > display might still show glitches.
> 
> True.
> 
> >> So using it would look like this:
> >> - the driver must have capabilities |= FB_CAP_FOURCC
> >> - the application may check capabilities to know whether FOURCC is
> >> supported - the application may write a raw FOURCC value in nonstd to
> >> request changing to FOURCC mode with this format
> >> - when the driver switches to a FOURCC mode it must have visual =
> >> FB_VISUAL_FOURCC and the current FOURCC format in nonstd
> >> - the application should check visual and nonstd to make sure it gets
> >> what it wanted
> >> 
> >> 
> >> So if there are no strong objections against this I think we should
> >> implement it. I do not really care whether we use a union or not but I
> >> think if we decide to have one it should cover all fields that are
> >> undefined/unused in FOURCC mode.
> >> 
> >> 
> >> Hope we can find anything that everyone considers acceptable,
> > 
> > This sounds good to me, except that I would use the grayscale field
> > instead of the nonstd field. nonstd has pretty weird usecases, while
> > grayscale is better defined. nonstd might also make sense combined with
> > FOURCC-based modes, while grayscale would be completely redundant.
> > 
> > What's your opinion on that ?
> 
> I do not really care, either one would be okay for me.
> You're right that nonstd is used for a lot of things and perhaps some of
> those should still be possible in FOURCC mode. On the other hand I think
> applications are more likely to pass random values to grayscale as its
> meaning seems globally accepted (in contrast to nonstd where the
> application needs to know the driver to get any use of it).
> Perhaps you should also say that in FOURCC mode all unused pixel format
> fields should be set to 0 by the application and other values of those may
> get a meaning in later extensions or individual drivers.

Good point. I'll add that to the documentation.

-- 
Regards,

Laurent Pinchart
