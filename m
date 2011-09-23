Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab1IWWvu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:51:50 -0400
Message-ID: <4E7D0D81.9020106@redhat.com>
Date: Fri, 23 Sep 2011 19:51:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH  17/17]DVB:Siano drivers - Automatically load client modules
 to make easier usage of device
References: <1316514727.5199.95.camel@Doron-Ubuntu>
In-Reply-To: <1316514727.5199.95.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:32, Doron Cohen escreveu:
> Hi,
> This patch step makes Automatically load client modules to make easier
> usage of device

Ok.

> Thanks,
> Doron Cohen
> 
> -----------------------
>>From 82afa26fc1fb9db798e46de0c55b49fd1bda9580 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Tue, 20 Sep 2011 09:39:02 +0300
> Subject: [PATCH 21/21] Automatically load client modules to make easier
> usage of device
> 
> ---
>  drivers/media/dvb/siano/sms-cards.c |   17 ++++-------------
>  1 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/sms-cards.c
> b/drivers/media/dvb/siano/sms-cards.c
> index 66b302e..378c25d 100644
> --- a/drivers/media/dvb/siano/sms-cards.c
> +++ b/drivers/media/dvb/siano/sms-cards.c
> @@ -458,19 +458,10 @@ EXPORT_SYMBOL_GPL(sms_board_lna_control);
>  
>  int sms_board_load_modules(int id)
>  {
> -	switch (id) {
> -	case SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT:
> -	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
> -	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
> -	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> -	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> -	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> -		request_module("smsdvb");
> -		break;
> -	default:
> -		/* do nothing */
> -		break;
> -	}
> +	/* Siano smsmdtv loads all other supported "client" modules*/
> +	request_module("smsdvb");
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(sms_board_load_modules);

