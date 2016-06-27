Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46320 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbcF0JMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 05:12:47 -0400
Subject: Re: [PATCH v2 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
To: Ismael Luceno <ismael@iodev.co.uk>, linux-media@vger.kernel.org
References: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <33cd3138-6adc-d9c4-a9b0-bfb5f0445088@xs4all.nl>
Date: Mon, 27 Jun 2016 11:12:42 +0200
MIME-Version: 1.0
In-Reply-To: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey,

Since you are the original author, can you give me your Signed-off-by line?

My apologies for the very late reply, it's been very busy lately and I am
finally catching up...

Thanks!

	Hans

On 05/04/2016 06:21 PM, Ismael Luceno wrote:
> From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> 
> Such frame size is met in practice. Also report oversized frames.
> 
> [ismael: Reworked warning and commit message]
> 
> Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
> ---
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> index 67a14c4..f98017b 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> @@ -33,7 +33,7 @@
>  #include "solo6x10-jpeg.h"
>  
>  #define MIN_VID_BUFFERS		2
> -#define FRAME_BUF_SIZE		(196 * 1024)
> +#define FRAME_BUF_SIZE		(200 * 1024)
>  #define MP4_QS			16
>  #define DMA_ALIGN		4096
>  
> @@ -323,8 +323,11 @@ static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
>  	int i;
>  	int ret;
>  
> -	if (WARN_ON_ONCE(size > FRAME_BUF_SIZE))
> +	if (WARN_ON_ONCE(size > FRAME_BUF_SIZE)) {
> +		dev_warn(&solo_dev->pdev->dev,
> +			 "oversized frame (%d bytes)\n", size);
>  		return -EINVAL;
> +	}
>  
>  	solo_enc->desc_count = 1;
>  
> 
