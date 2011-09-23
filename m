Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab1IWWvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:51:14 -0400
Message-ID: <4E7D0D5E.3010706@redhat.com>
Date: Fri, 23 Sep 2011 19:51:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH  16/17]DVB:Siano drivers - extern function smscore_send_last_fw_chunk
 to be used by other modules
References: <1316514723.5199.94.camel@Doron-Ubuntu>
In-Reply-To: <1316514723.5199.94.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:32, Doron Cohen escreveu:
> Hi,
> This patch step externs function smscore_send_last_fw_chunk to be used
> by other modules.
> Thanks,
> Doron Cohen
> 
> -----------------------
> 
>>From 1e19b238fa7129396df7ddc89e8197669c72a3a4 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Tue, 20 Sep 2011 09:38:10 +0300
> Subject: [PATCH 20/21] extern function smscore_send_last_fw_chunk to be
> used by other modules
> 
> ---
>  drivers/media/dvb/siano/smscoreapi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/smscoreapi.c
> b/drivers/media/dvb/siano/smscoreapi.c
> index 0555a38..10bd28c 100644
> --- a/drivers/media/dvb/siano/smscoreapi.c
> +++ b/drivers/media/dvb/siano/smscoreapi.c
> @@ -964,6 +964,8 @@ exit_fw_download:
>  
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(smscore_send_last_fw_chunk);
> +

The driver should be able to compile after each applied patch. If you're needing this one
here, you probably broke the compilation.

Please fold this patch with the one that had the compilation breakage.

>  
>  /**
>   * notifies all clients registered with the device, notifies hotplugs,

