Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56664 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbbKBMZz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2015 07:25:55 -0500
Message-ID: <5637564A.6010400@xs4all.nl>
Date: Mon, 02 Nov 2015 13:25:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v8 1/6] media: videobuf2: Move timestamp to vb2_buffer
References: <1446439425-13242-1-git-send-email-jh1009.sung@samsung.com> <1446439425-13242-2-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1446439425-13242-2-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/02/2015 05:43 AM, Junghak Sung wrote:
> Move timestamp from struct vb2_v4l2_buffer to struct vb2_buffer
> for common use, and change its type to struct timespec in order to handling
> y2038 problem. This patch also includes all device drivers' changes related to
> this restructuring.
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---

<snip>

> diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
> index 51d4a17..34525dc 100644
> --- a/drivers/usb/gadget/function/uvc_queue.c
> +++ b/drivers/usb/gadget/function/uvc_queue.c
> @@ -329,7 +329,7 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
>  
>  	buf->buf.field = V4L2_FIELD_NONE;
>  	buf->buf.sequence = queue->sequence++;
> -	v4l2_get_timestamp(&buf->buf.timestamp);
> +	ktime_get_ts(&buf->buf.vb2_buf.timestamp);
>  
>  	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
>  	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 647ebfe..3fe6600 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -211,6 +211,7 @@ struct vb2_queue;
>   * @num_planes:		number of planes in the buffer
>   *			on an internal driver queue
>   * @planes:		private per-plane information; do not change
> + * @timestamp:		frame timestamp
>   */
>  struct vb2_buffer {
>  	struct vb2_queue	*vb2_queue;
> @@ -219,6 +220,7 @@ struct vb2_buffer {
>  	unsigned int		memory;
>  	unsigned int		num_planes;
>  	struct vb2_plane	planes[VB2_MAX_PLANES];
> +	struct timespec		timestamp;

This should be a __u64 containing nanoseconds. That is the recommended way of
storing timestamps according to the y2038 team. The timespec struct is not
y2038 safe, whereas using __u64 is OK.

Please change!

And instead of using ktime_get_ts() in drivers use ktime_get_ns().

Regards,

	Hans
