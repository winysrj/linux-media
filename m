Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52127 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbbDHKIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 06:08:46 -0400
Date: Wed, 8 Apr 2015 07:08:39 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jaedon Shin <jaedon.shin@gmail.com>
Cc: Changbing Xiong <cb.xiong@samsung.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] dmxdev: fix possible race conditions in
 dvb_dmxdev_buffer_read
Message-ID: <20150408070839.272933e1@recife.lan>
In-Reply-To: <1419908734-57798-1-git-send-email-jaedon.shin@gmail.com>
References: <1419908734-57798-1-git-send-email-jaedon.shin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Em Tue, 30 Dec 2014 12:05:34 +0900
Jaedon Shin <jaedon.shin@gmail.com> escreveu:

> This patch splits the dvb_dmxdev_buffer_read into dvb_dvr_read and
> dvb_demux_read that fixes to unlock mutex before sleeping.
> 
> There are race conditions executing the DMX_ADD_PID and the DMX_REMOVE_PID
> in the dvb_demux_do_ioctl when dvb_demux_read is waiting for data.
> 
> Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
> ---
>  drivers/media/dvb-core/dmxdev.c | 94 ++++++++++++++++++++++++++++++++---------
>  1 file changed, 75 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index abff803..c2564b0 100644
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -57,10 +57,11 @@ static int dvb_dmxdev_buffer_write(struct dvb_ringbuffer *buf,
>  	return dvb_ringbuffer_write(buf, src, len);
>  }
>  
> -static ssize_t dvb_dmxdev_buffer_read(struct dvb_ringbuffer *src,
> +static ssize_t dvb_dmxdev_buffer_read(struct dmxdev_filter *dmxdevfilter,
>  				      int non_blocking, char __user *buf,
>  				      size_t count, loff_t *ppos)
>  {
> +	struct dvb_ringbuffer *src = &dmxdevfilter->buffer;
>  	size_t todo;
>  	ssize_t avail;
>  	ssize_t ret = 0;
> @@ -75,16 +76,21 @@ static ssize_t dvb_dmxdev_buffer_read(struct dvb_ringbuffer *src,
>  	}
>  
>  	for (todo = count; todo > 0; todo -= ret) {
> -		if (non_blocking && dvb_ringbuffer_empty(src)) {
> -			ret = -EWOULDBLOCK;
> -			break;
> -		}
> +		if (dvb_ringbuffer_empty(src)) {
> +			mutex_unlock(&dmxdevfilter->mutex);
>  
> -		ret = wait_event_interruptible(src->queue,
> -					       !dvb_ringbuffer_empty(src) ||
> -					       (src->error != 0));
> -		if (ret < 0)
> -			break;
> +			if (non_blocking)
> +				return -EWOULDBLOCK;
> +
> +			ret = wait_event_interruptible(src->queue,
> +					!dvb_ringbuffer_empty(src) ||
> +					(src->error != 0));
> +			if (ret < 0)
> +				return ret;
> +
> +			if (mutex_lock_interruptible(&dmxdevfilter->mutex))
> +				return -ERESTARTSYS;
> +		}
>  
>  		if (src->error) {
>  			ret = src->error;
> @@ -242,13 +248,63 @@ static ssize_t dvb_dvr_read(struct file *file, char __user *buf, size_t count,
>  {
>  	struct dvb_device *dvbdev = file->private_data;
>  	struct dmxdev *dmxdev = dvbdev->priv;
> +	struct dvb_ringbuffer *src = &dmxdev->dvr_buffer;
> +	size_t todo;
> +	ssize_t avail;
> +	ssize_t ret = 0;
>  
> -	if (dmxdev->exit)
> +	if (mutex_lock_interruptible(&dmxdev->mutex))
> +		return -ERESTARTSYS;
> +
> +	if (dmxdev->exit) {
> +		mutex_unlock(&dmxdev->mutex);
>  		return -ENODEV;
> +	}
> +
> +	if (src->error) {
> +		ret = src->error;
> +		dvb_ringbuffer_flush(src);
> +		mutex_unlock(&dmxdev->mutex);
> +		return ret;
> +	}
> +
> +	for (todo = count; todo > 0; todo -= ret) {
> +		if (dvb_ringbuffer_empty(src)) {
> +			mutex_unlock(&dmxdev->mutex);
>  
> -	return dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
> -				      file->f_flags & O_NONBLOCK,
> -				      buf, count, ppos);
> +			if (file->f_flags & O_NONBLOCK)
> +				return -EWOULDBLOCK;
> +
> +			ret = wait_event_interruptible(src->queue,
> +					!dvb_ringbuffer_empty(src) ||
> +					(src->error != 0));
> +			if (ret < 0)
> +				return ret;
> +
> +			if (mutex_lock_interruptible(&dmxdev->mutex))
> +				return -ERESTARTSYS;
> +		}

Hmm... you're replicating what's there at dvb_dmxdev_buffer_read()
with a few additions bellow.

Instead, please do it in a way that we'll have just one copy of the
code. The DVB ringbuf logic is already complex enough without code
duplication.

This would also make easier for reviewers to check the changes at
the logic.

> +
> +		if (src->error) {
> +			ret = src->error;
> +			dvb_ringbuffer_flush(src);
> +			break;
> +		}
> +
> +		avail = dvb_ringbuffer_avail(src);
> +		if (avail > todo)
> +			avail = todo;
> +
> +		ret = dvb_ringbuffer_read_user(src, buf, avail);
> +		if (ret < 0)
> +			break;
> +
> +		buf += ret;
> +	}
> +
> +	mutex_unlock(&dmxdev->mutex);
> +
> +	return (count - todo) ? (count - todo) : ret;
>  }
>  
>  static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
> @@ -283,7 +339,6 @@ static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
>  
>  	return 0;
>  }
> -
>  static inline void dvb_dmxdev_filter_state_set(struct dmxdev_filter
>  					       *dmxdevfilter, int state)
>  {
> @@ -904,7 +959,7 @@ static ssize_t dvb_dmxdev_read_sec(struct dmxdev_filter *dfil,
>  		hcount = 3 + dfil->todo;
>  		if (hcount > count)
>  			hcount = count;
> -		result = dvb_dmxdev_buffer_read(&dfil->buffer,
> +		result = dvb_dmxdev_buffer_read(dfil,
>  						file->f_flags & O_NONBLOCK,
>  						buf, hcount, ppos);
>  		if (result < 0) {
> @@ -925,7 +980,7 @@ static ssize_t dvb_dmxdev_read_sec(struct dmxdev_filter *dfil,
>  	}
>  	if (count > dfil->todo)
>  		count = dfil->todo;
> -	result = dvb_dmxdev_buffer_read(&dfil->buffer,
> +	result = dvb_dmxdev_buffer_read(dfil,
>  					file->f_flags & O_NONBLOCK,
>  					buf, count, ppos);
>  	if (result < 0)
> @@ -947,11 +1002,12 @@ dvb_demux_read(struct file *file, char __user *buf, size_t count,
>  	if (dmxdevfilter->type == DMXDEV_TYPE_SEC)
>  		ret = dvb_dmxdev_read_sec(dmxdevfilter, file, buf, count, ppos);
>  	else
> -		ret = dvb_dmxdev_buffer_read(&dmxdevfilter->buffer,
> +		ret = dvb_dmxdev_buffer_read(dmxdevfilter,
>  					     file->f_flags & O_NONBLOCK,
>  					     buf, count, ppos);
>  
> -	mutex_unlock(&dmxdevfilter->mutex);
> +	if (mutex_is_locked(&dmxdevfilter->mutex))
> +		mutex_unlock(&dmxdevfilter->mutex);
>  	return ret;
>  }
>  
