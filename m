Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33232 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934303AbeCGXCM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 18:02:12 -0500
Received: by mail-lf0-f67.google.com with SMTP id o145-v6so5700994lff.0
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 15:02:11 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 8 Mar 2018 00:02:09 +0100
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] i2c: adv748x: afe: fix sparse warning
Message-ID: <20180307230209.GB2205@bigcity.dyn.berto.se>
References: <20180307225816.9801-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180307225816.9801-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC linux-media.

It's linux-media@vger.kernel.org not linux-media@vger.kernel.or, sorry
for the noise.

On 2018-03-07 23:58:16 +0100, Niklas Söderlund wrote:
> This fixes the following sparse warning:
> 
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    expected unsigned int [usertype] *signal
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    got int *<noident>
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34: warning: incorrect type in argument 2 (different signedness)
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
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
> -- 
> 2.16.2
> 

-- 
Regards,
Niklas Söderlund
