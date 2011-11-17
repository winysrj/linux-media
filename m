Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61662 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab1KQMO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 07:14:28 -0500
Received: by bke11 with SMTP id 11so1891184bke.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:14:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320753962-14079-5-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1320753962-14079-5-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Thu, 17 Nov 2011 13:14:26 +0100
Message-ID: <CACKLOr2XoEWba_aYvV==6czbinHaAVK1Ufxu0kHpZcoWpz7DDQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] uvcvideo: Add UVC timestamps support
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Yann Sionneau <yann@minet.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 8 November 2011 13:06, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>  void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
> diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
> index 513ba30..d0600a5 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
[snip]
> +       ts.tv_sec = first->host_ts.tv_sec - 1 + y / NSEC_PER_SEC;
> +       ts.tv_nsec = first->host_ts.tv_nsec + y % NSEC_PER_SEC;

I'm trying to build the uvcvideo-next branch which includes this patch
and the previous two lines give the following error:

drivers/built-in.o: In function `uvc_video_clock_update':
/home/javier/GIT/linux-uvc/drivers/media/video/uvc/uvc_video.c:656:
undefined reference to `__aeabi_uldivmod'
/home/javier/GIT/linux-uvc/drivers/media/video/uvc/uvc_video.c:657:
undefined reference to `__aeabi_uldivmod'

I am using gcc version 4.2.3 (Sourcery G++ Lite 2008q1-126) for ARM.

> +       if (ts.tv_nsec >= NSEC_PER_SEC) {
> +               ts.tv_sec++;
> +               ts.tv_nsec -= NSEC_PER_SEC;
> +       }
> +
> +       uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %lu.%06lu "
> +                 "buf ts %lu.%06lu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
> +                 stream->dev->name,
> +                 sof >> 16, div64_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
> +                 y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
> +                 v4l2_buf->timestamp.tv_sec, v4l2_buf->timestamp.tv_usec,
> +                 x1, first->host_sof, first->dev_sof,
> +                 x2, last->host_sof, last->dev_sof, y1, y2);
> +
> +       /* Update the V4L2 buffer. */
> +       v4l2_buf->timestamp.tv_sec = ts.tv_sec;
> +       v4l2_buf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> +
> +done:
> +       spin_unlock_irqrestore(&stream->clock.lock, flags);
> +}
> +
>  /* ------------------------------------------------------------------------
>  * Stream statistics
>  */
> @@ -637,6 +957,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
>                        uvc_video_stats_update(stream);
>        }
>
> +       uvc_video_clock_decode(stream, buf, data, len);
>        uvc_video_stats_decode(stream, data, len);
>
>        /* Store the payload FID bit and return immediately when the buffer is
> @@ -1096,6 +1417,8 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
>
>        if (free_buffers)
>                uvc_free_urb_buffers(stream);
> +
> +       uvc_video_clock_cleanup(stream);
>  }
>
>  /*
> @@ -1225,6 +1548,10 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
>
>        uvc_video_stats_start(stream);
>
> +       ret = uvc_video_clock_init(stream);
> +       if (ret < 0)
> +               return ret;
> +
>        if (intf->num_altsetting > 1) {
>                struct usb_host_endpoint *best_ep = NULL;
>                unsigned int best_psize = 3 * 1024;
> diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
> index e4d4b6d..e9c19f5 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -329,6 +329,8 @@ struct uvc_buffer {
>        void *mem;
>        unsigned int length;
>        unsigned int bytesused;
> +
> +       u32 pts;
>  };
>
>  #define UVC_QUEUE_DISCONNECTED         (1 << 0)
> @@ -455,6 +457,25 @@ struct uvc_streaming {
>                struct uvc_stats_frame frame;
>                struct uvc_stats_stream stream;
>        } stats;
> +
> +       /* Timestamps support. */
> +       struct uvc_clock {
> +               struct uvc_clock_sample {
> +                       u32 dev_stc;
> +                       u16 dev_sof;
> +                       struct timespec host_ts;
> +                       u16 host_sof;
> +               } *samples;
> +
> +               unsigned int head;
> +               unsigned int count;
> +               unsigned int size;
> +
> +               u16 last_sof;
> +               u16 sof_offset;
> +
> +               spinlock_t lock;
> +       } clock;
>  };
>
>  enum uvc_device_state {
> @@ -527,6 +548,7 @@ struct uvc_driver {
>  #define UVC_TRACE_STATUS       (1 << 9)
>  #define UVC_TRACE_VIDEO                (1 << 10)
>  #define UVC_TRACE_STATS                (1 << 11)
> +#define UVC_TRACE_CLOCK                (1 << 12)
>
>  #define UVC_WARN_MINMAX                0
>  #define UVC_WARN_PROBE_DEF     1
> @@ -607,6 +629,9 @@ extern int uvc_probe_video(struct uvc_streaming *stream,
>                struct uvc_streaming_control *probe);
>  extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
>                __u8 intfnum, __u8 cs, void *data, __u16 size);
> +void uvc_video_clock_update(struct uvc_streaming *stream,
> +                           struct v4l2_buffer *v4l2_buf,
> +                           struct uvc_buffer *buf);
>
>  /* Status */
>  extern int uvc_status_init(struct uvc_device *dev);
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
