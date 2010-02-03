Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886Ab0BCUZJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:25:09 -0500
Message-ID: <4B69DB9D.90609@redhat.com>
Date: Wed, 03 Feb 2010 18:25:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 4/15] -  tm6000.h
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de> <4B69D9AF.4020309@arcor.de>
In-Reply-To: <4B69D9AF.4020309@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one is a very obscure patch. What are you doing this patch and why?

Stefan Ringel wrote:
> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> 
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -90,12 +97,14 @@ enum tm6000_core_state {
>      DEV_MISCONFIGURED = 0x04,
>  };
>  
> +#if 1
>  /* io methods */
>  enum tm6000_io_method {
>      IO_NONE,
>      IO_READ,
>      IO_MMAP,
>  };
> +#endif
>  
>  enum tm6000_mode {
>      TM6000_MODE_UNKNOWN=0,
> @@ -202,6 +211,9 @@ struct tm6000_fh {
>              V4L2_STD_PAL_M|V4L2_STD_PAL_60|V4L2_STD_NTSC_M| \
>              V4L2_STD_NTSC_M_JP|V4L2_STD_SECAM
>  
> +/* In tm6000-cards.c */
> +
> +int tm6000_tuner_callback (void *ptr, int component, int command, int arg);
>  /* In tm6000-core.c */
>  
>  int tm6000_read_write_usb (struct tm6000_core *dev, u8 reqtype, u8 req,
> @@ -209,7 +221,6 @@ int tm6000_read_write_usb (struct tm6000_core *dev,
> u8 reqtype, u8 req,
>  int tm6000_get_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
>  int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
>  int tm6000_init (struct tm6000_core *dev);
> -int tm6000_init_after_firmware (struct tm6000_core *dev);
>  
>  int tm6000_init_analog_mode (struct tm6000_core *dev);
>  int tm6000_init_digital_mode (struct tm6000_core *dev);
> @@ -231,7 +242,12 @@ int tm6000_set_standard (struct tm6000_core *dev,
> v4l2_std_id *norm);
>  int tm6000_i2c_register(struct tm6000_core *dev);
>  int tm6000_i2c_unregister(struct tm6000_core *dev);
>  
> +#if 1
>  /* In tm6000-queue.c */
> +#if 0
> +int tm6000_init_isoc(struct tm6000_core *dev, int max_packets);
> +void tm6000_uninit_isoc(struct tm6000_core *dev);
> +#endif
>  
>  int tm6000_v4l2_mmap(struct file *filp, struct vm_area_struct *vma);
>  
> @@ -276,3 +292,4 @@ extern int tm6000_debug;
>          __FUNCTION__ , ##arg); } while (0)
>  
>  
> +#endif
> 


-- 

Cheers,
Mauro
