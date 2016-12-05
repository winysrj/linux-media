Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54301 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751064AbcLEMdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 07:33:00 -0500
Subject: Re: [PATCH v3 3/3] ARM: multi_v7_defconfig: enable STMicroelectronics
 HVA debugfs
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        linux-media@vger.kernel.org
References: <1480329054-30403-1-git-send-email-jean-christophe.trotin@st.com>
 <1480329054-30403-4-git-send-email-jean-christophe.trotin@st.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4cd00e98-5198-2c0e-4779-336f1cd32f8c@xs4all.nl>
Date: Mon, 5 Dec 2016 13:32:53 +0100
MIME-Version: 1.0
In-Reply-To: <1480329054-30403-4-git-send-email-jean-christophe.trotin@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please provide a commit message, it shouldn't be empty.

But are you sure you want to enable it in the defconfig? I think in general
DEBUGFS config options aren't enabled by default.

Regards,

	Hans

On 11/28/2016 11:30 AM, Jean-Christophe Trotin wrote:
> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index eb14ab6..7a15107 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -563,6 +563,7 @@ CONFIG_VIDEO_SAMSUNG_S5P_JPEG=m
>  CONFIG_VIDEO_SAMSUNG_S5P_MFC=m
>  CONFIG_VIDEO_STI_BDISP=m
>  CONFIG_VIDEO_STI_HVA=m
> +CONFIG_VIDEO_STI_HVA_DEBUGFS=y
>  CONFIG_DYNAMIC_DEBUG=y
>  CONFIG_VIDEO_RENESAS_JPU=m
>  CONFIG_VIDEO_RENESAS_VSP1=m
> 

