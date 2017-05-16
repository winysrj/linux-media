Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36450 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbdEPPa5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 11:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <5debeb08338b520f52577ca6cf9be815a54c07ea.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ebf0f0df2d74f2a209e8b628269e3cac27d4a2ab.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
 <5debeb08338b520f52577ca6cf9be815a54c07ea.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 16 May 2017 17:30:55 +0200
Message-ID: <CAMuHMdUuoAy2kQ3D=GWScgt2GZZbgyiNvvvOaJkTNFH1CbBdew@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] v4l: vsp1: Provide a writeback video device
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, May 9, 2017 at 6:39 PM, Kieran Bingham
<kieran.bingham+renesas@ideasonboard.com> wrote:
> When the VSP1 is used in an active display pipeline, the output of the
> WPF can supply the LIF entity directly and simultaneously write to
> memory.
>
> Support this functionality in the VSP1 driver, by extending the WPF
> source pads, and establishing a V4L2 video device node connected to the
> new source.
>
> The source will be able to perform pixel format conversion, but not
> rescaling, and as such the output from the memory node will always be
> of the same dimensions as the display output.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c

> @@ -900,6 +901,147 @@ static const struct vb2_ops vsp1_video_queue_qops = {
>         .stop_streaming = vsp1_video_stop_streaming,
>  };
>
> +
> +/* -----------------------------------------------------------------------------
> + * videobuf2 queue operations for writeback nodes
> + */
> +
> +static void vsp1_video_wb_process_buffer(struct vsp1_video *video)
> +{
> +       struct vsp1_vb2_buffer *buf;
> +       unsigned long flags;
> +
> +       /*
> +        * Writeback uses a running stream, unlike the M2M interface which
> +        * controls a pipeline process manually though the use of
> +        * vsp1_pipeline_run().
> +        *
> +        * Instead writeback will commence at the next frame interval, and can
> +        * be marked complete at the interval following that. To handle this we
> +        * store the configured buffer as pending until the next callback.
> +        *
> +        * |    |    |    |    |
> +        *  A   |<-->|
> +        *       B   |<-->|
> +        *            C   |<-->| : Only at interrupt C can A be marked done
> +        */
> +
> +       spin_lock_irqsave(&video->irqlock, flags);
> +
> +       /* Move the pending image to the active hw queue */
> +       if (video->pending) {
> +               list_add_tail(&video->pending->queue, &video->irqqueue);
> +               video->pending = NULL;
> +       }
> +
> +       buf = list_first_entry_or_null(&video->wbqueue, struct vsp1_vb2_buffer,
> +                                       queue);
> +
> +       if (buf) {
> +               video->rwpf->mem = buf->mem;
> +
> +               /*
> +                * Store this buffer as pending. It will commence at the next
> +                * frame start interrupt
> +                */
> +               video->pending = buf;
> +               list_del(&buf->queue);
> +       } else {
> +               /* Disable writeback with no buffer */
> +               video->rwpf->mem = (struct vsp1_rwpf_memory) { 0 };

With gcc 4.9.0:

    drivers/media/platform/vsp1/vsp1_video.c: In function
'vsp1_video_wb_process_buffer':
    drivers/media/platform/vsp1/vsp1_video.c:942:30: warning: missing
braces around initializer [-Wmissing-braces]
       video->rwpf->mem = (struct vsp1_rwpf_memory) { 0 };

-               video->rwpf->mem = (struct vsp1_rwpf_memory) { 0 };
+               video->rwpf->mem = (struct vsp1_rwpf_memory) { { 0, } };

> +static void vsp1_video_wb_stop_streaming(struct vb2_queue *vq)
> +{
> +       struct vsp1_video *video = vb2_get_drv_priv(vq);
> +       struct vsp1_rwpf *rwpf = video->rwpf;
> +       struct vsp1_pipeline *pipe = rwpf->pipe;
> +       struct vsp1_vb2_buffer *buffer;
> +       unsigned long flags;
> +
> +       /*
> +        * Disable the completion interrupts, and clear the WPF memory to
> +        * prevent writing out frames
> +        */
> +       spin_lock_irqsave(&video->irqlock, flags);
> +       video->frame_end = NULL;
> +       rwpf->mem = (struct vsp1_rwpf_memory) { 0 };

Likewise:

-       rwpf->mem = (struct vsp1_rwpf_memory) { 0 };
+       rwpf->mem = (struct vsp1_rwpf_memory) { { 0, } };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
