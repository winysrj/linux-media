Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab2EFR6M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 13:58:12 -0400
Message-ID: <4FA6BBB2.9010505@redhat.com>
Date: Sun, 06 May 2012 19:58:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 13/17] gspca: switch to V4L2 core locking, except
 for the buffer queuing ioctls.
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl> <4e0d537b1e1baf060981580d93f400a92ecfe427.1336305565.git.hans.verkuil@cisco.com> <4FA69803.20605@redhat.com> <201205061751.03303.hverkuil@xs4all.nl>
In-Reply-To: <201205061751.03303.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/06/2012 05:51 PM, Hans Verkuil wrote:
> On Sun May 6 2012 17:25:55 Hans de Goede wrote:

<snip snip>

>> Notice that usb_lock is unlocked before video_unregister_device gets called,
>> which means that any ioctl or other fops waiting for usb_lock can run
>> before video_unregister_device runs, and thus before they are protected
>> against being called on an disconnected device by the
>> video_is_registered checks in v4l2-dev.
>
> True, good catch, I missed that one.
>
>> Unfortunately simply moving the unlock down won't work, because if there
>> are no open file handles referencing the device, then the memory
>> referenced by gspca_dev will be free-ed after the video_unregister_device
>> call.
>
> What you should do (refer to the disconnect implementation in radio/dsbr100.c)
> is to use the release callback of struct v4l2_device instead. That way the
> memory will be released after you call v4l2_device_put() as the last line in
> the disconnect(). The advantage of using the v4l2_device release callback is
> that it also works if you have more than one video/radio/vbi node. Only when
> the very last user of the very last node exits will the release be called.

Better solution, I'll adapt your patch to use this solution, merging in
the necessary changes.

<snip snip>

>>> @@ -2009,11 +1883,9 @@ static int vidioc_dqbuf(struct file *file, void *priv,
>>>    	gspca_dev->fr_o = (i + 1) % GSPCA_MAX_FRAMES;
>>>
>>>    	if (gspca_dev->sd_desc->dq_callback) {
>>> -		mutex_lock(&gspca_dev->usb_lock);
>>>    		gspca_dev->usb_err = 0;
>>>    		if (gspca_dev->present)
>>>    			gspca_dev->sd_desc->dq_callback(gspca_dev);
>>> -		mutex_unlock(&gspca_dev->usb_lock);
>>>    	}
>>>
>>>    	frame->v4l2_buf.flags&= ~V4L2_BUF_FLAG_DONE;
>>
>> You cannot remove the locking here, as dq_callback expects to be
>> called with the usb-lock locked.
>>
>> Since usb-lock now is the device lock and thus gets locked before
>> the queue_lock, we cannot simply drop this chunk. Instead I've
>> moved the dq_callback to the end of vidioc_dqbuf, so after the
>> stream_lock has been released (there is no reason to have
>> the stream_lock hold when calling the dq_callback).
>>
>> The dq_callback is used to do camera control adjustments which
>> need to be done after every X frames, and which cannot be done
>> from the isoc frame interrupts since they should not be done under
>> interrupt. When the drivers using dq_callback are converted to the
>> control framework, they will likely end up calling v4l2_ctrl_s_ctrl
>> from the dq_callback.
>
> Can't dq_callback be called at the end of the function?

Right, if you look at the new version of the patch I had attached,
you will see that is actually what I did, which is what I tried to
explain with: "Instead I've moved the dq_callback to the end of
vidioc_dqbuf, so after the stream_lock has been released (there
is no reason to have the stream_lock hold when calling the dq_callback)".


> After the
> mutex_unlock(&queue_lock)? There we can take the usb_lock, call dq_callback
> and unlock usb_lock again:
>
> out:
> 		mutex_unlock(&gspca_dev->queue_lock);
>          if (!ret&&  gspca_dev->sd_desc->dq_callback) {
> 		        if (mutex_lock_interruptible(&gspca_dev->usb_lock))
>              		    return -ERESTARTSYS;
>                  gspca_dev->usb_err = 0;
>                  gspca_dev->sd_desc->dq_callback(gspca_dev);
> 				mutex_unlock(&gspca_dev->usb_lock);
>          }
> 		return ret;
>

Right, almost exactly what I've except that you're missing a gscpa_dev->present
check after taking the lock.

Regards,

Hans
