Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48167 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2CMDgv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 23:36:51 -0400
Received: by eaaq12 with SMTP id q12so12389eaa.19
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 20:36:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331295338-21065-1-git-send-email-festevam@gmail.com>
References: <1331295338-21065-1-git-send-email-festevam@gmail.com>
Date: Tue, 13 Mar 2012 00:36:49 -0300
Message-ID: <CAOMZO5Cgt0b8bWf-tmOrOTYQN2bj2shZu8BXqfpVB37QRhnrkQ@mail.gmail.com>
Subject: Re: [PATCH] video: Kconfig: Select VIDEOBUF2_DMA_CONTIG for VIDEO_MX2
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Cc: mchehab@infradead.org, javier.martin@vista-silicon.com,
	kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 3/9/12, Fabio Estevam <festevam@gmail.com> wrote:
> Fix the following build error:
>
> LD      .tmp_vmlinux1
> drivers/built-in.o: In function `mx2_camera_init_videobuf':
> clkdev.c:(.text+0xcfaf4): undefined reference to `vb2_dma_contig_memops'
> drivers/built-in.o: In function `mx2_camera_probe':
> clkdev.c:(.devinit.text+0x5734): undefined reference to
> `vb2_dma_contig_init_ctx'
> clkdev.c:(.devinit.text+0x5778): undefined reference to
> `vb2_dma_contig_cleanup_ctx'
> drivers/built-in.o: In function `mx2_camera_remove':
> clkdev.c:(.devexit.text+0x89c): undefined reference to
> `vb2_dma_contig_cleanup_ctx'
>
> commit c6a41e3271 ([media] media i.MX27 camera: migrate driver to videobuf2)
> missed to select VIDEOBUF2_DMA_CONTIG in Kconfig.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Could we have this one applied?

Otherwise we get build breakage in linux-next.

Thanks,

Fabio Estevam
