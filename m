Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:10471 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdLZBjs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Dec 2017 20:39:48 -0500
Subject: Re: [PATCH -next] media: atmel-isc: Make local symbol
 fmt_configs_list static
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <1513994224-86350-1-git-send-email-weiyongjun1@huawei.com>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <fa1db8ce-c93a-cb0c-a5e0-a8886879090e@Microchip.com>
Date: Tue, 26 Dec 2017 09:39:42 +0800
MIME-Version: 1.0
In-Reply-To: <1513994224-86350-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2017/12/23 9:57, Wei Yongjun wrote:
> Fixes the following sparse warning:
>
> drivers/media/platform/atmel/atmel-isc.c:338:19: warning:
>   symbol 'fmt_configs_list' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
Acked-by: Wenyou Yang <wenyou.yang@microchip.com>

>   drivers/media/platform/atmel/atmel-isc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index 0c26356..2dd72fc 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -335,7 +335,7 @@ struct isc_device {
>   	},
>   };
>   
> -struct fmt_config fmt_configs_list[] = {
> +static struct fmt_config fmt_configs_list[] = {
>   	{
>   		.fourcc		= V4L2_PIX_FMT_SBGGR8,
>   		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>
