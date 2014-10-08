Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10132 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaJHK0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 06:26:12 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400I8YFSD8170@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 11:29:01 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Kiran AVND' <avnd.kiran@samsung.com>, linux-media@vger.kernel.org
Cc: wuchengli@chromium.org, posciak@chromium.org, arun.m@samsung.com,
	ihf@chromium.org, prathyush.k@samsung.com, arun.kk@samsung.com,
	kiran@chromium.org
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
 <1411707142-4881-8-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-8-git-send-email-avnd.kiran@samsung.com>
Subject: RE: [PATCH v2 07/14] [media] s5p-mfc: Don't crash the kernel if the
 watchdog kicks in.
Date: Wed, 08 Oct 2014 12:26:08 +0200
Message-id: <11f401cfe2e2$46d42bf0$d47c83d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch does not apply to the current media tree.

commit cf3167cf1e969b17671a4d3d956d22718a8ceb85)
Author: Antti Palosaari <crope@iki.fi>
Date:   Fri Sep 26 22:45:36 2014 -0300

    [media] pt3: fix DTV FE I2C driver load error paths
    
Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Kiran AVND [mailto:avnd.kiran@samsung.com]
> Sent: Friday, September 26, 2014 6:52 AM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; wuchengli@chromium.org; posciak@chromium.org;
> arun.m@samsung.com; ihf@chromium.org; prathyush.k@samsung.com;
> arun.kk@samsung.com; kiran@chromium.org
> Subject: [PATCH v2 07/14] [media] s5p-mfc: Don't crash the kernel if
> the watchdog kicks in.
> 
> From: Pawel Osciak <posciak@chromium.org>
> 
> If the software watchdog kicks in, the watchdog worker is not
> synchronized with hardware interrupts and does not block other
> instances. It's possible for it to clear the hw_lock, making other
> instances trigger a BUG() on hw_lock checks. Since it's not fatal to
> clear the hw_lock to zero twice, just WARN in those cases for now. We
> should not explode, as firmware will return errors as needed for other
> instances after it's reloaded, or they will time out.
> 
> A clean fix should involve killing other instances when watchdog kicks
> in, but requires a major redesign of locking in the driver.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |   25 +++++++---------------
> ---
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 3fc2f8a..8d5da0c 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -337,8 +337,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx
> *ctx,
>  		ctx->state = MFCINST_RES_CHANGE_INIT;
>  		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>  		wake_up_ctx(ctx, reason, err);
> -		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -			BUG();
> +		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>  		s5p_mfc_clock_off();
>  		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>  		return;
> @@ -410,8 +409,7 @@ leave_handle_frame:
>  		clear_work_bit(ctx);
>  	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>  	wake_up_ctx(ctx, reason, err);
> -	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -		BUG();
> +	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>  	s5p_mfc_clock_off();
>  	/* if suspending, wake up device and do not try_run again*/
>  	if (test_bit(0, &dev->enter_suspend))
> @@ -458,8 +456,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev
> *dev,
>  			break;
>  		}
>  	}
> -	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -		BUG();
> +	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>  	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>  	s5p_mfc_clock_off();
>  	wake_up_dev(dev, reason, err);
> @@ -513,8 +510,7 @@ static void s5p_mfc_handle_seq_done(struct
> s5p_mfc_ctx *ctx,
>  	}
>  	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>  	clear_work_bit(ctx);
> -	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -		BUG();
> +	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>  	s5p_mfc_clock_off();
>  	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>  	wake_up_ctx(ctx, reason, err);
> @@ -552,19 +548,13 @@ static void s5p_mfc_handle_init_buffers(struct
> s5p_mfc_ctx *ctx,
>  		} else {
>  			ctx->dpb_flush_flag = 0;
>  		}
> -		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -			BUG();
> -
> +		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>  		s5p_mfc_clock_off();
> -
>  		wake_up(&ctx->queue);
>  		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>  	} else {
> -		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -			BUG();
> -
> +		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>  		s5p_mfc_clock_off();
> -
>  		wake_up(&ctx->queue);
>  	}
>  }
> @@ -638,8 +628,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>  				mfc_err("post_frame_start() failed\n");
>  			s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>  			wake_up_ctx(ctx, reason, err);
> -			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -				BUG();
> +			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>  			s5p_mfc_clock_off();
>  			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>  		} else {
> --
> 1.7.9.5

