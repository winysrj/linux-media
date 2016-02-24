Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33856 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbcBXHvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 02:51:53 -0500
MIME-Version: 1.0
In-Reply-To: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
References: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
Date: Wed, 24 Feb 2016 08:51:53 +0100
Message-ID: <CAMuHMdVRuA2u6UQHFbyQwTOEaTw+g3UdOSzJJ5dM=thJBE1S0A@mail.gmail.com>
Subject: Re: [PATCH] v4l2: remove MIPI CSI-2 driver for SH-Mobile platforms
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 24, 2016 at 3:07 AM, Simon Horman
<horms+renesas@verge.net.au> wrote:
> This driver does not appear to have ever been used by any SoC's defconfig
> and does not appear to support DT. In sort it seems unused an unlikely
> to be used.

Interestingly, its non-documented DT bindings are used in the canonical example
in Documentation/devicetree/bindings/media/video-interfaces.txt.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
