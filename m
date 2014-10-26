Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48724 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaJZMNc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 08:13:32 -0400
Message-ID: <544CE569.7060507@iki.fi>
Date: Sun, 26 Oct 2014 14:13:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH] dvb-core: set default properties of ISDB-S
References: <1414324874-16417-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414324874-16417-1-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka
How is channel bandwidth defined? Is it static? 38961000 Hz?

regards
Antti

On 10/26/2014 02:01 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
>
> delsys-fixed props should be set in dvb-core instead of in each driver.
> ---
>   drivers/media/dvb-core/dvb_frontend.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index c862ad7..1e9b814 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -962,6 +962,10 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>   	case SYS_ATSC:
>   		c->modulation = VSB_8;
>   		break;
> +	case SYS_ISDBS:
> +		c->symbol_rate = 28860000;
> +		c->rolloff = ROLLOFF_35;
> +		break;
>   	default:
>   		c->modulation = QAM_AUTO;
>   		break;
> @@ -2074,6 +2078,7 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
>   		break;
>   	case SYS_DVBS:
>   	case SYS_TURBO:
> +	case SYS_ISDBS:
>   		rolloff = 135;
>   		break;
>   	case SYS_DVBS2:
>

-- 
http://palosaari.fi/
