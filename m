Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56834 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751510AbeA3HWA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 02:22:00 -0500
Subject: Re: [PATCH 8/8] platform: vivid-cec: fix potential integer overflow
 in vivid_cec_pin_adap_events
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
 <00eea53890802b679c138fc7f68a0f162261d95c.1517268668.git.gustavo@embeddedor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2e1afa55-d214-f932-4ba7-2e21f6a2cd3d@xs4all.nl>
Date: Tue, 30 Jan 2018 08:21:54 +0100
MIME-Version: 1.0
In-Reply-To: <00eea53890802b679c138fc7f68a0f162261d95c.1517268668.git.gustavo@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On 01/30/2018 01:33 AM, Gustavo A. R. Silva wrote:
> Cast len to const u64 in order to avoid a potential integer
> overflow. This variable is being used in a context that expects
> an expression of type const u64.
> 
> Addresses-Coverity-ID: 1454996 ("Unintentional integer overflow")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/media/platform/vivid/vivid-cec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
> index b55d278..30240ab 100644
> --- a/drivers/media/platform/vivid/vivid-cec.c
> +++ b/drivers/media/platform/vivid/vivid-cec.c
> @@ -83,7 +83,7 @@ static void vivid_cec_pin_adap_events(struct cec_adapter *adap, ktime_t ts,
>  	if (adap == NULL)
>  		return;
>  	ts = ktime_sub_us(ts, (CEC_TIM_START_BIT_TOTAL +
> -			       len * 10 * CEC_TIM_DATA_BIT_TOTAL));
> +			       (const u64)len * 10 * CEC_TIM_DATA_BIT_TOTAL));

This makes no sense. Certainly the const part is pointless. And given that
len is always <= 16 there definitely is no overflow.

I don't really want this cast in the code.

Sorry,

	Hans

>  	cec_queue_pin_cec_event(adap, false, ts);
>  	ts = ktime_add_us(ts, CEC_TIM_START_BIT_LOW);
>  	cec_queue_pin_cec_event(adap, true, ts);
> 
