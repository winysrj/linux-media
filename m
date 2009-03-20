Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46053 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZCTMcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 08:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <1237526408-14249-1-git-send-email-hardik.shah@ti.com>
References: <1237526408-14249-1-git-send-email-hardik.shah@ti.com>
Date: Fri, 20 Mar 2009 15:32:06 +0300
Message-ID: <208cbae30903200532v763f0ce1vf1306d75efd6123e@mail.gmail.com>
Subject: Re: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hardik Shah <hardik.shah@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Brijesh Jadav <brijesh.j@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>

Hello again,
my previous message due to bad connection was send with no end.
Sorry about that.

> +               vout->vid = k;
> +               vid_dev->vouts[k] = vout;
> +               vout->vid_info.vid_dev = vid_dev;
> +               vout->vid_info.overlays[0] = vid_dev->overlays[k + 1];
> +               vout->vid_info.num_overlays = 1;
> +               vout->vid_info.id = k + 1;
> +               vid_dev->num_videos++;
> +
> +               /* Setup the default configuration for the video devices
> +                */
> +               if (omap_vout_setup_video_data(vout) != 0) {
> +                       r = -ENOMEM;
> +                       goto error;
> +               }
> +
> +               /* Allocate default number of buffers for the video streaming
> +                * and reserve the VRFB space for rotation
> +                */
> +               if (omap_vout_setup_video_bufs(pdev, k) != 0) {
> +                       r = -ENOMEM;
> +                       goto error1;
> +               }
> +
> +               /* Register the Video device with V4L2
> +                */
> +               vfd = vout->vfd;
> +               if (video_register_device(vfd, VFL_TYPE_GRABBER, k + 1) < 0) {
> +                       printk(KERN_ERR VOUT_NAME ": could not register \
> +                                       Video for Linux device\n");
> +                       vfd->minor = -1;
> +                       r = -ENODEV;
> +                       goto error2;
> +               }
> +
> +               if (k == 0)
> +                       saved_v1out = vout;
> +               else
> +                       saved_v2out = vout;
> +
> +               r = omapvid_apply_changes(vid_dev->vouts[k], 0, 1);
> +
> +               if (r)
> +                       goto error2;
> +               else
> +                       goto success;
> +error2:
> +       omap_vout_release_vrfb(vout);
> +       omap_vout_free_buffers(vout);
> +error1:
> +       video_device_release(vfd);
> +error:
> +       kfree(vout);
> +       return r;
> +
> +success:
> +       printk(KERN_INFO VOUT_NAME ": registered and initialized\
> +                       video device %d [v4l2]\n", vfd->minor);
> +       if (k == (pdev->num_resources - 1))
> +               return 0;
> +       }
> +       return -ENODEV;
> +
> +}
> +
> +int omapvid_apply_changes(struct omap_vout_device *vout, u32 addr, int init)
> +{
> +       int r = 0;
> +       struct omapvideo_info *ovid = &(vout->vid_info);
> +       struct omap_overlay *ovl;
> +       int posx, posy;
> +       int outw, outh, temp, rotation;
> +       int i;
> +       struct v4l2_window *win;
> +       struct omap_video_timings *timing;
> +       struct omap_display *cur_display;
> +
> +       win = &vout->win;
> +       rotation = vout->rotation;
> +       for (i = 0; i < ovid->num_overlays; i++) {
> +               ovl = ovid->overlays[i];
> +               if (!ovl->manager || !ovl->manager->display)
> +                       return -EINVAL;
> +
> +               timing = &ovl->manager->display->panel->timings;
> +               cur_display = ovl->manager->display;
> +
> +               if (init || (ovl->caps & OMAP_DSS_OVL_CAP_SCALE) == 0) {
> +                       outw = win->w.width;
> +                       outh = win->w.height;
> +
> +               } else {
> +                       outw = win->w.width;
> +                       outh = win->w.height;
> +               }
> +               if (init) {
> +                       posx = 0;
> +                       posy = 0;
> +               } else {
> +                       switch (rotation) {
> +
> +                       case 1:
> +                               /* Invert the height and widht for 90
> +                                * and 270 degree rotation
> +                                */
> +                               temp = outw;
> +                               outw = outh;
> +                               outh = temp;
> +                               posy = (timing->y_res - win->w.width)-
> +                                       win->w.left;
> +                               posx = win->w.top;
> +                               break;
> +
> +                       case 2:
> +                               posx = (timing->x_res - win->w.width) -
> +                                       win->w.left;
> +                               posy = (timing->y_res - win->w.height) -
> +                                       win->w.top;
> +                               break;
> +
> +                       case 3:
> +                               temp = outw;
> +                               outw = outh;
> +                               outh = temp;
> +                               posy = win->w.left;
> +                               posx = (timing->x_res - win->w.height)
> +                                       - win->w.top;
> +                               break;
> +
> +                       default:
> +                               posx = win->w.left;
> +                               posy = win->w.top;
> +                               break;
> +                       }
> +               }
> +
> +               if (cur_display->type == OMAP_DISPLAY_TYPE_VENC)
> +                       posy = posy/2;
> +
> +               r = omapvid_setup_overlay(vout, ovl, posx, posy, outw,
> +                               outh, addr, vout->tv_field1_offset, init);
> +               if (r)
> +                       goto err;
> +
> +               if (!init && ovl->manager)
> +                       ovl->manager->apply(ovl->manager);
> +
> +       }
> +       return 0;
> +err:
> +       printk(KERN_WARNING "apply_changes failed\n");

Module name here ?

> +       return r;
> +}
> +
> +int omapvid_setup_overlay(struct omap_vout_device *vout,
> +               struct omap_overlay *ovl, int posx, int posy, int outw,
> +               int outh, u32 addr, int tv_field1_offset, int init)
> +{
> +       int r = 0;
> +       enum omap_color_mode mode = 0;
> +       int rotation, mirror;
> +       int cropheight, cropwidth, pixheight, pixwidth;
> +       struct omap_overlay_info info;
> +
> +       if ((ovl->caps & OMAP_DSS_OVL_CAP_SCALE) == 0 &&
> +                       (outw != vout->pix.width || outh != vout->pix.height)) {
> +               r = -EINVAL;
> +               goto err;
> +       }
> +
> +       mode = video_mode_to_dss_mode(vout);
> +
> +       if (mode == -EINVAL) {
> +               r = -EINVAL;
> +               goto err;
> +       }
> +
> +       rotation = vout->rotation;
> +       mirror = 0;
> +
> +       /* Setup the input plane parameters according to
> +        * rotation value selected.
> +        */
> +       if (rotation == 1 || rotation == 3) {
> +               cropheight = vout->crop.width;
> +               cropwidth = vout->crop.height;
> +               pixheight = vout->pix.width;
> +               pixwidth = vout->pix.height;
> +       } else {
> +               cropheight = vout->crop.height;
> +               cropwidth = vout->crop.width;
> +               pixheight = vout->pix.height;
> +               pixwidth = vout->pix.width;
> +       }
> +
> +       ovl->get_overlay_info(ovl, &info);
> +       info.paddr = addr;
> +       info.vaddr = NULL;
> +       if (vout->rotation >= 0)
> +               info.screen_width = 2048;
> +       else
> +               info.screen_width = pixwidth;
> +       info.width = cropwidth;
> +       info.height = cropheight;
> +       info.color_mode = mode;
> +       info.rotation = rotation;
> +       info.mirror = mirror;
> +       info.pos_x = posx;
> +       info.pos_y = posy;
> +       info.out_width = outw;
> +       info.out_height = outh;
> +       info.rotation = 0;
> +       info.mirror = 0;
> +       info.global_alpha = vout->win.global_alpha;
> +
> +       r = ovl->set_overlay_info(ovl, &info);
> +       if (r)
> +               goto err;
> +
> +       return 0;
> +err:
> +       printk(KERN_WARNING "setup_overlay failed\n");

Module name ?

> +       return r;
> +}
> +
> +static enum omap_color_mode video_mode_to_dss_mode(struct omap_vout_device
> +                       *vout)
> +{
> +       struct v4l2_pix_format *pix = &vout->pix;
> +       switch (pix->pixelformat) {
> +
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
> +       {
> +               if (vout->vid == OMAP_VIDEO1)
> +                       return OMAP_DSS_COLOR_RGB24U;
> +               else
> +                       return OMAP_DSS_COLOR_ARGB32;
> +       }
> +       case V4L2_PIX_FMT_BGR32:
> +               return OMAP_DSS_COLOR_RGBX32;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +       return -EINVAL;
> +}
> +
> +static struct platform_driver omap_vout_driver = {
> +       .driver = {
> +                  .name = VOUT_NAME,
> +                  },
> +       .probe = omap_vout_probe,
> +       .remove = omap_vout_remove,
> +};
> +
> +void omap_vout_isr(void *arg, unsigned int irqstatus)
> +{
> +       int r;
> +       struct timeval timevalue;
> +       struct omap_vout_device *vout =
> +           (struct omap_vout_device *) arg;
> +       u32 addr, fid;
> +       struct omapvideo_info *ovid;
> +       struct omap_overlay *ovl;
> +       struct omap_display *cur_display;
> +
> +       if (!vout->streaming)
> +               return;
> +
> +       ovid = &(vout->vid_info);
> +       ovl = ovid->overlays[0];
> +       /* get the display device attached to the overlay */
> +       if (!ovl->manager || !ovl->manager->display)
> +               return;
> +       cur_display = ovl->manager->display;
> +
> +       spin_lock(&vout->vbq_lock);
> +       do_gettimeofday(&timevalue);
> +       if (cur_display->type == OMAP_DISPLAY_TYPE_DPI) {
> +               if (!(irqstatus & DISPC_IRQ_VSYNC))
> +                       return;
> +               if (!vout->first_int && (vout->curFrm != vout->nextFrm)) {
> +                       vout->curFrm->ts = timevalue;
> +                       vout->curFrm->state = VIDEOBUF_DONE;
> +                       wake_up_interruptible(&vout->curFrm->done);
> +                       vout->curFrm = vout->nextFrm;
> +               }
> +               vout->first_int = 0;
> +               if (list_empty(&vout->dma_queue)) {
> +                       spin_unlock(&vout->vbq_lock);
> +                       return;
> +               }
> +
> +               vout->nextFrm = list_entry(vout->dma_queue.next,
> +                                       struct videobuf_buffer, queue);
> +               list_del(&vout->nextFrm->queue);
> +
> +               vout->nextFrm->state = VIDEOBUF_ACTIVE;
> +
> +               addr = (unsigned long) vout->queued_buf_addr[vout->nextFrm->i] +
> +                               vout->cropped_offset ;
> +
> +               r = omapvid_apply_changes(vout, addr, 0);
> +               if (r)
> +                       printk(KERN_ERR VOUT_NAME "failed to change mode\n");
> +       } else {
> +               if (vout->first_int) {
> +                       vout->first_int = 0;
> +                       spin_unlock(&vout->vbq_lock);
> +                       return;
> +               }
> +               if (irqstatus & DISPC_IRQ_EVSYNC_ODD) {
> +                       fid = 1;
> +               } else if (irqstatus & DISPC_IRQ_EVSYNC_EVEN) {
> +                       fid = 0;
> +               } else {
> +                       spin_unlock(&vout->vbq_lock);
> +                       return;
> +               }
> +               vout->field_id ^= 1;
> +               if (fid != vout->field_id) {
> +                       if (0 == fid)
> +                               vout->field_id = fid;
> +
> +                       spin_unlock(&vout->vbq_lock);
> +                       return;
> +               }
> +               if (0 == fid) {
> +                       if (vout->curFrm == vout->nextFrm) {
> +                               spin_unlock(&vout->vbq_lock);
> +                               return;
> +                       }
> +                       vout->curFrm->ts = timevalue;
> +                       vout->curFrm->state = VIDEOBUF_DONE;
> +                       wake_up_interruptible(&vout->curFrm->done);
> +                       vout->curFrm = vout->nextFrm;
> +               } else if (1 == fid) {
> +                       if (list_empty(&vout->dma_queue) ||
> +                           (vout->curFrm != vout->nextFrm)) {
> +                               spin_unlock(&vout->vbq_lock);
> +                               return;
> +                       }
> +                       vout->nextFrm = list_entry(vout->dma_queue.next,
> +                                          struct videobuf_buffer, queue);
> +                       list_del(&vout->nextFrm->queue);
> +
> +                       vout->nextFrm->state = VIDEOBUF_ACTIVE;
> +                       addr = (unsigned long)
> +                           vout->queued_buf_addr[vout->nextFrm->i] +
> +                           vout->cropped_offset        ;
> +                       r = omapvid_apply_changes(vout, addr, 0);
> +                       if (r)
> +                               printk(KERN_ERR VOUT_NAME "failed to\
> +                                               change mode\n");
> +               }
> +
> +       }
> +       spin_unlock(&vout->vbq_lock);
> +}
> +
> +static void omap_vout_cleanup_device(struct omap_vout_device *vout)
> +{
> +
> +       struct video_device *vfd;
> +
> +       if (!vout)
> +               return;
> +       vfd = vout->vfd;
> +
> +       if (vfd) {
> +               if (vfd->minor == -1) {
> +                       /*
> +                        * The device was never registered, so release the
> +                        * video_device struct directly.
> +                        */
> +                       video_device_release(vfd);
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
> +
> +       omap_vout_free_buffers(vout);
> +
> +       kfree(vout);
> +
> +       if (!(vout->vid))
> +               saved_v1out = NULL;
> +       else
> +               saved_v2out = NULL;
> +}
> +
> +static int __init omap_vout_init(void)
> +{
> +
> +       if (platform_driver_register(&omap_vout_driver) != 0) {
> +               printk(KERN_ERR VOUT_NAME ": could not register \
> +                               Video driver\n");
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
> +MODULE_AUTHOR("Texas Instruments.");
> +MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
> +MODULE_LICENSE("GPL");
> +
> +late_initcall(omap_vout_init);
> +module_exit(omap_vout_cleanup);
> diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
> new file mode 100644
> index 0000000..d9bbc10
> --- /dev/null
> +++ b/drivers/media/video/omap/omap_voutdef.h
> @@ -0,0 +1,137 @@
> +/*
> + * drivers/media/video/omap/omap_voutdef.h
> + *
> + * Copyright (C) 2005 Texas Instruments.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef OMAP_VOUTDEF_H
> +#define OMAP_VOUTDEF_H
> +
> +#include <mach/display.h>
> +
> +#define YUYV_BPP        2
> +#define RGB565_BPP      2
> +#define RGB24_BPP       3
> +#define RGB32_BPP       4
> +#define TILE_SIZE       32
> +#define YUYV_VRFB_BPP   2
> +#define RGB_VRFB_BPP    1
> +#define MAX_CID                        3
> +
> +
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
> +       struct omap_overlay *overlays[3];
> +       struct omap2video_device *vid_dev;
> +};
> +
> +struct omap2video_device {
> +       struct device *dev;
> +       struct mutex  mtx;
> +
> +       int state;
> +
> +       int num_videos;
> +       struct omap_vout_device *vouts[10];
> +
> +       int num_displays;
> +       struct omap_display *displays[10];
> +       int num_overlays;
> +       struct omap_overlay *overlays[10];
> +       int num_managers;
> +       struct omap_overlay_manager *managers[10];
> +};
> +
> +/* per-device data structure */
> +struct omap_vout_device {
> +
> +       struct omapvideo_info vid_info;
> +       struct device dev;
> +       struct video_device *vfd;
> +       int vid;
> +       int opened;
> +
> +       /* we don't allow to change image fmt/size once buffer has
> +        * been allocated
> +        */
> +       int buffer_allocated;
> +       /* allow to reuse previosuly allocated buffer which is big enough */
> +       int buffer_size;
> +       /* keep buffer info accross opens */
> +       unsigned long buf_virt_addr[VIDEO_MAX_FRAME];
> +       unsigned long buf_phy_addr[VIDEO_MAX_FRAME];
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
> +       struct omap_vout_fh *streaming;
> +
> +       struct v4l2_pix_format pix;
> +       struct v4l2_rect crop;
> +       struct v4l2_window win;
> +       struct v4l2_framebuffer fbuf;
> +
> +       /* Lock to protect the shared data structures in ioctl */
> +       struct semaphore lock;
> +
> +
> +       /* V4L2 control structure for different control id */
> +       struct v4l2_control control[MAX_CID];
> +       int rotation;
> +       int mirror;
> +       int flicker_filter;
> +       /* V4L2 control structure for different control id */
> +
> +       int bpp; /* bytes per pixel */
> +       int vrfb_bpp; /* bytes per pixel with respect to VRFB */
> +
> +       struct vid_vrfb_dma vrfb_dma_tx;
> +       unsigned int smsshado_phy_addr[4];
> +       unsigned int smsshado_virt_addr[4];
> +       struct vrfb vrfb_context[4];
> +       unsigned int smsshado_size;
> +       unsigned char pos;
> +
> +       int ps, vr_ps, line_length, first_int, field_id;
> +       enum v4l2_memory memory;
> +       struct videobuf_buffer *curFrm, *nextFrm;
> +       struct list_head dma_queue;
> +       u8 *queued_buf_addr[32];
> +       u32 cropped_offset;
> +       s32 tv_field1_offset;
> +       void *isr_handle;
> +
> +};
> +
> +/* per-filehandle data structure */
> +struct omap_vout_fh {
> +       struct omap_vout_device *vout;
> +       enum v4l2_buf_type type;
> +       struct videobuf_queue vbq;
> +       int io_allowed;
> +};
> +
> +#endif /* ifndef OMAP_VOUTDEF_H */
> diff --git a/drivers/media/video/omap/omap_voutlib.c b/drivers/media/video/omap/omap_voutlib.c
> new file mode 100644
> index 0000000..c51a413
> --- /dev/null
> +++ b/drivers/media/video/omap/omap_voutlib.c
> @@ -0,0 +1,281 @@
> +/*
> + * drivers/media/video/omap/omap_voutlib.c
> + *
> + * Copyright (C) 2008 Texas Instruments.
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
> + * Copyright (C) 2004 Texas Instruments.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/vmalloc.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/smp_lock.h>
> +#include <linux/kdev_t.h>
> +#include <linux/types.h>
> +#include <linux/wait.h>
> +#include <linux/videodev2.h>
> +#include <linux/semaphore.h>
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
> +       new_win->field = /*V4L2_FIELD_NONE*/V4L2_FIELD_ANY;
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
> +       if ((crop->height/win->w.height) >= 2) {
> +               /* The maximum vertical downsizing ratio is 2:1 */
> +               crop->height = win->w.height * 2;
> +       }
> +       if ((crop->width/win->w.width) >= 2) {
> +               /* The maximum horizontal downsizing ratio is 2:1 */
> +               crop->width = win->w.width * 2;
> +       }
> +       if (crop->width > 768) {
> +               /* The OMAP2420 vertical resizing line buffer is 768 pixels
> +                * wide.  If the cropped image is wider than 768 pixels then it
> +                * cannot be vertically resized.
> +                */
> +               if (crop->height != win->w.height)
> +                       crop->width = 768;
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
> +       if (vresize > 2048)
> +               vresize = 2048;
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
> +       if (hresize > 2048)
> +               hresize = 2048;
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
> +       if ((try_crop.height/win->w.height) >= 2) {
> +               /* The maximum vertical downsizing ratio is 2:1 */
> +               try_crop.height = win->w.height * 2;
> +       }
> +       if ((try_crop.width/win->w.width) >= 2) {
> +               /* The maximum horizontal downsizing ratio is 2:1 */
> +               try_crop.width = win->w.width * 2;
> +       }
> +       if (try_crop.width > 768) {
> +               /* The OMAP2420 vertical resizing line buffer is 768 pixels
> +                * wide.  If the cropped image is wider than 768 pixels then it
> +                * cannot be vertically resized.
> +                */
> +               if (try_crop.height != win->w.height)
> +                       try_crop.width = 768;
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
> +MODULE_AUTHOR("Texas Instruments.");
> +MODULE_DESCRIPTION("OMAP Video library");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/omap/omap_voutlib.h b/drivers/media/video/omap/omap_voutlib.h
> new file mode 100644
> index 0000000..d98f659
> --- /dev/null
> +++ b/drivers/media/video/omap/omap_voutlib.h
> @@ -0,0 +1,34 @@
> +/*
> + * drivers/media/video/omap/omap_voutlib.h
> + *
> + * Copyright (C) 2008 Texas Instruments.
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
> +#endif /* #ifndef OMAP_LIB_H */

Please, also check years in patch.

-- 
Best regards, Klimov Alexey
