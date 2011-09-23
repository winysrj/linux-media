Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab1IWWd0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:33:26 -0400
Message-ID: <4E7D0931.30509@redhat.com>
Date: Fri, 23 Sep 2011 19:33:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 10/17]DVB:Siano drivers - Improve signal reception parameters
 monitoring using siano statistic functions
References: <1316514691.5199.88.camel@Doron-Ubuntu>
In-Reply-To: <1316514691.5199.88.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:31, Doron Cohen escreveu:
> 
> Hi,
> This patch Improve signal reception parameters monitoring using siano
> statistic functions.
> Thanks,
> Doron Cohen
> 
> --------------
> 
> 
>>From 0325e0559d99ccb5ac04e9edef8eb0281a410c52 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Mon, 19 Sep 2011 14:43:01 +0300
> Subject: [PATCH 13/21] Use get_statistics_ex instead of depracated
> get_statistics

Does that mean that the old firmwares won't work?

> 
> ---
>  drivers/media/dvb/siano/smsdvb.c |   73
> +++++++++++++++++++++-----------------
>  1 files changed, 40 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/smsdvb.c
> b/drivers/media/dvb/siano/smsdvb.c
> index b80868c..aa345ed 100644
> --- a/drivers/media/dvb/siano/smsdvb.c
> +++ b/drivers/media/dvb/siano/smsdvb.c
> @@ -48,6 +48,7 @@ struct smsdvb_client_t {
>  	fe_status_t             fe_status;
>  
>  	struct completion       tune_done;
> +	struct completion get_stats_done;
>  
>  	/* todo: save freq/band instead whole struct */
>  	struct dvb_frontend_parameters fe_params;
> @@ -330,7 +331,7 @@ static int smsdvb_onresponse(void *context, struct
> smscore_buffer_t *cb)
>  		is_status_update = true;
>  		break;
>  	}
> -	case MSG_SMS_GET_STATISTICS_RES: {
> +	case MSG_SMS_GET_STATISTICS_EX_RES: {
>  		union {
>  			struct SMSHOSTLIB_STATISTICS_ISDBT_S  isdbt;
>  			struct SMSHOSTLIB_STATISTICS_DVB_S    dvb;
> @@ -343,22 +344,20 @@ static int smsdvb_onresponse(void *context, struct
> smscore_buffer_t *cb)
>  		is_status_update = true;
>  
>  		switch (smscore_get_device_mode(client->coredev)) {
> +		case SMSHOSTLIB_DEVMD_DVBT:
> +		case SMSHOSTLIB_DEVMD_DVBH:
> +		case SMSHOSTLIB_DEVMD_DVBT_BDA:
> +			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
> +			break;
>  		case SMSHOSTLIB_DEVMD_ISDBT:
>  		case SMSHOSTLIB_DEVMD_ISDBT_BDA:
>  			smsdvb_update_isdbt_stats(pReceptionData, &p->isdbt);
>  			break;
>  		default:
> -			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
> -		}
> -		if (!pReceptionData->IsDemodLocked) {
> -			pReceptionData->SNR = 0;
> -			pReceptionData->BER = 0;
> -			pReceptionData->BERErrorCount = 0;
> -			pReceptionData->InBandPwr = 0;
> -			pReceptionData->ErrorTSPackets = 0;
> +			break;
>  		}
> -
> -		complete(&client->tune_done);
> +		is_status_update = true;
> +		complete(&client->get_stats_done);
>  		break;
>  	}
>  	default:
> @@ -470,18 +469,22 @@ static int smsdvb_sendrequest_and_wait(struct
> smsdvb_client_t *client,
>  						0 : -ETIME;
>  }
>  
> -static int smsdvb_send_statistics_request(struct smsdvb_client_t
> *client)
> -{
> -	int rc;
> -	struct SmsMsgHdr_S Msg = { MSG_SMS_GET_STATISTICS_REQ,
> -				    DVBT_BDA_CONTROL_MSG_ID,
> -				    HIF_TASK,
> -				    sizeof(struct SmsMsgHdr_S), 0 };
> +static int smsdvb_get_statistics_ex(struct dvb_frontend *fe) {
>  
> -	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
> -					  &client->tune_done);
> +	struct smsdvb_client_t *client =
> +	    container_of(fe, struct smsdvb_client_t, frontend);
> +	struct SmsMsgHdr_S Msg;
> +
> +	Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
> +	Msg.msgDstId = HIF_TASK;
> +	Msg.msgFlags = 0;
> +	Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
> +	Msg.msgLength = sizeof(Msg);
> +
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)&Msg);
> +	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
> +					   &client->get_stats_done);
>  
> -	return rc;
>  }
>  
>  static inline int led_feedback(struct smsdvb_client_t *client)
> @@ -500,7 +503,7 @@ static int smsdvb_read_status(struct dvb_frontend
> *fe, fe_status_t *stat)
>  	struct smsdvb_client_t *client;
>  	client = container_of(fe, struct smsdvb_client_t, frontend);
>  
> -	rc = smsdvb_send_statistics_request(client);
> +	rc = smsdvb_get_statistics_ex(fe);
>  
>  	*stat = client->fe_status;
>  
> @@ -515,7 +518,7 @@ static int smsdvb_read_ber(struct dvb_frontend *fe,
> u32 *ber)
>  	struct smsdvb_client_t *client;
>  	client = container_of(fe, struct smsdvb_client_t, frontend);
>  
> -	rc = smsdvb_send_statistics_request(client);
> +	rc = smsdvb_get_statistics_ex(fe);
>  
>  	*ber = client->reception_data.BER;
>  
> @@ -531,7 +534,7 @@ static int smsdvb_read_signal_strength(struct
> dvb_frontend *fe, u16 *strength)
>  	struct smsdvb_client_t *client;
>  	client = container_of(fe, struct smsdvb_client_t, frontend);
>  
> -	rc = smsdvb_send_statistics_request(client);
> +	rc = smsdvb_get_statistics_ex(fe);
>  
>  	if (client->reception_data.InBandPwr < -95)
>  		*strength = 0;
> @@ -553,7 +556,7 @@ static int smsdvb_read_snr(struct dvb_frontend *fe,
> u16 *snr)
>  	struct smsdvb_client_t *client;
>  	client = container_of(fe, struct smsdvb_client_t, frontend);
>  
> -	rc = smsdvb_send_statistics_request(client);
> +	rc = smsdvb_get_statistics_ex(fe);
>  
>  	*snr = client->reception_data.SNR;
>  
> @@ -568,7 +571,7 @@ static int smsdvb_read_ucblocks(struct dvb_frontend
> *fe, u32 *ucblocks)
>  	struct smsdvb_client_t *client;
>  	client = container_of(fe, struct smsdvb_client_t, frontend);
>  
> -	rc = smsdvb_send_statistics_request(client);
> +	rc = smsdvb_get_statistics_ex(fe);
>  
>  	*ucblocks = client->reception_data.ErrorTSPackets;
>  
> @@ -595,10 +598,11 @@ static int smsdvb_dvbt_set_frontend(struct
> dvb_frontend *fe,
>  	struct smsdvb_client_t *client =
>  		container_of(fe, struct smsdvb_client_t, frontend);
>  
> -	struct 	SmsMsgData3Args_S Msg;
> -
> +	struct SmsMsgData4Args_S Msg;
>  	int ret;
>  
> +	sms_info("setting DVB freq to %d", p->frequency);
> +
>  	client->fe_status = FE_HAS_SIGNAL;
>  	client->event_fe_state = -1;
>  	client->event_unc_state = -1;
> @@ -611,9 +615,7 @@ static int smsdvb_dvbt_set_frontend(struct
> dvb_frontend *fe,
>  	Msg.xMsgHeader.msgLength = sizeof(Msg);
>  	Msg.msgData[0] = c->frequency;
>  	Msg.msgData[2] = 12000000;
> -
> -	sms_info("%s: freq %d band %d", __func__, c->frequency,
> -		 c->bandwidth_hz);
> +	Msg.msgData[3] = 0;
>  
>  	switch (c->bandwidth_hz / 1000000) {
>  	case 8:
> @@ -723,9 +725,14 @@ static int smsdvb_set_frontend(struct dvb_frontend
> *fe,
>  {
>  	struct smsdvb_client_t *client =
>  		container_of(fe, struct smsdvb_client_t, frontend);
> -	struct smscore_device_t *coredev = client->coredev;
> +	sms_info("setting the front end");
> +
> +	client->fe_status = FE_HAS_SIGNAL;
> +	client->event_fe_state = -1;
> +	client->event_unc_state = -1;
> +
>  
> -	switch (smscore_get_device_mode(coredev)) {
> +	switch (smscore_get_device_mode(client->coredev)) {
>  	case SMSHOSTLIB_DEVMD_DVBT:
>  	case SMSHOSTLIB_DEVMD_DVBT_BDA:
>  		return smsdvb_dvbt_set_frontend(fe, fep);

