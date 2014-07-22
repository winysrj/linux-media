Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47777 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbaGVTdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 15:33:07 -0400
Message-ID: <53CEBC6F.4050605@iki.fi>
Date: Tue, 22 Jul 2014 22:33:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] si2168: Fix a badly solved merge conflict
References: <1406057133-7657-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406057133-7657-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Could you merge it directly from patchwork.

regards
Antti

On 07/22/2014 10:25 PM, Mauro Carvalho Chehab wrote:
> changeset a733291d6934 didn't merge the fixes well. It ended by
> restoring some bad logic removed there.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/dvb-frontends/si2168.c | 14 --------------
>   1 file changed, 14 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 842c4a555d01..02127613eeff 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -381,20 +381,6 @@ static int si2168_init(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> -	cmd.args[0] = 0x05;
> -	cmd.args[1] = 0x00;
> -	cmd.args[2] = 0xaa;
> -	cmd.args[3] = 0x4d;
> -	cmd.args[4] = 0x56;
> -	cmd.args[5] = 0x40;
> -	cmd.args[6] = 0x00;
> -	cmd.args[7] = 0x00;
> -	cmd.wlen = 8;
> -	cmd.rlen = 1;
> -	ret = si2168_cmd_execute(s, &cmd);
> -	if (ret)
> -		goto err;
> -
>   	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
>   			cmd.args[4] << 0;
>
>

-- 
http://palosaari.fi/
