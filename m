Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44517 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2H1JLW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 05:11:22 -0400
Received: by wicr5 with SMTP id r5so4678441wic.1
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2012 02:11:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346143234.2534.42.camel@pizza.hi.pengutronix.de>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
	<1345825078-3688-5-git-send-email-p.zabel@pengutronix.de>
	<CACKLOr35e2QaktJ675VN0K3CdosznQ-4fNCQGq8xYaRH1q8LKg@mail.gmail.com>
	<1346143234.2534.42.camel@pizza.hi.pengutronix.de>
Date: Tue, 28 Aug 2012 11:11:20 +0200
Message-ID: <CACKLOr0aLx_4KtKjcZxnP2hoSa8WXxhMF_C2NtSZo7cvEr3Jsg@mail.gmail.com>
Subject: Re: [PATCH 04/12] media: coda: allocate internal framebuffers
 separately from v4l2 buffers
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 August 2012 10:40, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Javier,
>
> Am Dienstag, den 28.08.2012, 09:50 +0200 schrieb javier Martin:
>> Hi Phillip,
>> I see you are trying a cleaner approach for reference and reconstructed frames.
>> > -#define CODA_OUTPUT_BUFS       4
>> > -#define CODA_CAPTURE_BUFS      2
>> > +#define CODA_MAX_FRAMEBUFFERS  2
>>
>> According to page 58 of 'cnm-codadx6-datasheet-v2.9.pdf' for H.264
>> encoding a third buffer is needed whose size should be 'framebuffer
>> size / 16'.
>
> I have no documentation about CODA7541 or CODA960, but from Freescale's
> vpu_lib code for i.MX6q I got an additional buffer allocation (of
> framebuffer size / 4) per frame in the H.264 case, see below. Could this
> be the third buffer the CodaDx6 datasheet is talking about?

No, it isn't. It's a separate buffer of framebuffer_size /16. But, as
I told you, there is a conflict between this datasheet and the code
from Freescale for i.MX27.

