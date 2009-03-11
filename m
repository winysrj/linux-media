Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:27274 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZCKJUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 05:20:36 -0400
Date: Wed, 11 Mar 2009 10:19:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: hg-commit@linuxtv.org, linuxtv-commits@linuxtv.org,
	linux-media@vger.kernel.org
Subject: Re: [hg:v4l-dvb] cx88: Prevent general protection fault on rmmod
Message-ID: <20090311101952.057d8e54@hyperion.delvare>
In-Reply-To: <E1LhFXL-0007ri-27@www.linuxtv.org>
References: <E1LhFXL-0007ri-27@www.linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2009 04:55:19 +0100, Patch from Jean Delvare wrote:
> The patch number 10935 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>

Ugh, you committed the wrong patches :( I have sent updated patches with
much cleaner code since then:
http://www.spinics.net/lists/linux-media/msg02646.html
http://www.spinics.net/lists/linux-media/msg02647.html
http://www.spinics.net/lists/linux-media/msg02648.html
http://www.spinics.net/lists/linux-media/msg02649.html

> ------
> 
> From: Jean Delvare  <khali@linux-fr.org>
> cx88: Prevent general protection fault on rmmod
> 
> 
> When unloading the cx8800 driver I sometimes get a general protection
> fault. Analysis revealed a race in cx88_ir_stop(). It can be solved by
> using a delayed work instead of a timer for infrared input polling.
> 
> This fixes kernel.org bug #12802.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> ---
> 
>  linux/drivers/media/video/cx88/cx88-input.c |   27 +++++++++++++++-----
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff -r 60b0989f6c7a -r 46412997b3c0 linux/drivers/media/video/cx88/cx88-input.c
> --- a/linux/drivers/media/video/cx88/cx88-input.c	Tue Mar 10 19:28:33 2009 -0700
> +++ b/linux/drivers/media/video/cx88/cx88-input.c	Thu Mar 05 09:38:24 2009 +0000
> @@ -49,8 +49,12 @@ struct cx88_IR {
>  
>  	/* poll external decoder */
>  	int polling;
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>  	struct work_struct work;
>  	struct timer_list timer;
> +#else
> +	struct delayed_work work;
> +#endif
>  	u32 gpio_addr;
>  	u32 last_gpio;
>  	u32 mask_keycode;
> (...)

-- 
Jean Delvare
