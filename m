Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52314 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab2CWMtn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 08:49:43 -0400
Message-ID: <4F6C7162.50900@iki.fi>
Date: Fri, 23 Mar 2012 14:49:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 1/3] cxd2820r: tweak search algorithm behavior
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com> <1331832829-4580-2-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331832829-4580-2-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>


Still I am little bit sceptical about that since dvb_frontend.h comments 
are speaking signal search - not for full LOCK. Maybe there is room for 
improvement somewhere else. Anyhow, better to merge that as now.

regards
Antti


On 15.03.2012 19:33, Gianluca Gennari wrote:
> MPIS based STBs running 3.x kernels and the Enigma2 OS are not able to tune
> DVB-T channels with the PCTV 290e using the current cxd2820r driver.
> DVB-T2 channels instead work properly.
>
> This patch fixes the problem by changing the condition to break out from the
> wait lock loop in the "search" function of the cxd2820r demodulator from
> FE_HAS_SIGNAL to FE_HAS_LOCK.
>
> As a consequence, the "search" function of the demodulator driver now returns
> DVBFE_ALGO_SEARCH_SUCCESS only if the frequency lock is successfully acquired.
>
> This behavior seems consistent with other demodulator drivers (e.g. stv090x,
> hd29l2, stv0900, stb0899, mb86a16).
>
> This patch has been successfully tested with DVB-T and DVB-T2 signals,
> on both PC and the mipsel STB running Enigma2.
> No apparent side effect has been observed on PC applications like Kaffeine.
> DVB-C is not available in my country so it's not tested.
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/dvb/frontends/cxd2820r_core.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
> index 5c7c2aa..3bba37d 100644
> --- a/drivers/media/dvb/frontends/cxd2820r_core.c
> +++ b/drivers/media/dvb/frontends/cxd2820r_core.c
> @@ -526,12 +526,12 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
>   		if (ret)
>   			goto error;
>
> -		if (status&  FE_HAS_SIGNAL)
> +		if (status&  FE_HAS_LOCK)
>   			break;
>   	}
>
>   	/* check if we have a valid signal */
> -	if (status) {
> +	if (status&  FE_HAS_LOCK) {
>   		priv->last_tune_failed = 0;
>   		return DVBFE_ALGO_SEARCH_SUCCESS;
>   	} else {


-- 
http://palosaari.fi/
