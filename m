Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1846 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaHDLEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 07:04:39 -0400
Message-ID: <53DF68B8.2030308@xs4all.nl>
Date: Mon, 04 Aug 2014 13:04:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH for v3.17 1/2] videobuf2-core.h: fix comment
References: <1407148032-41607-1-git-send-email-hverkuil@xs4all.nl> <1407148032-41607-2-git-send-email-hverkuil@xs4all.nl> <1677917.ZvIcNnnNOx@avalon>
In-Reply-To: <1677917.ZvIcNnnNOx@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2014 12:40 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Monday 04 August 2014 12:27:11 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The comment for start_streaming that tells the developer with which vb2
>> state buffers should be returned to vb2 gave the wrong state. Very
>> confusing.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I wonder whether we couldn't simplify drivers by moving this into vb2 though. 
> A failed start_streaming requires drivers to dequeue all buffers internally, 
> but the call to vb2_buffer_done() could be handled inside vb2. On the other 
> hand it would make the vb2 warning go away, and drivers that fail to dequeue 
> buffers internally would not be caught as easily, so I won't push for that 
> change.

The driver owns the buffers at that point. So if I just dequeue them internally
then I have no idea what sort of driver-internal data structures I am corrupting.

Most drivers use a linked list of some sort, so that is typically the one that
gets messed up (and that actually happens). By far the best approach is to
require that drivers just hand over the buffers themselves, that way everything
happens in a controlled manner.

Regards,

	Hans

> 
>> ---
>>  include/media/videobuf2-core.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index fc910a6..80fa725 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -295,7 +295,7 @@ struct vb2_buffer {
>>   *			can return an error if hardware fails, in that case all
>>   *			buffers that have been already given by the @buf_queue
>>   *			callback are to be returned by the driver by calling
>> - *			@vb2_buffer_done(VB2_BUF_STATE_DEQUEUED).
>> + *			@vb2_buffer_done(VB2_BUF_STATE_QUEUED).
>>   *			If you need a minimum number of buffers before you can
>>   *			start streaming, then set @min_buffers_needed in the
>>   *			vb2_queue structure. If that is non-zero then
> 

