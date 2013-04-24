Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64024 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab3DXPx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 11:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <201304200231.31802.sergei.shtylyov@cogentembedded.com>
References: <201304200231.31802.sergei.shtylyov@cogentembedded.com>
Date: Wed, 24 Apr 2013 16:53:54 +0100
Message-ID: <CANqRtoQCtvUwxS6dO6y9_qCB8Ftur4LwwjnbSZJpZ2QYk14uzQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] V4L2: soc_camera: Renesas R-Car VIN driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	SH-Linux <linux-sh@vger.kernel.org>,
	Phil Edworthy <phil.edworthy@renesas.com>,
	"matsu@igel.co.jp" <matsu@igel.co.jp>,
	vladimir.barinov@cogentembedded.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Fri, Apr 19, 2013 at 11:31 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> Add Renesas R-Car VIN (Video In) V4L2 driver.
>
> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: removed deprecated IRQF_DISABLED flag.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>
> ---
> Changes since the original posting:
> - added IRQF_SHARED flag in devm_request_irq() call (since on R8A7778 VIN0/1
>   share the same IRQ) and removed deprecated IRQF_DISABLED flag.
>
>  drivers/media/platform/soc_camera/Kconfig    |    7
>  drivers/media/platform/soc_camera/Makefile   |    1
>  drivers/media/platform/soc_camera/rcar_vin.c | 1784 +++++++++++++++++++++++++++
>  include/linux/platform_data/camera-rcar.h    |   25
>  4 files changed, 1817 insertions(+)
>
> Index: renesas/drivers/media/platform/soc_camera/Kconfig
> ===================================================================
> --- renesas.orig/drivers/media/platform/soc_camera/Kconfig
> +++ renesas/drivers/media/platform/soc_camera/Kconfig
> @@ -45,6 +45,13 @@ config VIDEO_PXA27x
>         ---help---
>           This is a v4l2 driver for the PXA27x Quick Capture Interface
>
> +config VIDEO_RCAR_VIN
> +       tristate "R-Car Video Input (VIN) support"
> +       depends on VIDEO_DEV && SOC_CAMERA && (ARCH_R8A7778 || ARCH_R8A7779)
> +       select VIDEOBUF2_DMA_CONTIG
> +       ---help---
> +         This is a v4l2 driver for the R-Car VIN Interface

Thanks for your work on this. I believe there are multiple SoCs
containing VIN hardware, so limiting to r8a7778 and r8a7779 doesn't
make sense to me. Actually, our other drivers do not have this kind of
detailed dependency control.

So based on that, would it be possible for you to change the above
dependency to:

depends on VIDEO_DEV && SOC_CAMERA

Thanks,

/ magnus
