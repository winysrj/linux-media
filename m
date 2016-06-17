Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45252
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbcFQLH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 07:07:29 -0400
Date: Fri, 17 Jun 2016 08:07:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 05/13] v4l: vsp1: Add FCP support
Message-ID: <20160617080723.7a760bf1@recife.lan>
In-Reply-To: <1461620198-13428-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1461620198-13428-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Apr 2016 00:36:30 +0300
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> On some platforms the VSP performs memory accesses through an FCP. When
> that's the case get a reference to the FCP from the VSP DT node and
> enable/disable it at runtime as needed.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  .../devicetree/bindings/media/renesas,vsp1.txt      |  5 +++++
>  drivers/media/platform/Kconfig                      |  1 +
>  drivers/media/platform/vsp1/vsp1.h                  |  2 ++
>  drivers/media/platform/vsp1/vsp1_drv.c              | 21 ++++++++++++++++++++-
>  4 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> index 627405abd144..9b695bcbf219 100644
> --- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> @@ -14,6 +14,11 @@ Required properties:
>    - interrupts: VSP interrupt specifier.
>    - clocks: A phandle + clock-specifier pair for the VSP functional clock.
>  
> +Optional properties:
> +
> +  - renesas,fcp: A phandle referencing the FCP that handles memory accesses
> +                 for the VSP. Not needed on Gen2, mandatory on Gen3.
> +
>  
>  Example: R8A7790 (R-Car H2) VSP1-S node
>  
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index f453910050be..a3304466e628 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -264,6 +264,7 @@ config VIDEO_RENESAS_VSP1
>  	tristate "Renesas VSP1 Video Processing Engine"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
>  	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
> +	depends on !ARM64 || VIDEO_RENESAS_FCP

It sounds that this will break compile-test on ARM64 for no good reason.

Thanks,
Mauro
