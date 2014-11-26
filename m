Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:54542 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaKZI7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 03:59:19 -0500
MIME-Version: 1.0
In-Reply-To: <1416982792-11917-2-git-send-email-taki@igel.co.jp>
References: <1416982792-11917-1-git-send-email-taki@igel.co.jp>
	<1416982792-11917-2-git-send-email-taki@igel.co.jp>
Date: Wed, 26 Nov 2014 09:59:17 +0100
Message-ID: <CAMuHMdWFgaxgNFOkXktBzoVe7ncjD0Xu12YHV1BFrZUh11UzDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] v4l: vsp1: Reset VSP1 RPF source address
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Takanari Hayama <taki@igel.co.jp>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hayama-san,

On Wed, Nov 26, 2014 at 7:19 AM, Takanari Hayama <taki@igel.co.jp> wrote:
> @@ -179,6 +190,10 @@ static void rpf_vdev_queue(struct vsp1_video *video,
>                            struct vsp1_video_buffer *buf)
>  {
>         struct vsp1_rwpf *rpf = container_of(video, struct vsp1_rwpf, video);
> +       int i;
> +
> +       for (i = 0; i < 3; i++)
> +               rpf->buf_addr[i] = buf->addr[i];

vsp1_video_buffer.addr is "dma_addr_t addr[3];"...

BTW, you can use memcpy() instead of an explicit loop.

>
>         vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
>                        buf->addr[0] + rpf->offsets[0]);
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index 28dd9e7..1f98fe3 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -39,6 +39,8 @@ struct vsp1_rwpf {
>         struct v4l2_rect crop;
>
>         unsigned int offsets[2];
> +
> +       unsigned int buf_addr[3];

... hence the above should use dma_addr_t, too.

If CONFIG_ARM_LPAE is enabled, CONFIG_ARCH_DMA_ADDR_T_64BIT
will be enabled, too, and dma_addr_t will be u64.

>  };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
