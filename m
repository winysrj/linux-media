Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab0HEVJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 17:09:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [PATCH 42/42] drivers/media/video/bt8xx: Adjust confusing if indentation
Date: Thu, 5 Aug 2010 23:08:56 +0200
Cc: Julia Lawall <julia@diku.dk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008052229390.31692@ask.diku.dk> <AANLkTi=YauQBWyZnGpuBtQpNq=Re8WUXY9mH6FSFMP+7@mail.gmail.com>
In-Reply-To: <AANLkTi=YauQBWyZnGpuBtQpNq=Re8WUXY9mH6FSFMP+7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008052308.56592.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 August 2010 22:51:12 Luca Tettamanti wrote:
> > diff --git a/drivers/media/video/bt8xx/bttv-i2c.c b/drivers/media/video/bt8xx/bttv-i2c.c
> > index 685d659..695765c 100644
> > --- a/drivers/media/video/bt8xx/bttv-i2c.c
> > +++ b/drivers/media/video/bt8xx/bttv-i2c.c
> > @@ -123,7 +123,7 @@ bttv_i2c_wait_done(struct bttv *btv)
> >        if (wait_event_interruptible_timeout(btv->i2c_queue,
> >                btv->i2c_done, msecs_to_jiffies(85)) == -ERESTARTSYS)
> >
> > -       rc = -EIO;
> > +               rc = -EIO;
> 
> I'd also remove the empty line before the indented statement, it's confusing...
> 

The entire function looks a bit weird to me. If you look at the caller,
you'll notice that -EIO is treated in the same way as if the function had
returned zero, so the entire if() clause is pointless (the wait_event_*
probably is not).

Moreover, returning -ERESTARTSYS is probably the right action here,
why else would you make the wait interruptible?

	Arnd
