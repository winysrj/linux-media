Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38377 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbbA2S3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 13:29:45 -0500
Received: by mail-wi0-f177.google.com with SMTP id r20so28310829wiv.4
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 10:29:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1598982.NztnJrsrWo@wuerfel>
References: <1598982.NztnJrsrWo@wuerfel>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 29 Jan 2015 18:29:14 +0000
Message-ID: <CA+V-a8svtf6TdF=3Vg6vqJGxkLGKbNMbc_eQFgpoby2h-+joaA@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci: add V4L2 dependencies
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 29, 2015 at 4:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The davinci media drivers use videobuf2, which they enable through
> a 'select' statement. If one of these drivers is built-in, but
> the v4l2 core is a loadable modules, we end up with a link
> error:
>
> drivers/built-in.o: In function `vb2_fop_mmap':
> :(.text+0x113e84): undefined reference to `video_devdata'
> drivers/built-in.o: In function `vb2_ioctl_create_bufs':
> :(.text+0x114710): undefined reference to `video_devdata'
> drivers/built-in.o: In function `vb2_ioctl_reqbufs':
> :(.text+0x114ed8): undefined reference to `video_devdata'
> drivers/built-in.o: In function `vb2_ioctl_querybuf':
> :(.text+0x115530): undefined reference to `video_devdata'
>
> To solve this, we need to add a dependency on VIDEO_V4L2,
> which enforces that the davinci drivers themselves can only
> be loadable modules if V4L2 is not built-in, and they do
> not cause the videobuf2 code to be built-in.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
> index d9e1ddb586b1..469e9d28cec0 100644
> --- a/drivers/media/platform/davinci/Kconfig
> +++ b/drivers/media/platform/davinci/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_DAVINCI_VPIF_DISPLAY
>         tristate "TI DaVinci VPIF V4L2-Display driver"
> -       depends on VIDEO_DEV
> +       depends on VIDEO_V4L2
>         depends on ARCH_DAVINCI || COMPILE_TEST
>         depends on HAS_DMA
>         select VIDEOBUF2_DMA_CONTIG
> @@ -16,7 +16,7 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
>
>  config VIDEO_DAVINCI_VPIF_CAPTURE
>         tristate "TI DaVinci VPIF video capture driver"
> -       depends on VIDEO_DEV
> +       depends on VIDEO_V4L2
>         depends on ARCH_DAVINCI || COMPILE_TEST
>         depends on HAS_DMA
>         select VIDEOBUF2_DMA_CONTIG
> @@ -75,7 +75,7 @@ config VIDEO_DM365_ISIF
>
>  config VIDEO_DAVINCI_VPBE_DISPLAY
>         tristate "TI DaVinci VPBE V4L2-Display driver"
> -       depends on ARCH_DAVINCI
> +       depends on VIDEO_V4L2 && ARCH_DAVINCI
>         depends on HAS_DMA
>         select VIDEOBUF2_DMA_CONTIG
>         help
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
