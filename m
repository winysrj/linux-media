Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1808 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbaDVMNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 08:13:22 -0400
Message-ID: <53565CBF.4020301@xs4all.nl>
Date: Tue, 22 Apr 2014 14:12:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv4 PATCH 12/18] vb2: only call start_streaming if sufficient
 buffers are queued
References: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl> <1393929746-39437-13-git-send-email-hverkuil@xs4all.nl> <77689490.zVtD3Raa0D@avalon>
In-Reply-To: <77689490.zVtD3Raa0D@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/21/2014 02:02 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 04 March 2014 11:42:20 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> In commit 02f142ecd24aaf891324ffba8527284c1731b561 support was added to
>> start_streaming to return -ENOBUFS if insufficient buffers were queued
>> for the DMA engine to start. The vb2 core would attempt calling
>> start_streaming again if another buffer would be queued up.
>>
>> Later analysis uncovered problems with the queue management if
>> start_streaming would return an error: the buffers are enqueued to the
>> driver before the start_streaming op is called, so after an error they are
>> never returned to the vb2 core. The solution for this is to let the driver
>> return them to the vb2 core in case of an error while starting the DMA
>> engine. However, in the case of -ENOBUFS that would be weird: it is not a
>> real error, it just says that more buffers are needed. Requiring
>> start_streaming to give them back only to have them requeued again the next
>> time the application calls QBUF is inefficient.
>>
>> This patch changes this mechanism: it adds a 'min_buffers_needed' field
>> to vb2_queue that drivers can set with the minimum number of buffers
>> required to start the DMA engine. The start_streaming op is only called
>> if enough buffers are queued. The -ENOBUFS handling has been dropped in
>> favor of this new method.
>>
>> Drivers are expected to return buffers back to vb2 core with state QUEUED
>> if start_streaming would return an error. The vb2 core checks for this
>> and produces a warning if that didn't happen and it will forcefully
>> reclaim such buffers to ensure that the internal vb2 core state remains
>> consistent and all buffer-related resources have been correctly freed
>> and all op calls have been balanced.
>>
>> __reqbufs() has been updated to check that at least min_buffers_needed
>> buffers could be allocated. If fewer buffers were allocated then __reqbufs
>> will free what was allocated and return -ENOMEM. Based on a suggestion from
>> Pawel Osciak.
>>
>> __create_bufs() doesn't do that check, since the use of __create_bufs
>> assumes some advance scenario where the user might want more control.
>> Instead streamon will check if enough buffers were allocated to prevent
>> streaming with fewer than the minimum required number of buffers.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/davinci/vpbe_display.c   |   6 +-
>>  drivers/media/platform/davinci/vpif_capture.c   |   7 +-
>>  drivers/media/platform/davinci/vpif_display.c   |   7 +-
>>  drivers/media/platform/s5p-tv/mixer_video.c     |   6 +-
>>  drivers/media/v4l2-core/videobuf2-core.c        | 146 ++++++++++++++-------
>>  drivers/staging/media/davinci_vpfe/vpfe_video.c |   3 +-
>>  include/media/videobuf2-core.h                  |  14 ++-
>>  7 files changed, 116 insertions(+), 73 deletions(-)
> 
> [snip]
> 
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c index 07cce7f..1f6eccf 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> 
> [snip]
> 
>> @@ -1890,18 +1939,23 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>  {
>>  	unsigned int i;
>>
>> -	if (q->retry_start_streaming) {
>> -		q->retry_start_streaming = 0;
>> -		q->streaming = 0;
>> -	}
>> -
>>  	/*
>>  	 * Tell driver to stop all transactions and release all queued
>>  	 * buffers.
>>  	 */
>> -	if (q->streaming)
>> +	if (q->start_streaming_called)
>>  		call_qop(q, stop_streaming, q);
>>  	q->streaming = 0;
>> +	q->start_streaming_called = 0;
>> +	q->queued_count = 0;
>> +
>> +	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
> 
> What's the rationale for a WARN_ON() here ? Wouldn't it simplify drivers to 
> handle buffer completion inside vb2 when stopping the stream ?

No.

The deal is that vb2 hands the buffer over to the driver via the buf_queue op
and the driver hands it back via the vb2_buffer_done call. In between the driver
owns the buffer. Typically the driver adds the buffer to an internal list in
the buf_queue op and deletes it from that list before calling vb2_buffer_done.

If vb2 cleans up 'dangling' buffers, then that means that that internal list
gets out of sync. That can cause all sorts of nasty problems. It is the reason
why so many drivers struggle with where that internal list should be initialized.

By warning when buf_queue and vb2_buffer_done are no longer balanced this driver
error is now detected properly and the driver can be fixed. By keeping these
calls balanced the buffer list in the driver will always be consistent with the
internal vb2 state.

This error is pretty nasty since it will only show up in corner cases such as
queuing buffers without ever calling STREAMON, or if start_streaming fails,
etc.

These days v4l2-compliance tests for the first corner case (QBUF without STREAMON),
so together with the WARN_ON we have a reasonable detection of this.

Regards,

	Hans

>> +		for (i = 0; i < q->num_buffers; ++i)
>> +			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
>> +				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
>> +		/* Must be zero now */
>> +		WARN_ON(atomic_read(&q->owned_by_drv_count));
>> +	}
>>
>>  	/*
>>  	 * Remove all buffers from videobuf's list...
> 

