Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34659 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752415AbcKOO1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 09:27:30 -0500
MIME-Version: 1.0
In-Reply-To: <1478282032-17571-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1478282032-17571-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1478282032-17571-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Nov 2016 15:27:29 +0100
Message-ID: <CAMuHMdUUXkJxbNxKJ0Od3N40+N4TNRoMFBjVCjvCO9x_xR1=tA@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] v4l: vsp1: Provide a writeback video device
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 4, 2016 at 6:53 PM, Kieran Bingham
<kieran.bingham+renesas@ideasonboard.com> wrote:
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c

> +static void vsp1_video_wb_process_buffer(struct vsp1_video *video)
> +{

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

drivers/media/platform/vsp1/vsp1_video.c:946:30: warning: missing
braces around initializer [-Wmissing-braces]
   video->rwpf->mem = (struct vsp1_rwpf_memory) { 0 };

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

drivers/media/platform/vsp1/vsp1_video.c:1008:22: warning: missing
braces around initializer [-Wmissing-braces]
  rwpf->mem = (struct vsp1_rwpf_memory) { 0 };

Either drop the "0":

        mem = (struct vsp1_rwpf_memory) { };

or add an additional pair of braces:

        mem = (struct vsp1_rwpf_memory) { { 0 } };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
