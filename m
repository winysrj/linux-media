Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36213 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbbCOViE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 17:38:04 -0400
Received: by lamx15 with SMTP id x15so25552757lam.3
        for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 14:38:02 -0700 (PDT)
Message-ID: <5505FBB7.2020907@cogentembedded.com>
Date: Mon, 16 Mar 2015 00:37:59 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH/RFC] media: soc_camera: rcar_vin: Fix wait_for_completion
References: <1426430373-3443-1-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1426430373-3443-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 03/15/2015 05:39 PM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> When stopping abnormally, a driver can't return from wait_for_completion.
> This patch resolved this problem by changing wait_for_completion_timeout
> from wait_for_completion.

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---

[...]

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 279ab9f..ff0359b 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -821,6 +823,10 @@ static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
>   			priv->request_to_stop = true;
>   			spin_unlock_irq(&priv->lock);
>   			wait_for_completion(&priv->capture_stop);

    You forgot to remove this line, as already noted.

> +			if (!wait_for_completion_timeout(
> +				&priv->capture_stop,
> +				msecs_to_jiffies(TIMEOUT_MS)))

    Please indent the above 2 lines more to the right, so that they're easier 
on the eyes with the following line.

> +				priv->state = STOPPED;
>   			spin_lock_irq(&priv->lock);
>   		}
>   	}

WBR, Sergei

