Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:57463 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408Ab0EGPrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 11:47:43 -0400
Message-ID: <4BE435C0.4010909@arcor.de>
Date: Fri, 07 May 2010 17:46:08 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH] tm6000: bugfix image position
References: <1273246144-6876-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1273246144-6876-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.05.2010 17:29, schrieb stefan.ringel@arcor.de:
> From: Stefan Ringel <stefan.ringel@arcor.de>
>
> bugfix incorrect image and line position in videobuffer
>
>
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-video.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 9554472..f7248f0 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -223,8 +223,8 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
>  			 * It should, instead, check if the user selected
>  			 * entrelaced or non-entrelaced mode
>  			 */
> -			pos= ((line<<1)+field)*linewidth +
> -				block*TM6000_URB_MSG_LEN;
> +			pos = ((line << 1) - field - 1) * linewidth +
> +				block * TM6000_URB_MSG_LEN;
>  
>  			/* Don't allow to write out of the buffer */
>  			if (pos+TM6000_URB_MSG_LEN > (*buf)->vb.size) {
>   


http://www.stefanringel.de/pub/tm6000_image_07_05_2010.jpg

-- 
Stefan Ringel <stefan.ringel@arcor.de>

