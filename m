Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46377
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbcGLPGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 11:06:22 -0400
Subject: Re: [PATCH] media: s5p-mfc remove void function return statement
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org
References: <1468283383-3142-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <901879fc-4964-fcc8-7ba9-f6f41e78bb72@osg.samsung.com>
Date: Tue, 12 Jul 2016 11:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <1468283383-3142-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah

On 07/11/2016 08:29 PM, Shuah Khan wrote:
> Remove void function return statement
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index c96421f..b6fde20 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -495,7 +495,6 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
>  	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>  	s5p_mfc_clock_off();
>  	wake_up_dev(dev, reason, err);
> -	return;
>  }
>  
>  /* Header parsing interrupt handling */
> 

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
