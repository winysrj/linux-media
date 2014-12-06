Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57161 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaLFQ3a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 11:29:30 -0500
Message-ID: <54832EE7.10705@iki.fi>
Date: Sat, 06 Dec 2014 18:29:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] mn88472: make sure the private data struct is nulled
 after free
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se> <1417825533-13081-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417825533-13081-2-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

But that is not needed anymore ?

regards
Antti

On 12/06/2014 02:25 AM, Benjamin Larsson wrote:
> Using this driver with the attach dvb model might trigger a use
> after free when unloading the driver. With this change the driver
> will always fail on unload instead of randomly crash depending
> on if the memory has been reused or not.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/staging/media/mn88472/mn88472.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 36ef39b..a9d5f0a 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -489,6 +489,7 @@ static int mn88472_remove(struct i2c_client *client)
>
>   	regmap_exit(dev->regmap[0]);
>
> +	memset(dev, 0, sizeof(*dev));
>   	kfree(dev);
>
>   	return 0;
>

-- 
http://palosaari.fi/
