Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58436 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab3ELIQo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 May 2013 04:16:44 -0400
Message-ID: <518F4FEB.70908@web.de>
Date: Sun, 12 May 2013 10:16:43 +0200
From: Soeren Moch <smoch@web.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: dmxdev: remove dvb_ringbuffer_flush() on writer
 side
References: <5150F926.8070505@web.de> <516A70EE.5010303@web.de> <20130510193955.GI1075@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130510193955.GI1075@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.05.2013 21:39, Sakari Ailus wrote:
> Hi Soeren,
>
> Thanks for the patch!
>
> On Sun, Apr 14, 2013 at 11:03:42AM +0200, Soeren Moch wrote:
>> In dvb_ringbuffer lock-less synchronizationof reader and writer threads is done
>> with separateread and write pointers. Since dvb_ringbuffer_flush() modifies the
>> read pointer, this function must not be called from the writer thread.
>>
>> This patch removes the dvb_ringbuffer_flush() calls in the dmxdev ringbuffer
>> write functions, this fixes Oopses "Unable to handle kernel paging request"
>> I could observe for the call chain dvb_demux_read ->dvb_dmxdev_buffer_read ->
>> dvb_ringbuffer_read_user -> __copy_to_user (the reader side of the ringbuffer).
>>
>> The flush calls at the write side are not necessary anyway since ringbuffer_flush
>> is also called in dvb_dmxdev_buffer_read() when an error condition is set in the
>> ringbuffer.
>>
>> This patch should also be applied to stable kernels.
>>
>> Signed-off-by: Soeren Moch <smoch@web.de>
>> CC: <stable@vger.kernel.org>
> While the change the patch does itself appears sound to me, I need to ask
> you to resend the patch using git send-email (it won't apply as-is). I can
> do that this time, too; let me know what works for you.
Please convert this patch to git format, thank you!
>
> Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>
And thanks for your rewiew, too.

   Soeren
>
>> --- a/drivers/media/dvb-core/dmxdev.c	2013-04-05 21:21:15.000000000 +0200
>> +++ b/drivers/media/dvb-core/dmxdev.c	2013-04-14 09:01:58.000000000 +0200
>> @@ -377,10 +377,8 @@ static int dvb_dmxdev_section_callback(c
>>   		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer2,
>>   					      buffer2_len);
>>   	}
>> -	if (ret < 0) {
>> -		dvb_ringbuffer_flush(&dmxdevfilter->buffer);
>> +	if (ret < 0)
>>   		dmxdevfilter->buffer.error = ret;
>> -	}
>>   	if (dmxdevfilter->params.sec.flags & DMX_ONESHOT)
>>   		dmxdevfilter->state = DMXDEV_STATE_DONE;
>>   	spin_unlock(&dmxdevfilter->dev->lock);
>> @@ -416,10 +414,8 @@ static int dvb_dmxdev_ts_callback(const
>>   	ret = dvb_dmxdev_buffer_write(buffer, buffer1, buffer1_len);
>>   	if (ret == buffer1_len)
>>   		ret = dvb_dmxdev_buffer_write(buffer, buffer2, buffer2_len);
>> -	if (ret < 0) {
>> -		dvb_ringbuffer_flush(buffer);
>> +	if (ret < 0)
>>   		buffer->error = ret;
>> -	}
>>   	spin_unlock(&dmxdevfilter->dev->lock);
>>   	wake_up(&buffer->queue);
>>   	return 0;
>>

