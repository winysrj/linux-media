Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:46456 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaIWOCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 10:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com>
Date: Tue, 23 Sep 2014 16:02:14 +0200
Message-ID: <CAMuHMdWnMz3P8tk_f_EQoZjgYS7SzH_2jYv_32aPnfM_hQgr1A@mail.gmail.com>
Subject: Re: [PATCH 1/6] V4L2: Add Renesas R-Car JPEG codec driver.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 19, 2014 at 2:50 PM, Mikhail Ulyanov
<mikhail.ulyanov@cogentembedded.com> wrote:
> +static void put_short_be(unsigned long *p, u16 v)
> +{
> +       u16 *addr = (u16 *)*p;
> +
> +       *addr = cpu_to_be16(v);
> +       *p += 2;
> +}
> +
> +static void put_word_be(unsigned long *p, u32 v)
> +{
> +       u32 *addr = (u32 *)*p;
> +
> +       *addr = cpu_to_be32(v);
> +       *p += 4;
> +}

Is the address in *p guaranteed to be aligned to 2 resp. 4  bytes?

If not, you can use put_unaligned*().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
