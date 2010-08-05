Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53511 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab0HEUvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 16:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1008052229390.31692@ask.diku.dk>
References: <Pine.LNX.4.64.1008052229390.31692@ask.diku.dk>
Date: Thu, 5 Aug 2010 22:51:12 +0200
Message-ID: <AANLkTi=YauQBWyZnGpuBtQpNq=Re8WUXY9mH6FSFMP+7@mail.gmail.com>
Subject: Re: [PATCH 42/42] drivers/media/video/bt8xx: Adjust confusing if
	indentation
From: Luca Tettamanti <kronos.it@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
one minor comment:

On Thu, Aug 5, 2010 at 10:29 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Indent the branch of an if.
[...]
> diff --git a/drivers/media/video/bt8xx/bttv-i2c.c b/drivers/media/video/bt8xx/bttv-i2c.c
> index 685d659..695765c 100644
> --- a/drivers/media/video/bt8xx/bttv-i2c.c
> +++ b/drivers/media/video/bt8xx/bttv-i2c.c
> @@ -123,7 +123,7 @@ bttv_i2c_wait_done(struct bttv *btv)
>        if (wait_event_interruptible_timeout(btv->i2c_queue,
>                btv->i2c_done, msecs_to_jiffies(85)) == -ERESTARTSYS)
>
> -       rc = -EIO;
> +               rc = -EIO;

I'd also remove the empty line before the indented statement, it's confusing...

Luca
