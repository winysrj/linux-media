Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41104 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1LMKrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 05:47:04 -0500
MIME-Version: 1.0
In-Reply-To: <201112130140.45045.laurent.pinchart@ideasonboard.com>
References: <1322562419-9934-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<201112121708.30839.laurent.pinchart@ideasonboard.com>
	<4EE64CC2.5090906@gmx.de>
	<201112130140.45045.laurent.pinchart@ideasonboard.com>
Date: Tue, 13 Dec 2011 11:47:02 +0100
Message-ID: <CAMuHMdVggt5wqKjBFjHYT4GH5M8rFUG_sOMB2aH5YrzEGH_VSA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] fbdev: Add FOURCC-based format configuration API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 13, 2011 at 01:40, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> I think you also want to do something with red, green, blue, transp when
>> entering FOURCC mode, at least setting them to zero or maybe even requiring
>> that they are zero to enter FOURCC mode (as additional safety barrier).
>
> Agreed. The FOURCC mode documentation already requires those fields to be set
> to 0 by applications.
>
> I'll enforce this in fb_set_var() if info->fix has the FB_CAP_FOURCC
> capability flag set.

So when info->fix has the FB_CAP_FOURCC capability flag set, you can no longer
enter legacy mode?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
