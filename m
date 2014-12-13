Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58273 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210AbaLMEPM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 23:15:12 -0500
Message-ID: <548BBD4D.3060001@iki.fi>
Date: Sat, 13 Dec 2014 06:15:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] mn88472: implemented ber reporting
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-4-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418429925-16342-4-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2014 02:18 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Reviewed-by: Antti Palosaari <crope@iki.fi>


Even I could accept that, as a staging driver, I see there some issues:

* missing commit message (ok, it is trivial and patch subject says)

* it is legacy DVBv3 API BER reporting, whilst driver is DVBv5 mostly 
due to DVB-T2... So DVBv5 statistics are preferred.

* dynamic debugs has unneded __func__,  see 
Documentation/dynamic-debug-howto.txt

* there should be spaces used around binary and ternary calculation 
operators, see Documentation/CodingStyle for more info how it should be.


Could you read overall these two docs before make new patches:
Documentation/CodingStyle
Documentation/dynamic-debug-howto.txt

also use scripts/checkpatch.pl to verify patch, like that
git diff | ./scripts/checkpatch.pl -

regards
Antti

> ---
>   drivers/staging/media/mn88472/mn88472.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 746cc94..8b35639 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -392,6 +392,36 @@ err:
>   	return ret;
>   }
>
> +static int mn88472_read_ber(struct dvb_frontend *fe, u32 *ber)
> +{
> +	struct i2c_client *client = fe->demodulator_priv;
> +	struct mn88472_dev *dev = i2c_get_clientdata(client);
> +	int ret, err, len;
> +	u8 data[3];
> +
> +	dev_dbg(&client->dev, "%s:\n", __func__);
> +
> +	ret = regmap_bulk_read(dev->regmap[0], 0x9F , data, 3);
> +	if (ret)
> +		goto err;
> +	err = data[0]<<16 | data[1]<<8 | data[2];
> +
> +	ret = regmap_bulk_read(dev->regmap[0], 0xA2 , data, 2);
> +	if (ret)
> +		goto err;
> +	len = data[0]<<8 | data[1];
> +
> +	if (len)
> +		*ber = (err*100)/len;
> +	else
> +		*ber = 0;
> +
> +	return 0;
> +err:
> +	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
> +	return ret;
> +}
> +
>   static struct dvb_frontend_ops mn88472_ops = {
>   	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
>   	.info = {
> @@ -425,6 +455,7 @@ static struct dvb_frontend_ops mn88472_ops = {
>   	.set_frontend = mn88472_set_frontend,
>
>   	.read_status = mn88472_read_status,
> +	.read_ber = mn88472_read_ber,
>   };
>
>   static int mn88472_probe(struct i2c_client *client,
>

-- 
http://palosaari.fi/
