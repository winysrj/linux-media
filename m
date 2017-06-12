Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61368 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdFLMlX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 08:41:23 -0400
Subject: Re: [PATCH 8/9] s5p_cec: set the CEC_CAP_NEEDS_HPD flag if needed
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1bf6c49a-97e2-4a1c-9a05-41c55b56439e@samsung.com>
Date: Mon, 12 Jun 2017 14:41:16 +0200
MIME-version: 1.0
In-reply-to: <20170607144616.15247-9-hverkuil@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
        <20170607144616.15247-9-hverkuil@xs4all.nl>
        <CGME20170612124120epcas1p3ef17f5a1f6f71c00757d4f3ee283ffc8@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/07/2017 04:46 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Use the needs-hpd DT property to determine if the CEC_CAP_NEEDS_HPD
> should be set.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>   drivers/media/platform/s5p-cec/s5p_cec.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
> index 65a223e578ed..8e06071a7977 100644
> --- a/drivers/media/platform/s5p-cec/s5p_cec.c
> +++ b/drivers/media/platform/s5p-cec/s5p_cec.c
> @@ -173,6 +173,7 @@ static int s5p_cec_probe(struct platform_device *pdev)
>   	struct platform_device *hdmi_dev;
>   	struct resource *res;
>   	struct s5p_cec_dev *cec;
> +	bool needs_hpd = of_property_read_bool(pdev->dev.of_node, "needs-hpd");

dev->of_node could also be used instead of pdev->dev.of_node.

>   	int ret;
>   
>   	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
> @@ -221,7 +222,8 @@ static int s5p_cec_probe(struct platform_device *pdev)
>   	cec->adap = cec_allocate_adapter(&s5p_cec_adap_ops, cec,
>   		CEC_NAME,
>   		CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
> -		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, 1);
> +		CEC_CAP_PASSTHROUGH | CEC_CAP_RC |
> +		(needs_hpd ? CEC_CAP_NEEDS_HPD : 0), 1);
>   	ret = PTR_ERR_OR_ZERO(cec->adap);
>   	if (ret)
>   		return ret; 

-- 
Regards,
Sylwester
