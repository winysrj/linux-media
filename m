Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3766 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaBWI5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 03:57:34 -0500
Message-ID: <5309B7E9.10502@xs4all.nl>
Date: Sun, 23 Feb 2014 09:57:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 09/11] vb2: only call start_streaming if sufficient
 buffers are queued
References: <1392374472-18393-1-git-send-email-hverkuil@xs4all.nl> <1392374472-18393-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392374472-18393-10-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2014 11:41 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> In commit 02f142ecd24aaf891324ffba8527284c1731b561 support was added to
> start_streaming to return -ENOBUFS if insufficient buffers were queued
> for the DMA engine to start. The vb2 core would attempt calling
> start_streaming again if another buffer would be queued up.
> 
> Later analysis uncovered problems with the queue management if start_streaming
> would return an error: the buffers are enqueued to the driver before the
> start_streaming op is called, so after an error they are never returned to
> the vb2 core. The solution for this is to let the driver return them to
> the vb2 core in case of an error while starting the DMA engine. However,
> in the case of -ENOBUFS that would be weird: it is not a real error, it
> just says that more buffers are needed. Requiring start_streaming to give
> them back only to have them requeued again the next time the application
> calls QBUF is inefficient.
> 
> This patch changes this mechanism: it adds a 'min_buffers_needed' field
> to vb2_queue that drivers can set with the minimum number of buffers
> required to start the DMA engine. The start_streaming op is only called
> if enough buffers are queued. The -ENOBUFS handling has been dropped in
> favor of this new method.
> 
> Drivers are expected to return buffers back to vb2 core with state QUEUED
> if start_streaming would return an error. The vb2 core checks for this
> and produces a warning if that didn't happen and it will forcefully
> reclaim such buffers to ensure that the internal vb2 core state remains
> consistent and all buffer-related resources have been correctly freed
> and all op calls have been balanced.
> 
> __reqbufs() and __create_bufs() have been updated to check that at least
> min_buffers_needed buffers could be allocated. If fewer buffers were
> allocated then those functions will free what was allocated and return
> -ENOMEM. Based on a suggestion from Pawel Osciak.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/davinci/vpbe_display.c   |   6 +-
>  drivers/media/platform/davinci/vpif_capture.c   |   7 +-
>  drivers/media/platform/davinci/vpif_display.c   |   7 +-
>  drivers/media/platform/s5p-tv/mixer_video.c     |   6 +-
>  drivers/media/v4l2-core/videobuf2-core.c        | 151 ++++++++++++++++--------
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |   3 +-
>  include/media/videobuf2-core.h                  |  14 ++-
>  7 files changed, 120 insertions(+), 74 deletions(-)
> 

<snip>

> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 96c5ac6..5c8adb4 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -804,6 +804,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  	 * Make sure the requested values and current defaults are sane.
>  	 */
>  	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
> +	num_buffers = max_t(unsigned int, req->count, q->min_buffers_needed);
>  	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>  	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
>  	q->memory = req->memory;
> @@ -829,9 +830,16 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  	allocated_buffers = ret;
>  
>  	/*
> +	 * There is no point in continuing if we can't allocate the minimum
> +	 * number of buffers needed by this vb2_queue.
> +	 */
> +	if (allocated_buffers < q->min_buffers_needed)
> +		ret = -ENOMEM;
> +
> +	/*
>  	 * Check if driver can handle the allocated number of buffers.
>  	 */
> -	if (allocated_buffers < num_buffers) {
> +	if (ret > 0 && allocated_buffers < num_buffers) {
>  		num_buffers = allocated_buffers;
>  
>  		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
> @@ -908,6 +916,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>  		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>  		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
>  		q->memory = create->memory;
> +		create->count = max(create->count, q->min_buffers_needed);
>  	}
>  
>  	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
> @@ -934,9 +943,16 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>  	allocated_buffers = ret;
>  
>  	/*
> +	 * There is no point in continuing if we can't allocate the minimum
> +	 * number of buffers needed by this vb2_queue.
> +	 */
> +	if (q->num_buffers + allocated_buffers < q->min_buffers_needed)
> +		ret = -ENOMEM;

On second thoughts I would drop these checks against min_buffers_needed in
create_bufs and reqbufs. It should be the driver in queue_setup that checks
this.

Instead, just return an error in vb2_internal_streamon if not enough buffers
have been created. This allows the application to create buffers in any order
it wants, but it still will prevent you from streaming if you didn't create
enough.

Regards,

	Hans
