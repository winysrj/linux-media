Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35250 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3EBKXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 06:23:24 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MM6003Q526LXO70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 May 2013 11:23:22 +0100 (BST)
Message-id: <51823E99.9040201@samsung.com>
Date: Thu, 02 May 2013 12:23:21 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH v2 1/2] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in
 hdmi_drv.c
References: <1367471009-7103-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1367471009-7103-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 05/02/2013 07:03 AM, Sachin Kamat wrote:
> NULL check on clocks obtained using common clock APIs should not
> be done. Use IS_ERR only.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Changes since v1:
> Initialised clocks to invalid value.
> ---
>  drivers/media/platform/s5p-tv/hdmi_drv.c |   18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
> index 4e86626..ed1a695 100644
> --- a/drivers/media/platform/s5p-tv/hdmi_drv.c
> +++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
> @@ -765,15 +765,15 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
>  		regulator_bulk_free(res->regul_count, res->regul_bulk);
>  	/* kfree is NULL-safe */
>  	kfree(res->regul_bulk);
> -	if (!IS_ERR_OR_NULL(res->hdmiphy))
> +	if (!IS_ERR(res->hdmiphy))
>  		clk_put(res->hdmiphy);
> -	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
> +	if (!IS_ERR(res->sclk_hdmiphy))
>  		clk_put(res->sclk_hdmiphy);
> -	if (!IS_ERR_OR_NULL(res->sclk_pixel))
> +	if (!IS_ERR(res->sclk_pixel))
>  		clk_put(res->sclk_pixel);
> -	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
> +	if (!IS_ERR(res->sclk_hdmi))
>  		clk_put(res->sclk_hdmi);
> -	if (!IS_ERR_OR_NULL(res->hdmi))
> +	if (!IS_ERR(res->hdmi))
>  		clk_put(res->hdmi);
>  	memset(res, 0, sizeof(*res));

Shouldn't this memset be removed not ? Then res->regul_count would need to
be set to 0.

>  }
> @@ -793,8 +793,14 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
>  	dev_dbg(dev, "HDMI resource init\n");
>  
>  	memset(res, 0, sizeof(*res));

This could be replaced with
	res->regul_count = 0;

> -	/* get clocks, power */
>  
> +	res->hdmi	 = ERR_PTR(-EINVAL);

You could remove this line, as res->sclk_hdmi will be set by clk_get()
right below.

> +	res->sclk_hdmi	 = ERR_PTR(-EINVAL);
> +	res->sclk_pixel	 = ERR_PTR(-EINVAL);
> +	res->sclk_hdmiphy = ERR_PTR(-EINVAL);
> +	res->hdmiphy	 = ERR_PTR(-EINVAL);
> +
> +	/* get clocks, power */
>  	res->hdmi = clk_get(dev, "hdmi");
>  	if (IS_ERR(res->hdmi)) {
>  		dev_err(dev, "failed to get clock 'hdmi'\n");
> 

Regards,
Sylwester
