Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49039 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbbCPVnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:43:03 -0400
Message-ID: <55074E64.10500@iki.fi>
Date: Mon, 16 Mar 2015 23:43:00 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 08/10] mn88473: check if firmware is already running before
 loading it
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-8-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-8-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Applied!

Antti

> ---
>   drivers/staging/media/mn88473/mn88473.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
> index 607ce4d..a23e59e 100644
> --- a/drivers/staging/media/mn88473/mn88473.c
> +++ b/drivers/staging/media/mn88473/mn88473.c
> @@ -196,8 +196,19 @@ static int mn88473_init(struct dvb_frontend *fe)
>
>   	dev_dbg(&client->dev, "\n");
>
> -	if (dev->warm)
> +	/* set cold state by default */
> +	dev->warm = false;
> +
> +	/* check if firmware is already running */
> +	ret = regmap_read(dev->regmap[0], 0xf5, &tmp);
> +	if (ret)
> +		goto err;
> +
> +	if (!(tmp & 0x1)) {
> +		dev_info(&client->dev, "firmware already running\n");
> +		dev->warm = true;
>   		return 0;
> +	}
>
>   	/* request the firmware, this will block and timeout */
>   	ret = request_firmware(&fw, fw_file, &client->dev);
>

-- 
http://palosaari.fi/
