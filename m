Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:35625 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab2JEOrf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 10:47:35 -0400
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Fri, 5 Oct 2012 07:48:29 -0700
Subject: RE: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support
 on marvell-ccic mcam-core
Message-ID: <477F20668A386D41ADCC57781B1F7043083B6575E0@SC-VEXCH1.marvell.com>
References: <1348840040-21390-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1209291926570.20390@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209291926570.20390@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Thank you for your review!

Sorry for late response.

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Sunday, 30 September, 2012 07:28
>To: Albert Wang
>Cc: corbet@lwn.net; Linux Media Mailing List; Libin Yang
>Subject: Re: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support on
>marvell-ccic mcam-core
>
>On Fri, 28 Sep 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the support of Soc Camera on marvell-ccic mcam-core.
>> The Soc Camera mode does not compatible with current mode.
>> Only one mode can be used at one time.
>>
>> To use Soc Camera, CONFIG_VIDEO_MMP_SOC_CAMERA should be defined.
>> What's more, the platform driver should support Soc camera at the same time.
>
>Just looking at the topic, this seems to be too much for a single patch
>and should be split into several patches. This also remains the main
>complain after looking through the patch, as also Jon has commented.
>
>Also, please, keep in mind, that this is a pretty quick look through your
>patch, I'm sure I missed a few issues, they will re-appear, when the patch
>is split.
>
Yes, the suggestion from you and Jonathan is make sense.
We will try to do that in next version.

>>
>> Also add MIPI interface and dual CCICs support in Soc Camera mode.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c | 1034
>++++++++++++++++++++++----
>>  drivers/media/platform/marvell-ccic/mcam-core.h |  126 +++-
>>  2 files changed, 997 insertions(+), 163 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index ce2b7b4..4adb1ca 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>> @@ -3,6 +3,12 @@
>>   * so it needs platform-specific support outside of the core.
>>   *
>>   * Copyright 2011 Jonathan Corbet corbet@lwn.net
>> + *
>> + * History:
>> + * Support Soc Camera
>> + * Support MIPI interface and Dual CCICs in Soc Camera mode
>> + * Sep-2012: Libin Yang <lbyang@marvell.com>
>> + *           Albert Wang <twang13@marvell.com>
>>   */
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>> @@ -27,16 +33,14 @@
>>  #include <media/videobuf2-vmalloc.h>
>>  #include <media/videobuf2-dma-contig.h>
>>  #include <media/videobuf2-dma-sg.h>
>> +#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
>
>This #ifdef isn't needed. The below two headers don't hurt even where
>soc-camera isn't used.
>
OK, we will change it.
>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>
>> +#endif
>> +#include <mach/regs-apmu.h>
>
>Don't think this header is available on all platforms, compilation will
>fail everywhere, where it's missing.
>
This header includes the regs definition of MMP SOC family.
Maybe we should try to find more suitable method to include these definitions.

