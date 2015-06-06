Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45083 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbbFFJLh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 05:11:37 -0400
Message-ID: <5572B947.1050500@iki.fi>
Date: Sat, 06 Jun 2015 12:11:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "[media] saa7164: Improvements for I2C handling"
References: <1433576698-1780-1-git-send-email-olli.salonen@iki.fi> <1433576698-1780-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1433576698-1780-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 10:44 AM, Olli Salonen wrote:
> This reverts commit ad90b6b0f10566d4a5546e27fe455ce3b5e6b6c7.
>
> This patch breaks I2C communication towards Si2168. After reverting and
> applying the other patch in this series the I2C communication is
> correct.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

> ---
>   drivers/media/pci/saa7164/saa7164-api.c | 11 +----------
>   1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/drivers/media/pci/saa7164/saa7164-api.c b/drivers/media/pci/saa7164/saa7164-api.c
> index e807703..e7e586c 100644
> --- a/drivers/media/pci/saa7164/saa7164-api.c
> +++ b/drivers/media/pci/saa7164/saa7164-api.c
> @@ -1385,8 +1385,7 @@ int saa7164_api_i2c_read(struct saa7164_i2c *bus, u8 addr, u32 reglen, u8 *reg,
>   	 *       08... register address
>   	 */
>   	memset(buf, 0, sizeof(buf));
> -	if (reg)
> -		memcpy((buf + 2 * sizeof(u32) + 0), reg, reglen);
> +	memcpy((buf + 2 * sizeof(u32) + 0), reg, reglen);
>   	*((u32 *)(buf + 0 * sizeof(u32))) = reglen;
>   	*((u32 *)(buf + 1 * sizeof(u32))) = datalen;
>
> @@ -1475,14 +1474,6 @@ int saa7164_api_i2c_write(struct saa7164_i2c *bus, u8 addr, u32 datalen,
>   	 *       04-07 dest bytes to write
>   	 *       08... register address
>   	 */
> -	if (datalen == 1) {
> -		/* Workaround for issues with i2c components
> -		 * that issue writes with no data. IE: SI2168/2157
> -		 * Increase reglen by 1, strobe out an additional byte,
> -		 * ignored by SI2168/2157.
> -		 */
> -		datalen++;
> -	}
>   	*((u32 *)(buf + 0 * sizeof(u32))) = reglen;
>   	*((u32 *)(buf + 1 * sizeof(u32))) = datalen - reglen;
>   	memcpy((buf + 2 * sizeof(u32)), data, datalen);
>

-- 
http://palosaari.fi/
