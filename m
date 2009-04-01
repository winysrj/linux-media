Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41896 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZDAEfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 00:35:17 -0400
From: "Subrahmanya, Chaithrika" <chaithrika@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 1 Apr 2009 10:02:15 +0530
Subject: RE: [PATCH 3/4] ARM: DaVinci: DM646x Video: Add VPIF display driver
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02A8764C45@dbde02.ent.ti.com>
References: <1238073752-9930-1-git-send-email-chaithrika@ti.com>,<200903301552.07252.hverkuil@xs4all.nl>
In-Reply-To: <200903301552.07252.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Thursday 26 March 2009 14:22:32 Chaithrika U S wrote:
> > Display driver for VPIF
> >
> > Adds the VPIF display driver and the associated header file.
> > The patch includes the review comments on the RFC sent earlier.
> > The major updates are:
> >         - change in the name of the file.
> >         - moved the platform related data to the platform specific
> files.
> >         - changed the subdev calls to subdev_call_until_err
> >
> > Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> > ---
> > Applies to v4l-dvb repository
> >
> >  drivers/media/video/davinci/vpif_display.c | 1702
> ++++++++++++++++++++++++++++
> >  drivers/media/video/davinci/vpif_display.h |  204 ++++
> >  2 files changed, 1906 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/davinci/vpif_display.c
> >  create mode 100644 drivers/media/video/davinci/vpif_display.h
> >
> > diff --git a/drivers/media/video/davinci/vpif_display.c
> b/drivers/media/video/davinci/vpif_display.c
> > new file mode 100644
> > index 0000000..582c2b1
> > --- /dev/null
> > +++ b/drivers/media/video/davinci/vpif_display.c
> > @@ -0,0 +1,1702 @@
> > +/*
> > + * vpif-display - VPIF display driver
> > + * Display driver for TI DaVinci VPIF
> > + *
> > + * Copyright (C) 2009 Texas Instruments Incorporated -
> http://www.ti.com/
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation version 2.
> > + *
> > + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> > + * kind, whether express or implied; without even the implied
> warranty
> > + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/errno.h>
> > +#include <linux/fs.h>
> > +#include <linux/mm.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/string.h>
> > +#include <linux/videodev2.h>
> > +#include <linux/wait.h>
> > +#include <linux/time.h>
> > +#include <linux/i2c.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/io.h>
> > +#include <linux/version.h>
> > +
> > +#include <asm/irq.h>
> > +#include <asm/page.h>
> > +
> > +#include <media/adv7343.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +
> > +#include <mach/dm646x.h>
> > +
> > +#include "vpif_display.h"
> > +#include "vpif.h"
> > +
> > +MODULE_DESCRIPTION("TI DaVinci VPIF Display driver");
> > +MODULE_LICENSE("GPL");
> > +
> > +#define DM646X_V4L2_STD (V4L2_STD_PAL | V4L2_STD_NTSC)
> > +
> > +static int debug;
> > +static u32 ch2_numbuffers = 3;
> > +static u32 ch3_numbuffers = 3;
> > +static u32 ch2_bufsize = 1920 * 1080 * 2;
> > +static u32 ch3_bufsize = 720 * 576 * 2;
> > +
> > +module_param(debug, int, 0644);
> > +module_param(ch2_numbuffers, uint, S_IRUGO);
> > +module_param(ch3_numbuffers, uint, S_IRUGO);
> > +module_param(ch2_bufsize, uint, S_IRUGO);
> > +module_param(ch3_bufsize, uint, S_IRUGO);
> > +
> > +MODULE_PARM_DESC(debug, "Debug level 0-1");
> > +MODULE_PARM_DESC(ch2_numbuffers, "Channel2 buffer count
> (default:3)");
> > +MODULE_PARM_DESC(ch3_numbuffers, "Channel3 buffer count
> (default:3)");
> > +MODULE_PARM_DESC(ch2_bufsize, "Channel2 buffer size (default:1920 x
> 1080 x 2)");
> > +MODULE_PARM_DESC(ch3_bufsize, "Channel3 buffer size (default:720 x
> 576 x 2)");
> > +
> > +static struct vpif_config_params config_params = {
> > +     .min_numbuffers         = 3,
> > +     .numbuffers[0]          = 3,
> > +     .numbuffers[1]          = 3,
> > +     .min_bufsize[0]         = 720 * 480 * 2,
> > +     .min_bufsize[1]         = 720 * 480 * 2,
> > +     .channel_bufsize[0]     = 1920 * 1080 * 2,
> > +     .channel_bufsize[1]     = 720 * 576 * 2,
> > +};
> > +
> > +static int vpif_nr[] = {2, 3,};
> > +static struct vpif_device vpif_obj = { {NULL} };
> > +static struct device *vpif_dev;
> > +
> > +static struct v4l2_capability vpif_videocap = {
> > +     .driver         = "vpif display",
> > +     .bus_info       = "Platform",
> > +     .version        = VPIF_DISPLAY_VERSION_CODE,
> > +     .capabilities   = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING,
> > +};
>
> Why not set it directly in the querycap function? That way everything
> is
> in one place.
>
Agree, it can be set directly in querycap.

> > +
> > +/*
> > + * vpif_uservirt_to_phys: This inline function is used to convert
> user
> > + * space virtual address to physical address.
> > + */
> > +static inline u32 vpif_uservirt_to_phys(u32 virtp)
>
> inline for such a large function?
>
> > +{
> > +     struct mm_struct *mm = current->mm;
> > +     unsigned long physp = 0;
> > +     struct vm_area_struct *vma;
> > +
> > +     vma = find_vma(mm, virtp);
> > +
> > +     /* For kernel direct-mapped memory, take the easy way */
> > +     if (virtp >= PAGE_OFFSET) {
> > +             physp = virt_to_phys((void *)virtp);
> > +     } else if (vma && (vma->vm_flags & VM_IO) && (vma->vm_pgoff)) {
> > +             /* this will catch, kernel-allocated, mmaped-to-
> usermode addr */
> > +             physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma-
> >vm_start);
> > +     } else {
> > +             /* otherwise, use get_user_pages() for general userland
> pages */
> > +             int res, nr_pages = 1;
> > +             struct page *pages;
> > +             down_read(&current->mm->mmap_sem);
> > +
> > +             res = get_user_pages(current, current->mm,
> > +                                  virtp, nr_pages, 1, 0, &pages,
> NULL);
> > +             up_read(&current->mm->mmap_sem);
> > +
> > +             if (res == nr_pages) {
> > +                     physp = __pa(page_address(&pages[0]) +
> > +                                                     (virtp &
> ~PAGE_MASK));
> > +             } else {
> > +                     v4l2_err(&vpif_obj.v4l2_dev, "get_user_pages
> failed\n");
> > +                     return 0;
> > +             }
> > +     }
> > +
> > +     return physp;
> > +}
> > +
> > +/*
> > + * buffer_prepare: This is the callback function called from
> videobuf_qbuf()
> > + * function the buffer is prepared and user space virtual address is
> converted
> > + * into physical address
> > + */
> > +static int vpif_buffer_prepare(struct videobuf_queue *q,
> > +                            struct videobuf_buffer *vb,
> > +                            enum v4l2_field field)
> > +{
> > +     struct vpif_fh *fh = q->priv_data;
> > +     struct common_obj *common;
> > +     unsigned long addr;
> > +
> > +     common = &(fh->channel->common[VPIF_VIDEO_INDEX]);
>
> No need for parenthesis here. It can be removed elsewhere as well as
> this
> is not the only place where it is done. I know, it's nitpicking.
>
I will take care of this.

> > +     if (VIDEOBUF_NEEDS_INIT == vb->state) {
> > +             vb->width       = common->width;
> > +             vb->height      = common->height;
> > +             vb->size        = vb->width * vb->height;
> > +             vb->field       = field;
> > +     }
> > +     vb->state = VIDEOBUF_PREPARED;
> > +
> > +     /* if user pointer memory mechanism is used, get the physical
> > +      * address of the buffer */
> > +     if (V4L2_MEMORY_USERPTR == common->memory) {
> > +             if (!vb->baddr) {
> > +                     v4l2_err(&vpif_obj.v4l2_dev, "buffer_address is
> 0\n");
> > +                     return -EINVAL;
> > +             }
> > +
> > +             vb->boff = vpif_uservirt_to_phys(vb->baddr);
> > +             if (!ISALIGNED(vb->boff))
> > +                     goto buf_align_exit;
> > +     }
> > +
> > +     addr = vb->boff;
> > +     if (q->streaming && (V4L2_BUF_TYPE_SLICED_VBI_OUTPUT != q-
> >type)) {
> > +             if (!ISALIGNED((addr + common->ytop_off)) ||
>
> Ditto here. See also my comment at the definition of this macro.
>
> > +                 !ISALIGNED((addr + common->ybtm_off)) ||
> > +                 !ISALIGNED((addr + common->ctop_off)) ||
> > +                 !ISALIGNED((addr + common->cbtm_off)))
> > +                     goto buf_align_exit;
> > +     }
> > +     return 0;
> > +
> > +buf_align_exit:
> > +     v4l2_err(&vpif_obj.v4l2_dev, "buffer offset not aligned to 8
> bytes\n");
> > +     return -EINVAL;
> > +}
> > +
> > +/*
> > + * vpif_buffer_setup: This function allocates memory for the buffers
> > + */
> > +static int vpif_buffer_setup(struct videobuf_queue *q, unsigned int
> *count,
> > +                             unsigned int *size)
> > +{
> > +     struct vpif_fh *fh = q->priv_data;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     if (V4L2_MEMORY_MMAP != common->memory)
> > +             return 0;
> > +
> > +     *size = config_params.channel_bufsize[channel->channel_id];
> > +     if (*count < config_params.min_numbuffers)
> > +             *count = config_params.min_numbuffers;
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * vpif_buffer_queue: This function adds the buffer to DMA queue
> > + */
> > +static void vpif_buffer_queue(struct videobuf_queue *q,
> > +                           struct videobuf_buffer *vb)
> > +{
> > +     struct vpif_fh *fh = q->priv_data;
> > +     struct common_obj *common;
> > +
> > +     common = &(fh->channel->common[VPIF_VIDEO_INDEX]);
> > +
> > +     /* add the buffer to the DMA queue */
> > +     list_add_tail(&vb->queue, &common->dma_queue);
> > +     vb->state = VIDEOBUF_QUEUED;
> > +}
> > +
> > +/*
> > + * vpif_buffer_release: This function is called from the videobuf
> layer to
> > + * free memory allocated to the buffers
> > + */
> > +static void vpif_buffer_release(struct videobuf_queue *q,
> > +                             struct videobuf_buffer *vb)
> > +{
> > +     struct vpif_fh *fh = q->priv_data;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common;
> > +     unsigned int buf_size = 0;
> > +
> > +     common = &(channel->common[VPIF_VIDEO_INDEX]);
> > +
> > +     videobuf_dma_contig_free(q, vb);
> > +     vb->state = VIDEOBUF_NEEDS_INIT;
> > +
> > +     if (V4L2_MEMORY_MMAP != common->memory)
> > +             return;
> > +
> > +     buf_size = config_params.channel_bufsize[channel->channel_id];
> > +
>
> Empty line?
>
> > +}
> > +
> > +static struct videobuf_queue_ops video_qops = {
> > +     .buf_setup      = vpif_buffer_setup,
> > +     .buf_prepare    = vpif_buffer_prepare,
> > +     .buf_queue      = vpif_buffer_queue,
> > +     .buf_release    = vpif_buffer_release,
> > +};
> > +static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
> > +
> > +/*
> > + * vpif_channel_isr: It changes status of the displayed buffer,
> takes next
> > + * buffer from the queue and sets its address in VPIF registers
> > + */
> > +static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
> > +{
> > +     struct vpif_device *dev = &vpif_obj;
> > +     struct channel_obj *channel;
> > +     struct common_obj *common;
> > +     struct video_obj *vid_ch;
> > +     struct timeval timevalue;
> > +     unsigned long addr = 0;
> > +     enum v4l2_field field;
> > +     int fid = -1, i;
> > +     int channel_id = 0;
> > +
> > +     channel_id = *(int *)(dev_id);
> > +     channel = dev->dev[channel_id];
> > +     vid_ch = &(channel->video);
> > +
> > +     do_gettimeofday(&timevalue);
> > +     field = channel->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
> > +     for (i = 0; i < VPIF_NUMOBJECTS; i++) {
> > +             common = &(channel->common[i]);
> > +             /* If streaming is started in this channel */
> > +             if (0 == common->started)
> > +                     continue;
> > +             if (1 == vid_ch->std_info.frame_format) {
>
> General note: wouldn't it be better to turn this part of the 'if'
> and the 'else' below into two separate functions called from here?
> It's a pretty big function right now.
>
OK.

> > +                     if (list_empty(&common->dma_queue))
> > +                             continue;
> > +
> > +                     /* Progressive mode */
> > +                     if (!channel_first_int[i][channel_id]) {
> > +                             /* Mark status of the curFrm to
> > +                              * done and unlock semaphore on it */
> > +                             common->curFrm->ts = timevalue;
> > +                             common->curFrm->state = VIDEOBUF_DONE;
> > +                             wake_up_interruptible(&common->curFrm-
> >done);
> > +                             /* Make curFrm pointing to nextFrm */
> > +                             common->curFrm = common->nextFrm;
> > +
> > +                     }
> > +                     channel_first_int[i][channel_id] = 0;
> > +
> > +                     /* Get the next buffer from buffer queue */
> > +                     common->nextFrm = list_entry(common-
> >dma_queue.next,
> > +                                             struct videobuf_buffer,
> queue);
>
> Please fix this camelCase! It's really distracting... It should be
> next_frm
> and cur_frm.
>
> > +                     /* Remove that buffer from the buffer queue */
> > +                     list_del(&common->nextFrm->queue);
> > +                     /* Mark status of the buffer as active */
> > +                     common->nextFrm->state = VIDEOBUF_ACTIVE;
> > +                     /* Set top and bottom field addrs in VPIF
> registers */
> > +
> > +                     addr = videobuf_to_dma_contig(common->nextFrm);
> > +                     common->set_addr(addr + common->ytop_off,
> > +                                      addr + common->ybtm_off,
> > +                                      addr + common->ctop_off,
> > +                                      addr + common->cbtm_off);
> > +             } else {
> > +                     /* Interlaced mode */
> > +                     /* If it is first interrupt, ignore it */
> > +
> > +                     if (channel_first_int[i][channel_id]) {
> > +                             channel_first_int[i][channel_id] = 0;
> > +                             continue;
> > +                     }
> > +                     if (0 == i) {
> > +                             channel->field_id ^= 1;
> > +                             /* Get field id from VPIF registers */
> > +                             fid = vpif_channel_getfid(channel->
> > +                                                     channel_id +
> 2);
> > +                             /* If fid does not match with stored
> field id */
> > +                             if (fid != channel->field_id) {
> > +                                     /* Make them in sync */
> > +                                     if (0 == fid)
> > +                                             channel->field_id =
> fid;
> > +
> > +                                     return IRQ_HANDLED;
> > +                             }
> > +                     }
> > +                     /* device field id and local field id are in
> sync */
> > +                     /* If this is even field */
> > +                     if (0 == fid) {
> > +                             if (common->curFrm == common->nextFrm)
> > +                                     continue;
> > +
> > +                             /* one frame is displayed If next frame
> is
> > +                              *  available, release curFrm and move
> on */
> > +
> > +                             /* Copy frame display time */
> > +                             common->curFrm->ts = timevalue;
> > +                             /* Change status of the curFrm */
> > +                             common->curFrm->state = VIDEOBUF_DONE;
> > +                             /* unlock semaphore on curFrm */
> > +                             wake_up_interruptible(&common->curFrm-
> >done);
> > +                             /* Make curFrm pointing to nextFrm */
> > +                             common->curFrm = common->nextFrm;
> > +
> > +                     } else if (1 == fid) {  /* odd field */
> > +                             if (list_empty(&common->dma_queue)
> > +                                 || (common->curFrm != common-
> >nextFrm)) {
> > +                                     continue;
> > +                             }
> > +
> > +                             /* one field is displayed configure the
> next
> > +                                frame if it is available else hold
> on current
> > +                                frame */
> > +                             /* Get next from the buffer queue */
> > +                             common->nextFrm = list_entry(common-
> >dma_queue.
> > +                                                     next,
> > +                                                     struct
> videobuf_buffer,
> > +                                                     queue);
> > +
> > +                             /* Remove that from the buffer queue */
> > +                             list_del(&common->nextFrm->queue);
> > +
> > +                             /* Mark state of the frame to active */
> > +                             common->nextFrm->state =
> VIDEOBUF_ACTIVE;
> > +                             addr = videobuf_to_dma_contig(common-
> >nextFrm);
> > +                             common->set_addr(addr + common-
> >ytop_off,
> > +                                              addr + common-
> >ybtm_off,
> > +                                              addr + common-
> >ctop_off,
> > +                                              addr + common-
> >cbtm_off);
> > +
> > +                     }
> > +             }
> > +     }
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static void vpif_get_std_info(struct channel_obj *ch)
> > +{
> > +     struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
> > +     struct video_obj *vid_ch = &(ch->video);
> > +     int ret;
> > +
> > +     vid_ch->std_info.channel_id = ch->channel_id + 2;
> > +
> > +     vid_ch->std_info.stdid = vid_ch->stdid;
> > +
> > +     /* Get standard information from VPIF layer */
> > +     ret = vpif_get_mode_info(&vid_ch->std_info);
> > +     common->fmt.fmt.pix.width = vid_ch->std_info.activepixels;
> > +     common->fmt.fmt.pix.height = vid_ch->std_info.activelines;
> > +
> > +     v4l2_dbg(1, debug, &vpif_obj.v4l2_dev,
> > +                     "Pixel details: Width = %d,Height = %d\n",
> > +                     common->fmt.fmt.pix.width, common-
> >fmt.fmt.pix.height);
> > +
> > +     /* Set height and width paramateres */
> > +     ch->common[VPIF_VIDEO_INDEX].height = vid_ch-
> >std_info.activelines;
> > +     ch->common[VPIF_VIDEO_INDEX].width = vid_ch-
> >std_info.activepixels;
> > +}
> > +
> > +/*
> > + * vpif_calculate_offsets: This function calculates buffers offset
> for Y and C
> > + * in the top and bottom field
> > + */
> > +static void vpif_calculate_offsets(struct channel_obj *channel)
> > +{
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     struct vpif_params *vpifparams = &channel->vpifparams;
> > +     enum v4l2_field field = common->fmt.fmt.pix.field;
> > +     struct video_obj *vid_ch = &(channel->video);
> > +     unsigned int hpitch, vpitch, sizeimage;
> > +
> > +     if (V4L2_FIELD_ANY == common->fmt.fmt.pix.field) {
> > +             if (vid_ch->std_info.frame_format)
> > +                     vid_ch->buf_field = V4L2_FIELD_NONE;
> > +             else
> > +                     vid_ch->buf_field = V4L2_FIELD_INTERLACED;
> > +     } else {
> > +             vid_ch->buf_field = common->fmt.fmt.pix.field;
> > +     }
> > +
> > +     if (V4L2_MEMORY_USERPTR == common->memory)
> > +             sizeimage = common->fmt.fmt.pix.sizeimage;
> > +     else
> > +             sizeimage = config_params.channel_bufsize[channel-
> >channel_id];
> > +
> > +     hpitch = common->fmt.fmt.pix.bytesperline;
> > +     vpitch = sizeimage / (hpitch * 2);
> > +
> > +     if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
> > +         (V4L2_FIELD_INTERLACED == vid_ch->buf_field)) {
> > +             common->ytop_off = 0;
> > +             common->ybtm_off = hpitch;
> > +             common->ctop_off = sizeimage / 2;
> > +             common->cbtm_off = sizeimage / 2 + hpitch;
> > +     } else if (V4L2_FIELD_SEQ_TB == vid_ch->buf_field) {
> > +             common->ytop_off = 0;
> > +             common->ybtm_off = sizeimage / 4;
> > +             common->ctop_off = sizeimage / 2;
> > +             common->cbtm_off = common->ctop_off + sizeimage / 4;
> > +     } else if (V4L2_FIELD_SEQ_BT == vid_ch->buf_field) {
> > +             common->ybtm_off = 0;
> > +             common->ytop_off = sizeimage / 4;
> > +             common->cbtm_off = sizeimage / 2;
> > +             common->ctop_off = common->cbtm_off + sizeimage / 4;
> > +     }
> > +
> > +     if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
> > +         (V4L2_FIELD_INTERLACED == vid_ch->buf_field)) {
> > +             vpifparams->video_params.storage_mode = 1;
> > +     } else {
> > +             vpifparams->video_params.storage_mode = 0;
> > +     }
> > +
> > +     if (vid_ch->std_info.frame_format == 1) {
> > +             vpifparams->video_params.hpitch =
> > +                 common->fmt.fmt.pix.bytesperline;
> > +     } else {
> > +             if ((field == V4L2_FIELD_ANY) ||
> > +                     (field == V4L2_FIELD_INTERLACED))
> > +                     vpifparams->video_params.hpitch =
> > +                         common->fmt.fmt.pix.bytesperline * 2;
> > +             else
> > +                     vpifparams->video_params.hpitch =
> > +                         common->fmt.fmt.pix.bytesperline;
> > +     }
> > +
> > +     channel->vpifparams.video_params.stdid = vid_ch-
> >std_info.stdid;
> > +}
> > +
> > +
> > +static void vpif_config_format(struct channel_obj *channel)
> > +{
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
> > +     if (config_params.numbuffers[channel->channel_id] == 0)
> > +             common->memory = V4L2_MEMORY_USERPTR;
> > +     else
> > +             common->memory = V4L2_MEMORY_MMAP;
> > +
> > +     common->fmt.fmt.pix.sizeimage =
> > +                     config_params.channel_bufsize[channel-
> >channel_id];
> > +     common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
> > +     common->fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> > +}
> > +
> > +static int vpif_check_format(struct channel_obj *channel,
> > +                          struct v4l2_pix_format *pixfmt)
> > +{
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     struct video_obj *vid_ch = &(channel->video);
> > +     enum v4l2_field field = pixfmt->field;
> > +     u32 sizeimage, hpitch, vpitch;
> > +
> > +     if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
> > +             goto invalid_fmt_exit;
> > +
> > +     if (!(VPIF_VALID_FIELD(field)))
> > +             goto invalid_fmt_exit;
> > +
> > +     if (pixfmt->bytesperline <= 0)
> > +             goto invalid_pitch_exit;
> > +
> > +     if (V4L2_MEMORY_USERPTR == common->memory)
> > +             sizeimage = pixfmt->sizeimage;
> > +     else
> > +             sizeimage = config_params.channel_bufsize[channel-
> >channel_id];
> > +
> > +     vpif_get_std_info(channel);
> > +
> > +     hpitch = pixfmt->bytesperline;
> > +     vpitch = sizeimage / (hpitch * 2);
> > +
> > +     /* Check for valid value of pitch */
> > +     if ((hpitch < vid_ch->std_info.activepixels) ||
> > +         (vpitch < vid_ch->std_info.activelines))
> > +             goto invalid_pitch_exit;
> > +
> > +     /* Check for 8 byte alignment */
> > +     if (!(ISALIGNED(hpitch))) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "invalid pitch
> alignment\n");
> > +             return -EINVAL;
> > +     }
> > +     pixfmt->width = common->fmt.fmt.pix.width;
> > +     pixfmt->height = common->fmt.fmt.pix.height;
> > +
> > +     return 0;
> > +
> > +invalid_fmt_exit:
> > +     v4l2_err(&vpif_obj.v4l2_dev, "invalid field format\n");
> > +     return -EINVAL;
> > +
> > +invalid_pitch_exit:
> > +     v4l2_err(&vpif_obj.v4l2_dev, "invalid pitch\n");
> > +     return -EINVAL;
> > +}
> > +
> > +static void vpif_config_addr(struct channel_obj *channel, int
> muxmode)
> > +{
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     if (VPIF_CHANNEL3_VIDEO == channel->channel_id) {
> > +             common->set_addr = ch3_set_videobuf_addr;
> > +     } else {
> > +             if (2 == muxmode)
> > +                     common->set_addr =
> ch2_set_videobuf_addr_yc_nmux;
> > +             else
> > +                     common->set_addr = ch2_set_videobuf_addr;
> > +     }
> > +}
> > +
> > +/*
> > + * vpif_mmap: It is used to map kernel space buffers into user
> spaces
> > + */
> > +static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
> > +{
> > +     struct vpif_fh *fh = filep->private_data;
> > +     struct common_obj *common = &(fh->channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     int err = 0;
> > +
> > +     err = videobuf_mmap_mapper(&common->buffer_queue, vma);
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * vpif_poll: It is used for select/poll system call
> > + */
> > +static unsigned int vpif_poll(struct file *filep, poll_table *wait)
> > +{
> > +     struct vpif_fh *fh = filep->private_data;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     int err = 0;
> > +
> > +     if (common->started)
> > +             err = videobuf_poll_stream(filep, &common-
> >buffer_queue, wait);
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * vpif_open: It creates object of file handle structure and stores
> it in
> > + * private_data member of filepointer
> > + */
> > +static int vpif_open(struct file *filep)
> > +{
> > +     struct video_device *vdev = video_devdata(filep);
> > +     struct channel_obj *channel = NULL;
> > +     struct vpif_fh *fh = NULL;
> > +     int err = 0;
> > +
> > +     channel = video_get_drvdata(vdev);
> > +
> > +     /* Allocate memory for the file handle object */
> > +     fh = kmalloc(sizeof(struct vpif_fh), GFP_KERNEL);
> > +     if (fh == NULL) {
> > +             v4l2_err(&vpif_obj.v4l2_dev,
> > +                     "unable to allocate memory for file handle
> object\n");
> > +             return -ENOMEM;
> > +     }
> > +
> > +     /* store pointer to fh in private_data member of filep */
> > +     filep->private_data = fh;
> > +     fh->channel = channel;
> > +     fh->initialized = 0;
> > +
> > +     if (!channel->initialized) {
> > +             fh->initialized = 1;
> > +             channel->initialized = 1;
> > +             memset(&(channel->vpifparams), 0, sizeof(channel-
> >vpifparams));
> > +     }
> > +
> > +     if (err < 0) {
> > +             if (fh->initialized)
> > +                     channel->initialized = 0;
> > +
> > +             filep->private_data = NULL;
> > +             fh->initialized = 0;
> > +             /* Free memory allocated to file handle object */
> > +             if (fh != NULL)
> > +                     kfree(fh);
> > +             return err;
> > +     }
> > +     /* Increment channel usrs counter */
> > +     channel->usrs++;
> > +
> > +     /* Set io_allowed[VPIF_VIDEO_INDEX] member to false */
> > +     fh->io_allowed[VPIF_VIDEO_INDEX] = 0;
> > +
> > +     /* Initialize priority of this instance to default priority */
> > +     fh->prio = V4L2_PRIORITY_UNSET;
> > +
> > +     v4l2_prio_open(&channel->prio, &fh->prio);
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * vpif_release: This function deletes buffer queue, frees the
> buffers and
> > + * the vpif file handle
> > + */
> > +static int vpif_release(struct file *filep)
> > +{
> > +     struct vpif_fh *fh = filep->private_data;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     down_interruptible(&common->lock);
> > +
> > +     /* if this instance is doing IO */
> > +     if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
> > +             /* Reset io_usrs member of channel object */
> > +             common->io_usrs = 0;
> > +             /* Disable channel */
> > +             if (VPIF_CHANNEL2_VIDEO == channel->channel_id) {
> > +                     enable_channel2(0);
> > +                     channel2_intr_enable(0);
> > +             }
> > +             if ((VPIF_CHANNEL3_VIDEO == channel->channel_id) ||
> > +                 (2 == common->started)) {
> > +                     enable_channel3(0);
> > +                     channel3_intr_enable(0);
> > +             }
> > +             common->started = 0;
> > +             /* Free buffers allocated */
> > +             videobuf_queue_cancel(&common->buffer_queue);
> > +             videobuf_mmap_free(&common->buffer_queue);
> > +             common->numbuffers =
> > +                 config_params.numbuffers[channel->channel_id];
> > +
> > +     }
> > +
> > +     up(&common->lock);
> > +
> > +     /* Decrement channel usrs counter */
> > +     channel->usrs--;
> > +     /* If this file handle has initialize encoder device, reset it
> */
> > +     if (fh->initialized)
> > +             channel->initialized = 0;
> > +
> > +     /* Close the priority */
> > +     v4l2_prio_close(&channel->prio, &fh->prio);
> > +     filep->private_data = NULL;
> > +     fh->initialized = 0;
> > +
> > +     if (fh != NULL)
> > +             kfree(fh);
> > +
> > +     return 0;
> > +}
> > +
> > +/* functions implementing ioctls */
> > +
> > +static int vpif_querycap(struct file *file, void  *priv,
> > +                             struct v4l2_capability *cap)
> > +{
> > +     struct vpif_config *config = vpif_dev->platform_data;
> > +
> > +     memset(cap, 0, sizeof(*cap));
> > +     *cap = vpif_videocap;
>
> No need for the memset.
OK.

>
> > +     strlcpy(cap->card, config->card_name, sizeof(cap->card));
> > +
> > +     return 0;
> > +}
> > +
> > +static int vpif_enum_fmt_vid_out(struct file *file, void  *priv,
> > +                                     struct v4l2_fmtdesc *fmt)
> > +{
> > +     unsigned int index = 0;
> > +
> > +     if (fmt->index != 0) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "Invalid format index\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* Fill in the information about format */
> > +     index = fmt->index;
> > +     memset(fmt, 0, sizeof(*fmt));
>
> For most if not all of these functions v4l2_ioctl2 will take care of
> zeroing
> the structs.
>
> > +     fmt->index = index;
> > +     fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> > +     strcpy(fmt->description, "YCbCr4:2:2 YC Planar");
> > +     fmt->pixelformat = V4L2_PIX_FMT_YUV422P;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vpif_g_fmt_vid_out(struct file *file, void *priv,
> > +                             struct v4l2_format *fmt)
> > +{
> > +     int ret = 0;
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct video_obj *vid_ch = &(channel->video);
> > +
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     /* Check the validity of the buffer type */
> > +     if (common->fmt.type != fmt->type)
> > +             return -EINVAL;
> > +
> > +     if (V4L2_BUF_TYPE_VIDEO_OUTPUT != fmt->type) {
> > +             if (vid_ch->std_info.vbi_supported == 0)
> > +                     return -EINVAL;
> > +     }
> > +     /* Fill in the information about format */
> > +     down_interruptible(&common->lock);
> > +
> > +     if (ret < 0)
> > +             goto g_fmt_exit;
> > +
> > +     vpif_get_std_info(channel);
> > +     *fmt = common->fmt;
> > +
> > +g_fmt_exit:
> > +     up(&(common->lock));
> > +     return ret;
> > +}
> > +
> > +static int vpif_s_fmt_vid_out(struct file *file, void *priv,
> > +                             struct v4l2_format *fmt)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     struct video_obj *vid_ch = &(channel->video);
> > +     int ret = 0;
> > +
> > +     if ((VPIF_CHANNEL2_VIDEO == channel->channel_id)
> > +         || (VPIF_CHANNEL3_VIDEO == channel->channel_id)) {
> > +             if (!fh->initialized) {
> > +                     v4l2_dbg(1, debug, &vpif_obj.v4l2_dev,
> > +                                                     "Channel
> Busy\n");
> > +                     return -EBUSY;
> > +             }
> > +
> > +             /* Check for the priority */
> > +             ret = v4l2_prio_check(&channel->prio, &fh->prio);
> > +             if (0 != ret)
> > +                     return ret;
> > +             fh->initialized = 1;
> > +     }
> > +
> > +     if (common->started) {
> > +             v4l2_dbg(1, debug, &vpif_obj.v4l2_dev,
> > +                                             "Streaming in
> progress\n");
> > +             return -EBUSY;
> > +     }
> > +
> > +     if (V4L2_BUF_TYPE_VIDEO_OUTPUT == fmt->type) {
> > +             struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> > +             /* Check for valid field format */
> > +             ret = vpif_check_format(channel, pixfmt);
> > +             if (ret)
> > +                     return ret;
> > +             /* store the pix format in the channel object */
> > +             common->fmt.fmt.pix = *pixfmt;
> > +     } else if (vid_ch->std_info.vbi_supported == 0) {
> > +             v4l2_err(&vpif_obj.v4l2_dev,
> > +                                  "standard doesn't support\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     /* store the format in the channel object */
> > +     down_interruptible(&common->lock);
> > +     common->fmt = *fmt;
> > +     up(&common->lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static int vpif_try_fmt_vid_out(struct file *file, void *priv,
> > +                             struct v4l2_format *fmt)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     int ret = -EINVAL;
> > +
> > +     if (V4L2_BUF_TYPE_VIDEO_OUTPUT == fmt->type) {
>
> No need to check this. These functions are never called unless the type
> matches. I noticed it's checked in the s_ and g_ variants as well.
> That's
> not needed.
>
OK.

> > +             struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> > +             ret = vpif_check_format(channel, pixfmt);
> > +             if (ret) {
> > +                     *pixfmt = common->fmt.fmt.pix;
> > +                     pixfmt->sizeimage = pixfmt->width * pixfmt-
> >height * 2;
> > +             }
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int vpif_reqbufs(struct file *file, void *priv,
> > +                     struct v4l2_requestbuffers *reqbuf)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common;
> > +     enum v4l2_field field;
> > +     u8 index = 0;
> > +     int ret = 0;
> > +
> > +     /* This file handle has not initialized the channel,
> > +        It is not allowed to do settings */
> > +     if ((VPIF_CHANNEL2_VIDEO == channel->channel_id)
> > +         || (VPIF_CHANNEL3_VIDEO == channel->channel_id)) {
> > +             if (!fh->initialized) {
> > +                     v4l2_err(&vpif_obj.v4l2_dev,
> > +                                                     "Channel
> Busy\n");
> > +                     return -EBUSY;
> > +             }
> > +     }
> > +
> > +     if ((V4L2_BUF_TYPE_VIDEO_OUTPUT != reqbuf->type))
> > +             return -EINVAL;
> > +
> > +     index = VPIF_VIDEO_INDEX;
> > +
> > +     common = &(channel->common[index]);
> > +     down_interruptible(&common->lock);
> > +
> > +     if (common->fmt.type != reqbuf->type) {
> > +             ret = -EINVAL;
> > +             goto reqbuf_exit;
> > +     }
> > +
> > +     if (0 != common->io_usrs) {
> > +             ret = -EBUSY;
> > +             goto reqbuf_exit;
> > +     }
> > +
> > +     if (reqbuf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +             if (common->fmt.fmt.pix.field == V4L2_FIELD_ANY)
> > +                     field = V4L2_FIELD_INTERLACED;
> > +             else
> > +                     field = common->fmt.fmt.pix.field;
> > +     } else {
> > +             field = V4L2_VBI_INTERLACED;
> > +     }
> > +
> > +     /* Initialize videobuf queue as per the buffer type */
> > +     videobuf_queue_dma_contig_init(&common->buffer_queue,
> > +                                         &video_qops, NULL,
> > +                                         &common->irqlock,
> > +                                         reqbuf->type, field,
> > +                                         sizeof(struct
> videobuf_buffer), fh);
> > +
> > +     /* Set io allowed member of file handle to TRUE */
> > +     fh->io_allowed[index] = 1;
> > +     /* Increment io usrs member of channel object to 1 */
> > +     common->io_usrs = 1;
> > +     /* Store type of memory requested in channel object */
> > +     common->memory = reqbuf->memory;
> > +     INIT_LIST_HEAD(&common->dma_queue);
> > +
> > +     /* Allocate buffers */
> > +     ret = videobuf_reqbufs(&common->buffer_queue, reqbuf);
> > +
> > +reqbuf_exit:
> > +     up(&common->lock);
> > +     return ret;
> > +}
> > +
> > +static int vpif_querybuf(struct file *file, void *priv,
> > +                             struct v4l2_buffer *tbuf)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     if (common->fmt.type != tbuf->type)
> > +             return -EINVAL;
> > +
> > +     if (tbuf->memory != V4L2_MEMORY_MMAP)
> > +             return -EINVAL;
> > +
> > +     return videobuf_querybuf(&common->buffer_queue, tbuf);
> > +}
> > +
> > +static int vpif_qbuf(struct file *file, void *priv, struct
> v4l2_buffer *buf)
> > +{
> > +
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     struct v4l2_buffer tbuf = *buf;
> > +     struct videobuf_buffer *buf1;
> > +     unsigned long addr = 0;
> > +     unsigned long flags;
> > +     int ret = 0;
> > +
> > +     if (common->fmt.type != tbuf.type)
> > +             return -EINVAL;
> > +
> > +     if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "fh->io_allowed\n");
> > +             return -EACCES;
> > +     }
> > +
> > +     if (!(list_empty(&common->dma_queue)) ||
> > +         (common->curFrm != common->nextFrm) ||
> > +         !(common->started) ||
> > +         (common->started && (0 == channel->field_id)))
> > +             return videobuf_qbuf(&common->buffer_queue, buf);
> > +
> > +     /* bufferqueue is empty store buffer address in VPIF registers
> */
> > +     mutex_lock(&common->buffer_queue.vb_lock);
> > +     buf1 = common->buffer_queue.bufs[tbuf.index];
> > +     if (buf1->memory != tbuf.memory) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "invalid buffer type\n");
> > +             goto qbuf_exit;
> > +     }
> > +
> > +     if ((buf1->state == VIDEOBUF_QUEUED) ||
> > +         (buf1->state == VIDEOBUF_ACTIVE)) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "invalid state\n");
> > +             goto qbuf_exit;
> > +     }
> > +
> > +     switch (buf1->memory) {
> > +     case V4L2_MEMORY_MMAP:
> > +             if (buf1->baddr == 0)
> > +                     goto qbuf_exit;
> > +             break;
> > +
> > +     case V4L2_MEMORY_USERPTR:
> > +             if (tbuf.length < buf1->bsize)
> > +                     goto qbuf_exit;
> > +
> > +             if ((VIDEOBUF_NEEDS_INIT != buf1->state)
> > +                         && (buf1->baddr != tbuf.m.userptr))
> > +                     vpif_buffer_release(&common->buffer_queue,
> buf1);
> > +                     buf1->baddr = tbuf.m.userptr;
> > +             break;
> > +
> > +     default:
> > +             goto qbuf_exit;
> > +     }
> > +
> > +     local_irq_save(flags);
> > +     ret = vpif_buffer_prepare(&common->buffer_queue, buf1,
> > +                                     common->buffer_queue.field);
> > +     if (ret < 0) {
> > +             local_irq_restore(flags);
> > +             goto qbuf_exit;
> > +     }
> > +
> > +     buf1->state = VIDEOBUF_ACTIVE;
> > +     addr = buf1->boff;
> > +     common->nextFrm = buf1;
> > +     if (tbuf.type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
> > +             common->set_addr((addr + common->ytop_off),
> > +                              (addr + common->ybtm_off),
> > +                              (addr + common->ctop_off),
> > +                              (addr + common->cbtm_off));
> > +     }
> > +
> > +     local_irq_restore(flags);
> > +     list_add_tail(&buf1->stream, &(common->buffer_queue.stream));
> > +     mutex_unlock(&common->buffer_queue.vb_lock);
> > +     return 0;
> > +
> > +qbuf_exit:
> > +     mutex_unlock(&common->buffer_queue.vb_lock);
> > +     return -EINVAL;
> > +}
> > +
> > +static int vpif_s_std(struct file *file, void *priv, v4l2_std_id
> *std_id)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     struct video_obj *vid_ch = &(channel->video);
> > +     int ret = 0;
> > +
> > +     if (common->started) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "streaming in
> progress\n");
> > +             return -EBUSY;
> > +     }
> > +
> > +     /* Call encoder subdevice function to set the standard */
> > +     down_interruptible(&common->lock);
> > +     ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
> > +                                             s_std_output, *std_id);
> > +
> > +     if (ret < 0) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "Failed to set output
> standard\n");
> > +             goto s_std_exit;
> > +     }
> > +
> > +     ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, tuner,
> > +                                                             s_std,
> *std_id);
> > +     if (ret < 0) {
> > +             v4l2_err(&vpif_obj.v4l2_dev,
> > +                             "Failed to set standard for sub
> devices\n");
> > +             goto s_std_exit;
> > +     }
> > +     channel->video.stdid = *std_id;
> > +
> > +     /* Get the information about the standard from the decoder */
> > +     vpif_get_std_info(channel);
> > +
> > +     if ((vid_ch->std_info.activelines * vid_ch-
> >std_info.activepixels * 2)
> > +                 > config_params.channel_bufsize[channel-
> >channel_id]) {
> > +                     v4l2_err(&vpif_obj.v4l2_dev,
> > +                                     "invalid std for this size\n");
> > +
> > +             ret = -EINVAL;
> > +             goto s_std_exit;
> > +
> > +     }
> > +
> > +     vpif_get_std_info(channel);
> > +     common->fmt.fmt.pix.bytesperline = common->fmt.fmt.pix.width;
> > +
> > +     /* Configure the default format information */
> > +     vpif_config_format(channel);
> > +
> > +s_std_exit:
> > +     up(&common->lock);
> > +     return ret;
> > +}
> > +
> > +static int vpif_dqbuf(struct file *file, void *priv, struct
> v4l2_buffer *p)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     if (file->f_flags & O_NONBLOCK)
> > +             /* Call videobuf_dqbuf for non blocking mode */
> > +             return videobuf_dqbuf(&common->buffer_queue, p, 1);
> > +     else
> > +             /* Call videobuf_dqbuf for blocking mode */
> > +             return videobuf_dqbuf(&common->buffer_queue, p, 0);
> > +}
> > +
> > +static int vpif_streamon(struct file *file, void *priv,
> > +                             enum v4l2_buf_type buftype)
> > +{
> > +     u8 index = VPIF_VIDEO_INDEX;
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     struct channel_obj *oth_ch = vpif_obj.dev[!channel-
> >channel_id];
> > +     struct video_obj *vid_ch = &(channel->video);
> > +     struct vpif_params *vpif = &channel->vpifparams;
> > +     struct vpif_config *vpif_config_data =
> > +                                     vpif_dev->platform_data;
> > +     unsigned long addr = 0;
> > +     int ret = 0;
> > +
> > +     if (!fh->io_allowed[index]) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "fh->io_allowed\n");
> > +             return -EACCES;
> > +     }
> > +
> > +     /* If Streaming is already started, return error */
> > +     if (common->started) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "channel->started\n");
> > +             return -EBUSY;
> > +     }
> > +
> > +     if ((channel->channel_id == VPIF_CHANNEL2_VIDEO
> > +             && oth_ch->common[VPIF_VIDEO_INDEX].started &&
> > +             channel->video.std_info.ycmux_mode == 0)
> > +             || ((channel->channel_id == VPIF_CHANNEL3_VIDEO)
> > +             && (2 == oth_ch->common[VPIF_VIDEO_INDEX].started))) {
> > +
> > +             v4l2_err(&vpif_obj.v4l2_dev, "other channel is
> using\n");
> > +             return -EBUSY;
> > +     }
> > +
> > +     if (index == VPIF_VIDEO_INDEX) {
> > +             ret = vpif_check_format(channel, &(common-
> >fmt.fmt.pix));
> > +             if (ret < 0)
> > +                     return ret;
> > +
> > +     } else {
> > +             if (!channel->common[VPIF_VIDEO_INDEX].started)
> > +                     return -EINVAL;
> > +     }
> > +
> > +     /* Call videobuf_streamon to start streaming  in videobuf */
> > +     ret = videobuf_streamon(&common->buffer_queue);
> > +     if (ret < 0) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "videobuf_streamon\n");
> > +             return ret;
> > +     }
> > +
> > +     down_interruptible(&common->lock);
> > +     /* If buffer queue is empty, return error */
> > +     if (list_empty(&common->dma_queue)) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "buffer queue is
> empty\n");
> > +             ret = -EIO;
> > +             goto streamon_exit;
> > +     }
> > +
> > +     /* Get the next frame from the buffer queue */
> > +     common->nextFrm = common->curFrm =
> > +                         list_entry(common->dma_queue.next,
> > +                                    struct videobuf_buffer, queue);
> > +
> > +     list_del(&common->curFrm->queue);
> > +     /* Mark state of the current frame to active */
> > +     common->curFrm->state = VIDEOBUF_ACTIVE;
> > +
> > +     /* Initialize field_id and started member */
> > +     channel->field_id = 0;
> > +     common->started = 1;
> > +     if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +             addr = common->curFrm->boff;
> > +             /* Calculate the offset for Y and C data  in the buffer
> */
> > +             vpif_calculate_offsets(channel);
> > +
> > +             if ((vid_ch->std_info.frame_format &&
> > +                     ((common->fmt.fmt.pix.field != V4L2_FIELD_NONE)
> > +                     && (common->fmt.fmt.pix.field !=
> V4L2_FIELD_ANY)))
> > +                     || (!vid_ch->std_info.frame_format
> > +                     && (common->fmt.fmt.pix.field ==
> V4L2_FIELD_NONE))) {
> > +
> > +                     v4l2_err(&vpif_obj.v4l2_dev,
> > +                             "conflict in field format and std
> format\n");
> > +                     ret = -EINVAL;
> > +                     goto streamon_exit;
> > +             }
> > +
> > +             /* clock settings */
> > +             ret = vpif_config_data->set_clock(vid_ch-
> >std_info.ycmux_mode,
> > +                                             vid_ch-
> >std_info.hd_sd);
> > +             if (ret < 0) {
> > +                     v4l2_err(&vpif_obj.v4l2_dev, "can't set
> clock\n");
> > +                     goto streamon_exit;
> > +             }
> > +
> > +             /* set the parameters and addresses */
> > +             ret = vpif_set_video_params(vpif, channel->channel_id +
> 2);
> > +             if (ret < 0)
> > +                     goto streamon_exit;
> > +
> > +             common->started = ret;
> > +             vpif_config_addr(channel, ret);
> > +
> > +             common->set_addr((addr + common->ytop_off),
> > +                              (addr + common->ybtm_off),
> > +                              (addr + common->ctop_off),
> > +                              (addr + common->cbtm_off));
> > +
> > +             /* Set interrupt for both the fields in VPIF
> > +                Register enable channel in VPIF register */
> > +             if (VPIF_CHANNEL2_VIDEO == channel->channel_id) {
> > +                     channel2_intr_assert();
> > +                     channel2_intr_enable(1);
> > +                     enable_channel2(1);
> > +             }
> > +             if ((VPIF_CHANNEL3_VIDEO == channel->channel_id)
> > +                     || (common->started == 2)) {
> > +                     channel3_intr_assert();
> > +                     channel3_intr_enable(1);
> > +                     enable_channel3(1);
> > +             }
> > +             channel_first_int[VPIF_VIDEO_INDEX][channel-
> >channel_id] = 1;
> > +     }
> > +
> > +streamon_exit:
> > +     up(&(common->lock));
> > +     return ret;
> > +}
> > +
> > +static int vpif_streamoff(struct file *file, void *priv,
> > +                             enum v4l2_buf_type buftype)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +
> > +     if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "fh->io_allowed\n");
> > +             return -EACCES;
> > +     }
> > +
> > +     if (!common->started) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "channel->started\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     down_interruptible(&common->lock);
> > +     if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +             /* disable channel */
> > +             if (VPIF_CHANNEL2_VIDEO == channel->channel_id) {
> > +                     enable_channel2(0);
> > +                     channel2_intr_enable(0);
> > +             }
> > +             if ((VPIF_CHANNEL3_VIDEO == channel->channel_id) ||
> > +                                     (2 == common->started)) {
> > +                     enable_channel3(0);
> > +                     channel3_intr_enable(0);
> > +             }
> > +     }
> > +
> > +     common->started = 0;
> > +     up(&common->lock);
> > +     return videobuf_streamoff(&common->buffer_queue);
> > +}
> > +
> > +static int vpif_cropcap(struct file *file, void *priv,
> > +                     struct v4l2_cropcap *crop)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     if (V4L2_BUF_TYPE_VIDEO_OUTPUT != crop->type)
> > +             return -EINVAL;
> > +
> > +     crop->bounds.left = crop->bounds.top = 0;
> > +     crop->defrect.left = crop->defrect.top = 0;
> > +     crop->defrect.height = crop->bounds.height = common->height;
> > +     crop->defrect.width = crop->bounds.width = common->width;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vpif_enum_output(struct file *file, void *fh,
> > +                             struct v4l2_output *output)
> > +{
> > +
> > +     struct vpif_config *config = vpif_dev->platform_data;
> > +     int index = output->index;
> > +
> > +     memset(output, 0, sizeof(*output));
> > +     if (index > config->output_count) {
> > +             v4l2_dbg(1, debug, &vpif_obj.v4l2_dev,
> > +                                             "Invalid output
> index\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     output->index = index;
> > +     strcpy(output->name, config->output[index].name);
> > +     output->type = V4L2_OUTPUT_TYPE_ANALOG;
> > +     output->std = DM646X_V4L2_STD;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vpif_s_output(struct file *file, void *priv, unsigned int
> i)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +     struct common_obj *common = &(channel-
> >common[VPIF_VIDEO_INDEX]);
> > +     struct v4l2_routing route;
> > +     int ret = 0;
> > +
> > +     down_interruptible(&common->lock);
> > +     if (common->started) {
> > +             v4l2_err(&vpif_obj.v4l2_dev, "Streaming in
> progress\n");
> > +             ret = -EBUSY;
> > +             goto s_output_exit;
> > +     }
> > +
> > +     route.output = i;
> > +     ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
> > +                                                     s_routing,
> &route);
> > +     if (ret < 0)
> > +             v4l2_err(&vpif_obj.v4l2_dev,
> > +                                     "Failed to set output
> standard\n");
> > +
> > +s_output_exit:
> > +     up(&common->lock);
> > +     return ret;
> > +}
> > +
> > +static int vpif_g_priority(struct file *file, void *priv, enum
> v4l2_priority *p)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +
> > +     *p = v4l2_prio_max(&channel->prio);
> > +
> > +     return 0;
> > +}
> > +
> > +static int vpif_s_priority(struct file *file, void *priv, enum
> v4l2_priority p)
> > +{
> > +     struct vpif_fh *fh = priv;
> > +     struct channel_obj *channel = fh->channel;
> > +
> > +     return v4l2_prio_change(&channel->prio, &fh->prio, p);
> > +}
> > +
> > +/* vpif display ioctl operations */
> > +static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
> > +     .vidioc_querycap         = vpif_querycap,
> > +     .vidioc_g_priority              = vpif_g_priority,
> > +     .vidioc_s_priority              = vpif_s_priority,
> > +     .vidioc_enum_fmt_vid_out        = vpif_enum_fmt_vid_out,
> > +     .vidioc_g_fmt_vid_out            = vpif_g_fmt_vid_out,
> > +     .vidioc_s_fmt_vid_out    = vpif_s_fmt_vid_out,
> > +     .vidioc_try_fmt_vid_out  = vpif_try_fmt_vid_out,
> > +     .vidioc_reqbufs          = vpif_reqbufs,
> > +     .vidioc_querybuf         = vpif_querybuf,
> > +     .vidioc_qbuf             = vpif_qbuf,
> > +     .vidioc_dqbuf            = vpif_dqbuf,
> > +     .vidioc_streamon         = vpif_streamon,
> > +     .vidioc_streamoff        = vpif_streamoff,
> > +     .vidioc_s_std            = vpif_s_std,
> > +     .vidioc_enum_output             = vpif_enum_output,
> > +     .vidioc_s_output                = vpif_s_output,
> > +     .vidioc_cropcap          = vpif_cropcap,
> > +};
> > +
> > +static struct v4l2_file_operations vpif_fops = {
> > +     .owner          = THIS_MODULE,
> > +     .open           = vpif_open,
> > +     .release        = vpif_release,
> > +     .ioctl          = video_ioctl2,
> > +     .mmap           = vpif_mmap,
> > +     .poll           = vpif_poll
> > +};
> > +
> > +static struct video_device vpif_video_template = {
> > +     .name           = "vpif",
> > +     .vfl_type       = VID_TYPE_CAPTURE,
> > +     .fops           = &vpif_fops,
> > +     .minor          = -1,
> > +     .ioctl_ops      = &vpif_ioctl_ops,
> > +     .tvnorms        = DM646X_V4L2_STD,
> > +     .current_norm   = V4L2_STD_PAL,
> > +
> > +};
> > +
> > +/*Configure the channels, buffer sizei, request irq */
> > +static int initialize_vpif(void)
> > +{
> > +     int free_channel_objects_index;
> > +     int free_buffer_channel_index;
> > +     int free_buffer_index;
> > +     int err = 0, i, j;
> > +
> > +     /* Default number of buffers should be 3 */
> > +     if ((ch2_numbuffers > 0) &&
> > +         (ch2_numbuffers < config_params.min_numbuffers))
> > +             ch2_numbuffers = config_params.min_numbuffers;
> > +     if ((ch3_numbuffers > 0) &&
> > +         (ch3_numbuffers < config_params.min_numbuffers))
> > +             ch3_numbuffers = config_params.min_numbuffers;
> > +
> > +     /* Set buffer size to min buffers size if invalid buffer size
> is
> > +      * given */
> > +     if (ch2_bufsize <
> config_params.min_bufsize[VPIF_CHANNEL2_VIDEO])
> > +             ch2_bufsize =
> > +                 config_params.min_bufsize[VPIF_CHANNEL2_VIDEO];
> > +     if (ch3_bufsize <
> config_params.min_bufsize[VPIF_CHANNEL3_VIDEO])
> > +             ch3_bufsize =
> > +                 config_params.min_bufsize[VPIF_CHANNEL3_VIDEO];
> > +
> > +     config_params.numbuffers[VPIF_CHANNEL2_VIDEO] = ch2_numbuffers;
> > +
> > +     if (ch2_numbuffers) {
> > +             config_params.channel_bufsize[VPIF_CHANNEL2_VIDEO] =
> > +                                                     ch2_bufsize;
> > +     }
> > +     config_params.numbuffers[VPIF_CHANNEL3_VIDEO] = ch3_numbuffers;
> > +
> > +     if (ch3_numbuffers) {
> > +             config_params.channel_bufsize[VPIF_CHANNEL3_VIDEO] =
> > +                                                     ch3_bufsize;
> > +     }
> > +
> > +     /* Allocate memory for six channel objects */
> > +     for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
> > +             vpif_obj.dev[i] =
> > +                 kmalloc(sizeof(struct channel_obj), GFP_KERNEL);
> > +             /* If memory allocation fails, return error */
> > +             if (!vpif_obj.dev[i]) {
> > +                     free_channel_objects_index = i;
> > +                     err = -ENOMEM;
> > +                     goto vpif_init_free_channel_objects;
> > +             }
> > +     }
> > +
> > +     free_channel_objects_index = VPIF_DISPLAY_MAX_DEVICES;
> > +     free_buffer_channel_index = VPIF_DISPLAY_NUM_CHANNELS;
> > +     free_buffer_index = config_params.numbuffers[i - 1];
> > +
> > +     return 0;
> > +
> > +vpif_init_free_channel_objects:
> > +     for (j = 0; j < free_channel_objects_index; j++)
> > +             kfree(vpif_obj.dev[j]);
> > +     return err;
> > +}
> > +
> > +/*
> > + * vpif_probe: This function creates device entries by register
> itself to the
> > + * V4L2 driver and initializes fields of each channel objects
> > + */
> > +static __init int vpif_probe(struct platform_device *pdev)
> > +{
> > +     int i, j = 0, k, q, m, err = 0;
> > +     struct vpif_config *config;
> > +     struct channel_obj *channel;
> > +     struct i2c_adapter *i2c_adap;
> > +     struct common_obj *common;
> > +     struct i2c_client *client;
> > +     struct video_device *vfd;
> > +     struct resource *res;
> > +     int subdev_count;
> > +
> > +     vpif_dev = &pdev->dev;
> > +
> > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +     if (!res) {
> > +             v4l2_err(vpif_dev->driver,
> > +                             "Error getting platform resource\n");
> > +             return -ENOENT;
> > +     }
> > +
> > +     if (!request_mem_region(res->start, res->end - res->start + 1,
> > +                                             vpif_dev->driver-
> >name)) {
> > +             v4l2_err(vpif_dev->driver, "VPIF: failed
> request_mem_region\n");
> > +             return -ENXIO;
> > +     }
> > +
> > +     vpif_base = ioremap_nocache(res->start, res->end - res->start +
> 1);
> > +     if (!vpif_base) {
> > +             v4l2_err(vpif_dev->driver, "Unable to ioremap VPIF
> reg\n");
> > +             err = -ENXIO;
> > +             goto resource_exit;
> > +     }
> > +
> > +     vpif_base_addr_init(vpif_base);
> > +
> > +     initialize_vpif();
> > +
> > +     err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
> > +     if (err) {
> > +             v4l2_err(vpif_dev->driver, "Error registering v4l2
> device\n");
> > +             return err;
> > +     }
> > +
> > +     k = 0;
> > +     while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k)))
> {
> > +             for (i = res->start; i <= res->end; i++) {
> > +                     if (request_irq(i, vpif_channel_isr,
> IRQF_DISABLED,
> > +                                     "DM646x_Display",
> > +                             (void *)(&(vpif_obj.dev[k]-
> >channel_id))))
> > +                             goto vpif_int_err;
> > +             }
> > +             k++;
> > +     }
> > +
> > +     for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
> > +
> > +             /* Get the pointer to the channel object */
> > +             channel = vpif_obj.dev[i];
> > +
> > +             /* Allocate memory for video device */
> > +             vfd = video_device_alloc();
> > +             if (vfd == NULL) {
> > +                     for (j = 0; j < i; j++) {
> > +                             channel = vpif_obj.dev[j];
> > +                             video_device_release(channel-
> >video_dev);
> > +                     }
> > +                     err = -ENOMEM;
> > +                     goto video_dev_alloc_exit;
> > +             }
> > +
> > +             /* Initialize field of video device */
> > +             *vfd = vpif_video_template;
> > +             vfd->v4l2_dev = &vpif_obj.v4l2_dev;
> > +             vfd->release = video_device_release;
> > +             snprintf(vfd->name, sizeof(vfd->name),
> > +                      "DM646x_VPIFDisplay_DRIVER_V%d.%d.%d",
> > +                      (VPIF_DISPLAY_VERSION_CODE >> 16) & 0xff,
> > +                      (VPIF_DISPLAY_VERSION_CODE >> 8) & 0xff,
> > +                      (VPIF_DISPLAY_VERSION_CODE) & 0xff);
> > +
> > +             /* Set video_dev to the video device */
> > +             channel->video_dev = vfd;
> > +     }
> > +
> > +     for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
> > +             channel = vpif_obj.dev[j];
> > +             /* Initialize field of the channel objects */
> > +             channel->usrs = 0;
> > +             for (k = 0; k < VPIF_NUMOBJECTS; k++) {
> > +                     channel->common[k].numbuffers = 0;
> > +                     common = &(channel->common[k]);
> > +                     common->io_usrs = 0;
> > +                     common->started = 0;
> > +                     spin_lock_init(&common->irqlock);
> > +                     init_MUTEX(&common->lock);
> > +                     common->numbuffers = 0;
> > +                     common->set_addr = NULL;
> > +                     common->ytop_off = common->ybtm_off = 0;
> > +                     common->ctop_off = common->cbtm_off = 0;
> > +                     common->curFrm = common->nextFrm = NULL;
> > +                     memset(&common->fmt, 0, sizeof(common->fmt));
> > +                     common->numbuffers =
> config_params.numbuffers[k];
> > +
> > +             }
> > +             channel->initialized = 0;
> > +             channel->channel_id = j;
> > +             if (j < 2)
> > +                     channel->common[VPIF_VIDEO_INDEX].numbuffers =
> > +                         config_params.numbuffers[channel-
> >channel_id];
> > +             else
> > +                     channel->common[VPIF_VIDEO_INDEX].numbuffers =
> 0;
> > +
> > +             memset(&(channel->vpifparams), 0, sizeof(channel-
> >vpifparams));
> > +
> > +             /* Initialize prio member of channel object */
> > +             v4l2_prio_init(&channel->prio);
> > +             channel->common[VPIF_VIDEO_INDEX].fmt.type =
> > +
> V4L2_BUF_TYPE_VIDEO_OUTPUT;
> > +
> > +             /* register video device */
> > +             v4l2_dbg(1, debug, &vpif_obj.v4l2_dev,
> > +                             "channel=%x,channel->video_dev=%x\n",
> > +                             (int)channel, (int)&channel-
> >video_dev);
> > +
> > +             err = video_register_device(channel->video_dev,
> > +                                       VFL_TYPE_GRABBER,
> vpif_nr[j]);
> > +             if (err < 0)
> > +                     goto probe_out;
> > +
> > +             video_set_drvdata(channel->video_dev, channel);
> > +     }
> > +
> > +     i2c_adap = i2c_get_adapter(1);
> > +     config = pdev->dev.platform_data;
> > +     subdev_count = config->subdev_count;
> > +
> > +     for (i = 0; i < subdev_count; i++) {
> > +             list_for_each_entry(client, &i2c_adap->clients, list) {
> > +             if (!strcmp(client->name, config->subdevinfo[i].name))
> > +                     break;
> > +             }
> > +             if (client == NULL) {
> > +                     v4l2_err(&vpif_obj.v4l2_dev, "No Subdevice
> found\n");
> > +                     err =  -ENODEV;
> > +                     goto probe_out;
> > +             }
> > +
> > +             /* Get subdevice data from the client */
> > +             vpif_obj.sd[i] = i2c_get_clientdata(client);
> > +             if (vpif_obj.sd[i])
> > +                     vpif_obj.sd[i]->grp_id = 1 << i;
> > +
> > +             err = v4l2_device_register_subdev(&vpif_obj.v4l2_dev,
> > +
> vpif_obj.sd[i]);
> > +             if (err) {
> > +                     v4l2_err(&vpif_obj.v4l2_dev,
> > +                             "Error registering v4l2 sub-device\n");
> > +                     goto probe_out;
> > +             }
> > +     }
> > +
> > +
> > +     return 0;
> > +
> > +probe_out:
> > +     for (k = 0; k < j; k++) {
> > +             channel = vpif_obj.dev[k];
> > +             video_unregister_device(channel->video_dev);
> > +             video_device_release(channel->video_dev);
> > +             channel->video_dev = NULL;
> > +     }
> > +
> > +vpif_int_err:
> > +     v4l2_err(&vpif_obj.v4l2_dev, "VPIF IRQ request failed\n");
> > +     for (q = k; k >= 0; k--) {
> > +             for (m = i; m >= res->start; m--)
> > +                     free_irq(m, (void *)(&(vpif_obj.dev[k]-
> >channel_id)));
> > +             res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
> > +             m = res->end;
> > +     }
> > +     err = -EBUSY;
> > +
> > +video_dev_alloc_exit:
> > +     iounmap(vpif_base);
> > +
> > +resource_exit:
> > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +     release_mem_region(res->start, res->end - res->start + 1);
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * vpif_remove: It un-register channels from V4L2 driver
> > + */
> > +static int vpif_remove(struct platform_device *device)
> > +{
> > +     struct channel_obj *channel;
> > +     int i;
> > +
> > +     v4l2_device_unregister(&vpif_obj.v4l2_dev);
> > +
> > +     /* un-register device */
> > +     for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
> > +             /* Get the pointer to the channel object */
> > +             channel = vpif_obj.dev[i];
> > +             /* Unregister video device */
> > +             video_unregister_device(channel->video_dev);
> > +
> > +             channel->video_dev = NULL;
> > +     }
> > +     return 0;
> > +}
> > +
> > +static struct platform_driver vpif_driver = {
> > +     .driver = {
> > +                     .name   = "vpif_display",
> > +                     .owner  = THIS_MODULE,
> > +     },
> > +     .probe  = vpif_probe,
> > +     .remove = vpif_remove,
> > +};
> > +
> > +static __init int vpif_init(void)
> > +{
> > +     return platform_driver_register(&vpif_driver);
> > +}
> > +
> > +/*
> > + * vpif_cleanup: This function un-registers device and driver to the
> kernel,
> > + * frees requested irq handler and de-allocates memory allocated for
> channel
> > + * objects.
> > + */
> > +static void vpif_cleanup(void)
> > +{
> > +     struct platform_device *pdev;
> > +     struct resource *res;
> > +     int irq_num;
> > +     int i = 0;
> > +
> > +     pdev = container_of(vpif_dev, struct platform_device, dev);
> > +
> > +     while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i)))
> {
> > +             for (irq_num = res->start; irq_num <= res->end;
> irq_num++)
> > +                     free_irq(irq_num,
> > +                              (void *)(&(vpif_obj.dev[i]-
> >channel_id)));
> > +             i++;
> > +     }
> > +
> > +     iounmap(vpif_base);
> > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +     release_mem_region(res->start, res->end - res->start + 1);
> > +     platform_driver_unregister(&vpif_driver);
> > +
> > +     for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)
> > +             kfree(vpif_obj.dev[i]);
> > +}
> > +
> > +module_init(vpif_init);
> > +module_exit(vpif_cleanup);
> > diff --git a/drivers/media/video/davinci/vpif_display.h
> b/drivers/media/video/davinci/vpif_display.h
> > new file mode 100644
> > index 0000000..b14a46e
> > --- /dev/null
> > +++ b/drivers/media/video/davinci/vpif_display.h
> > @@ -0,0 +1,204 @@
> > +/*
> > + * DM646x display header file
> > + *
> > + * Copyright (C) 2009 Texas Instruments Incorporated -
> http://www.ti.com/
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation version 2.
> > + *
> > + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> > + * kind, whether express or implied; without even the implied
> warranty
> > + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef DAVINCIHD_DISPLAY_H
> > +#define DAVINCIHD_DISPLAY_H
> > +
> > +/* Header files */
> > +#include <linux/videodev2.h>
> > +#include <linux/version.h>
> > +#include <media/v4l2-common.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/videobuf-core.h>
> > +#include <media/videobuf-dma-contig.h>
> > +
> > +#include "vpif.h"
> > +
> > +/* for v4l2_subdev interface */
> > +#define ADV7343_ID   (0x01 << 0)
> > +#define THS7303_ID   (0x01 << 1)
> > +
> > +#define ADV7343_IDX  (0)
> > +#define      THS7303_IDX     (1)
>
> Do these defines belong here? This is rather board specific. They also
> do
> not seem to be used.
>
No. This should have been removed, will be done in the next version of the patches.

