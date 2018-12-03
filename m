Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:45690 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbeLCPoA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 10:44:00 -0500
Subject: Re: [PATCH v6 2/2] media: platform: Add Aspeed Video Engine driver
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eddie James <eajames@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
References: <1543347457-59224-1-git-send-email-eajames@linux.ibm.com>
 <1543347457-59224-3-git-send-email-eajames@linux.ibm.com>
 <1d5f3260-2d95-32b2-090e-2f57ae9e6833@xs4all.nl>
Message-ID: <d876ac01-238f-7e74-2738-f1c878921c77@xs4all.nl>
Date: Mon, 3 Dec 2018 16:43:48 +0100
MIME-Version: 1.0
In-Reply-To: <1d5f3260-2d95-32b2-090e-2f57ae9e6833@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2018 12:04 PM, Hans Verkuil wrote:
> On 11/27/2018 08:37 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting a service processor, the Video Engine can capture
>> the host processor graphics output.
>>
>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>> Make the video frames available through the V4L2 streaming interface.
>>
>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>> ---

<snip>

>> +static void aspeed_video_bufs_done(struct aspeed_video *video,
>> +				   enum vb2_buffer_state state)
>> +{
>> +	unsigned long flags;
>> +	struct aspeed_video_buffer *buf;
>> +
>> +	spin_lock_irqsave(&video->lock, flags);
>> +	list_for_each_entry(buf, &video->buffers, link) {
>> +		if (list_is_last(&buf->link, &video->buffers))
>> +			buf->vb.flags |= V4L2_BUF_FLAG_LAST;
> 
> This really makes no sense. This flag is for codecs, not for receivers.
> 
> You say in an earlier reply about this:
> 
> "I mentioned before that dequeue calls hang in an error condition unless
> this flag is specified. For example if resolution change is detected and
> application is in the middle of trying to dequeue..."
> 
> What error condition are you referring to? Isn't your application using
> the select() or poll() calls to wait for events or new buffers to dequeue?
> If you just call VIDIOC_DQBUF to wait in blocking mode for a new buffer,
> then it will indeed block in that call.
> 
> No other video receiver needs this flag, so there is something else that is
> the cause.

Let me give a bit more information on how video receivers behave when the
signal disappears:

They will all send the SOURCE_CHANGE event, but what they do with respect
to streaming buffers is hardware dependent:

1) Some receivers have a freewheeling mode where the hardware generates
   an image when there is no signal (usually this is just a fixed color).
   In that case the application will just keep receiving buffers.

2) VIDIOC_DQBUF blocks until a new signal appears with the same timings,
   then the driver will just keep going as if nothing changed. DQBUF
   remains blocked as long as there is no signal, or the timings are
   different from the currently active timings.

3) The hardware requires a hard stop and cannot continue streaming. In
   that case it can call vb2_queue_error().

That last option should be avoided if possible as it's not very polite.
>From what I can tell from this hardware it seems option 2 is the
appropriate choice.

Regards,

	Hans

> 
>> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
>> +	}
>> +	INIT_LIST_HEAD(&video->buffers);
>> +	spin_unlock_irqrestore(&video->lock, flags);
>> +}
