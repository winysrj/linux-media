Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52582 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1HKRWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 13:22:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
Date: Thu, 11 Aug 2011 19:19:54 +0200
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <4DDAE63A.3070203@gmx.de> <4E35DD38.7070609@gmx.de> <CAMuHMdUMW3QC_43aKvw2KQqEmzmeXXois8+zFg+S+DG785GwjA@mail.gmail.com>
In-Reply-To: <CAMuHMdUMW3QC_43aKvw2KQqEmzmeXXois8+zFg+S+DG785GwjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108111919.54649.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Monday 01 August 2011 11:49:46 Geert Uytterhoeven wrote:
> On Mon, Aug 1, 2011 at 00:54, Florian Tobias Schandinat wrote:
> > On 07/31/2011 08:32 PM, Geert Uytterhoeven wrote:
> >> On Thu, Jul 28, 2011 at 12:51, Laurent Pinchart wrote:
> >>>> As for struct fb_var_screeninfo fields to support switching to a
> >>>> FOURCC mode, I also prefer an explicit dedicated flag to specify
> >>>> switching to it.
> >>>> Even though using FOURCC doesn't fit under the notion of a videomode,
> >>>> using
> >>>> one of .vmode bits is too tempting, so, I would actually take the
> >>>> plunge and
> >>>> use FB_VMODE_FOURCC.
> >>> 
> >>> Another option would be to consider any grayscale>  1 value as a
> >>> FOURCC. I've
> >>> briefly checked the in-tree drivers: they only assign grayscale with 0
> >>> or 1,
> >>> and check whether grayscale is 0 or different than 0. If a userspace
> >>> application only sets grayscale>  1 when talking to a driver that
> >>> supports the
> >>> FOURCC-based API, we could get rid of the flag.
> >>> 
> >>> What can't be easily found out is whether existing applications set
> >>> grayscale
> >>> to a>  1 value. They would break when used with FOURCC-aware drivers if
> >>> we
> >>> consider any grayscale>  1 value as a FOURCC. Is that a risk we can
> >>> take ?
> >> 
> >> I think we can. I'd expect applications to use either 1 or -1 (i.e.
> >> all ones), both are
> >> invalid FOURCC values.
> >> 
> >> Still, I prefer the nonstd way.
> >> And limiting traditional nonstd values to the lowest 24 bits (there
> >> are no in-tree
> >> drivers using the highest 8 bits, right?).
> > 
> > Okay, it would be okay for me to
> > - write raw FOURCC values in nonstd, enable FOURCC mode if upper byte !=
> > 0 - not having an explicit flag to enable FOURCC
> > - in FOURCC mode drivers must set visual to FB_VISUAL_FOURCC
> > - making support of FOURCC visible to userspace by capabilites |=
> > FB_CAP_FOURCC
> > 
> > The capabilities is not strictly necessary but I think it's very useful
> > as - it allows applications to make sure the extension is supported (for
> > example to adjust the UI)
> > - it allows applications to distinguish whether a particular format is
> > not supported or FOURCC at all
> > - it allows signaling further extensions of the API
> > - it does not hurt, one line per driver and still some bytes in fixinfo
> > free
> > 
> > 
> > So using it would look like this:
> > - the driver must have capabilities |= FB_CAP_FOURCC
> > - the application may check capabilities to know whether FOURCC is
> > supported - the application may write a raw FOURCC value in nonstd to
> > request changing to FOURCC mode with this format
> > - when the driver switches to a FOURCC mode it must have visual =
> > FB_VISUAL_FOURCC and the current FOURCC format in nonstd
> > - the application should check visual and nonstd to make sure it gets
> > what it wanted
> 
> As several of the FOURCC formats duplicate formats you can already specify
> in some other way (e.g. the RGB and greyscale formats), and as FOURCC makes
> life easier for the application writer, I'm wondering whether it makes sense
> to add FOURCC support in the generic layer for drivers that don't support
> it? I.e. the generic layer would fill in fb_var_screeninfo depending on the
> requested FOURCC mode, if possible.

That's a good idea, but I'd like to add that in a second step. I'm working on 
a proof-of-concept by porting a driver to the FOURCC-based API first.

-- 
Regards,

Laurent Pinchart