>>
>>  #include "mcam-core.h"
>>
>> -/*
>> - * Basic frame stats - to be deleted shortly
>> - */
>> -static int frames;
>> -static int singles;
>> -static int delivered;
>> -
>>  #ifdef MCAM_MODE_VMALLOC
>>  /*
>>   * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
>> @@ -100,10 +104,50 @@ MODULE_PARM_DESC(buffer_mode,
>>  #define CF_CONFIG_NEEDED 4  /* Must configure hardware */
>>  #define CF_SINGLE_BUFFER 5  /* Running with a single buffer */
>>  #define CF_SG_RESTART        6      /* SG restart needed */
>> +#define CF_FRAME_SOF0        7      /* Frame 0 started */
>> +#define CF_FRAME_SOF1        8
>> +#define CF_FRAME_SOF2        9
>>
>> +#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
>> +#define sensor_call(cam, o, f, args...) \
>> +    v4l2_subdev_call(soc_camera_to_subdev(cam->icd), o, f, ##args)
>> +#else
>>  #define sensor_call(cam, o, f, args...) \
>>      v4l2_subdev_call(cam->sensor, o, f, ##args)
>> +#endif
>>
>> +#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
>> +static const struct soc_mbus_pixelfmt mcam_formats[] = {
>
>I think, instead of redefining mcam_formats[] you could begin your series
>by a small patch, switching the standard CCIC driver to use struct
>soc_mbus_lookup for this array, since the fields are practically
>identical, only .packing is missing in the current driver, so, it will
>just ignore it. Then you can extend that array with your additional
>formats, add definitions for .packing and use it in both set ups -
>present and soc-camera.
>
Yes, good suggestion, we will try to do that.

>> +    {
>> +            .fourcc = V4L2_PIX_FMT_UYVY,
>> +            .name = "YUV422PACKED",
>> +            .bits_per_sample = 8,
>> +            .packing = SOC_MBUS_PACKING_2X8_PADLO,
>> +            .order = SOC_MBUS_ORDER_LE,
>> +    },
>> +    {
>> +            .fourcc = V4L2_PIX_FMT_YUV422P,
>> +            .name = "YUV422PLANAR",
>> +            .bits_per_sample = 8,
>> +            .packing = SOC_MBUS_PACKING_2X8_PADLO,
>> +            .order = SOC_MBUS_ORDER_LE,
>> +    },
>> +    {
>> +            .fourcc = V4L2_PIX_FMT_YUV420,
>> +            .name = "YUV420PLANAR",
>> +            .bits_per_sample = 12,
>> +            .packing = SOC_MBUS_PACKING_NONE,
>> +            .order = SOC_MBUS_ORDER_LE,
>> +    },
>> +    {
>> +            .fourcc = V4L2_PIX_FMT_YVU420,
>> +            .name = "YVU420PLANAR",
>> +            .bits_per_sample = 12,
>> +            .packing = SOC_MBUS_PACKING_NONE,
>> +            .order = SOC_MBUS_ORDER_LE,
>> +    },
>> +};
>> +#else
>>  static struct mcam_format_struct {
>>      __u8 *desc;
>>      __u32 pixelformat;
>> @@ -147,6 +191,7 @@ static struct mcam_format_struct *mcam_find_format(u32
>pixelformat)
>>      /* Not found? Then return the first format. */
>>      return mcam_formats;
>>  }
>> +#endif
>>
>>  /*
>>   * The default format we use until somebody says otherwise.
>> @@ -175,19 +220,6 @@ struct mcam_dma_desc {
>>      u32 segment_len;
>>  };
>>
>> -/*
>> - * Our buffer type for working with videobuf2.  Note that the vb2
>> - * developers have decreed that struct vb2_buffer must be at the
>> - * beginning of this structure.
>> - */
>> -struct mcam_vb_buffer {
>> -    struct vb2_buffer vb_buf;
>> -    struct list_head queue;
>> -    struct mcam_dma_desc *dma_desc; /* Descriptor virtual address */
>> -    dma_addr_t dma_desc_pa;         /* Descriptor physical address */
>> -    int dma_desc_nent;              /* Number of mapped descriptors */
>> -};
>> -
>
>You don't sem to need this struct in other files, please, don't move it
>to the header. Same goes for your new struct yuv_pointer_t.
>
OK. Will do that.

>>  static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
>>  {
>>      return container_of(vb, struct mcam_vb_buffer, vb_buf);
>> @@ -226,8 +258,10 @@ static void mcam_reset_buffers(struct mcam_camera *cam)
>>      int i;
>>
>>      cam->next_buf = -1;
>> -    for (i = 0; i < cam->nbufs; i++)
>> +    for (i = 0; i < cam->nbufs; i++) {
>>              clear_bit(i, &cam->flags);
>> +            clear_bit(CF_FRAME_SOF0 + i, &cam->flags);
>> +    }
>>  }
>>
>>  static inline int mcam_needs_config(struct mcam_camera *cam)
>> @@ -367,10 +401,10 @@ static void mcam_frame_tasklet(unsigned long data)
>>              if (!test_bit(bufno, &cam->flags))
>>                      continue;
>>              if (list_empty(&cam->buffers)) {
>> -                    singles++;
>> +                    cam->frame_state.singles++;
>>                      break;  /* Leave it valid, hope for better later */
>>              }
>> -            delivered++;
>> +            cam->frame_state.delivered++;
>>              clear_bit(bufno, &cam->flags);
>>              buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
>>                              queue);
>> @@ -422,11 +456,8 @@ static inline int mcam_check_dma_buffers(struct
>mcam_camera *cam)
>>      return 0;
>>  }
>>
>> -
>> -
>>  #endif /* MCAM_MODE_VMALLOC */
>>
>> -
>
>I personally don't fancy multiple empty lines either, but when editing
>work of others it is good to try to adjust to the original author's
>personal preferences (as long as they don't really break things), so,
>let's try to keep stuff as is.
>
>>  #ifdef MCAM_MODE_DMA_CONTIG
>>  /* ---------------------------------------------------------------------- */
>>  /*
>> @@ -443,27 +474,38 @@ static inline int mcam_check_dma_buffers(struct
>mcam_camera *cam)
>>  static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
>>  {
>>      struct mcam_vb_buffer *buf;
>> +    struct v4l2_pix_format *fmt = &cam->pix_format;
>> +    unsigned long flags = 0;
>
>No need to initialise flags.
>
>> +
>> +    spin_lock_irqsave(&cam->list_lock, flags);
>
>Are you sure you need a new spinlock? Is it a bug in the existing driver
>or is it only needed for your new driver? AFAICS, so far this function is
>always called with .dev_lock spinlock held - either in cafe_irq() or in
>mmpcam_irq() or in mcam_ctlr_configure().
>
OK, we will review our code again and try to clean up these issues.

>>      /*
>>       * If there are no available buffers, go into single mode
>>       */
>>      if (list_empty(&cam->buffers)) {
>>              buf = cam->vb_bufs[frame ^ 0x1];
>> -            cam->vb_bufs[frame] = buf;
>> -            mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
>> -                            vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
>>              set_bit(CF_SINGLE_BUFFER, &cam->flags);
>> -            singles++;
>> -            return;
>> +            cam->frame_state.singles++;
>> +    } else {
>> +            /*
>> +             * OK, we have a buffer we can use.
>> +             */
>> +            buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
>> +                                    queue);
>> +            list_del_init(&buf->queue);
>> +            clear_bit(CF_SINGLE_BUFFER, &cam->flags);
>>      }
>> -    /*
>> -     * OK, we have a buffer we can use.
>> -     */
>> -    buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
>> -    list_del_init(&buf->queue);
>> -    mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
>> -                    vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
>>      cam->vb_bufs[frame] = buf;
>> -    clear_bit(CF_SINGLE_BUFFER, &cam->flags);
>> +    mcam_reg_write(cam, frame == 0 ?
>> +                    REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
>> +    if (fmt->pixelformat == V4L2_PIX_FMT_YUV422P
>> +                    || fmt->pixelformat == V4L2_PIX_FMT_YUV420
>> +                    || fmt->pixelformat == V4L2_PIX_FMT_YVU420) {
>
>Rather than explicitly enumerating formats you could add "layout" fields
>to your format list and define a function
>
>static bool ..._fmt_is_planar(struct soc_mbus_pixelfmt *pfmt)
>{
>       switch (pfmt->layout) {
>       case SOC_MBUS_LAYOUT_PLANAR_2Y_U_V:
>       case SOC_MBUS_LAYOUT_PLANAR_2Y_C:
>       case SOC_MBUS_LAYOUT_PLANAR_Y_C:
>               return true;
>       }
>       return false;
>}
>
Good suggestion, we can do that in next version.

>> +            mcam_reg_write(cam, frame == 0 ?
>> +                            REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
>> +            mcam_reg_write(cam, frame == 0 ?
>> +                            REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
>> +    }
>> +    spin_unlock_irqrestore(&cam->list_lock, flags);
>>  }
>>
>>  /*
>> @@ -471,10 +513,10 @@ static void mcam_set_contig_buffer(struct mcam_camera
>*cam, int frame)
>>   */
>>  static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
>>  {
>> -    mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
>>      cam->nbufs = 2;
>>      mcam_set_contig_buffer(cam, 0);
>>      mcam_set_contig_buffer(cam, 1);
>> +    mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
>
>Why is this needed? Does it not work on your hardware with the original
>order?
>
The fourth patch will change the code.
Maybe we should keep its original code in this patch.

>>  }
>>
>>  /*
>> @@ -483,11 +525,14 @@ static void mcam_ctlr_dma_contig(struct mcam_camera
>*cam)
>>  static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
>>  {
>>      struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
>> +    unsigned long flags = 0;
>>
>> +    spin_lock_irqsave(&cam->list_lock, flags);
>>      if (!test_bit(CF_SINGLE_BUFFER, &cam->flags)) {
>> -            delivered++;
>> +            cam->frame_state.delivered++;
>>              mcam_buffer_done(cam, frame, &buf->vb_buf);
>>      }
>> +    spin_unlock_irqrestore(&cam->list_lock, flags);
>
>Same here - AFAICS, this is always called under the .dev_lock
>
Will review code again and try to clean up.

>>      mcam_set_contig_buffer(cam, frame);
>>  }
>>
>> @@ -542,7 +587,6 @@ static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
>>      cam->nbufs = 3;
>>  }
>>
>> -
>>  /*
>>   * Frame completion with S/G is trickier.  We can't muck with
>>   * a descriptor chain on the fly, since the controller buffers it
>> @@ -578,17 +622,16 @@ static void mcam_dma_sg_done(struct mcam_camera *cam,
>int frame)
>>       */
>>      } else {
>>              set_bit(CF_SG_RESTART, &cam->flags);
>> -            singles++;
>> +            cam->frame_state.singles++;
>>              cam->vb_bufs[0] = NULL;
>>      }
>>      /*
>>       * Now we can give the completed frame back to user space.
>>       */
>> -    delivered++;
>> +    cam->frame_state.delivered++;
>>      mcam_buffer_done(cam, frame, &buf->vb_buf);
>>  }
>>
>> -
>>  /*
>>   * Scatter/gather mode requires stopping the controller between
>>   * frames so we can put in a new DMA descriptor array.  If no new
>> @@ -616,56 +659,110 @@ static inline void mcam_sg_restart(struct mcam_camera
>*cam)
>>   * Buffer-mode-independent controller code.
>>   */
>>
>> -/*
>> - * Image format setup
>> - */
>> -static void mcam_ctlr_image(struct mcam_camera *cam)
>> +static int mcam_ctlr_image(struct mcam_camera *mcam)
>>  {
>> -    int imgsz;
>> -    struct v4l2_pix_format *fmt = &cam->pix_format;
>> +    struct v4l2_pix_format *fmt = &mcam->pix_format;
>> +    u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
>> +    int ret = 0;
>> +
>> +    cam_dbg(mcam, "camera: bytesperline = %d; height = %d\n",
>> +            fmt->bytesperline, fmt->sizeimage / fmt->bytesperline);
>> +    imgsz_h = (fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK;
>> +    imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
>> +
>> +    if (fmt->pixelformat == V4L2_PIX_FMT_YUV420
>> +            || fmt->pixelformat == V4L2_PIX_FMT_YVU420)
>> +            imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
>> +    else if (fmt->pixelformat == V4L2_PIX_FMT_JPEG)
>> +            imgsz_h = (fmt->sizeimage / fmt->bytesperline) << IMGSZ_V_SHIFT;
>> +
>> +    switch (fmt->pixelformat) {
>> +    case V4L2_PIX_FMT_YUYV:
>> +    case V4L2_PIX_FMT_UYVY:
>> +            widthy = fmt->width * 2;
>> +            widthuv = fmt->width * 2;
>> +            break;
>> +    case V4L2_PIX_FMT_RGB565:
>> +            widthy = fmt->width * 2;
>> +            widthuv = 0;
>> +            break;
>> +    case V4L2_PIX_FMT_JPEG:
>> +            widthy = fmt->bytesperline;
>> +            widthuv = fmt->bytesperline;
>> +            break;
>> +    case V4L2_PIX_FMT_YUV422P:
>> +            widthy = fmt->width;
>> +            widthuv = fmt->width / 2;
>> +            break;
>> +    case V4L2_PIX_FMT_YUV420:
>> +    case V4L2_PIX_FMT_YVU420:
>> +            widthy = fmt->width;
>> +            widthuv = fmt->width / 2;
>> +            break;
>> +    default:
>> +            break;
>> +    }
>> +
>> +    mcam_reg_write_mask(mcam, REG_IMGPITCH, widthuv << 16 | widthy,
>> +                    IMGP_YP_MASK | IMGP_UVP_MASK);
>> +    mcam_reg_write(mcam, REG_IMGSIZE, imgsz_h | imgsz_w);
>> +    mcam_reg_write(mcam, REG_IMGOFFSET, 0x0);
>>
>> -    imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
>> -            (fmt->bytesperline & IMGSZ_H_MASK);
>> -    mcam_reg_write(cam, REG_IMGSIZE, imgsz);
>> -    mcam_reg_write(cam, REG_IMGOFFSET, 0);
>> -    /* YPITCH just drops the last two bits */
>> -    mcam_reg_write_mask(cam, REG_IMGPITCH, fmt->bytesperline,
>> -                    IMGP_YP_MASK);
>>      /*
>>       * Tell the controller about the image format we are using.
>>       */
>> -    switch (cam->pix_format.pixelformat) {
>> +    switch (fmt->pixelformat) {
>> +    case V4L2_PIX_FMT_YUV422P:
>> +            mcam_reg_write_mask(mcam, REG_CTRL0,
>> +                    C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_YVYU,
>C0_DF_MASK);
>> +            break;
>> +    case V4L2_PIX_FMT_YUV420:
>> +    case V4L2_PIX_FMT_YVU420:
>> +            mcam_reg_write_mask(mcam, REG_CTRL0,
>> +                    C0_DF_YUV | C0_YUV_420PL | C0_YUVE_YVYU,
>C0_DF_MASK);
>> +            break;
>>      case V4L2_PIX_FMT_YUYV:
>> -        mcam_reg_write_mask(cam, REG_CTRL0,
>> -                        C0_DF_YUV|C0_YUV_PACKED|C0_YUVE_YUYV,
>> -                        C0_DF_MASK);
>> -        break;
>> -
>> +            mcam_reg_write_mask(mcam, REG_CTRL0,
>> +                    C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_UYVY,
>C0_DF_MASK);
>> +            break;
>> +    case V4L2_PIX_FMT_UYVY:
>> +            mcam_reg_write_mask(mcam, REG_CTRL0,
>> +                    C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV,
>C0_DF_MASK);
>> +            break;
>> +    case V4L2_PIX_FMT_JPEG:
>> +            mcam_reg_write_mask(mcam, REG_CTRL0,
>> +                    C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV,
>C0_DF_MASK);
>> +            break;
>>      case V4L2_PIX_FMT_RGB444:
>> -        mcam_reg_write_mask(cam, REG_CTRL0,
>> -                        C0_DF_RGB|C0_RGBF_444|C0_RGB4_XRGB,
>> -                        C0_DF_MASK);
>> -            /* Alpha value? */
>> -        break;
>> -
>> +            mcam_reg_write_mask(mcam, REG_CTRL0,
>> +                    C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB,
>C0_DF_MASK);
>> +            break;
>>      case V4L2_PIX_FMT_RGB565:
>> -        mcam_reg_write_mask(cam, REG_CTRL0,
>> -                        C0_DF_RGB|C0_RGBF_565|C0_RGB5_BGGR,
>> -                        C0_DF_MASK);
>> -        break;
>> -
>> +            mcam_reg_write_mask(mcam, REG_CTRL0,
>> +                    C0_DF_RGB | C0_RGBF_565 | C0_RGB5_BGGR,
>C0_DF_MASK);
>> +            break;
>>      default:
>> -        cam_err(cam, "Unknown format %x\n", cam->pix_format.pixelformat);
>> -        break;
>> +            cam_err(mcam, "camera: unknown format: %c\n", fmt->pixelformat);
>> +            break;
>>      }
>> +
>>      /*
>>       * Make sure it knows we want to use hsync/vsync.
>>       */
>> -    mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
>> -                    C0_SIFM_MASK);
>> -}
>> +    mcam_reg_write_mask(mcam, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
>> +    /*
>> +     * This field controls the generation of EOF(DVP only)
>> +     */
>> +    if (mcam->bus_type != V4L2_MBUS_CSI2_LANES) {
>> +            mcam_reg_set_bit(mcam, REG_CTRL0,
>> +                            C0_EOF_VSYNC | C0_VEDGE_CTRL);
>> +            mcam_reg_write(mcam, REG_CTRL3, 0x4);
>> +    }
>>
>> +    return ret;
>> +}
>
>If I understand correctly, the above is adding support for new formats
>and, while doing that, it is generalising the existing code and thus
>changing the way the hardware is configured also for presently supported
>formats. So, it would also affect existing systems. Therefore I think this
>has to be submitted and tested as a separate patch - adding support for
>new formats.
>
Got it, we will try to do that.

>>
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>  /*
>>   * Configure the controller for operation; caller holds the
>>   * device mutex.
>> @@ -683,23 +780,6 @@ static int mcam_ctlr_configure(struct mcam_camera *cam)
>>      return 0;
>>  }
>>
>> -static void mcam_ctlr_irq_enable(struct mcam_camera *cam)
>> -{
>> -    /*
>> -     * Clear any pending interrupts, since we do not
>> -     * expect to have I/O active prior to enabling.
>> -     */
>> -    mcam_reg_write(cam, REG_IRQSTAT, FRAMEIRQS);
>> -    mcam_reg_set_bit(cam, REG_IRQMASK, FRAMEIRQS);
>> -}
>> -
>> -static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
>> -{
>> -    mcam_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
>> -}
>> -
>> -
>> -
>>  static void mcam_ctlr_init(struct mcam_camera *cam)
>>  {
>>      unsigned long flags;
>> @@ -721,7 +801,22 @@ static void mcam_ctlr_init(struct mcam_camera *cam)
>>      mcam_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
>>      spin_unlock_irqrestore(&cam->dev_lock, flags);
>>  }
>> +#endif
>>
>> +static void mcam_ctlr_irq_enable(struct mcam_camera *cam)
>> +{
>> +    /*
>> +     * Clear any pending interrupts, since we do not
>> +     * expect to have I/O active prior to enabling.
>> +     */
>> +    mcam_reg_write(cam, REG_IRQSTAT, FRAMEIRQS);
>> +    mcam_reg_set_bit(cam, REG_IRQMASK, FRAMEIRQS);
>> +}
>> +
>> +static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
>> +{
>> +    mcam_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
>> +}
>>
>>  /*
>>   * Stop the controller, and don't return until we're really sure that no
>> @@ -796,6 +891,7 @@ static int __mcam_cam_reset(struct mcam_camera *cam)
>>      return sensor_call(cam, core, reset, 0);
>>  }
>>
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>  /*
>>   * We have found the sensor on the i2c.  Let's try to have a
>>   * conversation.
>> @@ -824,7 +920,7 @@ static int mcam_cam_init(struct mcam_camera *cam)
>>              ret = -EINVAL;
>>              goto out;
>>      }
>> -/* Get/set parameters? */
>> +    /* Get/set parameters? */
>>      ret = 0;
>>      cam->state = S_IDLE;
>>  out:
>> @@ -847,7 +943,6 @@ static int mcam_cam_set_flip(struct mcam_camera *cam)
>>      return sensor_call(cam, core, s_ctrl, &ctrl);
>>  }
>>
>> -
>>  static int mcam_cam_configure(struct mcam_camera *cam)
>>  {
>>      struct v4l2_mbus_framefmt mbus_fmt;
>> @@ -923,7 +1018,6 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
>>      return 0;
>>  }
>>
>> -
>>  static void mcam_vb_buf_queue(struct vb2_buffer *vb)
>>  {
>>      struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
>> @@ -941,7 +1035,6 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
>>              mcam_read_setup(cam);
>>  }
>>
>> -
>>  /*
>>   * vb2 uses these to release the mutex when waiting in dqbuf.  I'm
>>   * not actually sure we need to do this (I'm not sure that vb2_dqbuf() needs
>> @@ -1010,7 +1103,6 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
>>      return 0;
>>  }
>>
>> -
>>  static const struct vb2_ops mcam_vb2_ops = {
>>      .queue_setup            = mcam_vb_queue_setup,
>>      .buf_queue              = mcam_vb_buf_queue,
>> @@ -1020,7 +1112,6 @@ static const struct vb2_ops mcam_vb2_ops = {
>>      .wait_finish            = mcam_vb_wait_finish,
>>  };
>>
>> -
>>  #ifdef MCAM_MODE_DMA_SG
>>  /*
>>   * Scatter/gather mode uses all of the above functions plus a
>> @@ -1082,7 +1173,6 @@ static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
>>                      mvb->dma_desc, mvb->dma_desc_pa);
>>  }
>>
>> -
>>  static const struct vb2_ops mcam_vb2_sg_ops = {
>>      .queue_setup            = mcam_vb_queue_setup,
>>      .buf_init               = mcam_vb_sg_buf_init,
>> @@ -1151,7 +1241,6 @@ static void mcam_cleanup_vb2(struct mcam_camera *cam)
>>  #endif
>>  }
>>
>> -
>>  /* ---------------------------------------------------------------------- */
>>  /*
>>   * The long list of V4L2 ioctl() operations.
>> @@ -1169,7 +1258,6 @@ static int mcam_vidioc_streamon(struct file *filp, void *priv,
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_vidioc_streamoff(struct file *filp, void *priv,
>>              enum v4l2_buf_type type)
>>  {
>> @@ -1182,7 +1270,6 @@ static int mcam_vidioc_streamoff(struct file *filp, void *priv,
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
>>              struct v4l2_requestbuffers *req)
>>  {
>> @@ -1195,7 +1282,6 @@ static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_vidioc_querybuf(struct file *filp, void *priv,
>>              struct v4l2_buffer *buf)
>>  {
>> @@ -1232,8 +1318,6 @@ static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
>>      return ret;
>>  }
>>
>> -
>> -
>>  static int mcam_vidioc_queryctrl(struct file *filp, void *priv,
>>              struct v4l2_queryctrl *qc)
>>  {
>> @@ -1246,7 +1330,6 @@ static int mcam_vidioc_queryctrl(struct file *filp, void *priv,
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_vidioc_g_ctrl(struct file *filp, void *priv,
>>              struct v4l2_control *ctrl)
>>  {
>> @@ -1259,7 +1342,6 @@ static int mcam_vidioc_g_ctrl(struct file *filp, void *priv,
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_vidioc_s_ctrl(struct file *filp, void *priv,
>>              struct v4l2_control *ctrl)
>>  {
>> @@ -1272,7 +1354,6 @@ static int mcam_vidioc_s_ctrl(struct file *filp, void *priv,
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_vidioc_querycap(struct file *file, void *priv,
>>              struct v4l2_capability *cap)
>>  {
>> @@ -1284,7 +1365,6 @@ static int mcam_vidioc_querycap(struct file *file, void *priv,
>>      return 0;
>>  }
>>
>> -
>>  static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
>>              void *priv, struct v4l2_fmtdesc *fmt)
>>  {
>> @@ -1545,7 +1625,9 @@ static int mcam_v4l_open(struct file *filp)
>>
>>      filp->private_data = cam;
>>
>> -    frames = singles = delivered = 0;
>> +    cam->frame_state.frames = 0;
>> +    cam->frame_state.singles = 0;
>> +    cam->frame_state.delivered = 0;
>>      mutex_lock(&cam->s_mutex);
>>      if (cam->users == 0) {
>>              ret = mcam_setup_vb2(cam);
>> @@ -1561,13 +1643,13 @@ out:
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_v4l_release(struct file *filp)
>>  {
>>      struct mcam_camera *cam = filp->private_data;
>>
>> -    cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n", frames,
>> -                    singles, delivered);
>> +    cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n",
>> +                    cam->frame_state.frames, cam->frame_state.singles,
>> +                    cam->frame_state.delivered);
>>      mutex_lock(&cam->s_mutex);
>>      (cam->users)--;
>>      if (cam->users == 0) {
>> @@ -1594,8 +1676,6 @@ static ssize_t mcam_v4l_read(struct file *filp,
>>      return ret;
>>  }
>>
>> -
>> -
>>  static unsigned int mcam_v4l_poll(struct file *filp,
>>              struct poll_table_struct *pt)
>>  {
>> @@ -1608,7 +1688,6 @@ static unsigned int mcam_v4l_poll(struct file *filp,
>>      return ret;
>>  }
>>
>> -
>>  static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
>>  {
>>      struct mcam_camera *cam = filp->private_data;
>> @@ -1620,8 +1699,6 @@ static int mcam_v4l_mmap(struct file *filp, struct
>vm_area_struct *vma)
>>      return ret;
>>  }
>>
>> -
>> -
>>  static const struct v4l2_file_operations mcam_v4l_fops = {
>>      .owner = THIS_MODULE,
>>      .open = mcam_v4l_open,
>> @@ -1632,7 +1709,6 @@ static const struct v4l2_file_operations mcam_v4l_fops = {
>>      .unlocked_ioctl = video_ioctl2,
>>  };
>>
>> -
>>  /*
>>   * This template device holds all of those v4l2 methods; we
>>   * clone it for specific real devices.
>> @@ -1647,6 +1723,672 @@ static struct video_device mcam_v4l_template = {
>>      .release = video_device_release_empty,
>>  };
>>
>> +#else  /* CONFIG_VIDEO_MRVL_SOC_CAMERA */
>> +
>> +static int mcam_config_phy(struct mcam_camera *mcam, int enable)
>> +{
>> +    if (mcam->bus_type == V4L2_MBUS_CSI2_LANES && enable) {
>> +            cam_dbg(mcam, "camera: DPHY3=0x%x, DPHY5=0x%x,
>DPHY6=0x%x\n",
>> +                    (*mcam->dphy)[0], (*mcam->dphy)[1], (*mcam->dphy)[2]);
>> +            mcam_reg_write(mcam, REG_CSI2_DPHY3, (*mcam->dphy)[0]);
>> +            mcam_reg_write(mcam, REG_CSI2_DPHY6, (*mcam->dphy)[2]);
>> +            mcam_reg_write(mcam, REG_CSI2_DPHY5, (*mcam->dphy)[1]);
>> +
>> +            if (mcam->mipi_enabled == 0) {
>> +                    /*
>> +                     * 0x41 actives 1 lane
>> +                     * 0x43 actives 2 lanes
>> +                     * 0x47 actives 4 lanes
>> +                     * There is no 3 lanes case
>> +                     */
>> +                    if (mcam->lane == 1)
>> +                            mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x41);
>> +                    else if (mcam->lane == 2)
>> +                            mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x43);
>> +                    else if (mcam->lane == 4)
>> +                            mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x47);
>> +                    else {
>> +                            cam_err(mcam, "camera: lane number set err");
>> +                            return -EINVAL;
>> +                    }
>> +                    mcam->mipi_enabled = 1;
>> +            }
>> +    } else {
>> +            mcam_reg_write(mcam, REG_CSI2_DPHY3, 0x0);
>> +            mcam_reg_write(mcam, REG_CSI2_DPHY6, 0x0);
>> +            mcam_reg_write(mcam, REG_CSI2_DPHY5, 0x0);
>> +            mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x0);
>> +            mcam->mipi_enabled = 0;
>> +    }
>> +    return 0;
>> +}
>> +
>> +/*
>> + * Get everything ready, and start grabbing frames.
>> + */
>> +static int mcam_read_setup(struct mcam_camera *mcam)
>> +{
>> +    int ret = 0;
>> +
>> +    clear_bit(CF_DMA_ACTIVE, &mcam->flags);
>> +    mcam_reset_buffers(mcam);
>> +    ret = mcam_config_phy(mcam, 1);
>> +    if (ret < 0)
>> +            return ret;
>> +    mcam_ctlr_irq_enable(mcam);
>> +    mcam_ctlr_dma_contig(mcam);
>> +    mcam->state = S_STREAMING;
>> +    mcam_ctlr_start(mcam);
>> +
>> +    return 0;
>> +}
>> +
>> +void mcam_ctlr_reset(struct mcam_camera *mcam)
>> +{
>> +    unsigned long val;
>> +
>> +    /*
>> +     * Used CCIC2
>> +     */
>> +    if (mcam->ccic_id) {
>> +            val = readl(APMU_CCIC2_RST);
>> +            writel(val & ~0x2, APMU_CCIC2_RST);
>> +            writel(val | 0x2, APMU_CCIC2_RST);
>> +    }
>> +
>> +    val = readl(APMU_CCIC_RST);
>> +    writel(val & ~0x2, APMU_CCIC_RST);
>> +    writel(val | 0x2, APMU_CCIC_RST);
>> +}
>> +
>> +
>> +static int mcam_videobuf_setup(struct vb2_queue *vq,
>> +                    const struct v4l2_format *fmt,
>> +                    u32 *count, u32 *num_planes,
>> +                    unsigned int sizes[], void *alloc_ctxs[])
>> +{
>
>This and the following queue handling functions are very similar to non
>soc-camera versions, any chance to re-use? You'd extract common parts,
>taking mcam as an additional argument?
>
Good suggestion, we will try to re-use the original code.

>> +    struct soc_camera_device *icd = container_of(vq,
>> +                    struct soc_camera_device, vb2_vidq);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +                    icd->current_fmt->host_fmt);
>> +
>> +    int minbufs = 2;
>> +    if (*count < minbufs)
>> +            *count = minbufs;
>> +
>> +    if (bytes_per_line < 0)
>> +            return bytes_per_line;
>
>You're not really using bytes_per_line. If you look in existing soc-camera
>drivers, you'll see, that it can be used to calculate the frame size. If
>you don't want to do that, you don't have to re-check the _currently_
>configured frame format, it had to be checked during S_FMT.
>
>BTW, you're ignoring the "fmt" parameter of this function, which is not
>good. If a user is calling CREATE_BUFS with a different from the current
>frame format, you'll configure wrong buffer sizes. Please see existing
>drivers on how to do that. Maybe you can return an error code if fmt !=
>NULL if you don't want to support that ioctl - the spec doesn't seem very
>verbous on that (ambiguity?:-))
>
It seems your concern is right, we need re-implement this ioctl.

