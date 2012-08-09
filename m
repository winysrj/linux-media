Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43798 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759861Ab2HIWit (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 18:38:49 -0400
Received: from dyn3-82-128-186-179.psoas.suomi.net ([82.128.186.179] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SzbNP-0008FY-SR
	for linux-media@vger.kernel.org; Fri, 10 Aug 2012 01:38:47 +0300
Message-ID: <50243BEC.3020101@iki.fi>
Date: Fri, 10 Aug 2012 01:38:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] add LNA support for DVB API
References: <1342055041-18377-1-git-send-email-crope@iki.fi>
In-Reply-To: <1342055041-18377-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/12/2012 04:04 AM, Antti Palosaari wrote:

Any comment about that?
Should I store value to cache?
Should I offer get too?
Should I offer way to query possible values?

I think that implementation is quite simply and safe to add. Lets extend 
later if really needed...


regards
Antti


> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb/dvb-core/dvb_frontend.c |    5 +++++
>   drivers/media/dvb/dvb-core/dvb_frontend.h |    1 +
>   include/linux/dvb/frontend.h              |    4 +++-
>   3 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index b54c297..fe22aaa 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1020,6 +1020,7 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>
>   	_DTV_CMD(DTV_ISDBS_TS_ID, 1, 0),
>   	_DTV_CMD(DTV_DVBT2_PLP_ID, 1, 0),
> +	_DTV_CMD(DTV_LNA, 1, 0),
>
>   	/* Get */
>   	_DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
> @@ -1723,6 +1724,10 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>   	case DTV_INTERLEAVING:
>   		c->interleaving = tvp->u.data;
>   		break;
> +	case DTV_LNA:
> +		if (fe->ops.set_lna)
> +			r = fe->ops.set_lna(fe, tvp->u.data);
> +		break;
>
>   	/* ISDB-T Support here */
>   	case DTV_ISDBT_PARTIAL_RECEPTION:
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
> index 31a3d1c..628a821 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
> @@ -302,6 +302,7 @@ struct dvb_frontend_ops {
>   	int (*dishnetwork_send_legacy_command)(struct dvb_frontend* fe, unsigned long cmd);
>   	int (*i2c_gate_ctrl)(struct dvb_frontend* fe, int enable);
>   	int (*ts_bus_ctrl)(struct dvb_frontend* fe, int acquire);
> +	int (*set_lna)(struct dvb_frontend *, int);
>
>   	/* These callbacks are for devices that implement their own
>   	 * tuning algorithms, rather than a simple swzigzag
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index 2dd5823..e28802a 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -350,8 +350,9 @@ struct dvb_frontend_event {
>   #define DTV_ATSCMH_SCCC_CODE_MODE_D	59
>
>   #define DTV_INTERLEAVING			60
> +#define DTV_LNA					61
>
> -#define DTV_MAX_COMMAND				DTV_INTERLEAVING
> +#define DTV_MAX_COMMAND				DTV_LNA
>
>   typedef enum fe_pilot {
>   	PILOT_ON,
> @@ -424,6 +425,7 @@ enum atscmh_rs_code_mode {
>   	ATSCMH_RSCODE_RES        = 3,
>   };
>
> +#define LNA_AUTO INT_MIN
>
>   struct dtv_cmds_h {
>   	char	*name;		/* A display name for debugging purposes */
>


-- 
http://palosaari.fi/
