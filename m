Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:42975 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754687Ab1FRLJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 07:09:51 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: Linux Media Mailing List <linux-media@vger.kernel.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Fwd: [PATCH] ngene: blocking and nonblocking io for sec0
Date: Sat, 18 Jun 2011 13:07:31 +0200
Cc: Ralph Metzler <rjkm@metzlerbros.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4DE6A8C0.4060603@redhat.com>
In-Reply-To: <4DE6A8C0.4060603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106181307.32895@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

sorry for the delay, I don't have much time atm.


On Wednesday 01 June 2011 23:01:52 Mauro Carvalho Chehab wrote:
> Oliver/Ralph,
> 
> Could you please review this patch? On a quick look, it looks
> fine on my eyes, but I don't have any ngene hardware here for testing.
>
> Thanks!
> Mauro


The patch is not correct. See my comments below.


> -------- Mensagem original --------
> Date: Thu, 12 May 2011 15:47:09 +0200
> From: Issa Gorissen <flop.m@usa.net>
> To: linux-media@vger.kernel.org
> Subject: [PATCH] ngene: blocking and nonblocking io for sec0
> 
> Patch allows for blocking or nonblocking io on the ngene sec0 device.
> It also enforces one reader and one writer at a time.
> 
> Signed-off-by: Issa Gorissen <flop.m@usa.net>
> --
> 
> --- a/linux/drivers/media/dvb/ngene/ngene-dvb.c	2011-05-10 19:11:21.000000000 +0200
> +++ b/linux/drivers/media/dvb/ngene/ngene-dvb.c	2011-05-12 15:28:53.573185365 +0200
> @@ -53,15 +53,29 @@ static ssize_t ts_write(struct file *fil
>  	struct dvb_device *dvbdev = file->private_data;
>  	struct ngene_channel *chan = dvbdev->priv;
>  	struct ngene *dev = chan->dev;
> +	int avail = 0;
> +	char nonblock = file->f_flags & O_NONBLOCK;
>  
> -	if (wait_event_interruptible(dev->tsout_rbuf.queue,
> -				     dvb_ringbuffer_free
> -				     (&dev->tsout_rbuf) >= count) < 0)
> +	if (!count)
>  		return 0;
>  
> -	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, count);
> +	if (nonblock) {
> +		avail = dvb_ringbuffer_avail(&dev->tsout_rbuf);
> +		if (!avail)
> +			return -EAGAIN;

Wrong. dvb_ringbuffer_avail() returns the number of bytes waiting in the
ring buffer. The code must use dvb_ringbuffer_free() instead.

Furthermore the code completely ignores count (the number of bytes to be
written).


> +	} else {
> +		while (1) {
> +			if (wait_event_interruptible(dev->tsout_rbuf.queue,
> +						     dvb_ringbuffer_free
> +						     (&dev->tsout_rbuf) >= count) >= 0)
> +				break;
> +		}

What is this loop supposed to do?

> +		avail = count;
> +	}
> +
> +	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, avail);
> +	return avail;
>  
> -	return count;
>  }
>  
>  static ssize_t ts_read(struct file *file, char *buf,
> @@ -70,22 +84,35 @@ static ssize_t ts_read(struct file *file
>  	struct dvb_device *dvbdev = file->private_data;
>  	struct ngene_channel *chan = dvbdev->priv;
>  	struct ngene *dev = chan->dev;
> -	int left, avail;
> +	int avail = 0;
> +	char nonblock = file->f_flags & O_NONBLOCK;
>  
> -	left = count;
> -	while (left) {
> -		if (wait_event_interruptible(
> -			    dev->tsin_rbuf.queue,
> -			    dvb_ringbuffer_avail(&dev->tsin_rbuf) > 0) < 0)
> -			return -EAGAIN;
> +	if (!count)
> +		return 0;
> +
> +	if (nonblock) {
>  		avail = dvb_ringbuffer_avail(&dev->tsin_rbuf);
> -		if (avail > left)
> -			avail = left;
> -		dvb_ringbuffer_read_user(&dev->tsin_rbuf, buf, avail);
> -		left -= avail;
> -		buf += avail;
> +	} else {
> +		while (!avail) {
> +			if (wait_event_interruptible(
> +				    dev->tsin_rbuf.queue,
> +				    dvb_ringbuffer_avail(&dev->tsin_rbuf) > 0) < 0)
> +				continue;
> +
> +			avail = dvb_ringbuffer_avail(&dev->tsin_rbuf);
> +		}

This piece of code is also wrong. The loop does not wait, until there is
enough data available. It does not consider 'count'.
Furthermore 'count' might be larger than the size of the ring buffer.

The original code was correct, except that it did not handle O_NONBLOCK.

>  	}
> -	return count;
> +
> +	if (avail > count)
> +		avail = count;
> +	if (avail > 0)
> +		dvb_ringbuffer_read_user(&dev->tsin_rbuf, buf, avail);
> +
> +	if (!avail)
> +		return -EAGAIN;
> +	else
> +		return avail;
> +
>  }
>  
>  static const struct file_operations ci_fops = {
> @@ -98,9 +125,9 @@ static const struct file_operations ci_f
>  
>  struct dvb_device ngene_dvbdev_ci = {
>  	.priv    = 0,
> -	.readers = -1,
> -	.writers = -1,
> -	.users   = -1,
> +	.readers = 1,
> +	.writers = 1,
> +	.users   = 2,

Ok.

>  	.fops    = &ci_fops,
>  };

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
