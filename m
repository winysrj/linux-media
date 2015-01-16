Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54282 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbbAPK5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 05:57:43 -0500
Message-ID: <54B8EE91.7020704@xs4all.nl>
Date: Fri, 16 Jan 2015 11:57:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Haim Daniel <haimdaniel@gmail.com>, linux-media@vger.kernel.org
CC: Haim Daniel <haim.daniel@gmail.com>
Subject: Re: [PATCH] [media] [pvrusb2]: remove dead retry cmd code
References: <1420497518-10375-1-git-send-email-haim.daniel@gmail.com>
In-Reply-To: <1420497518-10375-1-git-send-email-haim.daniel@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/05/2015 11:38 PM, Haim Daniel wrote:
> In case a command is timed out, current flow sets the retry_flag
> and does nothing.

Really? That's not how I read the code: it retries up to 20 times before
bailing out.

Perhaps you missed the "if (try_count < 20) continue;" line?

Regards,

	Hans

> 
> Signed-off-by: Haim Daniel <haim.daniel@gmail.com>
> ---
>  drivers/media/usb/pvrusb2/pvrusb2-encoder.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
> index f7702ae..02028aa 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
> @@ -145,8 +145,6 @@ static int pvr2_encoder_cmd(void *ctxt,
>  			    u32 *argp)
>  {
>  	unsigned int poll_count;
> -	unsigned int try_count = 0;
> -	int retry_flag;
>  	int ret = 0;
>  	unsigned int idx;
>  	/* These sizes look to be limited by the FX2 firmware implementation */
> @@ -213,8 +211,6 @@ static int pvr2_encoder_cmd(void *ctxt,
>  			break;
>  		}
>  
> -		retry_flag = 0;
> -		try_count++;
>  		ret = 0;
>  		wrData[0] = 0;
>  		wrData[1] = cmd;
> @@ -245,11 +241,9 @@ static int pvr2_encoder_cmd(void *ctxt,
>  			}
>  			if (rdData[0] && (poll_count < 1000)) continue;
>  			if (!rdData[0]) {
> -				retry_flag = !0;
>  				pvr2_trace(
>  					PVR2_TRACE_ERROR_LEGS,
> -					"Encoder timed out waiting for us"
> -					"; arranging to retry");
> +					"Encoder timed out waiting for us");
>  			} else {
>  				pvr2_trace(
>  					PVR2_TRACE_ERROR_LEGS,
> @@ -269,13 +263,6 @@ static int pvr2_encoder_cmd(void *ctxt,
>  			ret = -EBUSY;
>  			break;
>  		}
> -		if (retry_flag) {
> -			if (try_count < 20) continue;
> -			pvr2_trace(
> -				PVR2_TRACE_ERROR_LEGS,
> -				"Too many retries...");
> -			ret = -EBUSY;
> -		}
>  		if (ret) {
>  			del_timer_sync(&hdw->encoder_run_timer);
>  			hdw->state_encoder_ok = 0;
> 

