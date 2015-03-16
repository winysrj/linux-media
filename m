Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59727 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbbCPVXr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:23:47 -0400
Message-ID: <550749DF.2090500@iki.fi>
Date: Mon, 16 Mar 2015 23:23:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 02/10] r820t: change read_gain() code to match register
 layout
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-2-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Looks correct, I will apply it.
That routine is used to estimate signal strength only.

regards
Antti

> ---
>   drivers/media/tuners/r820t.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
> index 639c220..eaaf1dc 100644
> --- a/drivers/media/tuners/r820t.c
> +++ b/drivers/media/tuners/r820t.c
> @@ -1199,7 +1199,7 @@ static int r820t_read_gain(struct r820t_priv *priv)
>   	if (rc < 0)
>   		return rc;
>
> -	return ((data[3] & 0x0f) << 1) + ((data[3] & 0xf0) >> 4);
> +	return ((data[3] & 0x08) << 1) + ((data[3] & 0xf0) >> 4);
>   }
>
>   #if 0
>

-- 
http://palosaari.fi/
