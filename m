Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:1238 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935175AbcIVPkl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 11:40:41 -0400
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Wei Yongjun <weiyongjun1@huawei.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 22 Sep 2016 17:40:27 +0200
Subject: Re: [PATCH -next] [media] bdisp: fix error return code in
 bdisp_probe()
Message-ID: <3010a122-c83f-90ab-9d6a-ae2a44fcc230@st.com>
References: <1474470578-2870-1-git-send-email-weiyj.lk@gmail.com>
In-Reply-To: <1474470578-2870-1-git-send-email-weiyj.lk@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,


Thank you for the patch.


On 09/21/2016 05:09 PM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Fix to return error code -EINVAL from the platform_get_resource() error
> handling case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>

> ---
>   drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> index 45f82b5..8236081 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> @@ -1337,6 +1337,7 @@ static int bdisp_probe(struct platform_device *pdev)
>   	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>   	if (!res) {
>   		dev_err(dev, "failed to get IRQ resource\n");
> +		ret = -EINVAL;
>   		goto err_clk;
>   	}
>
