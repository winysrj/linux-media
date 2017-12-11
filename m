Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37219 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdLKUQV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 15:16:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v8] uvcvideo: Add a metadata device node
Date: Mon, 11 Dec 2017 22:16:23 +0200
Message-ID: <6758104.TntGDxqkIy@avalon>
In-Reply-To: <alpine.DEB.2.20.1712061202230.26640@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <3317467.6k60bZc7Ey@avalon> <alpine.DEB.2.20.1712061202230.26640@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Wednesday, 6 December 2017 17:15:40 EET Guennadi Liakhovetski wrote:
> From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> 
> Some UVC video cameras contain metadata in their payload headers. This
> patch extracts that data, adding more clock synchronisation information,
> on both bulk and isochronous endpoints and makes it available to the user
> space on a separate video node, using the V4L2_CAP_META_CAPTURE capability
> and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. By default, only the
> V4L2_META_FMT_UVC pixel format is available from those nodes. However,
> cameras can be added to the device ID table to additionally specify their
> own metadata format, in which case that format will also become available
> from the metadata node.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
> 
> v8: addressed comments and integrated changes from Laurent, thanks again,
> e.g.:
> 
> - multiple stylistic changes
> - remove the UVC_DEV_FLAG_METADATA_NODE flag / quirk: nodes are now
>   created unconditionally
> - reuse uvc_ioctl_querycap()
> - reuse code in uvc_register_video()
> - set an error flag when the metadata buffer overflows
> 
>  drivers/media/usb/uvc/Makefile       |   2 +-
>  drivers/media/usb/uvc/uvc_driver.c   |  15 ++-
>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
>  drivers/media/usb/uvc/uvc_metadata.c | 179 ++++++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvc_queue.c    |  44 +++++++--
>  drivers/media/usb/uvc/uvc_video.c    | 132 ++++++++++++++++++++++++--
>  drivers/media/usb/uvc/uvcvideo.h     |  16 +++-
>  include/uapi/linux/uvcvideo.h        |  26 +++++
>  8 files changed, 394 insertions(+), 22 deletions(-)
>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 13f459e..2fc0bf2 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c

[snip]

> +static void uvc_video_decode_meta(struct uvc_streaming *stream,
> +				  struct uvc_buffer *meta_buf,
> +				  const u8 *mem, unsigned int length)
> +{
> +	struct uvc_meta_buf *meta;
> +	size_t len_std = 2;
> +	bool has_pts, has_scr;
> +	unsigned long flags;
> +	ktime_t time;
> +	const u8 *scr;
> +
> +	if (!meta_buf || length == 2)
> +		return;
> +
> +	if (meta_buf->length - meta_buf->bytesused <
> +	    length + sizeof(meta->ns) + sizeof(meta->sof)) {
> +		meta_buf->error = 1;
> +		return;
> +	}
> +
> +	has_pts = mem[1] & UVC_STREAM_PTS;
> +	has_scr = mem[1] & UVC_STREAM_SCR;
> +
> +	if (has_pts) {
> +		len_std += 4;
> +		scr = mem + 6;
> +	} else {
> +		scr = mem + 2;
> +	}
> +
> +	if (has_scr)
> +		len_std += 6;
> +
> +	if (stream->meta.format == V4L2_META_FMT_UVC)
> +		length = len_std;
> +
> +	if (length == len_std && (!has_scr ||
> +				  !memcmp(scr, stream->clock.last_scr, 6)))
> +		return;
> +
> +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf->bytesused);
> +	local_irq_save(flags);
> +	time = uvc_video_get_time();
> +	meta->sof = usb_get_current_frame_number(stream->dev->udev);

You need a put_unaligned here too. If you're fine with the patch below there's 
no need to resubmit, and

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Would you mind sending me your test tool patch ?

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/
uvc_video.c
index 2fc0bf2221db..02e4997a32bb 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1142,6 +1142,7 @@ static void uvc_video_decode_meta(struct uvc_streaming 
*stream,
 	size_t len_std = 2;
 	bool has_pts, has_scr;
 	unsigned long flags;
+	unsigned int sof;
 	ktime_t time;
 	const u8 *scr;
 
@@ -1177,9 +1178,10 @@ static void uvc_video_decode_meta(struct uvc_streaming 
*stream,
 	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf->bytesused);
 	local_irq_save(flags);
 	time = uvc_video_get_time();
-	meta->sof = usb_get_current_frame_number(stream->dev->udev);
+	sof = usb_get_current_frame_number(stream->dev->udev);
 	local_irq_restore(flags);
 	__put_unaligned_cpu64(ktime_to_ns(time), &meta->ns);
+	__put_unaligned_cpu16(sof, &meta->sof);
 
 	if (has_scr)
 		memcpy(stream->clock.last_scr, scr, 6);

> +	local_irq_restore(flags);
> +	__put_unaligned_cpu64(ktime_to_ns(time), &meta->ns);
> +
> +	if (has_scr)
> +		memcpy(stream->clock.last_scr, scr, 6);
> +
> +	memcpy(&meta->length, mem, length);
> +	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
> +
> +	uvc_trace(UVC_TRACE_FRAME,
> +		  "%s(): t-sys %lluns, SOF %u, len %u, flags 0x%x, PTS %u, STC %u frame
> SOF %u\n", +		  __func__, time, meta->sof, meta->length, meta->flags,
> +		  has_pts ? *(u32 *)meta->buf : 0,
> +		  has_scr ? *(u32 *)scr : 0,
> +		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> +}

[snip]

-- 
Regards,

Laurent Pinchart
