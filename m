Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2CXOcw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Mar 2012 10:32:52 -0400
Message-ID: <4F6DDB10.8000503@redhat.com>
Date: Sat, 24 Mar 2012 11:32:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Josu Lazkano <josu.lazkano@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb lock patch
References: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com>
In-Reply-To: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-03-2012 17:49, Josu Lazkano escreveu:
> Hello all, I am using this patch to get virtual adapters for DVB
> devices: https://aur.archlinux.org/packages/sa/sascng-linux3-patch/sascng-linux3-patch.tar.gz
> 
> Here is more info: https://aur.archlinux.org/packages.php?ID=51325
> 
> Is it possible to add this patch on the dvb source?
> 
> This patch is needed for people who not have a CI and need to create
> virtual adapters to get a working pay-tv system.

Please always send the diff, instead to a point to some tarball, otherwise
most developers won't care enough to see what's there.

Anyway:

> diff -Nur linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c
> --- linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c
> +++ linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c
> @@ -83,8 +83,11 @@ static int dvb_device_open(struct inode *inode, struct file *file)
>  			file->f_op = old_fops;
>  			goto fail;
>  		}
> -		if(file->f_op->open)
> +		if(file->f_op->open) {
> +			mutex_unlock(&dvbdev_mutex);
>  			err = file->f_op->open(inode,file);
> +			mutex_lock(&dvbdev_mutex);
> +		}
>  		if (err) {
>  			fops_put(file->f_op);
>  			file->f_op = fops_get(old_fops);
> -- 
> 

That doesn't sound right to me, and can actually cause race issues.

Regards,
Mauro.
