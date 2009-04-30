Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([81.2.80.65]:45194 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbZD3VyN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 17:54:13 -0400
Message-ID: <49FA1B2E.8030402@simon.arlott.org.uk>
Date: Thu, 30 Apr 2009 22:42:06 +0100
From: Simon Arlott <simon@fire.lp0.eu>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-core: Fix potential mutex_unlock without mutex_lock
 in dvb_dvr_read
References: <49F0A61D.1010002@simon.arlott.org.uk> <20090430131818.d8aded42.akpm@linux-foundation.org>
In-Reply-To: <20090430131818.d8aded42.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/04/09 21:18, Andrew Morton wrote:
> On Thu, 23 Apr 2009 18:32:13 +0100
> Simon Arlott <simon@fire.lp0.eu> wrote:
> 
>> dvb_dvr_read may unlock the dmxdev mutex and return -ENODEV,
>> except this function is a file op and will never be called
>> with the mutex held.
>> 
>> There's existing mutex_lock and mutex_unlock around the actual
>> read but it's commented out. These should probably be uncommented
>> but the read blocks and this could block another non-blocking
>> reader on the mutex instead.
>> 
>> This change comments out the extra mutex_unlock.
>> 
>> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
>> ---
>> This has been on my TODO list for far too long... I did come
>> up with a mutex_trylock/mutex_lock_interruptible version but
>> claiming that it'll block when it may not doesn't make sense
>> (and any blocking read would cause all non-blocking reads to
>> continually return -EWOULDBLOCK until there is data).
>> 
>>  drivers/media/dvb/dvb-core/dmxdev.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
>> index c35fbb8..d6d098a 100644
>> --- a/drivers/media/dvb/dvb-core/dmxdev.c
>> +++ b/drivers/media/dvb/dvb-core/dmxdev.c
>> @@ -247,7 +247,7 @@ static ssize_t dvb_dvr_read(struct file *file, char __user *buf, size_t count,
>>  	int ret;
>>  
>>  	if (dmxdev->exit) {
>> -		mutex_unlock(&dmxdev->mutex);
>> +		//mutex_unlock(&dmxdev->mutex);
>>  		return -ENODEV;
>>  	}
> 
> Is there any value in retaining all the commented-out lock operations,
> or can we zap 'em?

I'm assuming they should really be there - it's just not practical
because the call to dvb_dmxdev_buffer_read is likely to block waiting
for data.
 
> --- a/drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix
> +++ a/drivers/media/dvb/dvb-core/dmxdev.c
> @@ -244,19 +244,13 @@ static ssize_t dvb_dvr_read(struct file 
>  {
>  	struct dvb_device *dvbdev = file->private_data;
>  	struct dmxdev *dmxdev = dvbdev->priv;
> -	int ret;
>  
> -	if (dmxdev->exit) {
> -		//mutex_unlock(&dmxdev->mutex);
> +	if (dmxdev->exit)
>  		return -ENODEV;
> -	}
>  
> -	//mutex_lock(&dmxdev->mutex);
> -	ret = dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
> -				     file->f_flags & O_NONBLOCK,
> -				     buf, count, ppos);
> -	//mutex_unlock(&dmxdev->mutex);
> -	return ret;
> +	return dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
> +				      file->f_flags & O_NONBLOCK,
> +				      buf, count, ppos);
>  }
>  
>  static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
> _
> 


-- 
Simon Arlott
