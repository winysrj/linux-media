Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60102 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843AbcB0Xs5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 18:48:57 -0500
Subject: Re: [PATCH] Fixed frequency range for Si2157 tuner to 42-870 MHz
To: andreykosh000@mail.ru, linux-media@vger.kernel.org
References: <1456615348-2216-1-git-send-email-andreykosh000@mail.ru>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56D235E7.7080305@iki.fi>
Date: Sun, 28 Feb 2016 01:48:55 +0200
MIME-Version: 1.0
In-Reply-To: <1456615348-2216-1-git-send-email-andreykosh000@mail.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patch is already applied!

Antti

On 02/28/2016 01:22 AM, andreykosh000@mail.ru wrote:
> From: Andrei Koshkosh <andreykosh000@mail.ru>
>
> Signed-off-by: Andrei Koshkosh <andreykosh000@mail.ru>
>
> 	modified:   drivers/media/tuners/si2157.c
> This tuner supports frequency range from 42MHz to 870MHz
> ---
>   drivers/media/tuners/si2157.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 0e1ca2b..5da5b42 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -364,8 +364,8 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
>   static const struct dvb_tuner_ops si2157_ops = {
>   	.info = {
>   		.name           = "Silicon Labs Si2146/2147/2148/2157/2158",
> -		.frequency_min  = 55000000,
> -		.frequency_max  = 862000000,
> +		.frequency_min  = 42000000,
> +		.frequency_max  = 870000000,
>   	},
>
>   	.init = si2157_init,
>

-- 
http://palosaari.fi/
