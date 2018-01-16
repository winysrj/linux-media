Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:48983 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750741AbeAPFKK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 00:10:10 -0500
Subject: Re: [PATCH 6/7] si2168: Announce frontend creation failure
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
 <1515773982-6411-6-git-send-email-brad@nextdimension.cc>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <64e288a7-3d5d-6c90-7771-cd593ccffc63@iki.fi>
Date: Tue, 16 Jan 2018 07:10:08 +0200
MIME-Version: 1.0
In-Reply-To: <1515773982-6411-6-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hmmm, IIRC driver core even prints some error when driver probe fails? 
After that you could enable module debug logging to see more 
information. So I don't see point for that change.

regards
Antti

On 01/12/2018 06:19 PM, Brad Love wrote:
> The driver outputs on success, but is silent on failure. Give
> one message that probe failed.
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>   drivers/media/dvb-frontends/si2168.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 429c03a..c1a638c 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -810,7 +810,7 @@ static int si2168_probe(struct i2c_client *client,
>   err_kfree:
>   	kfree(dev);
>   err:
> -	dev_dbg(&client->dev, "failed=%d\n", ret);
> +	dev_warn(&client->dev, "probe failed = %d\n", ret);
>   	return ret;
>   }
>   
> 

-- 
http://palosaari.fi/
