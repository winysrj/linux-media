Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1IWWpZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:45:25 -0400
Message-ID: <4E7D0BFE.8020201@redhat.com>
Date: Fri, 23 Sep 2011 19:45:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH  13/17]DVB:Siano drivers - Support big endian platform
 which uses SPI/I2C
References: <1316514714.5199.91.camel@Doron-Ubuntu>
In-Reply-To: <1316514714.5199.91.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:31, Doron Cohen escreveu:
> Hi,
> This patch step adds support big endian platform which uses SPI/I2C

seems ok.

> 
> Thanks,
> Doron Cohen
> 
>>From 2b77c0b5f69924206b9e09cda42aad56772e9380 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Tue, 20 Sep 2011 08:31:52 +0300
> Subject: [PATCH 17/21] Support big endian platform which uses SPI/I2C
> (need to switch header byte order)
> 
> ---
>  drivers/media/dvb/siano/smscoreapi.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/smscoreapi.c
> b/drivers/media/dvb/siano/smscoreapi.c
> index e50e356..459c6e9 100644
> --- a/drivers/media/dvb/siano/smscoreapi.c
> +++ b/drivers/media/dvb/siano/smscoreapi.c
> @@ -570,8 +570,8 @@ static int smscore_load_firmware_family2(struct
> smscore_device_t *coredev,
>  		sms_debug("sending reload command.");
>  		SMS_INIT_MSG(msg, MSG_SW_RELOAD_START_REQ,
>  			     sizeof(struct SmsMsgHdr_S));
> -		rc = smscore_sendrequest_and_wait(coredev, msg,
> -						  msg->msgLength,
> +		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
> +		rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
>  						  &coredev->reload_start_done);
>  
>  		if (rc < 0) {				
> @@ -597,7 +597,7 @@ static int smscore_load_firmware_family2(struct
> smscore_device_t *coredev,
>  		memcpy(DataMsg->Payload, payload, payload_size);
>  
>  
> -	
> +		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
>  		rc = smscore_sendrequest_and_wait(coredev, DataMsg,
>  				DataMsg->xMsgHeader.msgLength,
>  				&coredev->data_download_done);
> @@ -976,6 +976,7 @@ static int smscore_detect_mode(struct
> smscore_device_t *coredev)
>  	SMS_INIT_MSG(msg, MSG_SMS_GET_VERSION_EX_REQ,
>  		     sizeof(struct SmsMsgHdr_S));
>  
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
>  	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
>  					  &coredev->version_ex_done);
>  
> @@ -1356,6 +1357,8 @@ void smscore_onresponse(struct smscore_device_t
> *coredev,
>  		rc = client->onresponse_handler(client->context, cb);
>  
>  	if (rc < 0) {
> +		smsendian_handle_rx_message((struct SmsMsgData_S *)phdr);
> +
>  		switch (phdr->msgType) {
>  		case MSG_SMS_ISDBT_TUNE_RES:
>  			sms_debug("MSG_SMS_ISDBT_TUNE_RES");

