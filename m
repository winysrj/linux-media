Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54613 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2AZLgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 06:36:44 -0500
Received: by wgbgn7 with SMTP id gn7so716862wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 03:36:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201251127040.18778@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
	<1327059392-29240-4-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201251127040.18778@axis700.grange>
Date: Thu, 26 Jan 2012 12:36:43 +0100
Message-ID: <CACKLOr2zLAj4eFbjBsmN=OvCFCi9UcpWFQJF-SP4GkuP=sDwEw@mail.gmail.com>
Subject: Re: [PATCH 3/4] media i.MX27 camera: improve discard buffer handling.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	baruch@tkos.co.il
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 25 January 2012 13:12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Fri, 20 Jan 2012, Javier Martin wrote:
>
>> The way discard buffer was previously handled lead
>> to possible races that made a buffer that was not
>> yet ready to be overwritten by new video data. This
>> is easily detected at 25fps just adding "#define DEBUG"
>> to enable the "memset" check and seeing how the image
>> is corrupted.
>>
>> A new "discard" queue and two discard buffers have
>> been added to make them flow trough the pipeline
>> of queues and thus provide suitable event ordering.
>
> Hmm, do I understand it right, that the problem is, that while the first
> frame went to the discard buffer, the second one went already to a user
> buffer, while it wasn't ready yet?

The problem is not only related to the discard buffer but also the way
valid buffers were handled in an unsafe basis.
For instance, the "buf->bufnum = !bufnum" issue. If you receive and
IRQ from bufnum = 0 you have to update buffer 0, not buffer 1.

>And you solve this by adding one more
> discard buffer? Wouldn't it be possible to either not start capture until
> .start_streaming() is issued, which should also be the case after your
> patch 2/4, or, at least, just reuse one discard buffer multiple times
> until user buffers are available?
>
> If I understand right, you don't really introduce two discard buffers,
> there's still only one data buffer, but you add two discard data objects
> and a list to keep them on. TBH, this seems severely over-engineered to
> me. What's wrong with just keeping one DMA data buffer and using it as
> long, as needed, and checking in your ISR, whether a proper buffer is
> present, by looking for list_empty(active)?
>
> I added a couple of comments below, but my biggest question really is -
> why are these two buffer objects needed? Please, consider getting rid of
> them. So, this is not a full review, if the objects get removed, most of
> this patch will change anyway.

1. Why a discard buffer is needed?

When I first took a look at the code it only supported CH1 of the PrP
(i.e. RGB formats) and a discard buffer was used. My first reaction
was trying to get rid of that trick. Both CH1 and CH2 of the PrP have
two pointers that the engine uses to write video frames in a ping-pong
basis. However, there is a big difference between both channels: if
you want to detect frame loss in CH1 you have to continually feed the
two pointers with valid memory areas because the engine is always
writing and you can't stop it, and this is where the discard buffer
function is required, but CH2 has a mechanism to stop capturing and
keep counting loss frames, thus a discard buffer wouldn't be needed.

To sum up: the driver would be much cleaner without this discard
buffer trick but we would have to drop support for CH1 (RGB format).
Being respectful to CH1 support I decided to add CH2 by extending the
discard buffer strategy to both channels, since the code is cleaner
this way and doesn't make sense to manage both channels differently.

2. Why two discard buffer objects are needed?

After enabling the DEBUG functionality that writes the buffers with
0xaa before they are filled with video data, I discovered some of them
were being corrupted. When I tried to find the reason I found that we
really have a pipeline here:

-------------------               -----------------------
  capture (n) | ------------>  active_bufs (2)|
-------------------              ------------------------

where
"capture" has buffers that are queued and ready to be written into
"active_bufs" represents those buffers that are assigned to a pointer
in the PrP and has a maximum of 2 since there are two pointers that
are written in a ping-pong fashion

However, with the previous approach, the discard buffer is kept
outside this pipeline as if it was a global variable which is usually
a dangerous practice and definitely it's wrong since the buffers are
corrupted.


