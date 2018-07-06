Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54686 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932562AbeGFNvM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jul 2018 09:51:12 -0400
Subject: Re: [PATCH] media: stm32: dcmi: replace "%p" with "%pK"
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        mchehab@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, hans.verkuil@cisco.com,
        hugues.fruchet@st.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
References: <20180706130355.22100-1-benjamin.gaignard@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <64b2a2ea-2da9-c40d-eae4-6375079771e7@xs4all.nl>
Date: Fri, 6 Jul 2018 15:51:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180706130355.22100-1-benjamin.gaignard@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/07/18 15:03, Benjamin Gaignard wrote:
> The format specifier "%p" can leak kernel addresses.
> Use "%pK" instead.

This patch no longer applies. AFAICT it is obsolete after some code reorg.

Regards,

	Hans

> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  drivers/media/platform/stm32/stm32-dcmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
> index 2e1933d872ee..fe90672cf16f 100644
> --- a/drivers/media/platform/stm32/stm32-dcmi.c
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -1753,7 +1753,7 @@ static int dcmi_probe(struct platform_device *pdev)
>  
>  	ret = clk_prepare(mclk);
>  	if (ret) {
> -		dev_err(&pdev->dev, "Unable to prepare mclk %p\n", mclk);
> +		dev_err(&pdev->dev, "Unable to prepare mclk %pK\n", mclk);
>  		goto err_dma_release;
>  	}
>  
> 
