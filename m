Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60576 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040AbaGOLI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 07:08:57 -0400
Message-ID: <53C50BC7.9020306@iki.fi>
Date: Tue, 15 Jul 2014 14:08:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] si2157: Add get_if_frequency callback
References: <1405411120-9569-1-git-send-email-zzam@gentoo.org> <1405411120-9569-3-git-send-email-zzam@gentoo.org>
In-Reply-To: <1405411120-9569-3-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks correct, I will apply that.

regards
Antti

On 07/15/2014 10:58 AM, Matthias Schwarzott wrote:
> This is needed for PCTV 522e support.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/tuners/si2157.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 4dbd3f1..06153fa 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -279,6 +279,12 @@ err:
>   	return ret;
>   }
>
> +static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +	*frequency = 5000000; /* default value of property 0x0706 */
> +	return 0;
> +}
> +
>   static const struct dvb_tuner_ops si2157_tuner_ops = {
>   	.info = {
>   		.name           = "Silicon Labs Si2157/Si2158",
> @@ -289,6 +295,7 @@ static const struct dvb_tuner_ops si2157_tuner_ops = {
>   	.init = si2157_init,
>   	.sleep = si2157_sleep,
>   	.set_params = si2157_set_params,
> +	.get_if_frequency = si2157_get_if_frequency,
>   };
>
>   static int si2157_probe(struct i2c_client *client,
>

-- 
http://palosaari.fi/