> > +#define SUBDEV_COUNT (2)
> > +
> > +/* Macros */
> > +#define VPIF_MAJOR_RELEASE   (0)
> > +#define VPIF_MINOR_RELEASE   (0)
> > +#define VPIF_BUILD           (1)
> > +
> > +#define VPIF_DISPLAY_VERSION_CODE \
> > +     ((VPIF_MAJOR_RELEASE<<16) | (VPIF_MINOR_RELEASE<<8) |
> VPIF_BUILD)
> > +
> > +#define VPIF_VALID_FIELD(field) \
> > +     (((V4L2_FIELD_ANY == field) || (V4L2_FIELD_NONE == field)) || \
> > +     (((V4L2_FIELD_INTERLACED == field) || (V4L2_FIELD_SEQ_TB ==
> field)) || \
> > +     (V4L2_FIELD_SEQ_BT == field)))
> > +
> > +#define VPIF_DISPLAY_MAX_DEVICES     (2)
> > +#define VPIF_SLICED_BUF_SIZE         (256)
> > +#define VPIF_SLICED_MAX_SERVICES     (3)
> > +#define VPIF_VIDEO_INDEX             (0)
> > +#define VPIF_VBI_INDEX                       (1)
> > +#define VPIF_HBI_INDEX                       (2)
> > +
> > +/* Setting it to 1 as HBI/VBI support yet to be added , else 3*/
> > +#define VPIF_NUMOBJECTS      (1)
> > +
> > +/* Macros */
> > +#define ISNULL(p)       ((NULL) == (p))
>
> No longer used (thanks!): can be removed.
>
> > +#define ISALIGNED(a)    (0 == (a%8))
>
> Here you need parenthesis: (0 == ((a) % 8))
>
OK.

