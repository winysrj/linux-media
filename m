Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43947 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1GaUcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 16:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <201107281251.35018.laurent.pinchart@ideasonboard.com>
References: <4DDAE63A.3070203@gmx.de>
	<201107111732.52156.laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1107280943470.20737@axis700.grange>
	<201107281251.35018.laurent.pinchart@ideasonboard.com>
Date: Sun, 31 Jul 2011 22:32:42 +0200
Message-ID: <CAMuHMdX=c=p7oASCE+GgY9AgaCPWoXRQyjEGpn4BvA9xSY6GQg@mail.gmail.com>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 28, 2011 at 12:51, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> As for struct fb_var_screeninfo fields to support switching to a FOURCC
>> mode, I also prefer an explicit dedicated flag to specify switching to it.
>> Even though using FOURCC doesn't fit under the notion of a videomode, using
>> one of .vmode bits is too tempting, so, I would actually take the plunge and
>> use FB_VMODE_FOURCC.
>
> Another option would be to consider any grayscale > 1 value as a FOURCC. I've
> briefly checked the in-tree drivers: they only assign grayscale with 0 or 1,
> and check whether grayscale is 0 or different than 0. If a userspace
> application only sets grayscale > 1 when talking to a driver that supports the
> FOURCC-based API, we could get rid of the flag.
>
> What can't be easily found out is whether existing applications set grayscale
> to a > 1 value. They would break when used with FOURCC-aware drivers if we
> consider any grayscale > 1 value as a FOURCC. Is that a risk we can take ?

I think we can. I'd expect applications to use either 1 or -1 (i.e.
all ones), both are
invalid FOURCC values.

Still, I prefer the nonstd way.
And limiting traditional nonstd values to the lowest 24 bits (there
are no in-tree
drivers using the highest 8 bits, right?).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
