Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38842 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdBASU4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 13:20:56 -0500
Received: by mail-wm0-f45.google.com with SMTP id r141so50565629wmg.1
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2017 10:20:55 -0800 (PST)
Date: Wed, 1 Feb 2017 18:20:48 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v6 03/10] ARM: multi_v7_defconfig:
 enable STMicroelectronics DELTA Support
Message-ID: <20170201182048.GE31988@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
 <1485965011-17388-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485965011-17388-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 01 Feb 2017, Hugues Fruchet wrote:

> Enables support of STMicroelectronics STiH4xx SoC series
> DELTA multi-format video decoder V4L2 driver.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>

Acked-by: Peter Griffin <peter.griffin@linaro.org>

> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index b01a438..5dff8fe 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -569,6 +569,7 @@ CONFIG_VIDEO_SAMSUNG_S5P_MFC=m
>  CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC=m
>  CONFIG_VIDEO_STI_BDISP=m
>  CONFIG_VIDEO_STI_HVA=m
> +CONFIG_VIDEO_STI_DELTA=m
>  CONFIG_VIDEO_RENESAS_JPU=m
>  CONFIG_VIDEO_RENESAS_VSP1=m
>  CONFIG_V4L_TEST_DRIVERS=y