>> >  #define MAX_W          720
>> >  #define MAX_H          576
>> > @@ -167,11 +166,12 @@ struct coda_ctx {
>> >         struct v4l2_m2m_ctx             *m2m_ctx;
>> >         struct v4l2_ctrl_handler        ctrls;
>> >         struct v4l2_fh                  fh;
>> > -       struct vb2_buffer               *reference;
>> >         int                             gopcounter;
>> >         char                            vpu_header[3][64];
>> >         int                             vpu_header_size[3];
>> >         struct coda_aux_buf             parabuf;
>> > +       struct coda_aux_buf             framebuffers[CODA_MAX_FRAMEBUFFERS];
>> > +       int                             num_framebuffers;
>> >         int                             idx;
>> >  };
>> >
>> > @@ -746,14 +746,6 @@ static int coda_job_ready(void *m2m_priv)
>> >                 return 0;
>> >         }
>> >
>> > -       /* For P frames a reference picture is needed too */
>> > -       if ((ctx->gopcounter != (ctx->params.gop_size - 1)) &&
>> > -          !ctx->reference) {
>> > -               v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> > -                        "not ready: reference picture not available.\n");
>> > -               return 0;
>> > -       }
>> > -
>> >         if (coda_isbusy(ctx->dev)) {
>> >                 v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> >                          "not ready: coda is still busy.\n");
>> > @@ -807,7 +799,6 @@ static void set_default_params(struct coda_ctx *ctx)
>> >         ctx->params.codec_mode = CODA_MODE_INVALID;
>> >         ctx->colorspace = V4L2_COLORSPACE_REC709;
>> >         ctx->params.framerate = 30;
>> > -       ctx->reference = NULL;
>> >         ctx->aborting = 0;
>> >
>> >         /* Default formats for output and input queues */
>> > @@ -833,7 +824,6 @@ static int coda_queue_setup(struct vb2_queue *vq,
>> >         unsigned int size;
>> >
>> >         if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>> > -               *nbuffers = CODA_OUTPUT_BUFS;
>> >                 if (fmt)
>> >                         size = fmt->fmt.pix.width *
>> >                                 fmt->fmt.pix.height * 3 / 2;
>> > @@ -841,7 +831,6 @@ static int coda_queue_setup(struct vb2_queue *vq,
>> >                         size = MAX_W *
>> >                                 MAX_H * 3 / 2;
>> >         } else {
>> > -               *nbuffers = CODA_CAPTURE_BUFS;
>> >                 size = CODA_MAX_FRAME_SIZE;
>> >         }
>> >
>> > @@ -894,6 +883,77 @@ static void coda_wait_finish(struct vb2_queue *q)
>> >         coda_lock(ctx);
>> >  }
>> >
>> > +static void coda_free_framebuffers(struct coda_ctx *ctx)
>> > +{
>> > +       int i;
>> > +
>> > +       for (i = 0; i < CODA_MAX_FRAMEBUFFERS; i++) {
>> > +               if (ctx->framebuffers[i].vaddr) {
>> > +                       dma_free_coherent(&ctx->dev->plat_dev->dev,
>> > +                               ctx->framebuffers[i].size,
>> > +                               ctx->framebuffers[i].vaddr,
>> > +                               ctx->framebuffers[i].paddr);
>> > +                       ctx->framebuffers[i].vaddr = NULL;
>> > +               }
>> > +       }
>> > +}
>> > +
>> > +static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_data, u32 fourcc)
>> > +{
>> > +       struct coda_dev *dev = ctx->dev;
>> > +
>> > +       int height = q_data->height;
>> > +       int width = q_data->width;
>> > +       u32 *p;
>> > +       int i;
>> > +
>> > +       /* Allocate frame buffers */
>> > +       ctx->num_framebuffers = CODA_MAX_FRAMEBUFFERS;
>> > +       for (i = 0; i < ctx->num_framebuffers; i++) {
>> > +               ctx->framebuffers[i].size = q_data->sizeimage;
>> > +               if (fourcc == V4L2_PIX_FMT_H264)
>> > +                       ctx->framebuffers[i].size += width / 2 * height / 2;
>
> Here we add an additional width*height/4 buffer for the h.264 encoding
> case.

This is not needed for codadx6.

>> > +               ctx->framebuffers[i].vaddr = dma_alloc_coherent(
>> > +                               &dev->plat_dev->dev, ctx->framebuffers[i].size,
>> > +                               &ctx->framebuffers[i].paddr, GFP_KERNEL);
>> > +               if (!ctx->framebuffers[i].vaddr) {
>> > +                       coda_free_framebuffers(ctx);
>> > +                       return -ENOMEM;
>> > +               }
>> > +       }
>> > +
>> > +       /* Register frame buffers in the parameter buffer */
>> > +       p = ctx->parabuf.vaddr;
>> > +
>> > +       if (dev->devtype->product == CODA_DX6) {
>> > +               for (i = 0; i < ctx->num_framebuffers; i++) {
>> > +                       p[i * 3] = ctx->framebuffers[i].paddr; /* Y */
>> > +                       p[i * 3 + 1] = p[i * 3] + width * height; /* Cb */
>> > +                       p[i * 3 + 2] = p[i * 3 + 1] + width / 2 * height / 2; /* Cr */
>> > +               }
>>
>> I'm the previous approach all source pictures were registered. Now you
>> only register the temporal private buffers. Are you sure this will
>> work?
>
> It seems to work on i.MX53. I think that is because a h.264 encoder does
> not use an original source frame as a reference frame, but a
> reconstructed frame, which is created by the encoder in one of the
> registered frame buffers.

OK, I'll test it on i.MX27 as soon as you resend the series.

>> > +       } else {
>> > +               for (i = 0; i < ctx->num_framebuffers; i += 2) {
>> > +                       p[i * 3 + 1] = ctx->framebuffers[i].paddr; /* Y */
>> > +                       p[i * 3] = p[i * 3 + 1] + width * height; /* Cb */
>> > +                       p[i * 3 + 3] = p[i * 3] + (width / 2) * (height / 2); /* Cr */
>> > +
>> > +                       if (fourcc == V4L2_PIX_FMT_H264)
>> > +                               p[96 + i + 1] = p[i * 3 + 3] + (width / 2) * (height / 2);
>
> And here ...
>
>> > +                       if (i + 1 < ctx->num_framebuffers) {
>> > +                               p[i * 3 + 2] = ctx->framebuffers[i+1].paddr; /* Y */
>> > +                               p[i * 3 + 5] = p[i * 3 + 2] + width * height ; /* Cb */
>> > +                               p[i * 3 + 4] = p[i * 3 + 5] + (width / 2) * (height / 2); /* Cr */
>> > +
>> > +                               if (fourcc == V4L2_PIX_FMT_H264)
>> > +                                       p[96 + i] = p[i * 3 + 4] + (width / 2) * (height / 2);
>
> ... and here the additional buffer mentioned above is registered.
>
>> > +                       }
>> > +               }
>> > +       }
>> > +
>> > +       return 0;
>> > +}
>> > +

Before you resend the series and I can make some intensive testing I
would only remove the extra size allocation for H-264 for CODADX6
case.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
