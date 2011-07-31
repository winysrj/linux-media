Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36990 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab1GaXaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 19:30:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
Date: Mon, 1 Aug 2011 01:30:19 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <4DDAE63A.3070203@gmx.de> <201107281251.35018.laurent.pinchart@ideasonboard.com> <CAMuHMdX=c=p7oASCE+GgY9AgaCPWoXRQyjEGpn4BvA9xSY6GQg@mail.gmail.com>
In-Reply-To: <CAMuHMdX=c=p7oASCE+GgY9AgaCPWoXRQyjEGpn4BvA9xSY6GQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108010130.19713.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thanks for the feedback.

On Sunday 31 July 2011 22:32:42 Geert Uytterhoeven wrote:
> On Thu, Jul 28, 2011 at 12:51, Laurent Pinchart wrote:
> >> As for struct fb_var_screeninfo fields to support switching to a FOURCC
> >> mode, I also prefer an explicit dedicated flag to specify switching to
> >> it. Even though using FOURCC doesn't fit under the notion of a
> >> videomode, using one of .vmode bits is too tempting, so, I would
> >> actually take the plunge and use FB_VMODE_FOURCC.
> > 
> > Another option would be to consider any grayscale > 1 value as a FOURCC.
> > I've briefly checked the in-tree drivers: they only assign grayscale
> > with 0 or 1, and check whether grayscale is 0 or different than 0. If a
> > userspace application only sets grayscale > 1 when talking to a driver
> > that supports the FOURCC-based API, we could get rid of the flag.
> > 
> > What can't be easily found out is whether existing applications set
> > grayscale to a > 1 value. They would break when used with FOURCC-aware
> > drivers if we consider any grayscale > 1 value as a FOURCC. Is that a
> > risk we can take ?
> 
> I think we can. I'd expect applications to use either 1 or -1 (i.e. all
> ones), both are invalid FOURCC values.

OK.

> Still, I prefer the nonstd way.
> And limiting traditional nonstd values to the lowest 24 bits (there
> are no in-tree drivers using the highest 8 bits, right?).

None that I've found. I still have a preference for the grayscale field 
though. As mentioned by Guennadi, the grayscale field would become redundant 
for FOURCC-based formats. It's then a good candidate, and would let drivers 
(and applications) do any crazy stuff they want with the nonstd field.

-- 
Regards,

Laurent Pinchart
