Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39911 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaLFWcU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 17:32:20 -0500
Message-ID: <548383F1.1030400@iki.fi>
Date: Sun, 07 Dec 2014 00:32:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mn88472: add 5MHz dvb-t2 bandwitdh support
References: <1417903051-22099-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417903051-22099-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 12/06/2014 11:57 PM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

> ---
>   drivers/staging/media/mn88472/mn88472.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index c6895ee..be8a6d5 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -61,7 +61,10 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
>   	switch (c->delivery_system) {
>   	case SYS_DVBT:
>   	case SYS_DVBT2:
> -		if (c->bandwidth_hz <= 6000000) {
> +		if (c->bandwidth_hz <= 5000000) {
> +			memcpy(bw_val, "\xe5\x99\x9a\x1b\xa9\x1b\xa9", 7);
> +			bw_val2 = 0x03;
> +		} else if (c->bandwidth_hz <= 6000000) {
>   			/* IF 3570000 Hz, BW 6000000 Hz */
>   			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
>   			bw_val2 = 0x02;
>

-- 
http://palosaari.fi/
