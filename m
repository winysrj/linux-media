Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51620 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751408AbdEFIyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 May 2017 04:54:25 -0400
Subject: Re: [PATCH v5 2/8] [media] stm32-dcmi: STM32 DCMI camera interface
 driver
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
References: <1493998287-5828-1-git-send-email-hugues.fruchet@st.com>
 <1493998287-5828-3-git-send-email-hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dd4a1ec1-b84a-81cb-51b6-c2e53b5efcc5@xs4all.nl>
Date: Sat, 6 May 2017 10:54:20 +0200
MIME-Version: 1.0
In-Reply-To: <1493998287-5828-3-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On 05/05/2017 05:31 PM, Hugues Fruchet wrote:
> This V4L2 subdev driver enables Digital Camera Memory Interface (DCMI)
> of STMicroelectronics STM32 SoC series.
> 
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/platform/Kconfig            |   12 +
>  drivers/media/platform/Makefile           |    2 +
>  drivers/media/platform/stm32/Makefile     |    1 +
>  drivers/media/platform/stm32/stm32-dcmi.c | 1403 +++++++++++++++++++++++++++++
>  4 files changed, 1418 insertions(+)
>  create mode 100644 drivers/media/platform/stm32/Makefile
>  create mode 100644 drivers/media/platform/stm32/stm32-dcmi.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index ac026ee..de6e18b 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -114,6 +114,18 @@ config VIDEO_S3C_CAMIF
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called s3c-camif.
>  
> +config VIDEO_STM32_DCMI
> +	tristate "Digital Camera Memory Interface (DCMI) support"

Is it OK with you if I change this to:

	tristate "STM32 Digital Camera Memory Interface (DCMI) support"

Right now the text gives no indication that this driver is for an STM32 platform.

No need to spin a new patch, just let me know you're OK with it and I'll make
the change.

Regards,

	Hans

> +	depends on VIDEO_V4L2 && OF && HAS_DMA
> +	depends on ARCH_STM32 || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This module makes the STM32 Digital Camera Memory Interface (DCMI)
> +	  available as a v4l2 device.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called stm32-dcmi.
> +
>  source "drivers/media/platform/soc_camera/Kconfig"
>  source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/am437x/Kconfig"
