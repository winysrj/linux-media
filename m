Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36592 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716Ab2CWMuw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 08:50:52 -0400
Message-ID: <4F6C71AA.4000106@iki.fi>
Date: Fri, 23 Mar 2012 14:50:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 3/3] cxd2820r: delete unused function cxd2820r_init_t2
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com> <1331832829-4580-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331832829-4580-4-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>



On 15.03.2012 19:33, Gianluca Gennari wrote:
> Deleted unused declaration of function "cxd2820r_init_t2".
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/dvb/frontends/cxd2820r_priv.h |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
> index 9a9822c..568b996 100644
> --- a/drivers/media/dvb/frontends/cxd2820r_priv.h
> +++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
> @@ -146,8 +146,6 @@ int cxd2820r_read_snr_t2(struct dvb_frontend *fe, u16 *snr);
>
>   int cxd2820r_read_ucblocks_t2(struct dvb_frontend *fe, u32 *ucblocks);
>
> -int cxd2820r_init_t2(struct dvb_frontend *fe);
> -
>   int cxd2820r_sleep_t2(struct dvb_frontend *fe);
>
>   int cxd2820r_get_tune_settings_t2(struct dvb_frontend *fe,


-- 
http://palosaari.fi/
