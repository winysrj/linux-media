Return-path: <mchehab@gaivota>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64215 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0LLQNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 11:13:48 -0500
MIME-Version: 1.0
In-Reply-To: <20101212131550.GA2608@darkstar>
References: <20101212131550.GA2608@darkstar>
Date: Sun, 12 Dec 2010 17:13:47 +0100
Message-ID: <AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Clayton <chris2553@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, Dec 12, 2010 at 2:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> oops happen in bttv_open while locking uninitialized mutex fh->cap.vb_lock
> add mutex_init before usage

I have seen the same problem twice since I switched of the BKL in
2.6.37-rc2, but only had the time today to search for the cause.
(It only happend on two boots out of probably more then 50, so I only
investigated after it happened a second time with -rc5)

The cause was making this change to bttv_open() and radio_open() to
remove the BKL from them:
+	mutex_lock(&fh->cap.vb_lock);
 	*fh = btv->init;
+	mutex_unlock(&fh->cap.vb_lock);

This is wrong because of two things:
First: The fh->cap.vb_lock has not been initialised, as you noted.
Second: The middle line will overwrite the mutex!

Just adding mutex_init() will not really help the second problem and
seems to be wrong from the point that cap.vb_lock already has a
mutex_init() via videobuf_queue_sg_init().

I'm not sure what the correct fix is, but I would rather suggest this:

 * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
&btv->init.cap.vb_lock
 * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()

> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> Tested-by: Chris Clayton <chris2553@googlemail.com>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-2.6.orig/drivers/media/video/bt8xx/bttv-driver.c      2010-11-27 11:21:30.000000000 +0800
> +++ linux-2.6/drivers/media/video/bt8xx/bttv-driver.c   2010-12-12 16:31:39.633333338 +0800
> @@ -3291,6 +3291,8 @@ static int bttv_open(struct file *file)
>        fh = kmalloc(sizeof(*fh), GFP_KERNEL);
>        if (unlikely(!fh))
>                return -ENOMEM;
> +
> +       mutex_init(&fh->cap.vb_lock);
>        file->private_data = fh;
>
>        /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
