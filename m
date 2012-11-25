Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48437 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2KYPc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 10:32:29 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4100356eaa.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 07:32:27 -0800 (PST)
Message-ID: <50B23A09.4010105@gmail.com>
Date: Sun, 25 Nov 2012 16:32:25 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 1/6] [media] s5p-fimc: Use devm_clk_get in mipi-csis.c
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org> <1353671443-2978-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353671443-2978-2-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 11/23/2012 12:50 PM, Sachin Kamat wrote:
> devm_clk_get is device managed and makes error handling and cleanup
> a bit simpler.

Can we postpone this once devm_clk_prepare() is available ?

> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/platform/s5p-fimc/mipi-csis.c |    6 +-----
>   1 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
> index 4c961b1..d624bfa 100644
> --- a/drivers/media/platform/s5p-fimc/mipi-csis.c
> +++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
> @@ -341,8 +341,6 @@ static void s5pcsis_clk_put(struct csis_state *state)
>   		if (IS_ERR_OR_NULL(state->clock[i]))
>   			continue;
>   		clk_unprepare(state->clock[i]);
> -		clk_put(state->clock[i]);
> -		state->clock[i] = NULL;

This line shouldn't be removed, it protects from releasing already
released clock resource. In fact state->clock[i] = ERR_PTR(-EINVAL);
would be more correct, but that's a different story.

>   	}
>   }
>
> @@ -352,13 +350,11 @@ static int s5pcsis_clk_get(struct csis_state *state)
>   	int i, ret;
>
>   	for (i = 0; i<  NUM_CSIS_CLOCKS; i++) {
> -		state->clock[i] = clk_get(dev, csi_clock_name[i]);
> +		state->clock[i] = devm_clk_get(dev, csi_clock_name[i]);
>   		if (IS_ERR(state->clock[i]))
>   			goto err;
>   		ret = clk_prepare(state->clock[i]);
>   		if (ret<  0) {
> -			clk_put(state->clock[i]);
> -			state->clock[i] = NULL;

And same here, now we have a pointer to valid, unprepared clock in
state->clock[i]. When s5pcsis_clk_put() gets called afterwards it will
invoke unbalanced clk_unprepare() in this clock.

I would prefer to hold on with that sort of changes in s5p-fimc driver,
until after devm_clk_prepare() is available.

>   			goto err;
>   		}
>   	}

Regards,
Sylwester
