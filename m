Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f217.google.com ([209.85.218.217]:61629 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0DBUKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 16:10:38 -0400
MIME-Version: 1.0
In-Reply-To: <1270115880-21404-2-git-send-email-hvaibhav@ti.com>
References: <hvaibhav@ti.com>
	 <1270115880-21404-2-git-send-email-hvaibhav@ti.com>
Date: Fri, 2 Apr 2010 16:03:14 -0400
Message-ID: <z2j55a3e0ce1004021303rdf3092f7r87b119cd97687f9b@mail.gmail.com>
Subject: Re: [PATCH 1/2] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on
	top of DSS2
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, m-karicheri2@ti.com,
	mchehab@redhat.com, linux-omap@vger.kernel.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,

I have some comments on this patch. Please address them.

> +
> +#include <asm/processor.h>

Add a line here??

> +#include <plat/dma.h>
> +#include <plat/vram.h>
> +#include <plat/vrfb.h>
> +#include <plat/display.h>
> +
> +#include "omap_voutlib.h"
> +#include "omap_voutdef.h"
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
> +MODULE_LICENSE("GPL");
> +
> +
> +/* Driver Configuration macros */
> +#define VOUT_NAME              "omap_vout"
> +
> +enum omap_vout_channels {
> +       OMAP_VIDEO1 = 0,
Why do we have to initialize this to 0. It always start with a value 0
by default.

> +       OMAP_VIDEO2,
> +};
> +
> +enum dma_channel_state {
> +       DMA_CHAN_NOT_ALLOTED = 0,

Ditto.

> +       DMA_CHAN_ALLOTED,
> +};
> +
> +#define QQVGA_WIDTH            160
> +#define QQVGA_HEIGHT           120
> +
> +/* Max Resolution supported by the driver */
> +#define VID_MAX_WIDTH          1280    /* Largest width */
> +#define VID_MAX_HEIGHT         720     /* Largest height */
> +

-------------------------------------

> +
> +module_param(debug, bool, S_IRUGO);
> +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> +
> +/* Local Helper functions */
> +static void omap_vout_isr(void *arg, unsigned int irqstatus);
> +static void omap_vout_cleanup_device(struct omap_vout_device *vout);
> +

Is there a reason why you need these prototypes? I think we could
remove these prototypes and move the function ahead in the file before
it is called.

> +/* list of image formats supported by OMAP2 video pipelines */
> +const static struct v4l2_fmtdesc omap_formats[] = {
> +       {
> +               /* Note:  V4L2 defines RGB565 as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
> +                *
> +                * We interpret RGB565 as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
> +                */
> +               .description = "RGB565, le",
> +               .pixelformat = V4L2_PIX_FMT_RGB565,
> +       },
> +       {
> +               /* Note:  V4L2 defines RGB32 as: RGB-8-8-8-8  we use
> +                *  this for RGB24 unpack mode, the last 8 bits are ignored
> +                * */
> +               .description = "RGB32, le",
> +               .pixelformat = V4L2_PIX_FMT_RGB32,
> +       },
> +       {
> +               /* Note:  V4L2 defines RGB24 as: RGB-8-8-8  we use
> +                *        this for RGB24 packed mode
> +                *
> +                */
> +               .description = "RGB24, le",
> +               .pixelformat = V4L2_PIX_FMT_RGB24,
> +       },
> +       {
> +               .description = "YUYV (YUV 4:2:2), packed",
> +               .pixelformat = V4L2_PIX_FMT_YUYV,
> +       },
> +       {
> +               .description = "UYVY, packed",
> +               .pixelformat = V4L2_PIX_FMT_UYVY,
> +       },
> +};
> +
> +#define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
> +
> +/*
> + * Allocate buffers
> + */

----------------------------------

> +
> +/*
> + * omap_vout_uservirt_to_phys: This inline function is used to convert user
> + * space virtual address to physical address.
> + */
> +static u32 omap_vout_uservirt_to_phys(u32 virtp)
> +{
> +       unsigned long physp = 0;
> +       struct vm_area_struct *vma;
> +       struct mm_struct *mm = current->mm;
> +
> +       vma = find_vma(mm, virtp);
> +       /* For kernel direct-mapped memory, take the easy way */
> +       if (virtp >= PAGE_OFFSET) {
> +               physp = virt_to_phys((void *) virtp);
> +       } else if (vma && (vma->vm_flags & VM_IO)
> +                       && vma->vm_pgoff) {
> +               /* this will catch, kernel-allocated,
> +                  mmaped-to-usermode addresses */
> +               physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
> +       } else {
> +               /* otherwise, use get_user_pages() for general userland pages */
> +               int res, nr_pages = 1;
> +               struct page *pages;
> +               down_read(&current->mm->mmap_sem);
> +
> +               res = get_user_pages(current, current->mm, virtp, nr_pages,
> +                               1, 0, &pages, NULL);
> +               up_read(&current->mm->mmap_sem);
> +
> +               if (res == nr_pages) {
> +                       physp =  __pa(page_address(&pages[0]) +
> +                                       (virtp & ~PAGE_MASK));
> +               } else {
> +                       printk(KERN_WARNING VOUT_NAME
> +                                       "get_user_pages failed\n");
> +                       return 0;
> +               }
> +       }
> +
> +       return physp;
> +}

Shouldn't we remove omap_vout_uservirt_to_phys() and use videobuf_iolock()
instead as we have done in vpfe_capture.c?

-------------------------------------------------


> +
> +/*
> + * Convert V4L2 rotation to DSS rotation
> + *     V4L2 understand 0, 90, 180, 270.
> + *     Convert to 0, 1, 2 and 3 repsectively for DSS
> + */
> +static int v4l2_rot_to_dss_rot(int v4l2_rotation, enum dss_rotation *rotation,
> +               bool mirror)
> +{
Suggest adding a variable int ret = 0;
and return ret at the end of the function instead of return at each case.

> +       switch (v4l2_rotation) {
> +       case 90:
> +               *rotation = dss_rotation_90_degree;
> +               return 0;
use break instead of return here
> +       case 180:
> +               *rotation = dss_rotation_180_degree;
> +               return 0;
Ditto
> +       case 270:
> +               *rotation = dss_rotation_270_degree;
> +               return 0;
Ditto
> +       case 0:
> +               *rotation = dss_rotation_0_degree;
> +               return 0;
Ditto
> +       default:
> +               return -EINVAL;

ret = -EINVAL;

> +       }

return ret;
> +
> +}

------------------------------------------------------------



> +/*
> + * Convert V4L2 pixel format to DSS pixel format
> + */
> +static enum omap_color_mode video_mode_to_dss_mode(struct omap_vout_device
> +                       *vout)
> +{
> +       struct omap_overlay *ovl;
> +       struct omapvideo_info *ovid;
> +       struct v4l2_pix_format *pix = &vout->pix;
> +
> +       ovid = &vout->vid_info;
> +       ovl = ovid->overlays[0];
> +
> +       switch (pix->pixelformat) {
> +       case 0:
> +               break;
> +       case V4L2_PIX_FMT_YUYV:
> +               return OMAP_DSS_COLOR_YUV2;
> +
> +       case V4L2_PIX_FMT_UYVY:
> +               return OMAP_DSS_COLOR_UYVY;
> +
> +       case V4L2_PIX_FMT_RGB565:
> +               return OMAP_DSS_COLOR_RGB16;
> +
> +       case V4L2_PIX_FMT_RGB24:
> +               return OMAP_DSS_COLOR_RGB24P;
> +
> +       case V4L2_PIX_FMT_RGB32:
> +               return (ovl->id == OMAP_DSS_VIDEO1) ?
> +                       OMAP_DSS_COLOR_RGB24U : OMAP_DSS_COLOR_ARGB32;
> +       case V4L2_PIX_FMT_BGR32:
> +               return OMAP_DSS_COLOR_RGBX32;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +       return -EINVAL;

Also return type is eum and you are returning a negative number here ???

> +}

Similar comment for this function as well. return at the end of the function.

> +
> +/*
> + * Setup the overlay
> + */
> +int omapvid_setup_overlay(struct omap_vout_device *vout,
> +               struct omap_overlay *ovl, int posx, int posy, int outw,
> +               int outh, u32 addr)

-----------------------------------------------------------------



> +
> +static int vidioc_try_fmt_vid_out(struct file *file, void *fh,
> +                       struct v4l2_format *f)
> +{
> +       struct omap_overlay *ovl;
> +       struct omapvideo_info *ovid;
> +       struct omap_video_timings *timing;
> +       struct omap_vout_device *vout = fh;
> +
> +       if (vout->streaming)
> +               return -EBUSY;

When application calls a TRY_FMT, I think as per v4l spec, driver
shouldn't change the state. So why should we return -EBUSY here?

> +
> +       ovid = &vout->vid_info;
> +       ovl = ovid->overlays[0];
> +
> +       if (!ovl->manager || !ovl->manager->device)
> +               return -EINVAL;
> +       /* get the display device attached to the overlay */
> +       timing = &ovl->manager->device->panel.timings;
> +
> +       vout->fbuf.fmt.height = timing->y_res;
> +       vout->fbuf.fmt.width = timing->x_res;
> +
> +       omap_vout_try_format(&f->fmt.pix);
> +       return 0;
> +}
> +

---------------------------------------------------------------------


> +
> +static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *ctrl)
> +{
> +       struct omap_vout_device *vout = fh;
> +
> +       switch (ctrl->id) {
> +       case V4L2_CID_ROTATE:
> +               ctrl->value = vout->control[0].value;
> +               return 0;
> +       case V4L2_CID_BG_COLOR:
> +       {
> +               struct omap_overlay_manager_info info;
> +               struct omap_overlay *ovl;
> +               ovl = vout->vid_info.overlays[0];
> +
> +               if (!ovl->manager || !ovl->manager->get_manager_info)
> +                       return -EINVAL;
> +
> +               ovl->manager->get_manager_info(ovl->manager, &info);
> +               ctrl->value = info.default_color;
> +               return 0;
> +       }
> +       case V4L2_CID_VFLIP:
> +               ctrl->value = vout->control[2].value;
> +               return 0;
> +       default:
> +               return -EINVAL;
> +       }
> +}

Return at the end and use break for each case.

> +
> +static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
> +{
> +       struct omap_vout_device *vout = fh;
> +
> +       switch (a->id) {
> +       case V4L2_CID_ROTATE:
> +       {
> +               int rotation = a->value;
> +
> +               mutex_lock(&vout->lock);
> +
> +               if (rotation &&
> +                       vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
> +                       mutex_unlock(&vout->lock);
> +                       return -EINVAL;
> +               }
> +
> +               if ((v4l2_rot_to_dss_rot(rotation, &vout->rotation,
> +                               vout->mirror))) {
> +                       mutex_unlock(&vout->lock);
> +                       return -EINVAL;
> +               }
> +
> +               vout->control[0].value = rotation;
> +               mutex_unlock(&vout->lock);
> +               return 0;
> +       }
> +       case V4L2_CID_BG_COLOR:
> +       {
> +               struct omap_overlay *ovl;
> +               unsigned int  color = a->value;
> +               struct omap_overlay_manager_info info;
> +
> +               ovl = vout->vid_info.overlays[0];
> +
> +               mutex_lock(&vout->lock);
> +               if (!ovl->manager || !ovl->manager->get_manager_info) {
> +                       mutex_unlock(&vout->lock);
> +                       return -EINVAL;
> +               }
> +
> +               ovl->manager->get_manager_info(ovl->manager, &info);
> +               info.default_color = color;
> +               if (ovl->manager->set_manager_info(ovl->manager, &info)) {
> +                       mutex_unlock(&vout->lock);
> +                       return -EINVAL;
> +               }
> +
> +               vout->control[1].value = color;
> +               mutex_unlock(&vout->lock);
> +               return 0;
> +       }
> +       case V4L2_CID_VFLIP:
> +       {
> +               struct omap_overlay *ovl;
> +               struct omapvideo_info *ovid;
> +               unsigned int  mirror = a->value;
> +
> +               ovid = &vout->vid_info;
> +               ovl = ovid->overlays[0];
> +
> +               mutex_lock(&vout->lock);
> +
> +               if (mirror  && vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
> +                       mutex_unlock(&vout->lock);
> +                       return -EINVAL;
> +               }
> +               vout->mirror = mirror;
> +               vout->control[2].value = mirror;
> +               mutex_unlock(&vout->lock);
> +               return 0;
> +       }
> +
> +       default:
> +               return -EINVAL;
> +       }
> +

Ditto,

--------------------------------------------------------------



> +
> +static int vidioc_streamon(struct file *file, void *fh,
> +                       enum v4l2_buf_type i)
> +{
> +       int ret = 0, j;
> +       u32 addr = 0, mask = 0;
> +       struct omap_vout_device *vout = fh;
> +       struct videobuf_queue *q = &vout->vbq;
> +       struct omapvideo_info *ovid = &vout->vid_info;
> +
> +       mutex_lock(&vout->lock);
> +
> +       if (vout->streaming) {
> +               ret = -EBUSY;
> +               goto streamon_err;
> +       }
> +
> +       ret = videobuf_streamon(q);
> +       if (ret < 0)
> +               goto streamon_err;
> +
> +       if (list_empty(&vout->dma_queue)) {
> +               ret = -EIO;
> +               goto streamon_err;
> +       }
> +       /* Get the next frame from the buffer queue */
> +       vout->next_frm = vout->cur_frm = list_entry(vout->dma_queue.next,
> +                       struct videobuf_buffer, queue);
> +       /* Remove buffer from the buffer queue */
> +       list_del(&vout->cur_frm->queue);
> +       /* Mark state of the current frame to active */
> +       vout->cur_frm->state = VIDEOBUF_ACTIVE;
> +       /* Initialize field_id and started member */
> +       vout->field_id = 0;
> +
> +       /* set flag here. Next QBUF will start DMA */
> +       vout->streaming = 1;
> +
> +       vout->first_int = 1;
> +
> +       if (omap_vout_calculate_offset(vout)) {
> +               ret = -EINVAL;
> +               goto streamon_err;
> +       }
> +       addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
> +               + vout->cropped_offset;
> +
> +       mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> +               DISPC_IRQ_EVSYNC_ODD;
> +
> +       omap_dispc_register_isr(omap_vout_isr, vout, mask);
> +
> +       for (j = 0; j < ovid->num_overlays; j++) {
> +               struct omap_overlay *ovl = ovid->overlays[j];
> +               if (ovl->manager && ovl->manager->device) {
> +                       struct omap_overlay_info info;
> +                       ovl->get_overlay_info(ovl, &info);
> +                       info.enabled = 1;
> +                       info.paddr = addr;
> +                       if (ovl->set_overlay_info(ovl, &info)) {
> +                               ret = -EINVAL;
> +                               goto streamon_err;
> +                       }
> +               }
> +       }
> +
> +       /* First save the configuration in ovelray structure */
> +       ret = omapvid_init(vout, addr);
> +       if (ret)
> +               v4l2_err(&vout->vid_dev->v4l2_dev,
> +                               "failed to set overlay info\n");
> +       /* Enable the pipeline and set the Go bit */
> +       ret = omapvid_apply_changes(vout);
> +       if (ret)
> +               v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
> +
> +       ret = 0;
> +
> +streamon_err:

In some error cases,  the videobuf_streamon() is already called. So
you have to call videobuf_streamoff() before return

> +       mutex_unlock(&vout->lock);
> +       return ret;
> +}
> +
> +static int vidioc_streamoff(struct file *file, void *fh,
> +                       enum v4l2_buf_type i)
> +{
> +       u32 mask = 0;
> +       int ret = 0, j;
> +       struct omap_vout_device *vout = fh;
> +       struct omapvideo_info *ovid = &vout->vid_info;
> +
> +       if (!vout->streaming)
> +               return -EINVAL;
> +
> +       vout->streaming = 0;
> +       mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> +               DISPC_IRQ_EVSYNC_ODD;
> +
> +       omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
> +
> +       for (j = 0; j < ovid->num_overlays; j++) {
> +               struct omap_overlay *ovl = ovid->overlays[j];
> +               if (ovl->manager && ovl->manager->device) {
> +                       struct omap_overlay_info info;
> +
> +                       ovl->get_overlay_info(ovl, &info);
> +                       info.enabled = 0;
> +                       ret = ovl->set_overlay_info(ovl, &info);
> +                       if (ret) {
> +                               v4l2_err(&vout->vid_dev->v4l2_dev,
> +                                       "failed to update overlay info\n");
> +                               return ret;

This is a failure.  In that case shouldn't we call videobuf_streamoff,
videobuf_queue_cancel etc as done below?

> +                       }
> +               }
> +       }
> +
> +       /* Turn of the pipeline */
> +       ret = omapvid_apply_changes(vout);
> +       if (ret) {
> +               v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
> +               return ret;
> +       }

Ditto,

> +       INIT_LIST_HEAD(&vout->dma_queue);
> +       videobuf_streamoff(&vout->vbq);
> +       videobuf_queue_cancel(&vout->vbq);
> +
> +       return 0;
> +}
> +


-----------------------------------------



> +
> +/* Init functions used during driver intitalization */
> +/* Initial setup of video_data */
> +static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
> +{
> +       struct video_device *vfd;
> +       struct v4l2_pix_format *pix;
> +       struct v4l2_control *control;
> +       struct omap_dss_device *display =
> +               vout->vid_info.overlays[0]->manager->device;
> +
> +       /* set the default pix */
> +       pix = &vout->pix;
> +
> +       /* Set the default picture of QVGA  */
> +       pix->width = QQVGA_WIDTH;
> +       pix->height = QQVGA_HEIGHT;
> +
> +       /* Default pixel format is RGB 5-6-5 */
> +       pix->pixelformat = V4L2_PIX_FMT_RGB565;
> +       pix->field = V4L2_FIELD_ANY;
> +       pix->bytesperline = pix->width * 2;
> +       pix->sizeimage = pix->bytesperline * pix->height;
> +       pix->priv = 0;
> +       pix->colorspace = V4L2_COLORSPACE_JPEG;
> +
> +       vout->bpp = RGB565_BPP;
> +       vout->fbuf.fmt.width  =  display->panel.timings.x_res;
> +       vout->fbuf.fmt.height =  display->panel.timings.y_res;
> +
> +       /* Set the data structures for the overlay parameters*/
> +       vout->win.global_alpha = 255;
> +       vout->fbuf.flags = 0;
> +       vout->fbuf.capability = V4L2_FBUF_CAP_LOCAL_ALPHA |
> +               V4L2_FBUF_CAP_SRC_CHROMAKEY | V4L2_FBUF_CAP_CHROMAKEY;
> +       vout->win.chromakey = 0;
> +
> +       omap_vout_new_format(pix, &vout->fbuf, &vout->crop, &vout->win);
> +
> +       /*Initialize the control variables for
> +         rotation, flipping and background color. */
> +       control = vout->control;
> +       control[0].id = V4L2_CID_ROTATE;
> +       control[0].value = 0;
> +       vout->rotation = 0;
> +       vout->mirror = 0;
> +       vout->control[2].id = V4L2_CID_HFLIP;
> +       vout->control[2].value = 0;
> +       vout->vrfb_bpp = 2;
> +
> +       control[1].id = V4L2_CID_BG_COLOR;
> +       control[1].value = 0;
> +
> +       /* initialize the video_device struct */
> +       vfd = vout->vfd = video_device_alloc();
> +
> +       if (!vfd) {
> +               printk(KERN_ERR VOUT_NAME ": could not allocate"
> +                               " video device struct\n");
> +               return -ENOMEM;
> +       }
> +       vfd->release = video_device_release;
> +       vfd->ioctl_ops = &vout_ioctl_ops;
> +
> +       strlcpy(vfd->name, VOUT_NAME, sizeof(vfd->name));
> +       vfd->vfl_type = VFL_TYPE_GRABBER;
> +
> +       /* need to register for a VID_HARDWARE_* ID in videodev.h */
> +       vfd->fops = &omap_vout_fops;
> +       mutex_init(&vout->lock);
> +
> +       vfd->minor = -1;
> +       return 0;
> +
> +}
> +
> +/* Setup video buffers */
> +static int __init omap_vout_setup_video_bufs(struct platform_device *pdev,
> +               int vid_num)
> +{
> +       u32 numbuffers;
> +       int ret = 0, i, j;
> +       int image_width, image_height;
> +       struct video_device *vfd;
> +       struct omap_vout_device *vout;
> +       int static_vrfb_allocation = 0, vrfb_num_bufs = 4;
> +       struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> +       struct omap2video_device *vid_dev =
> +               container_of(v4l2_dev, struct omap2video_device, v4l2_dev);
> +
> +       vout = vid_dev->vouts[vid_num];
> +       vfd = vout->vfd;
> +
> +       numbuffers = (vid_num == 0) ? video1_numbuffers : video2_numbuffers;
> +       vout->buffer_size = (vid_num == 0) ? video1_bufsize : video2_bufsize;
> +       dev_info(&pdev->dev, "Buffer Size = %d\n", vout->buffer_size);
> +
> +       for (i = 0; i < numbuffers; i++) {
> +               vout->buf_virt_addr[i] =
> +                       omap_vout_alloc_buffer(vout->buffer_size,
> +                                       (u32 *) &vout->buf_phy_addr[i]);
> +               if (!vout->buf_virt_addr[i]) {
> +                       numbuffers = i;
> +                       ret = -ENOMEM;
> +                       goto free_buffers;
> +               }
> +       }
> +
> +       for (i = 0; i < 4; i++) {

Can we replace magic number 4 with a #define? I see this number at
several places in the code.


> +               if (omap_vrfb_request_ctx(&vout->vrfb_context[i])) {
> +                       dev_info(&pdev->dev, ": VRFB allocation failed\n");
> +                       for (j = 0; j < i; j++)
> +                               omap_vrfb_release_ctx(&vout->vrfb_context[j]);
> +                       ret = -ENOMEM;
> +                       goto free_buffers;
> +               }
> +       }
> +       vout->cropped_offset = 0;
> +
> +       /* Calculate VRFB memory size */
> +       /* allocate for worst case size */
> +       image_width = VID_MAX_WIDTH / TILE_SIZE;
> +       if (VID_MAX_WIDTH % TILE_SIZE)
> +               image_width++;
> +
> +       image_width = image_width * TILE_SIZE;
> +       image_height = VID_MAX_HEIGHT / TILE_SIZE;
> +
> +       if (VID_MAX_HEIGHT % TILE_SIZE)
> +               image_height++;
> +
> +       image_height = image_height * TILE_SIZE;
> +       vout->smsshado_size = PAGE_ALIGN(image_width * image_height * 2 * 2);
> +
> +       /*
> +        * Request and Initialize DMA, for DMA based VRFB transfer
> +        */
> +       vout->vrfb_dma_tx.dev_id = OMAP_DMA_NO_DEVICE;
> +       vout->vrfb_dma_tx.dma_ch = -1;
> +       vout->vrfb_dma_tx.req_status = DMA_CHAN_ALLOTED;
> +       ret = omap_request_dma(vout->vrfb_dma_tx.dev_id, "VRFB DMA TX",
> +                       omap_vout_vrfb_dma_tx_callback,
> +                       (void *) &vout->vrfb_dma_tx, &vout->vrfb_dma_tx.dma_ch);
> +       if (ret < 0) {
> +               vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
> +               dev_info(&pdev->dev, ": failed to allocate DMA Channel for"
> +                               " video%d\n", vfd->minor);
> +       }
> +       init_waitqueue_head(&vout->vrfb_dma_tx.wait);
> +
> +       /* Allocate VRFB buffers if selected through bootargs */
> +       static_vrfb_allocation = (vid_num == 0) ?
> +               vid1_static_vrfb_alloc : vid2_static_vrfb_alloc;
> +
> +       /* statically allocated the VRFB buffer is done through
> +          commands line aruments */
> +       if (static_vrfb_allocation) {
> +               if (omap_vout_allocate_vrfb_buffers(vout, &vrfb_num_bufs, -1)) {
> +                       ret =  -ENOMEM;
> +                       goto release_vrfb_ctx;;
> +               }
> +               vout->vrfb_static_allocation = 1;
> +       }
> +       return 0;
> +
> +release_vrfb_ctx:
> +       for (j = 0; j < 4; j++)
> +               omap_vrfb_release_ctx(&vout->vrfb_context[j]);
> +
> +free_buffers:
> +       for (i = 0; i < numbuffers; i++) {
> +               omap_vout_free_buffer(vout->buf_virt_addr[i],
> +                                               vout->buffer_size);
> +               vout->buf_virt_addr[i] = 0;
> +               vout->buf_phy_addr[i] = 0;
> +       }
> +       return ret;
> +
> +}
> +
> +/* Create video out devices */
> +static int __init omap_vout_create_video_devices(struct platform_device *pdev)
> +{
> +       int ret = 0, k;
> +       struct omap_vout_device *vout;
> +       struct video_device *vfd = NULL;
> +       struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> +
> +       struct omap2video_device *vid_dev = container_of(v4l2_dev,
> +                       struct omap2video_device, v4l2_dev);
> +
> +       for (k = 0; k < pdev->num_resources; k++) {
> +
> +               vout = kmalloc(sizeof(struct omap_vout_device), GFP_KERNEL);
> +               if (!vout) {
> +                       dev_err(&pdev->dev, ": could not allocate memory\n");
> +                       return -ENOMEM;
> +               }
> +               memset(vout, 0, sizeof(struct omap_vout_device));
> +
> +               vout->vid = k;
> +               vid_dev->vouts[k] = vout;
> +               vout->vid_dev = vid_dev;
> +               /* Select video2 if only 1 overlay is controlled by V4L2 */
> +               if (pdev->num_resources == 1)
> +                       vout->vid_info.overlays[0] = vid_dev->overlays[k + 2];
> +               else
> +                       /* Else select video1 and video2 one by one. */
> +                       vout->vid_info.overlays[0] = vid_dev->overlays[k + 1];
> +               vout->vid_info.num_overlays = 1;
> +               vout->vid_info.id = k + 1;
> +               vid_dev->num_videos++;
> +
> +               /* Setup the default configuration for the video devices
> +                */
> +               if (omap_vout_setup_video_data(vout) != 0) {
> +                       ret = -ENOMEM;
> +                       goto error;
> +               }
> +
> +               /* Allocate default number of buffers for the video streaming
> +                * and reserve the VRFB space for rotation
> +                */
> +               if (omap_vout_setup_video_bufs(pdev, k) != 0) {
> +                       ret = -ENOMEM;
> +                       goto error1;
> +               }
> +
> +               /* Register the Video device with V4L2
> +                */
> +               vfd = vout->vfd;
> +               if (video_register_device(vfd, VFL_TYPE_GRABBER, k + 1) < 0) {
> +                       dev_err(&pdev->dev, ": Could not register "
> +                                       "Video for Linux device\n");
> +                       vfd->minor = -1;
> +                       ret = -ENODEV;
> +                       goto error2;
> +               }
> +               video_set_drvdata(vfd, vout);
> +
> +               /* Configure the overlay structure */
> +               ret = omapvid_init(vid_dev->vouts[k], 0);
> +               if (!ret)
> +                       goto success;
> +
> +error2:
> +               omap_vout_release_vrfb(vout);
> +               omap_vout_free_buffers(vout);
> +error1:
> +               video_device_release(vfd);
> +error:
> +               kfree(vout);
> +               return ret;
> +
> +success:
> +               dev_info(&pdev->dev, ": registered and initialized"
> +                               " video device %d\n", vfd->minor);
> +               if (k == (pdev->num_resources - 1))
> +                       return 0;
> +       }
> +
> +       return -ENODEV;
> +}
> +/* Driver functions */
> +static int omap_vout_remove(struct platform_device *pdev)
> +{
> +       int k;
> +       struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> +       struct omap2video_device *vid_dev = container_of(v4l2_dev, struct
> +                       omap2video_device, v4l2_dev);
> +
> +       v4l2_device_unregister(v4l2_dev);
> +       for (k = 0; k < pdev->num_resources; k++)
> +               omap_vout_cleanup_device(vid_dev->vouts[k]);
> +
> +       for (k = 0; k < vid_dev->num_displays; k++) {
> +               if (vid_dev->displays[k]->state != OMAP_DSS_DISPLAY_DISABLED)
> +                       vid_dev->displays[k]->disable(vid_dev->displays[k]);
> +
> +               omap_dss_put_device(vid_dev->displays[k]);
> +       }
> +       kfree(vid_dev);
> +       return 0;
> +}
> +
> +static int __init omap_vout_probe(struct platform_device *pdev)
> +{
> +       int ret = 0, i;
> +       struct omap_overlay *ovl;
> +       struct omap_dss_device *dssdev = NULL;
> +       struct omap_dss_device *def_display;
> +       struct omap2video_device *vid_dev = NULL;
> +
> +       if (pdev->num_resources == 0) {
> +               dev_err(&pdev->dev, "probed for an unknown device\n");
> +               return -ENODEV;
> +       }
> +
> +       vid_dev = kzalloc(sizeof(struct omap2video_device), GFP_KERNEL);
> +       if (vid_dev == NULL)
> +               return -ENOMEM;
> +
> +       vid_dev->num_displays = 0;
> +       for_each_dss_dev(dssdev) {
> +               omap_dss_get_device(dssdev);
> +               vid_dev->displays[vid_dev->num_displays++] = dssdev;
> +       }
> +
> +       if (vid_dev->num_displays == 0) {
> +               dev_err(&pdev->dev, "no displays\n");
> +               ret = -EINVAL;
> +               goto probe_err0;
> +       }
> +
> +       vid_dev->num_overlays = omap_dss_get_num_overlays();
> +       for (i = 0; i < vid_dev->num_overlays; i++)
> +               vid_dev->overlays[i] = omap_dss_get_overlay(i);
> +
> +       vid_dev->num_managers = omap_dss_get_num_overlay_managers();
> +       for (i = 0; i < vid_dev->num_managers; i++)
> +               vid_dev->managers[i] = omap_dss_get_overlay_manager(i);
> +
> +       /* Get the Video1 overlay and video2 overlay.
> +        * Setup the Display attached to that overlays
> +        */
> +       for (i = 1; i < 3; i++) {

Can we replace magic number 3 with a #define ?

> +               ovl = omap_dss_get_overlay(i);
> +               if (ovl->manager && ovl->manager->device) {
> +                       def_display = ovl->manager->device;
> +               } else {
> +                       dev_warn(&pdev->dev, "cannot find display\n");
> +                       def_display = NULL;
> +               }
> +               if (def_display) {
> +                       ret = def_display->enable(def_display);
> +                       if (ret) {
> +                               /* Here we are not considering a error
> +                                *  as display may be enabled by frame
> +                                *  buffer driver
> +                                */
> +                               dev_warn(&pdev->dev,
> +                                       "'%s' Display already enabled\n",
> +                                       def_display->name);
> +                       }
> +                       /* set the update mode */
> +                       if (def_display->caps &
> +                                       OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
> +#ifdef CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
> +                               if (def_display->enable_te)
> +                                       def_display->enable_te(def_display, 1);
> +                               if (def_display->set_update_mode)
> +                                       def_display->set_update_mode(def_display,
> +                                                       OMAP_DSS_UPDATE_AUTO);
> +#else  /* MANUAL_UPDATE */
> +                               if (def_display->enable_te)
> +                                       def_display->enable_te(def_display, 0);
> +                               if (def_display->set_update_mode)
> +                                       def_display->set_update_mode(def_display,
> +                                                       OMAP_DSS_UPDATE_MANUAL);
> +#endif
> +                       } else {
> +                               if (def_display->set_update_mode)
> +                                       def_display->set_update_mode(def_display,
> +                                                       OMAP_DSS_UPDATE_AUTO);
> +                       }
> +               }
> +       }
> +
> +       if (v4l2_device_register(&pdev->dev, &vid_dev->v4l2_dev) < 0) {
> +               dev_err(&pdev->dev, "v4l2_device_register failed\n");
> +               ret = -ENODEV;
> +               goto probe_err1;
> +       }
> +
> +       ret = omap_vout_create_video_devices(pdev);
> +       if (ret)
> +               goto probe_err2;
> +
> +       for (i = 0; i < vid_dev->num_displays; i++) {
> +               struct omap_dss_device *display = vid_dev->displays[i];
> +
> +               if (display->update)
> +                       display->update(display, 0, 0,
> +                                       display->panel.timings.x_res,
> +                                       display->panel.timings.y_res);
> +       }
> +       return 0;
> +
> +probe_err2:
> +       v4l2_device_unregister(&vid_dev->v4l2_dev);
> +probe_err1:
> +       for (i = 1; i < 3; i++) {

replace magic number 3 with #define constant.

> +               def_display = NULL;
> +               ovl = omap_dss_get_overlay(i);
> +               if (ovl->manager && ovl->manager->device)
> +                       def_display = ovl->manager->device;
> +
> +               if (def_display)
> +                       def_display->disable(def_display);
> +       }
> +probe_err0:
> +       kfree(vid_dev);
> +       return ret;
> +}
> +
> +static struct platform_driver omap_vout_driver = {
> +       .driver = {
> +               .name = VOUT_NAME,
> +       },
> +       .probe = omap_vout_probe,
> +       .remove = omap_vout_remove,
> +};
> +
> +void omap_vout_isr(void *arg, unsigned int irqstatus)
> +{
> +       int ret;
> +       u32 addr, fid;
> +       struct omap_overlay *ovl;
> +       struct timeval timevalue;
> +       struct omapvideo_info *ovid;
> +       struct omap_dss_device *cur_display;
> +       struct omap_vout_device *vout = (struct omap_vout_device *)arg;
> +
> +       if (!vout->streaming)
> +               return;
> +
> +       ovid = &vout->vid_info;
> +       ovl = ovid->overlays[0];
> +       /* get the display device attached to the overlay */
> +       if (!ovl->manager || !ovl->manager->device)
> +               return;
> +       cur_display = ovl->manager->device;
> +
> +       spin_lock(&vout->vbq_lock);
> +       do_gettimeofday(&timevalue);
> +       if (cur_display->type == OMAP_DISPLAY_TYPE_DPI) {
> +               if (!(irqstatus & DISPC_IRQ_VSYNC))
> +                       goto vout_isr_err;
> +
> +               if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
> +                       vout->cur_frm->ts = timevalue;
> +                       vout->cur_frm->state = VIDEOBUF_DONE;
> +                       wake_up_interruptible(&vout->cur_frm->done);
> +                       vout->cur_frm = vout->next_frm;
> +               }
> +               vout->first_int = 0;
> +               if (list_empty(&vout->dma_queue))
> +                       goto vout_isr_err;
> +
> +               vout->next_frm = list_entry(vout->dma_queue.next,
> +                               struct videobuf_buffer, queue);
> +               list_del(&vout->next_frm->queue);
> +
> +               vout->next_frm->state = VIDEOBUF_ACTIVE;
> +
> +               addr = (unsigned long) vout->queued_buf_addr[vout->next_frm->i]
> +                       + vout->cropped_offset;
> +
> +               /* First save the configuration in ovelray structure */
> +               ret = omapvid_init(vout, addr);
> +               if (ret)
> +                       printk(KERN_ERR VOUT_NAME
> +                                       "failed to set overlay info\n");
> +               /* Enable the pipeline and set the Go bit */
> +               ret = omapvid_apply_changes(vout);
> +               if (ret)
> +                       printk(KERN_ERR VOUT_NAME "failed to change mode\n");
> +       } else {
> +
> +               if (vout->first_int) {
> +                       vout->first_int = 0;
> +                       goto vout_isr_err;
> +               }
> +               if (irqstatus & DISPC_IRQ_EVSYNC_ODD)
> +                       fid = 1;
> +               else if (irqstatus & DISPC_IRQ_EVSYNC_EVEN)
> +                       fid = 0;
> +               else
> +                       goto vout_isr_err;
> +
> +               vout->field_id ^= 1;
> +               if (fid != vout->field_id) {
> +                       if (0 == fid)
> +                               vout->field_id = fid;
> +
> +                       goto vout_isr_err;
> +               }
> +               if (0 == fid) {
> +                       if (vout->cur_frm == vout->next_frm)
> +                               goto vout_isr_err;
> +
> +                       vout->cur_frm->ts = timevalue;
> +                       vout->cur_frm->state = VIDEOBUF_DONE;
> +                       wake_up_interruptible(&vout->cur_frm->done);
> +                       vout->cur_frm = vout->next_frm;
> +               } else if (1 == fid) {
> +                       if (list_empty(&vout->dma_queue) ||
> +                                       (vout->cur_frm != vout->next_frm))
> +                               goto vout_isr_err;
> +
> +                       vout->next_frm = list_entry(vout->dma_queue.next,
> +                                       struct videobuf_buffer, queue);
> +                       list_del(&vout->next_frm->queue);
> +
> +                       vout->next_frm->state = VIDEOBUF_ACTIVE;
> +                       addr = (unsigned long)
> +                               vout->queued_buf_addr[vout->next_frm->i] +
> +                               vout->cropped_offset;
> +                       /* First save the configuration in ovelray structure */
> +                       ret = omapvid_init(vout, addr);
> +                       if (ret)
> +                               printk(KERN_ERR VOUT_NAME
> +                                               "failed to set overlay info\n");
> +                       /* Enable the pipeline and set the Go bit */
> +                       ret = omapvid_apply_changes(vout);
> +                       if (ret)
> +                               printk(KERN_ERR VOUT_NAME
> +                                               "failed to change mode\n");
> +               }
> +
> +       }
> +
> +vout_isr_err:
> +       spin_unlock(&vout->vbq_lock);
> +}
> +
> +static void omap_vout_cleanup_device(struct omap_vout_device *vout)
> +{
> +       struct video_device *vfd;
> +
> +       if (!vout)
> +               return;

Is this possible to happen since device is already initialized and
this would have been checked already?

> +
> +       vfd = vout->vfd;
> +       if (vfd) {
> +               if (vfd->minor == -1) {
> +                       /*
> +                        * The device was never registered, so release the
> +                        * video_device struct directly.
> +                        */
> +                       video_device_release(vfd);

I think there is an v4l2 api to check if the device is registered
instead of checking the minor number. video_is_registered() can be
used here.

> +               } else {
> +                       /*
> +                        * The unregister function will release the video_device
> +                        * struct as well as unregistering it.
> +                        */
> +                       video_unregister_device(vfd);
> +               }
> +       }
> +
> +       omap_vout_release_vrfb(vout);
> +       omap_vout_free_buffers(vout);
> +       /* Free the VRFB buffer if allocated
> +        * init time
> +        */
> +       if (vout->vrfb_static_allocation)
> +               omap_vout_free_vrfb_buffers(vout);
> +
> +       kfree(vout);
> +}
> +
> +static int __init omap_vout_init(void)
> +{
> +       if (platform_driver_register(&omap_vout_driver) != 0) {
> +               printk(KERN_ERR VOUT_NAME ":Could not register Video driver\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static void omap_vout_cleanup(void)
> +{
> +       platform_driver_unregister(&omap_vout_driver);
> +}
> +
> +late_initcall(omap_vout_init);
> +module_exit(omap_vout_cleanup);
> diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
> new file mode 100644
> index 0000000..6d897f7
> --- /dev/null
> +++ b/drivers/media/video/omap/omap_voutdef.h
> @@ -0,0 +1,148 @@
> +/*
> + * omap_voutdef.h
> + *
> + * Copyright (C) 2010 Texas Instruments.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef OMAP_VOUTDEF_H
> +#define OMAP_VOUTDEF_H
> +
> +#include <plat/display.h>
> +
> +#define YUYV_BPP        2
> +#define RGB565_BPP      2
> +#define RGB24_BPP       3
> +#define RGB32_BPP       4
> +#define TILE_SIZE       32
> +#define YUYV_VRFB_BPP   2
> +#define RGB_VRFB_BPP    1
> +#define MAX_CID                3
> +#define MAC_VRFB_CTXS  4
> +#define MAX_VOUT_DEV   2
> +#define MAX_OVLS       3
> +#define MAX_DISPLAYS   3
> +#define MAX_MANAGERS   3
> +
> +/* Enum for Rotation
> + * DSS understands rotation in 0, 1, 2, 3 context
> + * while V4L2 driver understands it as 0, 90, 180, 270
> + */
> +enum dss_rotation {
> +       dss_rotation_0_degree   = 0,
> +       dss_rotation_90_degree  = 1,
> +       dss_rotation_180_degree = 2,
> +       dss_rotation_270_degree = 3,
> +};
> +/*
> + * This structure is used to store the DMA transfer parameters
> + * for VRFB hidden buffer
> + */
> +struct vid_vrfb_dma {
> +       int dev_id;
> +       int dma_ch;
> +       int req_status;
> +       int tx_status;
> +       wait_queue_head_t wait;
> +};
> +
> +struct omapvideo_info {
> +       int id;
> +       int num_overlays;
> +       struct omap_overlay *overlays[MAX_OVLS];
> +};
> +
> +struct omap2video_device {
> +       struct mutex  mtx;
> +
> +       int state;
> +
> +       struct v4l2_device v4l2_dev;
> +       int num_videos;
> +       struct omap_vout_device *vouts[MAX_VOUT_DEV];
> +
> +       int num_displays;
> +       struct omap_dss_device *displays[MAX_DISPLAYS];
> +       int num_overlays;
> +       struct omap_overlay *overlays[MAX_OVLS];
> +       int num_managers;
> +       struct omap_overlay_manager *managers[MAX_MANAGERS];
> +};
> +
> +/* per-device data structure */
> +struct omap_vout_device {
> +
> +       struct omapvideo_info vid_info;
> +       struct video_device *vfd;
> +       struct omap2video_device *vid_dev;
> +       int vid;
> +       int opened;
> +
> +       /* we don't allow to change image fmt/size once buffer has
> +        * been allocated
> +        */
> +       int buffer_allocated;
> +       /* allow to reuse previously allocated buffer which is big enough */
> +       int buffer_size;
> +       /* keep buffer info across opens */
> +       unsigned long buf_virt_addr[VIDEO_MAX_FRAME];
> +       unsigned long buf_phy_addr[VIDEO_MAX_FRAME];
> +       enum omap_color_mode dss_mode;
> +
> +       /* we don't allow to request new buffer when old buffers are
> +        * still mmaped
> +        */
> +       int mmap_count;
> +
> +       spinlock_t vbq_lock;            /* spinlock for videobuf queues */
> +       unsigned long field_count;      /* field counter for videobuf_buffer */
> +
> +       /* non-NULL means streaming is in progress. */
> +       bool streaming;
> +
> +       struct v4l2_pix_format pix;
> +       struct v4l2_rect crop;
> +       struct v4l2_window win;
> +       struct v4l2_framebuffer fbuf;
> +
> +       /* Lock to protect the shared data structures in ioctl */
> +       struct mutex lock;
> +
> +       /* V4L2 control structure for different control id */
> +       struct v4l2_control control[MAX_CID];
> +       enum dss_rotation rotation;
> +       bool mirror;
> +       int flicker_filter;
> +       /* V4L2 control structure for different control id */
> +
> +       int bpp; /* bytes per pixel */
> +       int vrfb_bpp; /* bytes per pixel with respect to VRFB */
> +
> +       struct vid_vrfb_dma vrfb_dma_tx;
> +       unsigned int smsshado_phy_addr[MAC_VRFB_CTXS];
> +       unsigned int smsshado_virt_addr[MAC_VRFB_CTXS];
> +       struct vrfb vrfb_context[MAC_VRFB_CTXS];
> +       bool vrfb_static_allocation;
> +       unsigned int smsshado_size;
> +       unsigned char pos;
> +
> +       int ps, vr_ps, line_length, first_int, field_id;
> +       enum v4l2_memory memory;
> +       struct videobuf_buffer *cur_frm, *next_frm;
> +       struct list_head dma_queue;
> +       u8 *queued_buf_addr[VIDEO_MAX_FRAME];
> +       u32 cropped_offset;
> +       s32 tv_field1_offset;
> +       void *isr_handle;
> +
> +       /* Buffer queue variables */
> +       struct omap_vout_device *vout;
> +       enum v4l2_buf_type type;
> +       struct videobuf_queue vbq;
> +       int io_allowed;
> +
> +};
> +#endif /* ifndef OMAP_VOUTDEF_H */
> diff --git a/drivers/media/video/omap/omap_voutlib.c b/drivers/media/video/omap/omap_voutlib.c
> new file mode 100644
> index 0000000..05c0e17
> --- /dev/null
> +++ b/drivers/media/video/omap/omap_voutlib.c
> @@ -0,0 +1,258 @@
> +/*
> + * omap_voutlib.c
> + *
> + * Copyright (C) 2005-2010 Texas Instruments.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + * Based on the OMAP2 camera driver
> + * Video-for-Linux (Version 2) camera capture driver for
> + * the OMAP24xx camera controller.
> + *
> + * Author: Andy Lowe (source@mvista.com)
> + *
> + * Copyright (C) 2004 MontaVista Software, Inc.
> + * Copyright (C) 2010 Texas Instruments.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_DESCRIPTION("OMAP Video library");
> +MODULE_LICENSE("GPL");
> +
> +/* Return the default overlay cropping rectangle in crop given the image
> + * size in pix and the video display size in fbuf.  The default
> + * cropping rectangle is the largest rectangle no larger than the capture size
> + * that will fit on the display.  The default cropping rectangle is centered in
> + * the image.  All dimensions and offsets are rounded down to even numbers.
> + */
> +void omap_vout_default_crop(struct v4l2_pix_format *pix,
> +                 struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop)
> +{
> +       crop->width = (pix->width < fbuf->fmt.width) ?
> +               pix->width : fbuf->fmt.width;
> +       crop->height = (pix->height < fbuf->fmt.height) ?
> +               pix->height : fbuf->fmt.height;
> +       crop->width &= ~1;
> +       crop->height &= ~1;
> +       crop->left = ((pix->width - crop->width) >> 1) & ~1;
> +       crop->top = ((pix->height - crop->height) >> 1) & ~1;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_default_crop);
> +
> +/* Given a new render window in new_win, adjust the window to the
> + * nearest supported configuration.  The adjusted window parameters are
> + * returned in new_win.
> + * Returns zero if succesful, or -EINVAL if the requested window is
> + * impossible and cannot reasonably be adjusted.
> + */
> +int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
> +                       struct v4l2_window *new_win)
> +{
> +       struct v4l2_rect try_win;
> +
> +       /* make a working copy of the new_win rectangle */
> +       try_win = new_win->w;
> +
> +       /* adjust the preview window so it fits on the display by clipping any
> +        * offscreen areas
> +        */
> +       if (try_win.left < 0) {
> +               try_win.width += try_win.left;
> +               try_win.left = 0;
> +       }
> +       if (try_win.top < 0) {
> +               try_win.height += try_win.top;
> +               try_win.top = 0;
> +       }
> +       try_win.width = (try_win.width < fbuf->fmt.width) ?
> +               try_win.width : fbuf->fmt.width;
> +       try_win.height = (try_win.height < fbuf->fmt.height) ?
> +               try_win.height : fbuf->fmt.height;
> +       if (try_win.left + try_win.width > fbuf->fmt.width)
> +               try_win.width = fbuf->fmt.width - try_win.left;
> +       if (try_win.top + try_win.height > fbuf->fmt.height)
> +               try_win.height = fbuf->fmt.height - try_win.top;
> +       try_win.width &= ~1;
> +       try_win.height &= ~1;
> +
> +       if (try_win.width <= 0 || try_win.height <= 0)
> +               return -EINVAL;
> +
> +       /* We now have a valid preview window, so go with it */
> +       new_win->w = try_win;
> +       new_win->field = V4L2_FIELD_ANY;
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_try_window);
> +
> +/* Given a new render window in new_win, adjust the window to the
> + * nearest supported configuration.  The image cropping window in crop
> + * will also be adjusted if necessary.  Preference is given to keeping the
> + * the window as close to the requested configuration as possible.  If
> + * successful, new_win, vout->win, and crop are updated.
> + * Returns zero if succesful, or -EINVAL if the requested preview window is
> + * impossible and cannot reasonably be adjusted.
> + */
> +int omap_vout_new_window(struct v4l2_rect *crop,
> +               struct v4l2_window *win, struct v4l2_framebuffer *fbuf,
> +               struct v4l2_window *new_win)
> +{
> +       int err;
> +
> +       err = omap_vout_try_window(fbuf, new_win);
> +       if (err)
> +               return err;
> +
> +       /* update our preview window */
> +       win->w = new_win->w;
> +       win->field = new_win->field;
> +       win->chromakey = new_win->chromakey;
> +
> +       /* adjust the cropping window to allow for resizing limitations */
> +       if ((crop->height/win->w.height) >= 4) {
> +               /* The maximum vertical downsizing ratio is 4:1 */
> +               crop->height = win->w.height * 4;
> +       }
> +       if ((crop->width/win->w.width) >= 4) {
> +               /* The maximum horizontal downsizing ratio is 4:1 */
> +               crop->width = win->w.width * 4;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_new_window);
> +
> +/* Given a new cropping rectangle in new_crop, adjust the cropping rectangle to
> + * the nearest supported configuration.  The image render window in win will
> + * also be adjusted if necessary.  The preview window is adjusted such that the
> + * horizontal and vertical rescaling ratios stay constant.  If the render
> + * window would fall outside the display boundaries, the cropping rectangle
> + * will also be adjusted to maintain the rescaling ratios.  If successful, crop
> + * and win are updated.
> + * Returns zero if succesful, or -EINVAL if the requested cropping rectangle is
> + * impossible and cannot reasonably be adjusted.
> + */
> +int omap_vout_new_crop(struct v4l2_pix_format *pix,
> +             struct v4l2_rect *crop, struct v4l2_window *win,
> +             struct v4l2_framebuffer *fbuf, const struct v4l2_rect *new_crop)
> +{
> +       struct v4l2_rect try_crop;
> +       unsigned long vresize, hresize;
> +
> +       /* make a working copy of the new_crop rectangle */
> +       try_crop = *new_crop;
> +
> +       /* adjust the cropping rectangle so it fits in the image */
> +       if (try_crop.left < 0) {
> +               try_crop.width += try_crop.left;
> +               try_crop.left = 0;
> +       }
> +       if (try_crop.top < 0) {
> +               try_crop.height += try_crop.top;
> +               try_crop.top = 0;
> +       }
> +       try_crop.width = (try_crop.width < pix->width) ?
> +               try_crop.width : pix->width;
> +       try_crop.height = (try_crop.height < pix->height) ?
> +               try_crop.height : pix->height;
> +       if (try_crop.left + try_crop.width > pix->width)
> +               try_crop.width = pix->width - try_crop.left;
> +       if (try_crop.top + try_crop.height > pix->height)
> +               try_crop.height = pix->height - try_crop.top;
> +       try_crop.width &= ~1;
> +       try_crop.height &= ~1;
> +       if (try_crop.width <= 0 || try_crop.height <= 0)
> +               return -EINVAL;
> +
> +       if (crop->height != win->w.height) {
> +               /* If we're resizing vertically, we can't support a crop width
> +                * wider than 768 pixels.
> +                */
> +               if (try_crop.width > 768)
> +                       try_crop.width = 768;
> +       }
> +       /* vertical resizing */
> +       vresize = (1024 * crop->height) / win->w.height;
> +       if (vresize > 4096)
> +               vresize = 4096;
> +       else if (vresize == 0)
> +               vresize = 1;
> +       win->w.height = ((1024 * try_crop.height) / vresize) & ~1;
> +       if (win->w.height == 0)
> +               win->w.height = 2;
> +       if (win->w.height + win->w.top > fbuf->fmt.height) {
> +               /* We made the preview window extend below the bottom of the
> +                * display, so clip it to the display boundary and resize the
> +                * cropping height to maintain the vertical resizing ratio.
> +                */
> +               win->w.height = (fbuf->fmt.height - win->w.top) & ~1;
> +               if (try_crop.height == 0)
> +                       try_crop.height = 2;
> +       }
> +       /* horizontal resizing */
> +       hresize = (1024 * crop->width) / win->w.width;
> +       if (hresize > 4096)
> +               hresize = 4096;
> +       else if (hresize == 0)
> +               hresize = 1;
> +       win->w.width = ((1024 * try_crop.width) / hresize) & ~1;
> +       if (win->w.width == 0)
> +               win->w.width = 2;
> +       if (win->w.width + win->w.left > fbuf->fmt.width) {
> +               /* We made the preview window extend past the right side of the
> +                * display, so clip it to the display boundary and resize the
> +                * cropping width to maintain the horizontal resizing ratio.
> +                */
> +               win->w.width = (fbuf->fmt.width - win->w.left) & ~1;
> +               if (try_crop.width == 0)
> +                       try_crop.width = 2;
> +       }
> +
> +       /* Check for resizing constraints */
> +       if ((try_crop.height/win->w.height) >= 4) {
> +               /* The maximum vertical downsizing ratio is 4:1 */
> +               try_crop.height = win->w.height * 4;
> +       }
> +       if ((try_crop.width/win->w.width) >= 4) {
> +               /* The maximum horizontal downsizing ratio is 4:1 */
> +               try_crop.width = win->w.width * 4;
> +       }
> +
> +       /* update our cropping rectangle and we're done */
> +       *crop = try_crop;
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_new_crop);
> +
> +/* Given a new format in pix and fbuf,  crop and win
> + * structures are initialized to default values. crop
> + * is initialized to the largest window size that will fit on the display.  The
> + * crop window is centered in the image. win is initialized to
> + * the same size as crop and is centered on the display.
> + * All sizes and offsets are constrained to be even numbers.
> + */
> +void omap_vout_new_format(struct v4l2_pix_format *pix,
> +               struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
> +               struct v4l2_window *win)
> +{
> +       /* crop defines the preview source window in the image capture
> +        * buffer
> +        */
> +       omap_vout_default_crop(pix, fbuf, crop);
> +
> +       /* win defines the preview target window on the display */
> +       win->w.width = crop->width;
> +       win->w.height = crop->height;
> +       win->w.left = ((fbuf->fmt.width - win->w.width) >> 1) & ~1;
> +       win->w.top = ((fbuf->fmt.height - win->w.height) >> 1) & ~1;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_new_format);
> +
> diff --git a/drivers/media/video/omap/omap_voutlib.h b/drivers/media/video/omap/omap_voutlib.h
> new file mode 100644
> index 0000000..a60b16e
> --- /dev/null
> +++ b/drivers/media/video/omap/omap_voutlib.h
> @@ -0,0 +1,34 @@
> +/*
> + * omap_voutlib.h
> + *
> + * Copyright (C) 2010 Texas Instruments.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + */
> +
> +#ifndef OMAP_VOUTLIB_H
> +#define OMAP_VOUTLIB_H
> +
> +extern void omap_vout_default_crop(struct v4l2_pix_format *pix,
> +               struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop);
> +
> +extern int omap_vout_new_crop(struct v4l2_pix_format *pix,
> +               struct v4l2_rect *crop, struct v4l2_window *win,
> +               struct v4l2_framebuffer *fbuf,
> +               const struct v4l2_rect *new_crop);
> +
> +extern int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
> +               struct v4l2_window *new_win);
> +
> +extern int omap_vout_new_window(struct v4l2_rect *crop,
> +               struct v4l2_window *win, struct v4l2_framebuffer *fbuf,
> +               struct v4l2_window *new_win);
> +
> +extern void omap_vout_new_format(struct v4l2_pix_format *pix,
> +               struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
> +               struct v4l2_window *win);
> +#endif /* #ifndef OMAP_VOUTLIB_H */
> +
> --
> 1.6.2.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Murali Karicheri
mkaricheri@gmail.com
