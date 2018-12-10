Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2845C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 17:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E20820821
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 17:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E20820821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbeLJRHN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:07:13 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:57516 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727538AbeLJRHN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 12:07:13 -0500
Received: from [IPv6:2001:983:e9a7:1:153f:c992:21d9:6742] ([IPv6:2001:983:e9a7:1:153f:c992:21d9:6742])
        by smtp-cloud8.xs4all.net with ESMTPA
        id WP1Sg6Y6cCZKKWP1TgF38P; Mon, 10 Dec 2018 18:07:11 +0100
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
To:     Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20181210160038.16122-1-thierry.reding@gmail.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <643e8da6-a8ed-145a-604d-f028e501add9@xs4all.nl>
Date:   Mon, 10 Dec 2018 18:07:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181210160038.16122-1-thierry.reding@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGyc7jKOu5vPlgycg8HpdyeI81VgGSHA3GJyeWR+aXELLLXJbohgASuNuuKk3FX6Hc/pHtcaWh2GqsL+kWikDpFNCUy2k15w/e4btnfaXk6fN7JcrwC2
 jEREHeBYzWEf+Aub5ZAL3mZPsdSzxp/Kj/fLGmicyYY3jOVFSztNH2lLoplAuvdLJHhg4GuHmj7Uclexl99n63l3MM/l3wbcaLX7PwzFC32Bu1n845psEimw
 FPiV/rGwnnvUF8r4MbDrZyptmHrQ2fLSyomGOFw6/w70jcV2p8efq4XQV6oSlaPe7PSW+lIW35OiHFqwbvEOs/ZGXzCWC2WzrDm2bBL0NEPc8dkfllUo78IN
 FhTfwSOE1SljMeop13F/+RULppPTzEmgGttz3rFmFWvjlX5vOXaRLEmzUSpJ4O141AZMZR0evogxnxPF2W5XjNoSgYVxoULgG+aupf4YpiBhspyoaCo=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Thierry,

On 12/10/18 5:00 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The CEC controller found on Tegra186 and Tegra194 is the same as on
> earlier generations.

Well... at least for the Tegra186 there is a problem that needs to be addressed first.
No idea if this was solved for the Tegra194, it might be present there as well.

The Tegra186 hardware connected the CEC lines of both HDMI outputs together. This is
a HW bug, and it means that only one of the two HDMI outputs can use the CEC block.

HDMI inputs CAN share the CEC line, but never outputs. There should have been two
CEC blocks, one for each HDMI output.

It should not be possible to use the same CEC block for both HDMI outputs on the 186.
Ideally it should be a required dts property that determines this. I'm not sure where
that should happen. One option might be to use the cec_notifier_get_conn() function
so you can register the CEC adapter for a specific connector only. For older tegra
versions the connector name would be NULL (i.e. don't care), for the 186 (and perhaps 194)
it would be a required property that tells the CEC driver which connector it is associated
with.

Just a suggestion, there might be other ways to implement this as well.

So before I can merge this I need to know first how you plan to handle this HW bug.

Regards,

	Hans

> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/media/platform/tegra-cec/tegra_cec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
> index aba488cd0e64..8a1e10d008d0 100644
> --- a/drivers/media/platform/tegra-cec/tegra_cec.c
> +++ b/drivers/media/platform/tegra-cec/tegra_cec.c
> @@ -472,6 +472,8 @@ static const struct of_device_id tegra_cec_of_match[] = {
>  	{ .compatible = "nvidia,tegra114-cec", },
>  	{ .compatible = "nvidia,tegra124-cec", },
>  	{ .compatible = "nvidia,tegra210-cec", },
> +	{ .compatible = "nvidia,tegra186-cec", },
> +	{ .compatible = "nvidia,tegra194-cec", },
>  	{},
>  };
>  
> 