> > +
> > +/* enumerated data types */
> > +/* Enumerated data type to give id to each device per channel */
> > +enum vpif_channel_id {
> > +     VPIF_CHANNEL2_VIDEO = 0,        /* Channel2 Video */
> > +     VPIF_CHANNEL3_VIDEO,            /* Channel3 Video */
> > +};
> > +
> > +/* structures */
> > +
> > +struct video_obj {
> > +     enum v4l2_field buf_field;
> > +
> > +     v4l2_std_id stdid;              /* Currently selected or
> default
> > +                                        standard */
> > +
> > +     u32 latest_only;                /* indicate whether to return
> > +                                        most recent displayed frame
> > +                                        only */
> > +     struct vpif_stdinfo std_info;   /*Keeps track of the
> information
> > +                                        about the standard */
> > +};
> > +
> > +struct vbi_obj {
> > +     struct vpif_vbi_params vbiparams;       /* Structure storing
> > +                                                vpif parameters
> > +                                                for the raw vbi data
> */
> > +     int num_services;
> > +};
> > +
> > +struct common_obj {
> > +     /* Buffer specific parameters */
> > +     u8 *fbuffers[VIDEO_MAX_FRAME];  /* List of buffer pointers for
> > +                                        storing frames */
> > +     u32 numbuffers;                 /* number of buffers in
> fbuffers */
> > +     struct videobuf_buffer *curFrm; /* Pointer pointing to current
> > +                                        videobuf_buffer */
> > +     struct videobuf_buffer *nextFrm;/* Pointer pointing to current
> > +                                        videobuf_buffer */
> > +     enum v4l2_memory memory;        /* This field keeps track of
> type
> > +                                        of buffer exchange mechanism
> > +                                        user has selected */
> > +     struct v4l2_format fmt;         /* Used to store the format */
> > +
> > +     struct videobuf_queue buffer_queue;     /* Buffer queue used in
> > +                                                video-buf */
> > +     struct list_head dma_queue;     /* Queue of filled frames */
> > +     spinlock_t irqlock;             /* Used in video-buf */
> > +
> > +     /* channel specifc parameters */
> > +     struct semaphore lock;          /* lock used to access this
> > +                                        structure */
>
> Unless this is a counting semaphore, then this should be replaced by
> the
> more efficient mutex.

OK, will look into this.

Thanks,
Chaithrika

>
> > +     u32 io_usrs;                    /* number of users performing
> > +                                        IO */
> > +     u8 started;                     /* Indicates whether streaming
> > +                                        started */
> > +     u32 ytop_off;                   /* offset where Y top starts
> > +                                        from the starting of the
> > +                                        buffer */
> > +     u32 ybtm_off;                   /* offset where Y bottom starts
> > +                                        from the starting of the
> > +                                        buffer */
> > +     u32 ctop_off;                   /* offset where C top starts
> > +                                        from the starting of the
> > +                                        buffer */
> > +     u32 cbtm_off;                   /* offset where C bottom starts
> > +                                        from the starting of the
> > +                                        buffer */
> > +
> > +     /* Function pointer to set the addresses */
> > +     void (*set_addr) (unsigned long, unsigned long,
> > +                             unsigned long, unsigned long);
> > +
> > +     u32 height;
> > +
> > +     u32 width;
> > +};
> > +
> > +struct channel_obj {
> > +     /* V4l2 specific parameters */
> > +     struct video_device *video_dev; /* Identifies video device for
> > +                                        this channel */
> > +     struct v4l2_prio_state prio;    /* Used to keep track of state
> of
> > +                                        the priority */
> > +     u32 usrs;                       /* number of open instances of
> > +                                        the channel */
> > +     u32 field_id;                   /* Indicates id of the field
> > +                                        which is being displayed */
> > +     u8 initialized;                 /* flag to indicate whether
> > +                                        encoder is initialized */
> > +
> > +     enum vpif_channel_id channel_id;/* Identifies channel */
> > +
> > +     struct vpif_params vpifparams;
> > +     struct common_obj common[VPIF_NUMOBJECTS];
> > +     struct video_obj video;
> > +     struct vbi_obj vbi;
> > +};
> > +
> > +/* File handle structure */
> > +struct vpif_fh {
> > +     struct channel_obj *channel;    /* pointer to channel object
> for
> > +                                        opened device */
> > +     u8 io_allowed[VPIF_NUMOBJECTS]; /* Indicates whether this file
> handle
> > +                                        is doing IO */
> > +     enum v4l2_priority prio;        /* Used to keep track priority
> of
> > +                                        this instance */
> > +     u8 initialized;                 /* Used to keep track of
> whether this
> > +                                        file handle has initialized
> > +                                        channel or not */
> > +};
> > +
> > +/* vpif device structure */
> > +struct vpif_device {
> > +     struct channel_obj *dev[VPIF_DISPLAY_NUM_CHANNELS];
> > +     struct v4l2_device v4l2_dev;
> > +     struct v4l2_subdev *sd[SUBDEV_COUNT];
> > +};
> > +
> > +struct vpif_config_params {
> > +     u8 min_numbuffers;
> > +     u8 numbuffers[VPIF_DISPLAY_NUM_CHANNELS];
> > +     u32 min_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
> > +     u32 channel_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
> > +};
> > +
> > +/* Struct which keeps track of the line numbers for the sliced vbi
> service */
> > +struct vpif_service_line {
> > +     u16 service_id;
> > +     u16 service_line[2];
> > +     u16 enc_service_id;
> > +     u8 bytestowrite;
> > +};
> > +
> > +/* IOCTLs */
> > +
> > +#define VPIF_S_VPIF_PARAMS    _IOW('V', BASE_VIDIOC_PRIVATE + 1, \
> > +                                     struct vpif_params)
> > +#define VPIF_G_VPIF_PARAMS   _IOR('V', BASE_VIDIOC_PRIVATE + 2, \
> > +                                     struct vpif_params)
> > +
> > +#endif                               /* DAVINCIHD_DISPLAY_H */
>
> Regards,
>
>         Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
