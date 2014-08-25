Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:35204 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaHYM7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 08:59:51 -0400
MIME-Version: 1.0
In-Reply-To: <1408970132-6690-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1408452653-14067-7-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<1408970132-6690-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Date: Mon, 25 Aug 2014 14:59:46 +0200
Message-ID: <CAMuHMdXQAFVJ8Ezd30JNkT6hWoFYKUWk5e0cq88jYUSBTPOzRA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] devicetree: bindings: Document Renesas JPEG
 Processing Unit.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Grant Likely <grant.likely@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

On Mon, Aug 25, 2014 at 2:35 PM, Mikhail Ulyanov
<mikhail.ulyanov@cogentembedded.com> wrote:
> +  - compatible: should containg one of the following:
> +                       - "renesas,jpu-r8a7790" for R-Car H2
> +                       - "renesas,jpu-r8a7791" for R-Car M2
> +                       - "renesas,jpu-gen2" for R-Car second generation

Isn't "renesas,jpu-gen2" meant as a fallback?

I.e. the DTS should have one of '7790 and '7791, AND the gen2 fallback,
so we can make the driver match against '7790 and '7791 is we find
out about an incompatibility.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
