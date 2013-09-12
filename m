Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52374 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3ILX2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 19:28:06 -0400
Received: by mail-ea0-f174.google.com with SMTP id z15so224434ead.5
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 16:28:04 -0700 (PDT)
Date: Fri, 13 Sep 2013 01:28:02 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/3] [media] siano: Don't show debug messages as errors
Message-ID: <20130913012802.1a0eaef9@neutrino.exnihilo>
In-Reply-To: <1379016000-19577-2-git-send-email-m.chehab@samsung.com>
References: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
	<1379016000-19577-2-git-send-email-m.chehab@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Sep 2013 16:59:58 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

Tested-by: André Roth <neolynx@gmail.com>

> At this bugzilla and similar ones:
>    https://bugzilla.kernel.org/show_bug.cgi?id=60645
> 
> Those debug messages were seen as errors, but they're just debug
> data, and are OK to appear on sms1100 and sms2270. Re-tag them
> to appear only if debug is enabled.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/common/siano/smscoreapi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
> index a142f79..acf39ad 100644
> --- a/drivers/media/common/siano/smscoreapi.c
> +++ b/drivers/media/common/siano/smscoreapi.c
> @@ -982,7 +982,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
>  	if (rc < 0)
>  		goto exit_fw_download;
>  
> -	sms_err("sending MSG_SMS_DATA_VALIDITY_REQ expecting 0x%x",
> +	sms_debug("sending MSG_SMS_DATA_VALIDITY_REQ expecting 0x%x",
>  		calc_checksum);
>  	SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_DATA_VALIDITY_REQ,
>  			sizeof(msg->x_msg_header) +
> @@ -1562,7 +1562,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
>  		{
>  			struct sms_msg_data *validity = (struct sms_msg_data *) phdr;
>  
> -			sms_err("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x",
> +			sms_debug("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x",
>  				validity->msg_data[0]);
>  			complete(&coredev->data_validity_done);
>  			break;
