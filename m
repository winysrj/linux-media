Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56231 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab0DFQkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 12:40:11 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Muralidharan Karicheri <mkaricheri@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>
Date: Tue, 6 Apr 2010 22:09:29 +0530
Subject: RE: [PATCH 1/2] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
 on 	top of DSS2
Message-ID: <19F8576C6E063C45BE387C64729E7394044DF7F789@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
	 <1270115880-21404-2-git-send-email-hvaibhav@ti.com>
 <z2j55a3e0ce1004021303rdf3092f7r87b119cd97687f9b@mail.gmail.com>
In-Reply-To: <z2j55a3e0ce1004021303rdf3092f7r87b119cd97687f9b@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Muralidharan Karicheri [mailto:mkaricheri@gmail.com]
> Sent: Saturday, April 03, 2010 1:33 AM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Karicheri, Muralidharan;
> mchehab@redhat.com; linux-omap@vger.kernel.org; tony@atomide.com
> Subject: Re: [PATCH 1/2] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
> on top of DSS2
>
> Vaibhav,
>
> I have some comments on this patch. Please address them.
>
[Hiremath, Vaibhav] Thanks Murali, I really appreciate your comments here. Please find response below -

> > +
> > +#include <asm/processor.h>
>
> Add a line here??
>
> > +#include <plat/dma.h>
> > +#include <plat/vram.h>
> > +#include <plat/vrfb.h>
> > +#include <plat/display.h>
> > +
> > +#include "omap_voutlib.h"
> > +#include "omap_voutdef.h"
> > +
> > +MODULE_AUTHOR("Texas Instruments");
> > +MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
> > +MODULE_LICENSE("GPL");
> > +
> > +
> > +/* Driver Configuration macros */
> > +#define VOUT_NAME              "omap_vout"
> > +
> > +enum omap_vout_channels {
> > +       OMAP_VIDEO1 = 0,
> Why do we have to initialize this to 0. It always start with a value 0
> by default.
>
> > +       OMAP_VIDEO2,
> > +};
> > +
> > +enum dma_channel_state {
> > +       DMA_CHAN_NOT_ALLOTED = 0,
>
> Ditto.
>
> > +       DMA_CHAN_ALLOTED,
> > +};
> > +
> > +#define QQVGA_WIDTH            160
> > +#define QQVGA_HEIGHT           120
> > +
> > +/* Max Resolution supported by the driver */
> > +#define VID_MAX_WIDTH          1280    /* Largest width */
> > +#define VID_MAX_HEIGHT         720     /* Largest height */
> > +
>
> -------------------------------------
>
> > +
> > +module_param(debug, bool, S_IRUGO);
> > +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> > +
> > +/* Local Helper functions */
> > +static void omap_vout_isr(void *arg, unsigned int irqstatus);
> > +static void omap_vout_cleanup_device(struct omap_vout_device *vout);
> > +
>
> Is there a reason why you need these prototypes? I think we could
> remove these prototypes and move the function ahead in the file before
> it is called.
>
[Hiremath, Vaibhav] Do you see any harm with this? I think its only implementation part. But still I will incorporate in next version.

> > +/* list of image formats supported by OMAP2 video pipelines */
> > +const static struct v4l2_fmtdesc omap_formats[] = {
> > +       {
> > +               /* Note:  V4L2 defines RGB565 as:
> > +                *
> > +                *      Byte 0                    Byte 1
> > +                *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
> > +                *
> > +                * We interpret RGB565 as:
> > +                *
> > +                *      Byte 0                    Byte 1
> > +                *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
> > +                */
> > +               .description = "RGB565, le",
> > +               .pixelformat = V4L2_PIX_FMT_RGB565,
> > +       },
> > +       {
> > +               /* Note:  V4L2 defines RGB32 as: RGB-8-8-8-8  we use
> > +                *  this for RGB24 unpack mode, the last 8 bits are
> ignored
> > +                * */
> > +               .description = "RGB32, le",
> > +               .pixelformat = V4L2_PIX_FMT_RGB32,
> > +       },
> > +       {
> > +               /* Note:  V4L2 defines RGB24 as: RGB-8-8-8  we use
> > +                *        this for RGB24 packed mode
> > +                *
> > +                */
> > +               .description = "RGB24, le",
> > +               .pixelformat = V4L2_PIX_FMT_RGB24,
> > +       },
> > +       {
> > +               .description = "YUYV (YUV 4:2:2), packed",
> > +               .pixelformat = V4L2_PIX_FMT_YUYV,
> > +       },
> > +       {
> > +               .description = "UYVY, packed",
> > +               .pixelformat = V4L2_PIX_FMT_UYVY,
> > +       },
> > +};
> > +
> > +#define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
> > +
> > +/*
> > + * Allocate buffers
> > + */
>
> ----------------------------------
>
> > +
> > +/*
> > + * omap_vout_uservirt_to_phys: This inline function is used to convert
> user
> > + * space virtual address to physical address.
> > + */
> > +static u32 omap_vout_uservirt_to_phys(u32 virtp)
> > +{
> > +       unsigned long physp = 0;
> > +       struct vm_area_struct *vma;
> > +       struct mm_struct *mm = current->mm;
> > +
> > +       vma = find_vma(mm, virtp);
> > +       /* For kernel direct-mapped memory, take the easy way */
> > +       if (virtp >= PAGE_OFFSET) {
> > +               physp = virt_to_phys((void *) virtp);
> > +       } else if (vma && (vma->vm_flags & VM_IO)
> > +                       && vma->vm_pgoff) {
> > +               /* this will catch, kernel-allocated,
> > +                  mmaped-to-usermode addresses */
> > +               physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma-
> >vm_start);
> > +       } else {
> > +               /* otherwise, use get_user_pages() for general userland
> pages */
> > +               int res, nr_pages = 1;
> > +               struct page *pages;
> > +               down_read(&current->mm->mmap_sem);
> > +
> > +               res = get_user_pages(current, current->mm, virtp,
> nr_pages,
> > +                               1, 0, &pages, NULL);
> > +               up_read(&current->mm->mmap_sem);
> > +
> > +               if (res == nr_pages) {
> > +                       physp =  __pa(page_address(&pages[0]) +
> > +                                       (virtp & ~PAGE_MASK));
> > +               } else {
> > +                       printk(KERN_WARNING VOUT_NAME
> > +                                       "get_user_pages failed\n");
> > +                       return 0;
> > +               }
> > +       }
> > +
> > +       return physp;
> > +}
>
> Shouldn't we remove omap_vout_uservirt_to_phys() and use videobuf_iolock()
> instead as we have done in vpfe_capture.c?
>
[Hiremath, Vaibhav] This change is in my TODO list, and since this patch series has been in queue since long time and has been tested for multiple releases I thought of adding this change in sub-sequent merges.

