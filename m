Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:65069 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab1HMJmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 05:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <201108111919.54649.laurent.pinchart@ideasonboard.com>
References: <4DDAE63A.3070203@gmx.de>
	<4E35DD38.7070609@gmx.de>
	<CAMuHMdUMW3QC_43aKvw2KQqEmzmeXXois8+zFg+S+DG785GwjA@mail.gmail.com>
	<201108111919.54649.laurent.pinchart@ideasonboard.com>
Date: Sat, 13 Aug 2011 11:42:41 +0200
Message-ID: <CAMuHMdVywgXhfrvGm4QzE79hPX-fRdY4eSFQP45XqAah_YdQ5Q@mail.gmail.com>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi LAurent,

On Thu, Aug 11, 2011 at 19:19, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 01 August 2011 11:49:46 Geert Uytterhoeven wrote:
>> As several of the FOURCC formats duplicate formats you can already specify
>> in some other way (e.g. the RGB and greyscale formats), and as FOURCC makes
>> life easier for the application writer, I'm wondering whether it makes sense
>> to add FOURCC support in the generic layer for drivers that don't support
>> it? I.e. the generic layer would fill in fb_var_screeninfo depending on the
>> requested FOURCC mode, if possible.
>
> That's a good idea, but I'd like to add that in a second step. I'm working on
> a proof-of-concept by porting a driver to the FOURCC-based API first.

Sure! I was just mentioning it, so we keep it in the back of our head and don't
make decisions now that would make it impossible to add that later.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
