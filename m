Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36978 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab1H2NeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 09:34:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC v2 1/3] fbdev: Add FOURCC-based format configuration API
Date: Mon, 29 Aug 2011 15:34:35 +0200
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com> <201108291455.36145.laurent.pinchart@ideasonboard.com> <CAMuHMdVGV6dYW+szHyD30=HvAnSh92rRp=PMauwZZLw6H7DhYw@mail.gmail.com>
In-Reply-To: <CAMuHMdVGV6dYW+szHyD30=HvAnSh92rRp=PMauwZZLw6H7DhYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291534.35951.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Monday 29 August 2011 15:09:04 Geert Uytterhoeven wrote:
> On Mon, Aug 29, 2011 at 14:55, Laurent Pinchart wrote:
> >> When will the driver report FB_{TYPE,VISUAL}_FOURCC?
> >>   - When using a mode that cannot be represented in the legacy way,
> > 
> > Definitely.
> > 
> >>   - But what with modes that can be represented? Legacy software cannot
> >>     handle FB_{TYPE,VISUAL}_FOURCC.
> > 
> > My idea was to use FB_{TYPE,VISUAL}_FOURCC only when the mode is
> > configured using the FOURCC API. If FBIOPUT_VSCREENINFO is called with a
> > non-FOURCC format, the driver will report non-FOURCC types and visuals.
> 
> Hmm, two use cases:
>   - The video mode is configured using a FOURCC-aware tool ("fbset on
> steroids").

Such as http://git.ideasonboard.org/?p=fbdev-test.git;a=summary :-)

>     Later the user runs a legacy application.
>       => Do not retain FOURCC across opening of /dev/fb*.

I know about that problem, but it's not that easy to work around. We have no 
per-open fixed and variable screen info, and FB devices can be opened by 
multiple applications at the same time.

>   - Is there an easy way to force FOURCC reporting, so new apps don't have
> to support parsing the legacy formats? This is useful for new apps that
> want to support (a subset of) FOURCC modes only.

Not at the moment.

-- 
Regards,

Laurent Pinchart