>> +
>> +    *num_planes = 1;
>> +    sizes[0] = mcam->pix_format.sizeimage;
>> +    alloc_ctxs[0] = mcam->vb_alloc_ctx;
>> +    cam_dbg(mcam, "count = %d, size = %u\n", *count, sizes[0]);
>> +
>> +    return 0;
>> +}
>> +
>> +static int mcam_videobuf_prepare(struct vb2_buffer *vb)
>> +{
>> +    struct soc_camera_device *icd = container_of(vb->vb2_queue,
>> +                    struct soc_camera_device, vb2_vidq);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    struct mcam_vb_buffer *buf =
>> +            container_of(vb, struct mcam_vb_buffer, vb_buf);
>> +    unsigned long size;
>> +    unsigned long flags = 0;
>> +    int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +                    icd->current_fmt->host_fmt);
>> +
>> +    if (bytes_per_line < 0)
>> +            return bytes_per_line;
>> +
>> +    cam_dbg(mcam, "%s; (vb = 0x%p), 0x%p, %lu\n", __func__,
>> +            vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>> +    spin_lock_irqsave(&mcam->list_lock, flags);
>> +    /*
>> +     * Added list head initialization on alloc
>> +     */
>> +    WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
>> +    spin_unlock_irqrestore(&mcam->list_lock, flags);
>> +    BUG_ON(NULL == icd->current_fmt);
>> +    size = vb2_plane_size(vb, 0);
>> +    vb2_set_plane_payload(vb, 0, size);
>
>Setting plane payload is the only useful thing, that you do here, maybe
>just do it in mcam_videobuf_queue() like other drivers do it?
>
Yes.

>> +
>> +    return 0;
>> +}
>> +
>> +static void mcam_videobuf_queue(struct vb2_buffer *vb)
>> +{
>> +    struct soc_camera_device *icd = container_of(vb->vb2_queue,
>> +                    struct soc_camera_device, vb2_vidq);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    struct mcam_vb_buffer *buf =
>> +            container_of(vb, struct mcam_vb_buffer, vb_buf);
>> +    unsigned long flags = 0;
>> +    int start;
>> +    dma_addr_t dma_handle;
>> +    u32 base_size = icd->user_width * icd->user_height;
>> +
>> +    mutex_lock(&mcam->s_mutex);
>> +    dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +    BUG_ON(!dma_handle);
>> +    spin_lock_irqsave(&mcam->list_lock, flags);
>> +    /*
>> +     * Wait until two buffers already queued to the list
>> +     * then start DMA
>> +     */
>> +    start = (mcam->state == S_BUFWAIT) && !list_empty(&mcam->buffers);
>> +    spin_unlock_irqrestore(&mcam->list_lock, flags);
>> +
>> +    if (mcam->pix_format.pixelformat == V4L2_PIX_FMT_YUV422P) {
>> +            buf->yuv_p.y = dma_handle;
>> +            buf->yuv_p.u = buf->yuv_p.y + base_size;
>> +            buf->yuv_p.v = buf->yuv_p.u + base_size / 2;
>> +    } else if (mcam->pix_format.pixelformat == V4L2_PIX_FMT_YUV420) {
>> +            buf->yuv_p.y = dma_handle;
>> +            buf->yuv_p.u = buf->yuv_p.y + base_size;
>> +            buf->yuv_p.v = buf->yuv_p.u + base_size / 4;
>> +    } else if (mcam->pix_format.pixelformat == V4L2_PIX_FMT_YVU420) {
>> +            buf->yuv_p.y = dma_handle;
>> +            buf->yuv_p.v = buf->yuv_p.y + base_size;
>> +            buf->yuv_p.u = buf->yuv_p.v + base_size / 4;
>> +    } else {
>> +            buf->yuv_p.y = dma_handle;
>> +    }
>
>Same here, first extend the existing driver with new planar formats, then
>extract and re-use common queue-handling functions.
>
OK, will do that in next version.

>> +
>> +    spin_lock_irqsave(&mcam->list_lock, flags);
>> +    list_add_tail(&buf->queue, &mcam->buffers);
>> +    spin_unlock_irqrestore(&mcam->list_lock, flags);
>> +
>> +    if (start)
>> +            mcam_read_setup(mcam);
>> +    mutex_unlock(&mcam->s_mutex);
>> +}
>> +
>> +static void mcam_videobuf_cleanup(struct vb2_buffer *vb)
>> +{
>> +    struct mcam_vb_buffer *buf =
>> +            container_of(vb, struct mcam_vb_buffer, vb_buf);
>> +    struct soc_camera_device *icd = container_of(vb->vb2_queue,
>> +                    struct soc_camera_device, vb2_vidq);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    unsigned long flags = 0;
>> +
>> +    spin_lock_irqsave(&mcam->list_lock, flags);
>> +    /*
>> +     * queue list must be initialized before del
>> +     */
>> +    if (buf->list_init_flag)
>> +            list_del_init(&buf->queue);
>> +    buf->list_init_flag = 0;
>> +    spin_unlock_irqrestore(&mcam->list_lock, flags);
>> +}
>> +
>> +/*
>> + * only the list that queued could be initialized
>> + */
>> +static int mcam_videobuf_init(struct vb2_buffer *vb)
>> +{
>> +    struct mcam_vb_buffer *buf =
>> +            container_of(vb, struct mcam_vb_buffer, vb_buf);
>> +    INIT_LIST_HEAD(&buf->queue);
>> +    buf->list_init_flag = 1;
>> +    return 0;
>> +}
>> +
>> +static int mcam_start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +    struct soc_camera_device *icd = container_of(vq,
>> +                    struct soc_camera_device, vb2_vidq);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    unsigned long flags = 0;
>> +    int ret = 0;
>> +
>> +    mutex_lock(&mcam->s_mutex);
>> +    if (count < 2) {
>> +            ret = -EINVAL;
>> +            goto out_unlock;
>> +    }
>> +
>> +    if (mcam->state != S_IDLE) {
>> +            ret = -EINVAL;
>> +            goto out_unlock;
>> +    }
>> +
>> +    /*
>> +     * Videobuf2 sneakily hoards all the buffers and won't
>> +     * give them to us until *after* streaming starts.      But
>> +     * we can't actually start streaming until we have a
>> +     * destination.  So go into a wait state and hope they
>> +     * give us buffers soon.
>> +     */
>> +    spin_lock_irqsave(&mcam->list_lock, flags);
>> +    if (list_empty(&mcam->buffers)) {
>> +            mcam->state = S_BUFWAIT;
>> +            spin_unlock_irqrestore(&mcam->list_lock, flags);
>> +            ret = 0;
>> +            goto out_unlock;
>> +    }
>> +    spin_unlock_irqrestore(&mcam->list_lock, flags);
>> +
>> +    ret = mcam_read_setup(mcam);
>> +out_unlock:
>> +    mutex_unlock(&mcam->s_mutex);
>> +
>> +    return ret;
>> +}
>> +
>> +static int mcam_stop_streaming(struct vb2_queue *vq)
>> +{
>> +    struct soc_camera_device *icd = container_of(vq,
>> +                    struct soc_camera_device, vb2_vidq);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    unsigned long flags = 0;
>> +    int ret = 0;
>> +
>> +    mutex_lock(&mcam->s_mutex);
>> +    if (mcam->state == S_BUFWAIT) {
>> +            /* They never gave us buffers */
>> +            mcam->state = S_IDLE;
>> +            goto out_unlock;
>> +    }
>> +
>> +    if (mcam->state != S_STREAMING) {
>> +            ret = -EINVAL;
>> +            goto out_unlock;
>> +    }
>> +
>> +    mcam_ctlr_stop_dma(mcam);
>> +    mcam->state = S_IDLE;
>> +    mcam_ctlr_reset(mcam);
>> +
>> +    spin_lock_irqsave(&mcam->list_lock, flags);
>> +    INIT_LIST_HEAD(&mcam->buffers);
>> +    spin_unlock_irqrestore(&mcam->list_lock, flags);
>> +out_unlock:
>> +    mutex_unlock(&mcam->s_mutex);
>> +
>> +    return ret;
>> +}
>> +
>> +static struct vb2_ops mcam_videobuf_ops = {
>> +    .queue_setup            = mcam_videobuf_setup,
>> +    .buf_prepare            = mcam_videobuf_prepare,
>> +    .buf_queue              = mcam_videobuf_queue,
>> +    .buf_cleanup            = mcam_videobuf_cleanup,
>> +    .buf_init               = mcam_videobuf_init,
>> +    .start_streaming        = mcam_start_streaming,
>> +    .stop_streaming         = mcam_stop_streaming,
>> +    .wait_prepare           = soc_camera_unlock,
>> +    .wait_finish            = soc_camera_lock,
>> +};
>> +
>> +static int mcam_camera_add_device(struct soc_camera_device *icd)
>> +{
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    int ret = 0;
>> +
>> +    if (mcam->icd)
>> +            return -EBUSY;
>> +
>> +    mcam->frame_complete = mcam_dma_contig_done;
>> +    mcam->frame_state.frames = 0;
>> +    mcam->frame_state.singles = 0;
>> +    mcam->frame_state.delivered = 0;
>> +
>> +    mcam->icd = icd;
>> +    mcam->state = S_IDLE;
>> +    mcam_ctlr_power_up(mcam);
>> +    mcam_ctlr_stop(mcam);
>> +    mcam_reg_write(mcam, REG_CTRL1,
>> +            mcam->burst | C1_RESERVED | C1_DMAPOSTED);
>> +    mcam_reg_write(mcam, REG_CLKCTRL,
>> +            (mcam->mclk_src << 29) | mcam->mclk_div);
>> +    cam_dbg(mcam, "camera: set sensor mclk = %dMHz\n", mcam->mclk_min);
>> +    /*
>> +     * Need sleep 1ms to wait for CCIC stable
>> +     * This is a workround for OV5640 MIPI
>> +     * TODO: Fix me in the future
>> +     */
>> +    usleep_range(1000, 2000);
>> +
>> +    /*
>> +     * Mask all interrupts.
>> +     */
>> +    mcam_reg_write(mcam, REG_IRQMASK, 0);
>> +    ret = v4l2_subdev_call(sd, core, init, 0);
>> +    /*
>> +     * When v4l2_subdev_call return -ENOIOCTLCMD,
>> +     * means No ioctl command
>> +     */
>> +    if ((ret < 0) && (ret != -ENOIOCTLCMD) && (ret != -ENODEV)) {
>> +            dev_info(icd->parent,
>
>You seem to be mixing up various output methods. This "failure" message
>should be something like a warning or an error, whereas...
>
Yes, you are right.

>> +                    "camera: Failed to initialize subdev: %d\n", ret);
>> +            return ret;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static void mcam_camera_remove_device(struct soc_camera_device *icd)
>> +{
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +
>> +    BUG_ON(icd != mcam->icd);
>> +    cam_err(mcam, "Release %d frames, %d singles, %d delivered\n",
>
>...this message doesn't seem to report an error.
>
Yes, it's our fault, we will change it.

>> +            mcam->frame_state.frames, mcam->frame_state.singles,
>> +            mcam->frame_state.delivered);
>> +    mcam_config_phy(mcam, 0);
>> +    mcam_ctlr_power_down(mcam);
>> +    mcam->icd = NULL;
>> +}
>> +
>> +static int mcam_camera_set_fmt(struct soc_camera_device *icd,
>> +                    struct v4l2_format *f)
>> +{
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    const struct soc_camera_format_xlate *xlate = NULL;
>> +    struct v4l2_mbus_framefmt mf;
>> +    struct v4l2_pix_format *pix = &f->fmt.pix;
>> +    struct v4l2_subdev_frame_interval inter;
>> +    int ret = 0;
>> +
>> +    cam_dbg(mcam, "camera: set_fmt: %c, width = %u, height = %u\n",
>> +            pix->pixelformat, pix->width, pix->height);
>> +    xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
>> +    if (!xlate) {
>> +            cam_err(mcam, "camera: format: %c not found\n",
>> +                    pix->pixelformat);
>> +            return -EINVAL;
>> +    }
>> +
>> +    mf.width = pix->width;
>> +    mf.height = pix->height;
>> +    mf.field = V4L2_FIELD_NONE;
>> +    mf.colorspace = pix->colorspace;
>> +    mf.code = xlate->code;
>> +
>> +    ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
>> +    if (ret < 0) {
>> +            cam_err(mcam, "camera: set_fmt failed %d\n", __LINE__);
>> +            return ret;
>> +    }
>> +
>> +    if (mf.code != xlate->code) {
>> +            cam_err(mcam, "camera: wrong code %s %d\n", __func__, __LINE__);
>> +            return -EINVAL;
>> +    }
>> +
>> +    /*
>> +     * To get frame_rate
>> +     */
>> +    inter.pad = mcam->mclk_min;
>> +    ret = v4l2_subdev_call(sd, video, g_frame_interval, &inter);
>> +    if (ret < 0) {
>> +            cam_err(mcam, "camera: Can't get frame rate %s %d\n",
>> +                    __func__, __LINE__);
>> +            mcam->frame_rate = 0;
>> +    } else
>> +            mcam->frame_rate =
>> +                    inter.interval.numerator / inter.interval.denominator;
>> +
>> +    /*
>> +     * Update CSI2_DPHY3 value
>> +     */
>> +    mcam->calc_dphy(mcam, &inter);
>> +    cam_dbg(mcam, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x,
>dphy6=0x%x\n",
>> +                    (*mcam->dphy)[0], (*mcam->dphy)[1], (*mcam->dphy)[2]);
>> +
>> +    pix->width = mf.width;
>> +    pix->height = mf.height;
>> +    pix->field = mf.field;
>> +    pix->colorspace = mf.colorspace;
>> +    mcam->pix_format.sizeimage = pix->sizeimage;
>> +    icd->current_fmt = xlate;
>> +
>> +    memcpy(&(mcam->pix_format), pix, sizeof(struct v4l2_pix_format));
>> +    ret = mcam_ctlr_image(mcam);
>> +
>> +    return ret;
>> +}
>> +
>> +static int mcam_camera_try_fmt(struct soc_camera_device *icd,
>> +                    struct v4l2_format *f)
>> +{
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    const struct soc_camera_format_xlate *xlate;
>> +    struct v4l2_pix_format *pix = &f->fmt.pix;
>> +    struct v4l2_mbus_framefmt mf;
>> +    __u32 pixfmt = pix->pixelformat;
>> +    int ret = 0;
>> +
>> +    xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>> +    if (!xlate) {
>> +            cam_err(mcam, "camera: format: %c not found\n",
>> +                    pix->pixelformat);
>> +            return -EINVAL;
>
>No, TRY_FMT shouldn't fail, just pick up some default format.
>
OK, we can update it.

>> +    }
>> +
>> +    pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
>> +                                            xlate->host_fmt);
>> +    if (pix->bytesperline < 0)
>> +            return pix->bytesperline;
>> +    if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
>> +            /*
>> +             * Todo: soc_camera_try_fmt could clear
>> +             * sizeimage, we can't get the value from
>> +             * userspace, just hard coding
>> +             */
>> +            pix->bytesperline = 2048;
>
>This has been fixed already.
>
Yes, we have submitted it.
We will adjust the code.

>> +    } else
>> +            pix->sizeimage = pix->height * pix->bytesperline;
>> +
>> +    /*
>> +     * limit to sensor capabilities
>> +     */
>> +    mf.width = pix->width;
>> +    mf.height = pix->height;
>> +    mf.field = V4L2_FIELD_NONE;
>> +    mf.colorspace = pix->colorspace;
>> +    mf.code = xlate->code;
>> +
>> +    ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
>> +    if (ret < 0)
>> +            return ret;
>> +
>> +    pix->width = mf.width;
>> +    pix->height = mf.height;
>> +    pix->colorspace = mf.colorspace;
>> +
>> +    switch (mf.field) {
>> +    case V4L2_FIELD_ANY:
>> +    case V4L2_FIELD_NONE:
>> +            pix->field = V4L2_FIELD_NONE;
>> +            break;
>> +    default:
>> +            cam_err(mcam, "camera: Field type %d unsupported.\n", mf.field);
>> +            ret = -EINVAL;
>> +            break;
>
>Same here: just set NONE always.
>
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int mcam_camera_set_parm(struct soc_camera_device *icd,
>> +                    struct v4l2_streamparm *para)
>> +{
>> +    return 0;
>> +}
>> +
>> +static int mcam_camera_init_videobuf(struct vb2_queue *q,
>> +                    struct soc_camera_device *icd)
>> +{
>> +    q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +    q->io_modes = VB2_USERPTR | VB2_MMAP;
>> +    q->drv_priv = icd;
>> +    q->ops = &mcam_videobuf_ops;
>> +    q->mem_ops = &vb2_dma_contig_memops;
>> +    q->buf_struct_size = sizeof(struct mcam_vb_buffer);
>> +
>> +    return vb2_queue_init(q);
>> +}
>> +
>> +static unsigned int mcam_camera_poll(struct file *file, poll_table *pt)
>> +{
>> +    struct soc_camera_device *icd = file->private_data;
>> +
>> +    return vb2_poll(&icd->vb2_vidq, file, pt);
>> +}
>> +
>> +static int mcam_camera_querycap(struct soc_camera_host *ici,
>> +                    struct v4l2_capability *cap)
>> +{
>> +    struct v4l2_dbg_chip_ident id;
>> +    struct mcam_camera *mcam = ici->priv;
>> +    struct soc_camera_device *icd = mcam->icd;
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    int ret = 0;
>> +
>> +    cap->version = KERNEL_VERSION(0, 0, 5);
>
>I don't think this is needed.
>
Yes, we will remove it.

>> +    cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>
>I think, the preferred way now is
>
>       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>
>
OK, will update it.

>> +    ret = v4l2_subdev_call(sd, core, g_chip_ident, &id);
>> +    if (ret < 0) {
>> +            cam_err(mcam, "%s %d\n", __func__, __LINE__);
>> +            return ret;
>> +    }
>> +
>> +    strcpy(cap->card, mcam->card_name);
>> +    strncpy(cap->driver, (const char *)&(id.ident), 4);
>> +
>> +    return 0;
>> +}
>> +
>> +static int mcam_camera_set_bus_param(struct soc_camera_device *icd)
>> +{
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    struct v4l2_mbus_config cfg;
>> +    int ret = 0;
>> +
>> +    ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
>> +    if ((ret < 0) && (ret != -ENOIOCTLCMD) && (ret != -ENODEV)) {
>> +            cam_err(mcam, "%s %d\n", __func__, __LINE__);
>> +            return ret;
>> +    }
>> +
>> +    ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
>> +    if ((ret < 0) && (ret != -ENOIOCTLCMD) && (ret != -ENODEV)) {
>> +            cam_err(mcam, "%s %d\n", __func__, __LINE__);
>> +            return ret;
>> +    }
>
>This doesn't make much sense to me - you retrieve client bus configuration
>and just write it back?
>
It looks we missed something, we will update it.

>> +
>> +    return 0;
>> +}
>> +
>> +static int mcam_camera_get_formats(struct soc_camera_device *icd, u32 idx,
>> +                    struct soc_camera_format_xlate  *xlate)
>> +{
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +    struct mcam_camera *mcam = ici->priv;
>> +    enum v4l2_mbus_pixelcode code;
>> +    const struct soc_mbus_pixelfmt *fmt;
>> +    int formats = 0, ret = 0, i;
>> +
>> +    ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
>> +    if (ret < 0)
>> +            /*
>> +             * No more formats
>> +             */
>> +            return 0;
>> +
>> +    fmt = soc_mbus_get_fmtdesc(code);
>> +    if (!fmt) {
>> +            cam_err(mcam, "camera: Invalid format #%u: %d\n", idx, code);
>> +            return 0;
>> +    }
>> +
>> +    switch (code) {
>> +    /*
>> +     * Refer to mbus_fmt struct
>> +     */
>> +    case V4L2_MBUS_FMT_UYVY8_2X8:
>> +            /*
>> +             * Add support for YUV420 and YUV422P
>> +             */
>> +            formats = ARRAY_SIZE(mcam_formats);
>> +            if (xlate) {
>> +                    for (i = 0; i < ARRAY_SIZE(mcam_formats); i++) {
>> +                            xlate->host_fmt = &mcam_formats[i];
>> +                            xlate->code = code;
>> +                            xlate++;
>> +                    }
>> +            }
>> +            return formats;
>> +    case V4L2_MBUS_FMT_JPEG_1X8:
>> +            if (xlate)
>> +                    cam_err(mcam, "camera: Providing format: %s\n",
>> +                            fmt->name);
>> +            break;
>> +    default:
>> +            /*
>> +             * camera controller can not support
>
>s/can not/cannot/
>
OK.

>> +             * this format, which might supported by the sensor
>
>s/might/might be/
>
OK.

>> +             */
>> +            cam_warn(mcam, "camera: Not support fmt: %s\n", fmt->name);
>
>s/Not support/Unsupported/
>
OK.

>> +            return 0;
>> +    }
>> +
>> +    formats++;
>> +    if (xlate) {
>> +            xlate->host_fmt = fmt;
>> +            xlate->code = code;
>> +            xlate++;
>> +    }
>> +
>> +    return formats;
>> +}
>> +
>> +struct soc_camera_host_ops mcam_soc_camera_host_ops = {
>> +    .owner          = THIS_MODULE,
>> +    .add            = mcam_camera_add_device,
>> +    .remove         = mcam_camera_remove_device,
>> +    .set_fmt        = mcam_camera_set_fmt,
>> +    .try_fmt        = mcam_camera_try_fmt,
>> +    .set_parm       = mcam_camera_set_parm,
>> +    .init_videobuf2 = mcam_camera_init_videobuf,
>> +    .poll           = mcam_camera_poll,
>> +    .querycap       = mcam_camera_querycap,
>> +    .set_bus_param  = mcam_camera_set_bus_param,
>> +    .get_formats    = mcam_camera_get_formats,
>> +};
>> +
>> +int mcam_soc_camera_host_register(struct mcam_camera *mcam)
>> +{
>> +    mcam->soc_host.drv_name = "mmp-camera";
>> +    mcam->soc_host.ops = &mcam_soc_camera_host_ops;
>> +    mcam->soc_host.priv = mcam;
>> +    mcam->soc_host.v4l2_dev.dev = mcam->dev;
>> +    mcam->soc_host.nr = mcam->ccic_id;
>> +    return soc_camera_host_register(&mcam->soc_host);
>> +}
>> +#endif
>> +
>>  /* ---------------------------------------------------------------------- */
>>  /*
>>   * Interrupt handler stuff
>> @@ -1658,9 +2400,9 @@ static void mcam_frame_complete(struct mcam_camera
>*cam, int frame)
>>       */
>>      set_bit(frame, &cam->flags);
>>      clear_bit(CF_DMA_ACTIVE, &cam->flags);
>> +    cam->frame_state.frames++;
>>      cam->next_buf = frame;
>>      cam->buf_seq[frame] = ++(cam->sequence);
>> -    frames++;
>>      /*
>>       * "This should never happen"
>>       */
>> @@ -1672,14 +2414,14 @@ static void mcam_frame_complete(struct mcam_camera
>*cam, int frame)
>>      cam->frame_complete(cam, frame);
>>  }
>>
>> -
>>  /*
>>   * The interrupt handler; this needs to be called from the
>>   * platform irq handler with the lock held.
>>   */
>>  int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
>>  {
>> -    unsigned int frame, handled = 0;
>> +    unsigned int frame, handled = IRQ_NONE;
>> +    struct vb2_buffer *vbuf;
>>
>>      mcam_reg_write(cam, REG_IRQSTAT, FRAMEIRQS); /* Clear'em all */
>>      /*
>> @@ -1693,9 +2435,11 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
>>       * each time.
>>       */
>>      for (frame = 0; frame < cam->nbufs; frame++)
>> -            if (irqs & (IRQ_EOF0 << frame)) {
>> +            if (irqs & (IRQ_EOF0 << frame) &&
>> +                    test_bit(CF_FRAME_SOF0 + frame, &cam->flags)) {
>>                      mcam_frame_complete(cam, frame);
>> -                    handled = 1;
>> +                    handled = IRQ_HANDLED;
>> +                    clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
>>                      if (cam->buffer_mode == B_DMA_sg)
>>                              break;
>>              }
>> @@ -1704,11 +2448,16 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
>>       * code assumes that we won't get multiple frame interrupts
>>       * at once; may want to rethink that.
>>       */
>> -    if (irqs & (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)) {
>> -            set_bit(CF_DMA_ACTIVE, &cam->flags);
>> -            handled = 1;
>> -            if (cam->buffer_mode == B_DMA_sg)
>> -                    mcam_ctlr_stop(cam);
>> +    for (frame = 0; frame < cam->nbufs; frame++) {
>> +            if (irqs & (IRQ_SOF0 << frame)) {
>> +                    set_bit(CF_DMA_ACTIVE, &cam->flags);
>> +                    set_bit(CF_FRAME_SOF0 + frame, &cam->flags);
>> +                    vbuf = &(cam->vb_bufs[frame]->vb_buf);
>> +                    do_gettimeofday(&vbuf->v4l2_buf.timestamp);
>> +                    handled = IRQ_HANDLED;
>> +                    if (cam->buffer_mode == B_DMA_sg)
>> +                            mcam_ctlr_stop(cam);
>> +            }
>
>This seems to be changing the behaviour quite a lot, should be verified
>for not introducing regressions on existing hardware.
>
Yes.

>>      }
>>      return handled;
>>  }
>> @@ -1717,6 +2466,7 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
>>  /*
>>   * Registration and such.
>>   */
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>  static struct ov7670_config sensor_cfg = {
>>      /*
>>       * Exclude QCIF mode, because it only captures a tiny portion
>> @@ -1725,20 +2475,25 @@ static struct ov7670_config sensor_cfg = {
>>      .min_width = 320,
>>      .min_height = 240,
>>  };
>> -
>> +#endif
>>
>>  int mccic_register(struct mcam_camera *cam)
>>  {
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>      struct i2c_board_info ov7670_info = {
>>              .type = "ov7670",
>>              .addr = 0x42 >> 1,
>>              .platform_data = &sensor_cfg,
>>      };
>> +#endif
>>      int ret;
>
>All the sensor information should be removed from the original driver,
>really.
>
Yes, we hope that.
Maybe we can prepare a patch to do that before these patches.

>>
>>      /*
>>       * Validate the requested buffer mode.
>>       */
>> +
>> +    /* Only support B_DMA_contig mode in soc camera currently */
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>      if (buffer_mode >= 0)
>>              cam->buffer_mode = buffer_mode;
>>      if (cam->buffer_mode == B_DMA_sg &&
>> @@ -1747,24 +2502,27 @@ int mccic_register(struct mcam_camera *cam)
>>                      "attempting vmalloc mode instead\n");
>>              cam->buffer_mode = B_vmalloc;
>>      }
>> +#endif
>>      if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
>>              printk(KERN_ERR "marvell-cam: buffer mode %d unsupported\n",
>>                              cam->buffer_mode);
>>              return -EINVAL;
>>      }
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>      /*
>>       * Register with V4L
>>       */
>>      ret = v4l2_device_register(cam->dev, &cam->v4l2_dev);
>>      if (ret)
>>              return ret;
>> -
>> +#endif
>>      mutex_init(&cam->s_mutex);
>>      cam->state = S_NOTREADY;
>>      mcam_set_config_needed(cam, 1);
>>      cam->pix_format = mcam_def_pix_format;
>>      cam->mbus_code = mcam_def_mbus_code;
>>      INIT_LIST_HEAD(&cam->buffers);
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>      mcam_ctlr_init(cam);
>>
>>      /*
>> @@ -1809,10 +2567,10 @@ out:
>>      return ret;
>>  out_unregister:
>>      v4l2_device_unregister(&cam->v4l2_dev);
>> +#endif
>>      return ret;
>>  }
>>
>> -
>>  void mccic_shutdown(struct mcam_camera *cam)
>>  {
>>      /*
>> @@ -1828,8 +2586,10 @@ void mccic_shutdown(struct mcam_camera *cam)
>>      vb2_queue_release(&cam->vb_queue);
>>      if (cam->buffer_mode == B_vmalloc)
>>              mcam_free_dma_bufs(cam);
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>      video_unregister_device(&cam->vdev);
>>      v4l2_device_unregister(&cam->v4l2_dev);
>> +#endif
>>  }
>>
>>  /*
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index bd6acba..b7d8b17 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -2,6 +2,12 @@
>>   * Marvell camera core structures.
>>   *
>>   * Copyright 2011 Jonathan Corbet corbet@lwn.net
>> + *
>> + * History:
>> + * Support Soc Camera
>> + * Support MIPI interface and Dual CCICs in Soc Camera mode
>> + * Sep-2012: Libin Yang <lbyang@marvell.com>
>> + *           Albert Wang <twang13@marvell.com>
>>   */
>>  #ifndef _MCAM_CORE_H
>>  #define _MCAM_CORE_H
>> @@ -18,7 +24,6 @@
>>  #if defined(CONFIG_VIDEOBUF2_VMALLOC) ||
>defined(CONFIG_VIDEOBUF2_VMALLOC_MODULE)
>>  #define MCAM_MODE_VMALLOC 1
>>  #endif
>> -
>>  #if defined(CONFIG_VIDEOBUF2_DMA_CONTIG) ||
>defined(CONFIG_VIDEOBUF2_DMA_CONTIG_MODULE)
>>  #define MCAM_MODE_DMA_CONTIG 1
>>  #endif
>> @@ -32,7 +37,6 @@
>>  #error One of the videobuf buffer modes must be selected in the config
>>  #endif
>>
>> -
>>  enum mcam_state {
>>      S_NOTREADY,     /* Not yet initialized */
>>      S_IDLE,         /* Just hanging around */
>> @@ -40,6 +44,7 @@ enum mcam_state {
>>      S_STREAMING,    /* Streaming data */
>>      S_BUFWAIT       /* streaming requested but no buffers yet */
>>  };
>> +
>>  #define MAX_DMA_BUFS 3
>>
>>  /*
>> @@ -73,6 +78,35 @@ static inline int mcam_buffer_mode_supported(enum
>mcam_buffer_mode mode)
>>      }
>>  }
>>
>> +struct yuv_pointer_t {
>> +    dma_addr_t y;
>> +    dma_addr_t u;
>> +    dma_addr_t v;
>> +};
>> +
>> +/*
>> + * Our buffer type for working with videobuf2.  Note that the vb2
>> + * developers have decreed that struct vb2_buffer must be at the
>> + * beginning of this structure.
>> + */
>> +struct mcam_vb_buffer {
>> +    struct vb2_buffer vb_buf;
>> +    struct list_head queue;
>> +    struct mcam_dma_desc *dma_desc; /* Descriptor virtual address */
>> +    dma_addr_t dma_desc_pa;         /* Descriptor physical address */
>> +    int dma_desc_nent;              /* Number of mapped descriptors */
>> +    struct yuv_pointer_t yuv_p;
>> +    int list_init_flag;
>> +};
>> +
>> +/*
>> + * Basic frame states
>> + */
>> +struct mmp_frame_state {
>> +    unsigned int frames;
>> +    unsigned int singles;
>> +    unsigned int delivered;
>> +};
>>
>>  /*
>>   * A description of one of our devices.
>> @@ -81,10 +115,15 @@ static inline int mcam_buffer_mode_supported(enum
>mcam_buffer_mode mode)
>>   *          dev_lock is also required for access to device registers.
>>   */
>>  struct mcam_camera {
>> +#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
>> +    struct soc_camera_host soc_host;
>> +    struct soc_camera_device *icd;
>> +#endif
>>      /*
>>       * These fields should be set by the platform code prior to
>>       * calling mcam_register().
>>       */
>> +    spinlock_t list_lock;
>>      struct i2c_adapter *i2c_adapter;
>>      unsigned char __iomem *regs;
>>      spinlock_t dev_lock;
>> @@ -93,11 +132,17 @@ struct mcam_camera {
>>      short int clock_speed;  /* Sensor clock speed, default 30 */
>>      short int use_smbus;    /* SMBUS or straight I2c? */
>>      enum mcam_buffer_mode buffer_mode;
>> -    /*
>> -     * Callbacks from the core to the platform code.
>> -     */
>> -    void (*plat_power_up) (struct mcam_camera *cam);
>> -    void (*plat_power_down) (struct mcam_camera *cam);
>> +
>> +    int bus_type;
>> +    int ccic_id;
>> +    int (*dphy)[3];
>> +    int burst;
>> +    int mclk_min;
>> +    int mclk_src;
>> +    int mclk_div;
>> +    int mipi_enabled;
>> +    int lane;
>> +    char *card_name;
>>
>>      /*
>>       * Everything below here is private to the mcam core and
>> @@ -108,12 +153,24 @@ struct mcam_camera {
>>      unsigned long flags;            /* Buffer status, mainly (dev_lock) */
>>      int users;                      /* How many open FDs */
>>
>> +    int frame_rate;
>> +    struct mmp_frame_state frame_state;     /* Frame state counter */
>> +#ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
>>      /*
>>       * Subsystem structures.
>>       */
>>      struct video_device vdev;
>>      struct v4l2_subdev *sensor;
>>      unsigned short sensor_addr;
>> +    u32 sensor_type;                /* Currently ov7670 only */
>> +#endif
>> +    /*
>> +     * Callbacks from the core to the platform code.
>> +     */
>> +    void (*plat_power_up) (struct mcam_camera *cam);
>> +    void (*plat_power_down) (struct mcam_camera *cam);
>> +    void (*calc_dphy)(struct mcam_camera *cam,
>> +                    struct v4l2_subdev_frame_interval *inter);
>>
>>      /* Videobuf2 stuff */
>>      struct vb2_queue vb_queue;
>> @@ -141,7 +198,6 @@ struct mcam_camera {
>>      void (*frame_complete)(struct mcam_camera *cam, int frame);
>>
>>      /* Current operating parameters */
>> -    u32 sensor_type;                /* Currently ov7670 only */
>>      struct v4l2_pix_format pix_format;
>>      enum v4l2_mbus_pixelcode mbus_code;
>>
>> @@ -149,7 +205,6 @@ struct mcam_camera {
>>      struct mutex s_mutex; /* Access to this structure */
>>  };
>>
>> -
>>  /*
>>   * Register I/O functions.  These are here because the platform code
>>   * may legitimately need to mess with the register space.
>> @@ -169,7 +224,6 @@ static inline unsigned int mcam_reg_read(struct mcam_camera
>*cam,
>>      return ioread32(cam->regs + reg);
>>  }
>>
>> -
>>  static inline void mcam_reg_write_mask(struct mcam_camera *cam, unsigned int reg,
>>              unsigned int val, unsigned int mask)
>>  {
>> @@ -201,6 +255,9 @@ void mccic_shutdown(struct mcam_camera *cam);
>>  void mccic_suspend(struct mcam_camera *cam);
>>  int mccic_resume(struct mcam_camera *cam);
>>  #endif
>> +#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
>> +int mcam_soc_camera_host_register(struct mcam_camera *mcam);
>> +#endif
>>
>>  /*
>>   * Register definitions for the m88alp01 camera interface.  Offsets in bytes
>> @@ -209,14 +266,31 @@ int mccic_resume(struct mcam_camera *cam);
>>  #define REG_Y0BAR   0x00
>>  #define REG_Y1BAR   0x04
>>  #define REG_Y2BAR   0x08
>> -/* ... */
>> +#define REG_U0BAR   0x0c
>> +#define REG_U1BAR   0x10
>> +#define REG_U2BAR   0x14
>> +#define REG_V0BAR   0x18
>> +#define REG_V1BAR   0x1C
>> +#define REG_V2BAR   0x20
>> +
>> +/*
>> + * MIPI enable
>> + */
>> +#define REG_CSI2_CTRL0      0x100
>> +#define REG_CSI2_DPHY3  0x12c
>> +#define REG_CSI2_DPHY5  0x134
>> +#define REG_CSI2_DPHY6  0x138
>>
>> +/* ... */
>>  #define REG_IMGPITCH        0x24    /* Image pitch register */
>>  #define   IMGP_YP_SHFT        2             /* Y pitch params */
>>  #define   IMGP_YP_MASK        0x00003ffc    /* Y pitch field */
>>  #define       IMGP_UVP_SHFT   18            /* UV pitch (planar) */
>>  #define   IMGP_UVP_MASK   0x3ffc0000
>> +
>>  #define REG_IRQSTATRAW      0x28    /* RAW IRQ Status */
>> +#define REG_IRQMASK 0x2c    /* IRQ mask - same bits as IRQSTAT */
>> +#define REG_IRQSTAT 0x30    /* IRQ status / clear */
>>  #define   IRQ_EOF0    0x00000001    /* End of frame 0 */
>>  #define   IRQ_EOF1    0x00000002    /* End of frame 1 */
>>  #define   IRQ_EOF2    0x00000004    /* End of frame 2 */
>> @@ -224,14 +298,10 @@ int mccic_resume(struct mcam_camera *cam);
>>  #define   IRQ_SOF1    0x00000010    /* Start of frame 1 */
>>  #define   IRQ_SOF2    0x00000020    /* Start of frame 2 */
>>  #define   IRQ_OVERFLOW        0x00000040    /* FIFO overflow */
>> -#define   IRQ_TWSIW   0x00010000    /* TWSI (smbus) write */
>> -#define   IRQ_TWSIR   0x00020000    /* TWSI read */
>> -#define   IRQ_TWSIE   0x00040000    /* TWSI error */
>> -#define   TWSIIRQS (IRQ_TWSIW|IRQ_TWSIR|IRQ_TWSIE)
>> -#define   FRAMEIRQS
>(IRQ_EOF0|IRQ_EOF1|IRQ_EOF2|IRQ_SOF0|IRQ_SOF1|IRQ_SOF2)
>> -#define   ALLIRQS (TWSIIRQS|FRAMEIRQS|IRQ_OVERFLOW)
>> -#define REG_IRQMASK 0x2c    /* IRQ mask - same bits as IRQSTAT */
>> -#define REG_IRQSTAT 0x30    /* IRQ status / clear */
>> +#define   FRAMEIRQS_EOF   (IRQ_EOF0 | IRQ_EOF1 | IRQ_EOF2)
>> +#define   FRAMEIRQS_SOF   (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)
>> +#define   FRAMEIRQS   (FRAMEIRQS_EOF | FRAMEIRQS_SOF)
>> +#define   ALLIRQS     (TWSIIRQS|FRAMEIRQS|IRQ_OVERFLOW)
>>
>>  #define REG_IMGSIZE 0x34    /* Image size */
>>  #define  IMGSZ_V_MASK         0x1fff0000
>> @@ -241,10 +311,8 @@ int mccic_resume(struct mcam_camera *cam);
>>
>>  #define REG_CTRL0   0x3c    /* Control 0 */
>>  #define   C0_ENABLE   0x00000001    /* Makes the whole thing go */
>> -
>>  /* Mask for all the format bits */
>>  #define   C0_DF_MASK          0x00fffffc    /* Bits 2-23 */
>> -
>>  /* RGB ordering */
>>  #define       C0_RGB4_RGBX    0x00000000
>>  #define       C0_RGB4_XRGB    0x00000004
>> @@ -254,7 +322,6 @@ int mccic_resume(struct mcam_camera *cam);
>>  #define       C0_RGB5_GRBG    0x00000004
>>  #define       C0_RGB5_GBRG    0x00000008
>>  #define       C0_RGB5_BGGR    0x0000000c
>> -
>>  /* Spec has two fields for DIN and DOUT, but they must match, so
>>     combine them here. */
>>  #define       C0_DF_YUV       0x00000000    /* Data is YUV      */
>> @@ -283,21 +350,28 @@ int mccic_resume(struct mcam_camera *cam);
>>  #define       C0_DOWNSCALE    0x08000000    /* Enable downscaler */
>>  #define       C0_SIFM_MASK    0xc0000000    /* SIF mode bits */
>>  #define       C0_SIF_HVSYNC   0x00000000    /* Use H/VSYNC */
>> -#define       CO_SOF_NOSYNC   0x40000000    /* Use inband active signaling */
>> +#define       C0_SOF_NOSYNC   0x40000000    /* Use inband active signaling */
>> +#define   C0_EOF_VSYNC        0x00400000    /* Generate EOF by VSYNC */
>> +#define   C0_VEDGE_CTRL   0x00800000        /* Detecting falling edge of VSYNC */
>>
>>  /* Bits below C1_444ALPHA are not present in Cafe */
>>  #define REG_CTRL1   0x40    /* Control 1 */
>> +#define   C1_RESERVED         0x0000003c    /* Reserved and shouldn't be changed
>*/
>> +#define   C1_444ALPHA         0x00f00000    /* Alpha field in RGB444 */
>>  #define       C1_CLKGATE      0x00000001    /* Sensor clock gate */
>>  #define   C1_DESC_ENA         0x00000100    /* DMA descriptor enable */
>>  #define   C1_DESC_3WORD   0x00000200        /* Three-word descriptors used */
>>  #define       C1_444ALPHA     0x00f00000    /* Alpha field in RGB444 */
>>  #define       C1_ALPHA_SHFT   20
>> -#define       C1_DMAB32       0x00000000    /* 32-byte DMA burst */
>> -#define       C1_DMAB16       0x02000000    /* 16-byte DMA burst */
>> -#define       C1_DMAB64       0x04000000    /* 64-byte DMA burst */
>> +#define       C1_DMAB64       0x00000000    /* 64-byte DMA burst */
>> +#define       C1_DMAB128      0x02000000    /* 128-byte DMA burst */
>> +#define       C1_DMAB256      0x04000000    /* 256-byte DMA burst */
>>  #define       C1_DMAB_MASK    0x06000000
>>  #define       C1_TWOBUFS      0x08000000    /* Use only two DMA buffers */
>>  #define       C1_PWRDWN       0x10000000    /* Power down */
>> +#define   C1_DMAPOSTED        0x40000000    /* DMA Posted Select */
>> +
>> +#define REG_CTRL3   0x1ec   /* CCIC parallel mode */
>>
>>  #define REG_CLKCTRL 0x88    /* Clock control */
>>  #define       CLK_DIV_MASK    0x0000ffff    /* Upper bits RW "reserved" */
>> --
>> 1.7.0.4
>>
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
