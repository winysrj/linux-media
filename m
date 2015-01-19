Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51459 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbbASNY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:24:26 -0500
Message-ID: <54BD0573.3020207@xs4all.nl>
Date: Mon, 19 Jan 2015 14:24:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 01/22] si2168: define symbol rate limits
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2014 10:34 PM, Antti Palosaari wrote:
> w_scan complains about missing symbol rate limits:
> This dvb driver is *buggy*: the symbol rate limits are undefined - please report to linuxtv.org
> 
> Chip supports 1 to 7.2 MSymbol/s on DVB-C.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Antti,

Are you planning to make a pull request of this patch series?

It looks good to me, so for this patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

BTW, please add a cover letter whenever you post a patch series (git send-email --compose).
It makes it easier to get an overview of what the patch series is all about.

Regards,

	Hans

> ---
>  drivers/media/dvb-frontends/si2168.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index ce9ab44..acf0fc3 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -635,6 +635,8 @@ static const struct dvb_frontend_ops si2168_ops = {
>  	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
>  	.info = {
>  		.name = "Silicon Labs Si2168",
> +		.symbol_rate_min = 1000000,
> +		.symbol_rate_max = 7200000,
>  		.caps =	FE_CAN_FEC_1_2 |
>  			FE_CAN_FEC_2_3 |
>  			FE_CAN_FEC_3_4 |
> 

