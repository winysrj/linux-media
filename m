Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:37740 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753503AbeBFVWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 16:22:39 -0500
Subject: Re: [PATCH 1/5] add missing blob structure field for tag id
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
 <1517950905-5015-2-git-send-email-floe@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3219b5c2-2497-25a5-a22f-2f0f874692fe@xs4all.nl>
Date: Tue, 6 Feb 2018 22:22:34 +0100
MIME-Version: 1.0
In-Reply-To: <1517950905-5015-2-git-send-email-floe@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2018 10:01 PM, Florian Echtler wrote:
> The SUR40 can recognize specific printed patterns directly in hardware;
> this information (i.e. the pattern id) is present but currently unused
> in the blob structure.
> 
> Signed-off-by: Florian Echtler <floe@butterbrot.org>
> ---
>  drivers/input/touchscreen/sur40.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index f16f835..8375b06 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -81,7 +81,10 @@ struct sur40_blob {
>  
>  	__le32 area;       /* size in pixels/pressure (?) */
>  
> -	u8 padding[32];
> +	u8 padding[24];
> +
> +	__le32 tag_id;     /* valid when type == 0x04 (SUR40_TAG) */
> +	__le32 unknown;
>  
>  } __packed;
>  
> 

Usually new fields are added before the padding, not after.

Unless there is a good reason for this I'd change this.

Regards,

	Hans