(Same approach which you followed for VPFE.)

> -------------------------------------------------
>
>
> > +
> > +/*
> > + * Convert V4L2 rotation to DSS rotation
> > + *     V4L2 understand 0, 90, 180, 270.
> > + *     Convert to 0, 1, 2 and 3 repsectively for DSS
> > + */
> > +static int v4l2_rot_to_dss_rot(int v4l2_rotation, enum dss_rotation
> *rotation,
> > +               bool mirror)
> > +{
> Suggest adding a variable int ret = 0;
> and return ret at the end of the function instead of return at each case.
>
[Hiremath, Vaibhav] Agreed and will incorporate in next version.

> > +       switch (v4l2_rotation) {
> > +       case 90:
> > +               *rotation = dss_rotation_90_degree;
> > +               return 0;
> use break instead of return here
> > +       case 180:
> > +               *rotation = dss_rotation_180_degree;
> > +               return 0;
> Ditto
> > +       case 270:
> > +               *rotation = dss_rotation_270_degree;
> > +               return 0;
> Ditto
> > +       case 0:
> > +               *rotation = dss_rotation_0_degree;
> > +               return 0;
> Ditto
> > +       default:
> > +               return -EINVAL;
>
> ret = -EINVAL;
>
> > +       }
>
> return ret;
> > +
> > +}
>
> ------------------------------------------------------------
>
>
>
> > +/*
> > + * Convert V4L2 pixel format to DSS pixel format
> > + */
> > +static enum omap_color_mode video_mode_to_dss_mode(struct
> omap_vout_device
> > +                       *vout)
> > +{
> > +       struct omap_overlay *ovl;
> > +       struct omapvideo_info *ovid;
> > +       struct v4l2_pix_format *pix = &vout->pix;
> > +
> > +       ovid = &vout->vid_info;
> > +       ovl = ovid->overlays[0];
> > +
> > +       switch (pix->pixelformat) {
> > +       case 0:
> > +               break;
> > +       case V4L2_PIX_FMT_YUYV:
> > +               return OMAP_DSS_COLOR_YUV2;
> > +
> > +       case V4L2_PIX_FMT_UYVY:
> > +               return OMAP_DSS_COLOR_UYVY;
> > +
> > +       case V4L2_PIX_FMT_RGB565:
> > +               return OMAP_DSS_COLOR_RGB16;
> > +
> > +       case V4L2_PIX_FMT_RGB24:
> > +               return OMAP_DSS_COLOR_RGB24P;
> > +
> > +       case V4L2_PIX_FMT_RGB32:
> > +               return (ovl->id == OMAP_DSS_VIDEO1) ?
> > +                       OMAP_DSS_COLOR_RGB24U : OMAP_DSS_COLOR_ARGB32;
> > +       case V4L2_PIX_FMT_BGR32:
> > +               return OMAP_DSS_COLOR_RGBX32;
> > +
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +       return -EINVAL;
>
> Also return type is eum and you are returning a negative number here ???
>
[Hiremath, Vaibhav] good catch, will fix in next version.

> > +}
>
> Similar comment for this function as well. return at the end of the
> function.
>
> > +
> > +/*
> > + * Setup the overlay
> > + */
> > +int omapvid_setup_overlay(struct omap_vout_device *vout,
> > +               struct omap_overlay *ovl, int posx, int posy, int outw,
> > +               int outh, u32 addr)
>
> -----------------------------------------------------------------
>
>
>
> > +
> > +static int vidioc_try_fmt_vid_out(struct file *file, void *fh,
> > +                       struct v4l2_format *f)
> > +{
> > +       struct omap_overlay *ovl;
> > +       struct omapvideo_info *ovid;
> > +       struct omap_video_timings *timing;
> > +       struct omap_vout_device *vout = fh;
> > +
> > +       if (vout->streaming)
> > +               return -EBUSY;
>
> When application calls a TRY_FMT, I think as per v4l spec, driver
> shouldn't change the state. So why should we return -EBUSY here?
>
> > +
> > +       ovid = &vout->vid_info;
> > +       ovl = ovid->overlays[0];
> > +
> > +       if (!ovl->manager || !ovl->manager->device)
> > +               return -EINVAL;
> > +       /* get the display device attached to the overlay */
> > +       timing = &ovl->manager->device->panel.timings;
> > +
> > +       vout->fbuf.fmt.height = timing->y_res;
> > +       vout->fbuf.fmt.width = timing->x_res;
> > +
> > +       omap_vout_try_format(&f->fmt.pix);
> > +       return 0;
> > +}
> > +
>
> ---------------------------------------------------------------------
>
>
> > +
> > +static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control
> *ctrl)
> > +{
> > +       struct omap_vout_device *vout = fh;
> > +
> > +       switch (ctrl->id) {
> > +       case V4L2_CID_ROTATE:
> > +               ctrl->value = vout->control[0].value;
> > +               return 0;
> > +       case V4L2_CID_BG_COLOR:
> > +       {
> > +               struct omap_overlay_manager_info info;
> > +               struct omap_overlay *ovl;
> > +               ovl = vout->vid_info.overlays[0];
> > +
> > +               if (!ovl->manager || !ovl->manager->get_manager_info)
> > +                       return -EINVAL;
> > +
> > +               ovl->manager->get_manager_info(ovl->manager, &info);
> > +               ctrl->value = info.default_color;
> > +               return 0;
> > +       }
> > +       case V4L2_CID_VFLIP:
> > +               ctrl->value = vout->control[2].value;
> > +               return 0;
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +}
>
> Return at the end and use break for each case.
>
[Hiremath, Vaibhav] Agreed and will incorporate in next version.

> > +
> > +static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control
> *a)
> > +{
> > +       struct omap_vout_device *vout = fh;
> > +
> > +       switch (a->id) {
> > +       case V4L2_CID_ROTATE:
> > +       {
> > +               int rotation = a->value;
> > +
> > +               mutex_lock(&vout->lock);
> > +
> > +               if (rotation &&
> > +                       vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
> > +                       mutex_unlock(&vout->lock);
> > +                       return -EINVAL;
> > +               }
> > +
> > +               if ((v4l2_rot_to_dss_rot(rotation, &vout->rotation,
> > +                               vout->mirror))) {
> > +                       mutex_unlock(&vout->lock);
> > +                       return -EINVAL;
> > +               }
> > +
> > +               vout->control[0].value = rotation;
> > +               mutex_unlock(&vout->lock);
> > +               return 0;
> > +       }
> > +       case V4L2_CID_BG_COLOR:
> > +       {
> > +               struct omap_overlay *ovl;
> > +               unsigned int  color = a->value;
> > +               struct omap_overlay_manager_info info;
> > +
> > +               ovl = vout->vid_info.overlays[0];
> > +
> > +               mutex_lock(&vout->lock);
> > +               if (!ovl->manager || !ovl->manager->get_manager_info) {
> > +                       mutex_unlock(&vout->lock);
> > +                       return -EINVAL;
> > +               }
> > +
> > +               ovl->manager->get_manager_info(ovl->manager, &info);
> > +               info.default_color = color;
> > +               if (ovl->manager->set_manager_info(ovl->manager, &info)) {
> > +                       mutex_unlock(&vout->lock);
> > +                       return -EINVAL;
> > +               }
> > +
> > +               vout->control[1].value = color;
> > +               mutex_unlock(&vout->lock);
> > +               return 0;
> > +       }
> > +       case V4L2_CID_VFLIP:
> > +       {
> > +               struct omap_overlay *ovl;
> > +               struct omapvideo_info *ovid;
> > +               unsigned int  mirror = a->value;
> > +
> > +               ovid = &vout->vid_info;
> > +               ovl = ovid->overlays[0];
> > +
> > +               mutex_lock(&vout->lock);
> > +
> > +               if (mirror  && vout->pix.pixelformat ==
> V4L2_PIX_FMT_RGB24) {
> > +                       mutex_unlock(&vout->lock);
> > +                       return -EINVAL;
> > +               }
> > +               vout->mirror = mirror;
> > +               vout->control[2].value = mirror;
> > +               mutex_unlock(&vout->lock);
> > +               return 0;
> > +       }
> > +
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +
>
> Ditto,
>
> --------------------------------------------------------------
>
>
>
> > +
> > +static int vidioc_streamon(struct file *file, void *fh,
> > +                       enum v4l2_buf_type i)
> > +{
> > +       int ret = 0, j;
> > +       u32 addr = 0, mask = 0;
> > +       struct omap_vout_device *vout = fh;
> > +       struct videobuf_queue *q = &vout->vbq;
> > +       struct omapvideo_info *ovid = &vout->vid_info;
> > +
> > +       mutex_lock(&vout->lock);
> > +
> > +       if (vout->streaming) {
> > +               ret = -EBUSY;
> > +               goto streamon_err;
> > +       }
> > +
> > +       ret = videobuf_streamon(q);
> > +       if (ret < 0)
> > +               goto streamon_err;
> > +
> > +       if (list_empty(&vout->dma_queue)) {
> > +               ret = -EIO;
> > +               goto streamon_err;
> > +       }
> > +       /* Get the next frame from the buffer queue */
> > +       vout->next_frm = vout->cur_frm = list_entry(vout->dma_queue.next,
> > +                       struct videobuf_buffer, queue);
> > +       /* Remove buffer from the buffer queue */
> > +       list_del(&vout->cur_frm->queue);
> > +       /* Mark state of the current frame to active */
> > +       vout->cur_frm->state = VIDEOBUF_ACTIVE;
> > +       /* Initialize field_id and started member */
> > +       vout->field_id = 0;
> > +
> > +       /* set flag here. Next QBUF will start DMA */
> > +       vout->streaming = 1;
> > +
> > +       vout->first_int = 1;
> > +
> > +       if (omap_vout_calculate_offset(vout)) {
> > +               ret = -EINVAL;
> > +               goto streamon_err;
> > +       }
> > +       addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
> > +               + vout->cropped_offset;
> > +
> > +       mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> > +               DISPC_IRQ_EVSYNC_ODD;
> > +
> > +       omap_dispc_register_isr(omap_vout_isr, vout, mask);
> > +
> > +       for (j = 0; j < ovid->num_overlays; j++) {
> > +               struct omap_overlay *ovl = ovid->overlays[j];
> > +               if (ovl->manager && ovl->manager->device) {
> > +                       struct omap_overlay_info info;
> > +                       ovl->get_overlay_info(ovl, &info);
> > +                       info.enabled = 1;
> > +                       info.paddr = addr;
> > +                       if (ovl->set_overlay_info(ovl, &info)) {
> > +                               ret = -EINVAL;
> > +                               goto streamon_err;
> > +                       }
> > +               }
> > +       }
> > +
> > +       /* First save the configuration in ovelray structure */
> > +       ret = omapvid_init(vout, addr);
> > +       if (ret)
> > +               v4l2_err(&vout->vid_dev->v4l2_dev,
> > +                               "failed to set overlay info\n");
> > +       /* Enable the pipeline and set the Go bit */
> > +       ret = omapvid_apply_changes(vout);
> > +       if (ret)
> > +               v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change
> mode\n");
> > +
> > +       ret = 0;
> > +
> > +streamon_err:
>
> In some error cases,  the videobuf_streamon() is already called. So
> you have to call videobuf_streamoff() before return
>
[Hiremath, Vaibhav] Agreed and will incorporate in next version.

> > +       mutex_unlock(&vout->lock);
> > +       return ret;
> > +}
> > +
> > +static int vidioc_streamoff(struct file *file, void *fh,
> > +                       enum v4l2_buf_type i)
> > +{
> > +       u32 mask = 0;
> > +       int ret = 0, j;
> > +       struct omap_vout_device *vout = fh;
> > +       struct omapvideo_info *ovid = &vout->vid_info;
> > +
> > +       if (!vout->streaming)
> > +               return -EINVAL;
> > +
> > +       vout->streaming = 0;
> > +       mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> > +               DISPC_IRQ_EVSYNC_ODD;
> > +
> > +       omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
> > +
> > +       for (j = 0; j < ovid->num_overlays; j++) {
> > +               struct omap_overlay *ovl = ovid->overlays[j];
> > +               if (ovl->manager && ovl->manager->device) {
> > +                       struct omap_overlay_info info;
> > +
> > +                       ovl->get_overlay_info(ovl, &info);
> > +                       info.enabled = 0;
> > +                       ret = ovl->set_overlay_info(ovl, &info);
> > +                       if (ret) {
> > +                               v4l2_err(&vout->vid_dev->v4l2_dev,
> > +                                       "failed to update overlay
> info\n");
> > +                               return ret;
>
> This is a failure.  In that case shouldn't we call videobuf_streamoff,
> videobuf_queue_cancel etc as done below?
>
> > +                       }
> > +               }
> > +       }
> > +
> > +       /* Turn of the pipeline */
> > +       ret = omapvid_apply_changes(vout);
> > +       if (ret) {
> > +               v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change
> mode\n");
> > +               return ret;
> > +       }
>
> Ditto,
>
> > +       INIT_LIST_HEAD(&vout->dma_queue);
> > +       videobuf_streamoff(&vout->vbq);
> > +       videobuf_queue_cancel(&vout->vbq);
> > +
> > +       return 0;
> > +}
> > +
>
>
> -----------------------------------------
>
>
>
> > +
> > +/* Init functions used during driver intitalization */
> > +/* Initial setup of video_data */
> > +static int __init omap_vout_setup_video_data(struct omap_vout_device
> *vout)
> > +{
> > +       struct video_device *vfd;
> > +       struct v4l2_pix_format *pix;
> > +       struct v4l2_control *control;
> > +       struct omap_dss_device *display =
> > +               vout->vid_info.overlays[0]->manager->device;
> > +
> > +       /* set the default pix */
> > +       pix = &vout->pix;
> > +
> > +       /* Set the default picture of QVGA  */
> > +       pix->width = QQVGA_WIDTH;
> > +       pix->height = QQVGA_HEIGHT;
> > +
> > +       /* Default pixel format is RGB 5-6-5 */
> > +       pix->pixelformat = V4L2_PIX_FMT_RGB565;
> > +       pix->field = V4L2_FIELD_ANY;
> > +       pix->bytesperline = pix->width * 2;
> > +       pix->sizeimage = pix->bytesperline * pix->height;
> > +       pix->priv = 0;
> > +       pix->colorspace = V4L2_COLORSPACE_JPEG;
> > +
> > +       vout->bpp = RGB565_BPP;
> > +       vout->fbuf.fmt.width  =  display->panel.timings.x_res;
> > +       vout->fbuf.fmt.height =  display->panel.timings.y_res;
> > +
> > +       /* Set the data structures for the overlay parameters*/
> > +       vout->win.global_alpha = 255;
> > +       vout->fbuf.flags = 0;
> > +       vout->fbuf.capability = V4L2_FBUF_CAP_LOCAL_ALPHA |
> > +               V4L2_FBUF_CAP_SRC_CHROMAKEY | V4L2_FBUF_CAP_CHROMAKEY;
> > +       vout->win.chromakey = 0;
> > +
> > +       omap_vout_new_format(pix, &vout->fbuf, &vout->crop, &vout->win);
> > +
> > +       /*Initialize the control variables for
> > +         rotation, flipping and background color. */
> > +       control = vout->control;
> > +       control[0].id = V4L2_CID_ROTATE;
> > +       control[0].value = 0;
> > +       vout->rotation = 0;
> > +       vout->mirror = 0;
> > +       vout->control[2].id = V4L2_CID_HFLIP;
> > +       vout->control[2].value = 0;
> > +       vout->vrfb_bpp = 2;
> > +
> > +       control[1].id = V4L2_CID_BG_COLOR;
> > +       control[1].value = 0;
> > +
> > +       /* initialize the video_device struct */
> > +       vfd = vout->vfd = video_device_alloc();
> > +
> > +       if (!vfd) {
> > +               printk(KERN_ERR VOUT_NAME ": could not allocate"
> > +                               " video device struct\n");
> > +               return -ENOMEM;
> > +       }
> > +       vfd->release = video_device_release;
> > +       vfd->ioctl_ops = &vout_ioctl_ops;
> > +
> > +       strlcpy(vfd->name, VOUT_NAME, sizeof(vfd->name));
> > +       vfd->vfl_type = VFL_TYPE_GRABBER;
> > +
> > +       /* need to register for a VID_HARDWARE_* ID in videodev.h */
> > +       vfd->fops = &omap_vout_fops;
> > +       mutex_init(&vout->lock);
> > +
> > +       vfd->minor = -1;
> > +       return 0;
> > +
> > +}
> > +
> > +/* Setup video buffers */
> > +static int __init omap_vout_setup_video_bufs(struct platform_device
> *pdev,
> > +               int vid_num)
> > +{
> > +       u32 numbuffers;
> > +       int ret = 0, i, j;
> > +       int image_width, image_height;
> > +       struct video_device *vfd;
> > +       struct omap_vout_device *vout;
> > +       int static_vrfb_allocation = 0, vrfb_num_bufs = 4;
> > +       struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> > +       struct omap2video_device *vid_dev =
> > +               container_of(v4l2_dev, struct omap2video_device,
> v4l2_dev);
> > +
> > +       vout = vid_dev->vouts[vid_num];
> > +       vfd = vout->vfd;
> > +
> > +       numbuffers = (vid_num == 0) ? video1_numbuffers :
> video2_numbuffers;
> > +       vout->buffer_size = (vid_num == 0) ? video1_bufsize :
> video2_bufsize;
> > +       dev_info(&pdev->dev, "Buffer Size = %d\n", vout->buffer_size);
> > +
> > +       for (i = 0; i < numbuffers; i++) {
> > +               vout->buf_virt_addr[i] =
> > +                       omap_vout_alloc_buffer(vout->buffer_size,
> > +                                       (u32 *) &vout->buf_phy_addr[i]);
> > +               if (!vout->buf_virt_addr[i]) {
> > +                       numbuffers = i;
> > +                       ret = -ENOMEM;
> > +                       goto free_buffers;
> > +               }
> > +       }
> > +
> > +       for (i = 0; i < 4; i++) {
>
> Can we replace magic number 4 with a #define? I see this number at
> several places in the code.
>
[Hiremath, Vaibhav] Agreed and will incorporate in next version.

>
> > +               if (omap_vrfb_request_ctx(&vout->vrfb_context[i])) {
> > +                       dev_info(&pdev->dev, ": VRFB allocation
> failed\n");
> > +                       for (j = 0; j < i; j++)
> > +                               omap_vrfb_release_ctx(&vout-
> >vrfb_context[j]);
> > +                       ret = -ENOMEM;
> > +                       goto free_buffers;
> > +               }
> > +       }
> > +       vout->cropped_offset = 0;
> > +
> > +       /* Calculate VRFB memory size */
> > +       /* allocate for worst case size */
> > +       image_width = VID_MAX_WIDTH / TILE_SIZE;
> > +       if (VID_MAX_WIDTH % TILE_SIZE)
> > +               image_width++;
> > +
> > +       image_width = image_width * TILE_SIZE;
> > +       image_height = VID_MAX_HEIGHT / TILE_SIZE;
> > +
> > +       if (VID_MAX_HEIGHT % TILE_SIZE)
> > +               image_height++;
> > +
> > +       image_height = image_height * TILE_SIZE;
> > +       vout->smsshado_size = PAGE_ALIGN(image_width * image_height * 2 *
> 2);
> > +
> > +       /*
> > +        * Request and Initialize DMA, for DMA based VRFB transfer
> > +        */
> > +       vout->vrfb_dma_tx.dev_id = OMAP_DMA_NO_DEVICE;
> > +       vout->vrfb_dma_tx.dma_ch = -1;
> > +       vout->vrfb_dma_tx.req_status = DMA_CHAN_ALLOTED;
> > +       ret = omap_request_dma(vout->vrfb_dma_tx.dev_id, "VRFB DMA TX",
> > +                       omap_vout_vrfb_dma_tx_callback,
> > +                       (void *) &vout->vrfb_dma_tx, &vout-
> >vrfb_dma_tx.dma_ch);
> > +       if (ret < 0) {
> > +               vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
> > +               dev_info(&pdev->dev, ": failed to allocate DMA Channel
> for"
> > +                               " video%d\n", vfd->minor);
> > +       }
> > +       init_waitqueue_head(&vout->vrfb_dma_tx.wait);
> > +
> > +       /* Allocate VRFB buffers if selected through bootargs */
> > +       static_vrfb_allocation = (vid_num == 0) ?
> > +               vid1_static_vrfb_alloc : vid2_static_vrfb_alloc;
> > +
> > +       /* statically allocated the VRFB buffer is done through
> > +          commands line aruments */
> > +       if (static_vrfb_allocation) {
> > +               if (omap_vout_allocate_vrfb_buffers(vout, &vrfb_num_bufs,
> -1)) {
> > +                       ret =  -ENOMEM;
> > +                       goto release_vrfb_ctx;;
> > +               }
> > +               vout->vrfb_static_allocation = 1;
> > +       }
> > +       return 0;
> > +
> > +release_vrfb_ctx:
> > +       for (j = 0; j < 4; j++)
> > +               omap_vrfb_release_ctx(&vout->vrfb_context[j]);
> > +
> > +free_buffers:
> > +       for (i = 0; i < numbuffers; i++) {
> > +               omap_vout_free_buffer(vout->buf_virt_addr[i],
> > +                                               vout->buffer_size);
> > +               vout->buf_virt_addr[i] = 0;
> > +               vout->buf_phy_addr[i] = 0;
> > +       }
> > +       return ret;
> > +
> > +}
> > +
> > +/* Create video out devices */
> > +static int __init omap_vout_create_video_devices(struct platform_device
> *pdev)
> > +{
> > +       int ret = 0, k;
> > +       struct omap_vout_device *vout;
> > +       struct video_device *vfd = NULL;
> > +       struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> > +
> > +       struct omap2video_device *vid_dev = container_of(v4l2_dev,
> > +                       struct omap2video_device, v4l2_dev);
> > +
> > +       for (k = 0; k < pdev->num_resources; k++) {
> > +
> > +               vout = kmalloc(sizeof(struct omap_vout_device),
> GFP_KERNEL);
> > +               if (!vout) {
> > +                       dev_err(&pdev->dev, ": could not allocate
> memory\n");
> > +                       return -ENOMEM;
> > +               }
> > +               memset(vout, 0, sizeof(struct omap_vout_device));
> > +
> > +               vout->vid = k;
> > +               vid_dev->vouts[k] = vout;
> > +               vout->vid_dev = vid_dev;
> > +               /* Select video2 if only 1 overlay is controlled by V4L2
> */
> > +               if (pdev->num_resources == 1)
> > +                       vout->vid_info.overlays[0] = vid_dev->overlays[k +
> 2];
> > +               else
> > +                       /* Else select video1 and video2 one by one. */
> > +                       vout->vid_info.overlays[0] = vid_dev->overlays[k +
> 1];
> > +               vout->vid_info.num_overlays = 1;
> > +               vout->vid_info.id = k + 1;
> > +               vid_dev->num_videos++;
> > +
> > +               /* Setup the default configuration for the video devices
> > +                */
> > +               if (omap_vout_setup_video_data(vout) != 0) {
> > +                       ret = -ENOMEM;
> > +                       goto error;
> > +               }
> > +
> > +               /* Allocate default number of buffers for the video
> streaming
> > +                * and reserve the VRFB space for rotation
> > +                */
> > +               if (omap_vout_setup_video_bufs(pdev, k) != 0) {
> > +                       ret = -ENOMEM;
> > +                       goto error1;
> > +               }
> > +
> > +               /* Register the Video device with V4L2
> > +                */
> > +               vfd = vout->vfd;
> > +               if (video_register_device(vfd, VFL_TYPE_GRABBER, k + 1) <
> 0) {
> > +                       dev_err(&pdev->dev, ": Could not register "
> > +                                       "Video for Linux device\n");
> > +                       vfd->minor = -1;
> > +                       ret = -ENODEV;
> > +                       goto error2;
> > +               }
> > +               video_set_drvdata(vfd, vout);
> > +
> > +               /* Configure the overlay structure */
> > +               ret = omapvid_init(vid_dev->vouts[k], 0);
> > +               if (!ret)
> > +                       goto success;
> > +
> > +error2:
> > +               omap_vout_release_vrfb(vout);
> > +               omap_vout_free_buffers(vout);
> > +error1:
> > +               video_device_release(vfd);
> > +error:
> > +               kfree(vout);
> > +               return ret;
> > +
> > +success:
> > +               dev_info(&pdev->dev, ": registered and initialized"
> > +                               " video device %d\n", vfd->minor);
> > +               if (k == (pdev->num_resources - 1))
> > +                       return 0;
> > +       }
> > +
> > +       return -ENODEV;
> > +}
> > +/* Driver functions */
> > +static int omap_vout_remove(struct platform_device *pdev)
> > +{
> > +       int k;
> > +       struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> > +       struct omap2video_device *vid_dev = container_of(v4l2_dev, struct
> > +                       omap2video_device, v4l2_dev);
> > +
> > +       v4l2_device_unregister(v4l2_dev);
> > +       for (k = 0; k < pdev->num_resources; k++)
> > +               omap_vout_cleanup_device(vid_dev->vouts[k]);
> > +
> > +       for (k = 0; k < vid_dev->num_displays; k++) {
> > +               if (vid_dev->displays[k]->state !=
> OMAP_DSS_DISPLAY_DISABLED)
> > +                       vid_dev->displays[k]->disable(vid_dev-
> >displays[k]);
> > +
> > +               omap_dss_put_device(vid_dev->displays[k]);
> > +       }
> > +       kfree(vid_dev);
> > +       return 0;
> > +}
> > +
> > +static int __init omap_vout_probe(struct platform_device *pdev)
> > +{
> > +       int ret = 0, i;
> > +       struct omap_overlay *ovl;
> > +       struct omap_dss_device *dssdev = NULL;
> > +       struct omap_dss_device *def_display;
> > +       struct omap2video_device *vid_dev = NULL;
> > +
> > +       if (pdev->num_resources == 0) {
> > +               dev_err(&pdev->dev, "probed for an unknown device\n");
> > +               return -ENODEV;
> > +       }
> > +
> > +       vid_dev = kzalloc(sizeof(struct omap2video_device), GFP_KERNEL);
> > +       if (vid_dev == NULL)
> > +               return -ENOMEM;
> > +
> > +       vid_dev->num_displays = 0;
> > +       for_each_dss_dev(dssdev) {
> > +               omap_dss_get_device(dssdev);
> > +               vid_dev->displays[vid_dev->num_displays++] = dssdev;
> > +       }
> > +
> > +       if (vid_dev->num_displays == 0) {
> > +               dev_err(&pdev->dev, "no displays\n");
> > +               ret = -EINVAL;
> > +               goto probe_err0;
> > +       }
> > +
> > +       vid_dev->num_overlays = omap_dss_get_num_overlays();
> > +       for (i = 0; i < vid_dev->num_overlays; i++)
> > +               vid_dev->overlays[i] = omap_dss_get_overlay(i);
> > +
> > +       vid_dev->num_managers = omap_dss_get_num_overlay_managers();
> > +       for (i = 0; i < vid_dev->num_managers; i++)
> > +               vid_dev->managers[i] = omap_dss_get_overlay_manager(i);
> > +
> > +       /* Get the Video1 overlay and video2 overlay.
> > +        * Setup the Display attached to that overlays
> > +        */
> > +       for (i = 1; i < 3; i++) {
>
> Can we replace magic number 3 with a #define ?
>
> > +               ovl = omap_dss_get_overlay(i);
> > +               if (ovl->manager && ovl->manager->device) {
> > +                       def_display = ovl->manager->device;
> > +               } else {
> > +                       dev_warn(&pdev->dev, "cannot find display\n");
> > +                       def_display = NULL;
> > +               }
> > +               if (def_display) {
> > +                       ret = def_display->enable(def_display);
> > +                       if (ret) {
> > +                               /* Here we are not considering a error
> > +                                *  as display may be enabled by frame
> > +                                *  buffer driver
> > +                                */
> > +                               dev_warn(&pdev->dev,
> > +                                       "'%s' Display already enabled\n",
> > +                                       def_display->name);
> > +                       }
> > +                       /* set the update mode */
> > +                       if (def_display->caps &
> > +
> OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
> > +#ifdef CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
> > +                               if (def_display->enable_te)
> > +                                       def_display-
> >enable_te(def_display, 1);
> > +                               if (def_display->set_update_mode)
> > +                                       def_display-
> >set_update_mode(def_display,
> > +
> OMAP_DSS_UPDATE_AUTO);
> > +#else  /* MANUAL_UPDATE */
> > +                               if (def_display->enable_te)
> > +                                       def_display-
> >enable_te(def_display, 0);
> > +                               if (def_display->set_update_mode)
> > +                                       def_display-
> >set_update_mode(def_display,
> > +
> OMAP_DSS_UPDATE_MANUAL);
> > +#endif
> > +                       } else {
> > +                               if (def_display->set_update_mode)
> > +                                       def_display-
> >set_update_mode(def_display,
> > +
> OMAP_DSS_UPDATE_AUTO);
> > +                       }
> > +               }
> > +       }
> > +
> > +       if (v4l2_device_register(&pdev->dev, &vid_dev->v4l2_dev) < 0) {
> > +               dev_err(&pdev->dev, "v4l2_device_register failed\n");
> > +               ret = -ENODEV;
> > +               goto probe_err1;
> > +       }
> > +
> > +       ret = omap_vout_create_video_devices(pdev);
> > +       if (ret)
> > +               goto probe_err2;
> > +
> > +       for (i = 0; i < vid_dev->num_displays; i++) {
> > +               struct omap_dss_device *display = vid_dev->displays[i];
> > +
> > +               if (display->update)
> > +                       display->update(display, 0, 0,
> > +                                       display->panel.timings.x_res,
> > +                                       display->panel.timings.y_res);
> > +       }
> > +       return 0;
> > +
> > +probe_err2:
> > +       v4l2_device_unregister(&vid_dev->v4l2_dev);
> > +probe_err1:
> > +       for (i = 1; i < 3; i++) {
>
> replace magic number 3 with #define constant.
>
> > +               def_display = NULL;
> > +               ovl = omap_dss_get_overlay(i);
> > +               if (ovl->manager && ovl->manager->device)
> > +                       def_display = ovl->manager->device;
> > +
> > +               if (def_display)
> > +                       def_display->disable(def_display);
> > +       }
> > +probe_err0:
> > +       kfree(vid_dev);
> > +       return ret;
> > +}
> > +
> > +static struct platform_driver omap_vout_driver = {
> > +       .driver = {
> > +               .name = VOUT_NAME,
> > +       },
> > +       .probe = omap_vout_probe,
> > +       .remove = omap_vout_remove,
> > +};
> > +
> > +void omap_vout_isr(void *arg, unsigned int irqstatus)
> > +{
> > +       int ret;
> > +       u32 addr, fid;
> > +       struct omap_overlay *ovl;
> > +       struct timeval timevalue;
> > +       struct omapvideo_info *ovid;
> > +       struct omap_dss_device *cur_display;
> > +       struct omap_vout_device *vout = (struct omap_vout_device *)arg;
> > +
> > +       if (!vout->streaming)
> > +               return;
> > +
> > +       ovid = &vout->vid_info;
> > +       ovl = ovid->overlays[0];
> > +       /* get the display device attached to the overlay */
> > +       if (!ovl->manager || !ovl->manager->device)
> > +               return;
> > +       cur_display = ovl->manager->device;
> > +
> > +       spin_lock(&vout->vbq_lock);
> > +       do_gettimeofday(&timevalue);
> > +       if (cur_display->type == OMAP_DISPLAY_TYPE_DPI) {
> > +               if (!(irqstatus & DISPC_IRQ_VSYNC))
> > +                       goto vout_isr_err;
> > +
> > +               if (!vout->first_int && (vout->cur_frm != vout->next_frm))
> {
> > +                       vout->cur_frm->ts = timevalue;
> > +                       vout->cur_frm->state = VIDEOBUF_DONE;
> > +                       wake_up_interruptible(&vout->cur_frm->done);
> > +                       vout->cur_frm = vout->next_frm;
> > +               }
> > +               vout->first_int = 0;
> > +               if (list_empty(&vout->dma_queue))
> > +                       goto vout_isr_err;
> > +
> > +               vout->next_frm = list_entry(vout->dma_queue.next,
> > +                               struct videobuf_buffer, queue);
> > +               list_del(&vout->next_frm->queue);
> > +
> > +               vout->next_frm->state = VIDEOBUF_ACTIVE;
> > +
> > +               addr = (unsigned long) vout->queued_buf_addr[vout-
> >next_frm->i]
> > +                       + vout->cropped_offset;
> > +
> > +               /* First save the configuration in ovelray structure */
> > +               ret = omapvid_init(vout, addr);
> > +               if (ret)
> > +                       printk(KERN_ERR VOUT_NAME
> > +                                       "failed to set overlay info\n");
> > +               /* Enable the pipeline and set the Go bit */
> > +               ret = omapvid_apply_changes(vout);
> > +               if (ret)
> > +                       printk(KERN_ERR VOUT_NAME "failed to change
> mode\n");
> > +       } else {
> > +
> > +               if (vout->first_int) {
> > +                       vout->first_int = 0;
> > +                       goto vout_isr_err;
> > +               }
> > +               if (irqstatus & DISPC_IRQ_EVSYNC_ODD)
> > +                       fid = 1;
> > +               else if (irqstatus & DISPC_IRQ_EVSYNC_EVEN)
> > +                       fid = 0;
> > +               else
> > +                       goto vout_isr_err;
> > +
> > +               vout->field_id ^= 1;
> > +               if (fid != vout->field_id) {
> > +                       if (0 == fid)
> > +                               vout->field_id = fid;
> > +
> > +                       goto vout_isr_err;
> > +               }
> > +               if (0 == fid) {
> > +                       if (vout->cur_frm == vout->next_frm)
> > +                               goto vout_isr_err;
> > +
> > +                       vout->cur_frm->ts = timevalue;
> > +                       vout->cur_frm->state = VIDEOBUF_DONE;
> > +                       wake_up_interruptible(&vout->cur_frm->done);
> > +                       vout->cur_frm = vout->next_frm;
> > +               } else if (1 == fid) {
> > +                       if (list_empty(&vout->dma_queue) ||
> > +                                       (vout->cur_frm != vout->next_frm))
> > +                               goto vout_isr_err;
> > +
> > +                       vout->next_frm = list_entry(vout->dma_queue.next,
> > +                                       struct videobuf_buffer, queue);
> > +                       list_del(&vout->next_frm->queue);
> > +
> > +                       vout->next_frm->state = VIDEOBUF_ACTIVE;
> > +                       addr = (unsigned long)
> > +                               vout->queued_buf_addr[vout->next_frm->i] +
> > +                               vout->cropped_offset;
> > +                       /* First save the configuration in ovelray
> structure */
> > +                       ret = omapvid_init(vout, addr);
> > +                       if (ret)
> > +                               printk(KERN_ERR VOUT_NAME
> > +                                               "failed to set overlay
> info\n");
> > +                       /* Enable the pipeline and set the Go bit */
> > +                       ret = omapvid_apply_changes(vout);
> > +                       if (ret)
> > +                               printk(KERN_ERR VOUT_NAME
> > +                                               "failed to change
> mode\n");
> > +               }
> > +
> > +       }
> > +
> > +vout_isr_err:
> > +       spin_unlock(&vout->vbq_lock);
> > +}
> > +
> > +static void omap_vout_cleanup_device(struct omap_vout_device *vout)
> > +{
> > +       struct video_device *vfd;
> > +
> > +       if (!vout)
> > +               return;
>
> Is this possible to happen since device is already initialized and
> this would have been checked already?
>
[Hiremath, Vaibhav] No. it has been checked before.


> > +
> > +       vfd = vout->vfd;
> > +       if (vfd) {
> > +               if (vfd->minor == -1) {
> > +                       /*
> > +                        * The device was never registered, so release the
> > +                        * video_device struct directly.
> > +                        */
> > +                       video_device_release(vfd);
>
> I think there is an v4l2 api to check if the device is registered
> instead of checking the minor number. video_is_registered() can be
> used here.
>
[Hiremath, Vaibhav] Agreed and will incorporate in next version.

Thanks,
Vaibhav

