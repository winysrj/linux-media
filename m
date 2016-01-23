Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34546 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbcAWNzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2016 08:55:21 -0500
MIME-Version: 1.0
In-Reply-To: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Sat, 23 Jan 2016 14:55:20 +0100
Message-ID: <CAMuHMdVYy+O6oAHAH-uQoEsrdCJD0ex9cp79ry=FbevDAQbH+A@mail.gmail.com>
Subject: Re: [PATCH] [media] media: Kconfig: add dependency of HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 30, 2015 at 2:26 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> The build of m32r allmodconfig fails with the error:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:484:2:
>         error: implicit declaration of function 'dma_get_cache_alignment'
>
> The build of videobuf2-dma-contig.c depends on HAS_DMA and it is
> correctly mentioned in the Kconfig but the symbol VIDEO_STI_BDISP also
> selects VIDEOBUF2_DMA_CONTIG, so it is trying to compile
> videobuf2-dma-contig.c even though HAS_DMA is not defined.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
