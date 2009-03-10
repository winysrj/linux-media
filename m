Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4898 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZCJI2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 04:28:35 -0400
Message-ID: <11783.62.70.2.252.1236673648.squirrel@webmail.xs4all.nl>
Date: Tue, 10 Mar 2009 09:27:28 +0100 (CET)
Subject: Re: [patch] radio-rtrack2: fix double mutex_unlock
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Alexey Klimov" <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Douglas Schilling Landgraf" <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Patch fixes double mutex unlocking.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

Ouch.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks!

       Hans

>
> --
> diff -r 615fb8f01610 linux/drivers/media/radio/radio-rtrack2.c
> --- a/linux/drivers/media/radio/radio-rtrack2.c	Tue Mar 10 02:33:02 2009
> -0300
> +++ b/linux/drivers/media/radio/radio-rtrack2.c	Tue Mar 10 09:28:27 2009
> +0300
> @@ -60,7 +60,6 @@
>  		return;
>  	mutex_lock(&dev->lock);
>  	outb(1, dev->io);
> -	mutex_unlock(&dev->lock);
>  	mutex_unlock(&dev->lock);
>  	dev->muted = 1;
>  }
>
>
> --
> Best regards, Klimov Alexey
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

