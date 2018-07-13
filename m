Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:50061 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbeGMJnw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 05:43:52 -0400
Subject: Re: [PATCH] ARM: multi_v7_defconfig: enable STM32 DCMI media support
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
References: <1530781532-7125-1-git-send-email-hugues.fruchet@st.com>
From: Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <605b6b51-a17a-eda3-4767-67c175ddcde2@st.com>
Date: Fri, 13 Jul 2018 11:29:30 +0200
MIME-Version: 1.0
In-Reply-To: <1530781532-7125-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On 07/05/2018 11:05 AM, Hugues Fruchet wrote:
> Enables support of STM32 DCMI V4L2 media driver.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>   arch/arm/configs/multi_v7_defconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index 8f6be19..42ad73f76 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -578,6 +578,7 @@ CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC=m
>   CONFIG_VIDEO_STI_BDISP=m
>   CONFIG_VIDEO_STI_HVA=m
>   CONFIG_VIDEO_STI_DELTA=m
> +CONFIG_VIDEO_STM32_DCMI=m
>   CONFIG_VIDEO_RENESAS_JPU=m
>   CONFIG_VIDEO_RENESAS_VSP1=m
>   CONFIG_V4L_TEST_DRIVERS=y
> 

Applied on stm32-next.

Thanks.
Alex
