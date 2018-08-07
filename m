Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40712 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbeHGMHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 08:07:47 -0400
Received: by mail-yw1-f68.google.com with SMTP id z143-v6so4695475ywa.7
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 02:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
From: Tomasz Figa <tfiga@google.com>
Date: Tue, 7 Aug 2018 18:54:02 +0900
Message-ID: <CAAFQd5CQEhmuLbs0dmGfu66x1Xq1V_kOT0bV_DoPitkkOX5Q4A@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] media: uvcvideo: Move decode processing to process context
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        g.liakhovetski@gmx.de, olivier.braun@stereolabs.com,
        troy.kisky@boundarydevices.com,
        Randy Dunlap <rdunlap@infradead.org>, philipp.zabel@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, Mar 28, 2018 at 1:47 AM Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
[snip]
> @@ -1544,25 +1594,29 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
>   */
>  static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
>  {
> -       struct urb *urb;
> -       unsigned int i;
> +       struct uvc_urb *uvc_urb;
>
>         uvc_video_stats_stop(stream);
>
> -       for (i = 0; i < UVC_URBS; ++i) {
> -               struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
> +       /*
> +        * We must poison the URBs rather than kill them to ensure that even
> +        * after the completion handler returns, any asynchronous workqueues
> +        * will be prevented from resubmitting the URBs
> +        */
> +       for_each_uvc_urb(uvc_urb, stream)
> +               usb_poison_urb(uvc_urb->urb);
>
> -               urb = uvc_urb->urb;
> -               if (urb == NULL)
> -                       continue;
> +       flush_workqueue(stream->async_wq);
>
> -               usb_kill_urb(urb);
> -               usb_free_urb(urb);
> +       for_each_uvc_urb(uvc_urb, stream) {
> +               usb_free_urb(uvc_urb->urb);
>                 uvc_urb->urb = NULL;
>         }
>
>         if (free_buffers)
>                 uvc_free_urb_buffers(stream);
> +
> +       destroy_workqueue(stream->async_wq);

In our testing, this function ends up being called twice, if before
suspend the camera is streaming and if the camera disconnects between
suspend and resume. This is because uvc_video_suspend() calls this
function (with free_buffers = 0), but uvc_video_resume() wouldn't call
uvc_init_video() due to an earlier failure and uvc_v4l2_release()
would end up calling this function again, while the workqueue is
already destroyed.

The following diff seems to take care of it:

8<~~~
diff --git a/drivers/media/usb/uvc/uvc_video.c
b/drivers/media/usb/uvc/uvc_video.c
index c5e0ab564b1a..6fb890c8ba67 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1493,10 +1493,11 @@ static void uvc_uninit_video(struct
uvc_streaming *stream, int free_buffers)
               uvc_urb->urb = NULL;
       }

-       if (free_buffers)
+       if (free_buffers) {
               uvc_free_urb_buffers(stream);
-
-       destroy_workqueue(stream->async_wq);
+               destroy_workqueue(stream->async_wq);
+               stream->async_wq = NULL;
+       }
}

/*
@@ -1648,10 +1649,12 @@ static int uvc_init_video(struct uvc_streaming
*stream, gfp_t gfp_flags)

       uvc_video_stats_start(stream);

-       stream->async_wq = alloc_workqueue("uvcvideo", WQ_UNBOUND | WQ_HIGHPRI,
-                       0);
-       if (!stream->async_wq)
-               return -ENOMEM;
+       if (!stream->async_wq) {
+               stream->async_wq = alloc_workqueue("uvcvideo",
+                                                  WQ_UNBOUND | WQ_HIGHPRI, 0);
+               if (!stream->async_wq)
+                       return -ENOMEM;
+       }

       if (intf->num_altsetting > 1) {
               struct usb_host_endpoint *best_ep = NULL;
~~~>8

Best regards,
Tomasz
