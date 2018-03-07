Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35525 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbeCGXMh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 18:12:37 -0500
Subject: Re: [PATCH v2] i2c: adv748x: afe: fix sparse warning
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: linux-renesas-soc@vger.kernel.org
References: <20180307225816.9801-1-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieranbingham@gmail.com>
Message-ID: <f0c23d2b-c71d-3769-171b-c62733853397@gmail.com>
Date: Wed, 7 Mar 2018 23:12:34 +0000
MIME-Version: 1.0
In-Reply-To: <20180307225816.9801-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for your patch.

On 07/03/18 22:58, Niklas Söderlund wrote:
> This fixes the following sparse warning:
> 
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    expected unsigned int [usertype] *signal
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    got int *<noident>
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34: warning: incorrect type in argument 2 (different signedness)
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
> 
> * Changes since v1
> - Use u32 instead of unsigned int as suggested by Geert.
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index 5188178588c9067d..61514bae7e5ceb42 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -275,7 +275,8 @@ static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>  	struct adv748x_state *state = adv748x_afe_to_state(afe);
> -	int ret, signal = V4L2_IN_ST_NO_SIGNAL;
> +	u32 signal = V4L2_IN_ST_NO_SIGNAL;
> +	int ret;
>  
>  	mutex_lock(&state->mutex);
>  
> 