On the other hand, if we add 2 discard buffer objects we will be able
to pass them through the pipeline as if they were normal buffers. We
chose 2 because this is the number of pointers of the PrP and thus,
the maximum of elements that can be in "active_bufs" queue (i.e. we
have to cover the case where both pointers are assigned discard
buffers). This has several advantages:
 - They can be treated in most cases as normal buffers which saves
code ("mx27_update_emma_buf" function).
 - The events are properly ordered: every time an IRQ comes you know
the first element in active_bufs queue is the buffer you want, if it
is not the case something has gone terribly wrong.
 - It's much easier to demonstrate mathematically that this will work
(I wasn't able with the previous approach).


>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/mx2_camera.c |  215 +++++++++++++++++++++-----------------
>>  1 files changed, 117 insertions(+), 98 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index 4816da6..e0c5dd4 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -224,6 +224,28 @@ struct mx2_fmt_cfg {
>>       struct mx2_prp_cfg              cfg;
>>  };
>>
>> +enum mx2_buffer_state {
>> +     MX2_STATE_NEEDS_INIT = 0,
>> +     MX2_STATE_PREPARED   = 1,
>> +     MX2_STATE_QUEUED     = 2,
>> +     MX2_STATE_ACTIVE     = 3,
>> +     MX2_STATE_DONE       = 4,
>> +     MX2_STATE_ERROR      = 5,
>> +     MX2_STATE_IDLE       = 6,
>> +};
>> +
>> +/* buffer for one video frame */
>> +struct mx2_buffer {
>> +     /* common v4l buffer stuff -- must be first */
>> +     struct vb2_buffer               vb;
>> +     struct list_head                queue;
>> +     enum mx2_buffer_state           state;
>> +     enum v4l2_mbus_pixelcode        code;
>> +
>> +     int                             bufnum;
>> +     bool                            discard;
>> +};
>> +
>
> When submitting a patch series, it is usually good to avoid
> double-patching. E.g., in this case, your first patch adds these enum and
> struct and this patch moves them a couple of lines up. Please, place them
> at the correct location already with the first patch.

OK, I'll fix it in the next version.

>>  struct mx2_camera_dev {
>>       struct device           *dev;
>>       struct soc_camera_host  soc_host;
>> @@ -240,6 +262,7 @@ struct mx2_camera_dev {
>>
>>       struct list_head        capture;
>>       struct list_head        active_bufs;
>> +     struct list_head        discard;
>>
>>       spinlock_t              lock;
>>
>> @@ -252,6 +275,7 @@ struct mx2_camera_dev {
>>
>>       u32                     csicr1;
>>
>> +     struct mx2_buffer       buf_discard[2];
>>       void                    *discard_buffer;
>>       dma_addr_t              discard_buffer_dma;
>>       size_t                  discard_size;
>> @@ -260,27 +284,6 @@ struct mx2_camera_dev {
>>       struct vb2_alloc_ctx    *alloc_ctx;
>>  };
>>
>> -enum mx2_buffer_state {
>> -     MX2_STATE_NEEDS_INIT = 0,
>> -     MX2_STATE_PREPARED   = 1,
>> -     MX2_STATE_QUEUED     = 2,
>> -     MX2_STATE_ACTIVE     = 3,
>> -     MX2_STATE_DONE       = 4,
>> -     MX2_STATE_ERROR      = 5,
>> -     MX2_STATE_IDLE       = 6,
>> -};
>> -
>> -/* buffer for one video frame */
>> -struct mx2_buffer {
>> -     /* common v4l buffer stuff -- must be first */
>> -     struct vb2_buffer               vb;
>> -     struct list_head                queue;
>> -     enum mx2_buffer_state           state;
>> -     enum v4l2_mbus_pixelcode        code;
>> -
>> -     int bufnum;
>> -};
>> -
>>  static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
>>       /*
>>        * This is a generic configuration which is valid for most
>> @@ -334,6 +337,29 @@ static struct mx2_fmt_cfg *mx27_emma_prp_get_format(
>>       return &mx27_emma_prp_table[0];
>>  };
>>
>> +static void mx27_update_emma_buf(struct mx2_camera_dev *pcdev,
>> +                              unsigned long phys, int bufnum)
>> +{
>> +     u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
>
> Are only 1-byte-per-pixel formats supported? Ok, it is only used for
> YUV420, please, move this variable down in that "if".
>> +     struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>> +
>> +     if (prp->cfg.channel == 1) {
>> +             writel(phys, pcdev->base_emma +
>> +                             PRP_DEST_RGB1_PTR + 4 * bufnum);
>> +     } else {
>> +             writel(phys, pcdev->base_emma +
>> +                                     PRP_DEST_Y_PTR -
>> +                                     0x14 * bufnum);
>
> Join the above two lines, please.
>
>> +             if (prp->out_fmt == V4L2_PIX_FMT_YUV420) {
>> +                     writel(phys + imgsize,
>> +                     pcdev->base_emma + PRP_DEST_CB_PTR -
>> +                     0x14 * bufnum);
>> +                     writel(phys + ((5 * imgsize) / 4), pcdev->base_emma +
>> +                     PRP_DEST_CR_PTR - 0x14 * bufnum);
>> +             }
>> +     }
>> +}
>> +
>>  static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
>>  {
>>       unsigned long flags;
>> @@ -382,7 +408,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>>       writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
>>
>>       pcdev->icd = icd;
>> -     pcdev->frame_count = -1;
>> +     pcdev->frame_count = 0;
>>
>>       dev_info(icd->parent, "Camera driver attached to camera %d\n",
>>                icd->devnum);
>> @@ -648,10 +674,9 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
>>        * types.
>>        */
>>       spin_lock_irqsave(&pcdev->lock, flags);
>> -     if (buf->state == MX2_STATE_QUEUED || buf->state == MX2_STATE_ACTIVE) {
>> -             list_del_init(&buf->queue);
>> -             buf->state = MX2_STATE_NEEDS_INIT;
>> -     } else if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
>> +     INIT_LIST_HEAD(&buf->queue);
>
> Wouldn't this leave the list, on which this buffer is, corrupted?

By the time this is called, the queues have already been initialized
(stream_stop).

>> +     buf->state = MX2_STATE_NEEDS_INIT;
>> +     if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
>>               if (pcdev->fb1_active == buf) {
>>                       pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
>>                       writel(0, pcdev->base_csi + CSIDMASA_FB1);
>> @@ -674,7 +699,10 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
>>               to_soc_camera_host(icd->parent);
>>       struct mx2_camera_dev *pcdev = ici->priv;
>>       struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>> +     struct vb2_buffer *vb;
>> +     struct mx2_buffer *buf;
>>       unsigned long flags;
>> +     unsigned long phys;
>>       int ret = 0;
>>
>>       spin_lock_irqsave(&pcdev->lock, flags);
>> @@ -684,6 +712,26 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
>>                       goto err;
>>               }
>>
>> +             buf = list_entry(pcdev->capture.next,
>> +                              struct mx2_buffer, queue);
>> +             buf->bufnum = 0;
>> +             vb = &buf->vb;
>> +             buf->state = MX2_STATE_ACTIVE;
>> +
>> +             phys = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +             mx27_update_emma_buf(pcdev, phys, buf->bufnum);
>> +             list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
>> +
>> +             buf = list_entry(pcdev->capture.next,
>> +                              struct mx2_buffer, queue);
>> +             buf->bufnum = 1;
>> +             vb = &buf->vb;
>> +             buf->state = MX2_STATE_ACTIVE;
>> +
>> +             phys = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +             mx27_update_emma_buf(pcdev, phys, buf->bufnum);
>> +             list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
>> +
>>               if (prp->cfg.channel == 1) {
>>                       writel(PRP_CNTL_CH1EN |
>>                               PRP_CNTL_CSIEN |
>> @@ -731,6 +779,9 @@ static int mx2_stop_streaming(struct vb2_queue *q)
>>                       writel(cntl & ~PRP_CNTL_CH2EN,
>>                              pcdev->base_emma + PRP_CNTL);
>>               }
>> +             INIT_LIST_HEAD(&pcdev->capture);
>> +             INIT_LIST_HEAD(&pcdev->active_bufs);
>> +             INIT_LIST_HEAD(&pcdev->discard);
>>       }
>>       spin_unlock_irqrestore(&pcdev->lock, flags);
>>
>> @@ -793,50 +844,21 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
>>               to_soc_camera_host(icd->parent);
>>       struct mx2_camera_dev *pcdev = ici->priv;
>>       struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>> -     u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
>>
>> +     writel((icd->user_width << 16) | icd->user_height,
>> +            pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>> +     writel(prp->cfg.src_pixel,
>> +            pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
>>       if (prp->cfg.channel == 1) {
>> -             writel(pcdev->discard_buffer_dma,
>> -                             pcdev->base_emma + PRP_DEST_RGB1_PTR);
>> -             writel(pcdev->discard_buffer_dma,
>> -                             pcdev->base_emma + PRP_DEST_RGB2_PTR);
>> -
>> -             writel((icd->user_width << 16) | icd->user_height,
>> -                     pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>>               writel((icd->user_width << 16) | icd->user_height,
>>                       pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
>>               writel(bytesperline,
>>                       pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
>> -             writel(prp->cfg.src_pixel,
>> -                     pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
>>               writel(prp->cfg.ch1_pixel,
>>                       pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
>>       } else { /* channel 2 */
>> -             writel(pcdev->discard_buffer_dma,
>> -                     pcdev->base_emma + PRP_DEST_Y_PTR);
>> -             writel(pcdev->discard_buffer_dma,
>> -                     pcdev->base_emma + PRP_SOURCE_Y_PTR);
>> -
>> -             if (prp->cfg.out_fmt == PRP_CNTL_CH2_OUT_YUV420) {
>> -                     writel(pcdev->discard_buffer_dma + imgsize,
>> -                             pcdev->base_emma + PRP_DEST_CB_PTR);
>> -                     writel(pcdev->discard_buffer_dma + ((5 * imgsize) / 4),
>> -                             pcdev->base_emma + PRP_DEST_CR_PTR);
>> -                     writel(pcdev->discard_buffer_dma + imgsize,
>> -                             pcdev->base_emma + PRP_SOURCE_CB_PTR);
>> -                     writel(pcdev->discard_buffer_dma + ((5 * imgsize) / 4),
>> -                             pcdev->base_emma + PRP_SOURCE_CR_PTR);
>> -             }
>> -
>> -             writel((icd->user_width << 16) | icd->user_height,
>> -                     pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>> -
>>               writel((icd->user_width << 16) | icd->user_height,
>>                       pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
>> -
>> -             writel(prp->cfg.src_pixel,
>> -                     pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
>> -
>>       }
>>
>>       /* Enable interrupts */
>> @@ -927,11 +949,22 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
>>               if (ret)
>>                       return ret;
>>
>> -             if (pcdev->discard_buffer)
>> +             if (pcdev->discard_buffer) {
>>                       dma_free_coherent(ici->v4l2_dev.dev,
>>                               pcdev->discard_size, pcdev->discard_buffer,
>>                               pcdev->discard_buffer_dma);
>>
>> +                     pcdev->buf_discard[0].discard = true;
>> +                     INIT_LIST_HEAD(&pcdev->buf_discard[0].queue);
>> +                     list_add_tail(&pcdev->buf_discard[0].queue,
>> +                                   &pcdev->discard);
>> +
>> +                     pcdev->buf_discard[1].discard = true;
>> +                     INIT_LIST_HEAD(&pcdev->buf_discard[1].queue);
>> +                     list_add_tail(&pcdev->buf_discard[1].queue,
>> +                                   &pcdev->discard);
>> +             }
>> +
>
> So, you want to do this every time someone does S_FMT?...

Not really, good you noticed, let me fix it for v2.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
