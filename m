Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38140 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbcAKKay (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 05:30:54 -0500
Subject: Re: [PATCH] Fixed frequency range to 42-870 MHz
To: andreykosh000@mail.ru, linux-media@vger.kernel.org
References: <1452506324-11055-1-git-send-email-andreykosh000@mail.ru>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <5693845C.7090908@iki.fi>
Date: Mon, 11 Jan 2016 12:30:52 +0200
MIME-Version: 1.0
In-Reply-To: <1452506324-11055-1-git-send-email-andreykosh000@mail.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>


On 01/11/2016 11:58 AM, andreykosh000@mail.ru wrote:
> From: Andrei Koshkosh <andreykosh000@mail.ru>
>
> Signed-off-by: Andrei Koshkosh <andreykosh000@mail.ru>
> ---
>   drivers/media/tuners/si2157.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index ce157ed..86a753e 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -363,8 +363,8 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
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
