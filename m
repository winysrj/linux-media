Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45038 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaH0SKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 14:10:07 -0400
Message-ID: <53FE1EF5.5060007@iki.fi>
Date: Wed, 27 Aug 2014 21:09:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1409153356-1887-2-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka
I have feeling DVBv5 API is aimed to transfer data via property cached. 
I haven't done much driver for DVBv5 statistics, but recently I 
implemented CNR (DVBv5 stats) to Si2168 driver and it just writes all 
the values directly to property cache. I expect RF strength (RSSI) is 
just similar.

Antti



On 08/27/2014 06:29 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
>
> fe->ops.tuner_ops.get_rf_strength() reports its result in u16,
> while in DVB APIv5 it should be reported in s64 and by 0.001dBm.
>
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>   drivers/media/dvb-core/dvb_frontend.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index 816269e..f6222b5 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -222,6 +222,8 @@ struct dvb_tuner_ops {
>   #define TUNER_STATUS_STEREO 2
>   	int (*get_status)(struct dvb_frontend *fe, u32 *status);
>   	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
> +	/** get signal strengh in 0.001dBm, in accordance with APIv5 */
> +	int (*get_rf_strength_dbm)(struct dvb_frontend *fe, s64 *strength);
>   	int (*get_afc)(struct dvb_frontend *fe, s32 *afc);
>
>   	/** These are provided separately from set_params in order to facilitate silicon
>

-- 
http://palosaari.fi/
