Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2417 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZKOLXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 06:23:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 2/5] s2250: Mutex function usage.
Date: Sun, 15 Nov 2009 12:23:13 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1257880891.21307.1104.camel@pete-desktop>
In-Reply-To: <1257880891.21307.1104.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911151223.13885.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 November 2009 20:21:31 Pete Eberlein wrote:
> From: Pete Eberlein <pete@sensoray.com>
> 
> Fix mutex function usage, which was overlooked in a previous patch.
> 
> Priority: normal
> 
> Signed-off-by: Pete Eberlein <pete@sensoray.com>
> 
> diff -r a603ad1e6a1c -r 99e4a0cf6788 linux/drivers/staging/go7007/s2250-board.c
> --- a/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:41:56 2009 -0800
> +++ b/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:47:34 2009 -0800
> @@ -261,7 +261,7 @@
>  
>  	memset(buf, 0xcd, 6);
>  	usb = go->hpi_context;
> -	if (down_interruptible(&usb->i2c_lock) != 0) {
> +	if (mutex_lock_interruptible(&usb->i2c_lock) != 0) {
>  		printk(KERN_INFO "i2c lock failed\n");
>  		kfree(buf);
>  		return -EINTR;
> @@ -270,7 +270,7 @@
>  		kfree(buf);
>  		return -EFAULT;
>  	}
> -	up(&usb->i2c_lock);
> +	mutex_unlock(&usb->i2c_lock);
>  
>  	*val = (buf[0] << 8) | buf[1];
>  	kfree(buf);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Looks good. I'll prepare a pull request for this one and ask Mauro to get this
fix into 2.6.32-rcX as well since it produces a compiler warning.

I'll also ask Mauro to get the missing drivers/staging/go7007/s2250-loader.h
into 2.6.32-rcX: it apparently fell on the floor when the go7007 driver was
updated in 2.6.32.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
