Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:49766 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902AbZFKWlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 18:41:25 -0400
Received: by an-out-0708.google.com with SMTP id d40so3422898and.1
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2009 15:41:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244739649-27466-2-git-send-email-m-karicheri2@ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-2-git-send-email-m-karicheri2@ti.com>
Date: Fri, 12 Jun 2009 02:41:26 +0400
Message-ID: <208cbae30906111541u21693b69vd67d02792f119509@mail.gmail.com>
Subject: Re: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and DM6446
From: Alexey Klimov <klimov.linux@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Very small suggestion, please see below.

On Thu, Jun 11, 2009 at 9:00 PM, <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> Re-sending since previous one missed a file (vpfe_types.h)
>
> VPFE Capture bridge driver
>
> This is version, v2 of vpfe capture bridge driver for doing video
> capture on DM355 and DM6446 evms. The ccdc hw modules register with the
> driver and are used for configuring the CCD Controller for a specific
> decoder interface. The driver also registers the sub devices required
> for a specific evm. More than one sub devices can be registered.
> This allows driver to switch dynamically to capture video from
> any sub device that is registered. Currently only one sub device
> (tvp5146) is supported. But in future this driver is expected
> to do capture from sensor devices such as Micron's MT9T001,MT9T031
> and MT9P031 etc. The driver currently supports MMAP based IO.
>
> Following are the updates based on review comments:-
>        1) minor number is allocated dynamically
>        2) updates to QUERYCAP handling
>        3) eliminated intermediate vpfe pixel format
>        4) refactored few functions
>        5) reworked isr routines for reducing indentation
>        6) reworked vpfe_check_format and added a documentation
>           for algorithm
>        7) fixed memory leak in probe()
>
> TODO list :
>        1) load sub device from bridge driver. Hans has enhanced
>        the v4l2-subdevice framework to do this. Will be updated
>        soon to pick this.
>
>
> Reviewed By "Hans Verkuil".
> Reviewed By "Laurent Pinchart".
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
>
>  drivers/media/video/davinci/vpfe_capture.c | 2252 ++++++++++++++++++++++++++++
>  include/media/davinci/vpfe_capture.h       |  183 +++
>  include/media/davinci/vpfe_types.h         |   51 +
>  3 files changed, 2486 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpfe_capture.c
>  create mode 100644 include/media/davinci/vpfe_capture.h
>  create mode 100644 include/media/davinci/vpfe_types.h


<snip>

> +/* vpfe capture driver file operations */
> +static struct v4l2_file_operations vpfe_fops = {
> +       .owner = THIS_MODULE,
> +       .open = vpfe_open,
> +       .release = vpfe_release,
> +       .ioctl = video_ioctl2,
> +       .mmap = vpfe_mmap,
> +       .poll = vpfe_poll
> +};
> +
> +/*
> + * vpfe_check_format()
> + * This function adjust the input pixel format as per hardware
> + * capabilities and update the same in pixfmt.
> + * Following algorithm used :-
> + *
> + *     If given pixformat is not in the vpfe list of pix formats or not
> + *     supported by the hardware, current value of pixformat in the device
> + *     is used
> + *     If given field is not supported, then current field is used. If field
> + *     is different from current, then it is matched with that from sub device.
> + *     Minimum height is 2 lines for interlaced or tb field and 1 line for
> + *     progressive. Maximum height is clamped to active active lines of scan
> + *     Minimum width is 32 bytes in memory and width is clamped to active
> + *     pixels of scan.
> + *     bytesperline is a multiple of 32.
> + */
> +static const struct vpfe_pixel_format *
> +       vpfe_check_format(struct vpfe_device *vpfe_dev,
> +                         struct v4l2_pix_format *pixfmt)
> +{
> +       u32 min_height = 1, min_width = 32, max_width, max_height;
> +       const struct vpfe_pixel_format *vpfe_pix_fmt;
> +       u32 pix;
> +       int temp, found;
> +
> +       vpfe_pix_fmt = vpfe_lookup_pix_format(pixfmt->pixelformat);
> +       if (NULL == vpfe_pix_fmt) {
> +               /*
> +                * use current pixel format in the vpfe device. We
> +                * will find this pix format in the table
> +                */
> +               pixfmt->pixelformat = vpfe_dev->fmt.fmt.pix.pixelformat;
> +               vpfe_pix_fmt = vpfe_lookup_pix_format(pixfmt->pixelformat);
> +       }
> +
> +       /* check if hw supports it */
> +       temp = 0;
> +       found = 0;
> +       while (ccdc_dev->hw_ops.enum_pix(&pix, temp) >= 0) {
> +               if (vpfe_pix_fmt->fmtdesc.pixelformat == pix) {
> +                       found = 1;
> +                       break;
> +               }
> +               temp++;
> +       }
> +
> +       if (!found) {
> +               /* use current pixel format */
> +               pixfmt->pixelformat = vpfe_dev->fmt.fmt.pix.pixelformat;
> +               /*
> +                * Since this is currently used in the vpfe device, we
> +                * will find this pix format in the table
> +                */
> +               vpfe_pix_fmt = vpfe_lookup_pix_format(pixfmt->pixelformat);
> +       }
> +
> +       /* check what field format is supported */
> +       if (pixfmt->field == V4L2_FIELD_ANY) {
> +               /* if field is any, use current value as default */
> +               pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
> +       }
> +
> +       /*
> +        * if field is not same as current field in the vpfe device
> +        * try matching the field with the sub device field
> +        */
> +       if (vpfe_dev->fmt.fmt.pix.field != pixfmt->field) {
> +               /*
> +                * If field value is not in the supported fields, use current
> +                * field used in the device as default
> +                */
> +               switch (pixfmt->field) {
> +               case V4L2_FIELD_INTERLACED:
> +               case V4L2_FIELD_SEQ_TB:
> +                       /* if sub device is supporting progressive, use that */
> +                       if (!vpfe_dev->std_info.frame_format)
> +                               pixfmt->field = V4L2_FIELD_NONE;
> +                       break;
> +               case V4L2_FIELD_NONE:
> +                       if (vpfe_dev->std_info.frame_format)
> +                               pixfmt->field = V4L2_FIELD_INTERLACED;
> +                       break;
> +
> +               default:
> +                       /* use current field as default */
> +                       pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
> +               }
> +       }
> +
> +       /* Now adjust image resolutions supported */
> +       if (pixfmt->field == V4L2_FIELD_INTERLACED ||
> +           pixfmt->field == V4L2_FIELD_SEQ_TB)
> +               min_height = 2;
> +
> +       max_width = vpfe_dev->std_info.active_pixels;
> +       max_height = vpfe_dev->std_info.active_lines;
> +       min_width /= vpfe_pix_fmt->bpp;
> +
> +       v4l2_info(&vpfe_dev->v4l2_dev, "width = %d, height = %d, bpp = %d\n",
> +                 pixfmt->width, pixfmt->height, vpfe_pix_fmt->bpp);
> +
> +       pixfmt->width = clamp((pixfmt->width), min_width, max_width);
> +       pixfmt->height = clamp((pixfmt->height), min_height, max_height);
> +
> +       /* If interlaced, adjust height to be a multiple of 2 */
> +       if (pixfmt->field == V4L2_FIELD_INTERLACED)
> +               pixfmt->height &= (~1);
> +       /*
> +        * recalculate bytesperline and sizeimage since width
> +        * and height might have changed
> +        */
> +       pixfmt->bytesperline = (((pixfmt->width * vpfe_pix_fmt->bpp) + 31)
> +                               & ~31);
> +       if (pixfmt->pixelformat == V4L2_PIX_FMT_NV12)
> +               pixfmt->sizeimage =
> +                       pixfmt->bytesperline * pixfmt->height +
> +                       ((pixfmt->bytesperline * pixfmt->height) >> 1);
> +       else
> +               pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
> +
> +       v4l2_info(&vpfe_dev->v4l2_dev, "adjusted width = %d, height ="
> +                " %d, bpp = %d, bytesperline = %d, sizeimage = %d\n",
> +                pixfmt->width, pixfmt->height, vpfe_pix_fmt->bpp,
> +                pixfmt->bytesperline, pixfmt->sizeimage);
> +       return vpfe_pix_fmt;
> +}
> +
> +static int vpfe_querycap(struct file *file, void  *priv,
> +                              struct v4l2_capability *cap)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querycap\n");
> +
> +       cap->version = VPFE_CAPTURE_VERSION_CODE;
> +       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +       strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
> +       strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));
> +       strlcpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
> +       return 0;
> +}
> +
> +static int vpfe_g_fmt_vid_cap(struct file *file, void *priv,
> +                               struct v4l2_format *fmt)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       int ret = 0;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt_vid_cap\n");
> +       /* Fill in the information about format */
> +       *fmt = vpfe_dev->fmt;
> +       return ret;
> +}
> +
> +static int vpfe_enum_fmt_vid_cap(struct file *file, void  *priv,
> +                                  struct v4l2_fmtdesc *fmt)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       const struct vpfe_pixel_format *pix_fmt;
> +       int temp_index;
> +       u32 pix;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_fmt_vid_cap\n");
> +
> +       if (ccdc_dev->hw_ops.enum_pix(&pix, fmt->index) < 0)
> +               return -EINVAL;
> +
> +       /* Fill in the information about format */
> +       pix_fmt = vpfe_lookup_pix_format(pix);
> +       if (NULL != pix_fmt) {
> +               temp_index = fmt->index;
> +               *fmt = pix_fmt->fmtdesc;
> +               fmt->index = temp_index;
> +               return 0;
> +       }
> +       return -EINVAL;
> +}
> +
> +static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
> +                               struct v4l2_format *fmt)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       const struct vpfe_pixel_format *pix_fmts;
> +       int ret = 0;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_fmt_vid_cap\n");
> +
> +       /* If streaming is started, return error */
> +       if (vpfe_dev->started) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Streaming is started\n");
> +               return -EBUSY;
> +       }
> +
> +       /* Check for valid frame format */
> +       pix_fmts = vpfe_check_format(vpfe_dev, &fmt->fmt.pix);
> +
> +       if (NULL == pix_fmts)
> +               return -EINVAL;
> +
> +       /* store the pixel format in the device  object */
> +       ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +       if (ret)
> +               return ret;
> +
> +       /* First detach any IRQ if currently attached */
> +       vpfe_detach_irq(vpfe_dev);
> +       vpfe_dev->fmt = *fmt;
> +       /* set image capture parameters in the ccdc */
> +       ret = vpfe_config_ccdc_image_format(vpfe_dev);
> +       mutex_unlock(&vpfe_dev->lock);
> +       return ret;
> +}
> +
> +static int vpfe_try_fmt_vid_cap(struct file *file, void *priv,
> +                                 struct v4l2_format *f)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       const struct vpfe_pixel_format *pix_fmts;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_try_fmt_vid_cap\n");
> +
> +       pix_fmts = vpfe_check_format(vpfe_dev, &f->fmt.pix);
> +       if (NULL == pix_fmts)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +/*
> + * vpfe_get_subdev_input_index - Get subdev index and subdev input index for a
> + * given app input index
> + */
> +static int vpfe_get_subdev_input_index(struct vpfe_device *vpfe_dev,
> +                                       int *subdev_index,
> +                                       int *subdev_input_index,
> +                                       int app_input_index)
> +{
> +       struct vpfe_config *cfg = vpfe_dev->cfg;
> +       struct vpfe_subdev_info *sub_dev;
> +       int i, j = 0;
> +
> +       for (i = 0; i < cfg->num_subdevs; i++) {
> +               sub_dev = &cfg->sub_devs[i];
> +               if (app_input_index < (j + sub_dev->num_inputs)) {
> +                       *subdev_index = i;
> +                       *subdev_input_index = app_input_index - j;
> +                       return 0;
> +               }
> +               j += sub_dev->num_inputs;
> +       }
> +       return -EINVAL;
> +}
> +
> +/*
> + * vpfe_get_app_input - Get app input index for a given subdev input index
> + * driver stores the input index of the current sub device and translate it
> + * when application request the current input
> + */
> +static int vpfe_get_app_input_index(struct vpfe_device *vpfe_dev,
> +                                   int *app_input_index)
> +{
> +       struct vpfe_config *cfg = vpfe_dev->cfg;
> +       struct vpfe_subdev_info *sub_dev;
> +       int i, j = 0;
> +
> +       for (i = 0; i < cfg->num_subdevs; i++) {
> +               sub_dev = &cfg->sub_devs[i];
> +               if (!strcmp(sub_dev->name, vpfe_dev->current_subdev->name)) {
> +                       if (vpfe_dev->current_input >= sub_dev->num_inputs)
> +                               return -1;
> +                       *app_input_index = j + vpfe_dev->current_input;
> +                       return 0;
> +               }
> +               j += sub_dev->num_inputs;
> +       }
> +       return -EINVAL;
> +}
> +
> +static int vpfe_enum_input(struct file *file, void *priv,
> +                                struct v4l2_input *inp)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct vpfe_subdev_info *sub_dev;
> +       int subdev, index ;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_input\n");
> +
> +       if (vpfe_get_subdev_input_index(vpfe_dev,
> +                                       &subdev,
> +                                       &index,
> +                                       inp->index) < 0) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "input information not found"
> +                        " for the subdev\n");
> +               return -EINVAL;
> +       }
> +       sub_dev = &vpfe_dev->cfg->sub_devs[subdev];
> +       memcpy(inp, &sub_dev->inputs[index],
> +               sizeof(struct v4l2_input));
> +       return 0;
> +}
> +
> +static int vpfe_g_input(struct file *file, void *priv, unsigned int *index)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_input\n");
> +
> +       return vpfe_get_app_input_index(vpfe_dev, index);
> +}
> +
> +
> +static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct vpfe_subdev_info *sub_dev;
> +       int subdev_index, inp_index;
> +       struct v4l2_routing *route;
> +       u32 input = 0, output = 0;
> +       int ret = -EINVAL;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_input\n");
> +
> +       ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +       if (ret)
> +               return ret;
> +
> +       /*
> +        * If streaming is started return device busy
> +        * error
> +        */
> +       if (vpfe_dev->started) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Streaming is on\n");
> +               ret = -EBUSY;
> +               goto unlock_out;
> +       }
> +
> +       if (vpfe_get_subdev_input_index(vpfe_dev,
> +                                       &subdev_index,
> +                                       &inp_index,
> +                                       index) < 0) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "invalid input index\n");
> +               goto unlock_out;
> +       }
> +
> +       sub_dev = &vpfe_dev->cfg->sub_devs[subdev_index];
> +       route = &sub_dev->routes[inp_index];
> +       if (route && sub_dev->can_route) {
> +               input = route->input;
> +               output = route->output;
> +       }
> +
> +       ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> +                                        sub_dev->grp_id,
> +                                        video, s_routing, input,
> +                                        output, 0);
> +
> +       if (ret) {
> +               v4l2_err(&vpfe_dev->v4l2_dev,
> +                       "vpfe_doioctl:error in setting input in decoder \n");
> +               ret = -EINVAL;
> +               goto unlock_out;
> +       }
> +       vpfe_dev->current_subdev = sub_dev;
> +       vpfe_dev->current_input = index;
> +       vpfe_dev->std_index = 0;
> +
> +       ret = vpfe_set_hw_if_params(vpfe_dev);
> +       if (ret)
> +               goto unlock_out;
> +
> +       /* set the default image parameters in the device */
> +       ret = vpfe_config_image_format(vpfe_dev,
> +                               &vpfe_standards[vpfe_dev->std_index].std_id);
> +       if (ret)
> +               goto unlock_out;

Why you check ret value and go to label below?
Probably you can remove if-check and goto here.

> +
> +unlock_out:
> +       mutex_unlock(&vpfe_dev->lock);
> +       return ret;
> +}
> +
> +static int vpfe_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct vpfe_subdev_info *subdev;
> +       int ret = 0;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querystd\n");
> +
> +       ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +       subdev = vpfe_dev->current_subdev;
> +       if (ret)
> +               return ret;
> +       /* Call querystd function of decoder device */
> +       ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> +                                        subdev->grp_id,
> +                                        video, querystd, std_id);
> +       mutex_unlock(&vpfe_dev->lock);
> +       return ret;
> +}
> +
> +static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct vpfe_subdev_info *subdev;
> +       int ret = 0;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_std\n");
> +
> +       /* Call decoder driver function to set the standard */
> +       ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +       if (ret)
> +               return ret;
> +
> +       subdev = vpfe_dev->current_subdev;
> +       /* If streaming is started, return device busy error */
> +       if (vpfe_dev->started) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "streaming is started\n");
> +               ret = -EBUSY;
> +               goto unlock_out;
> +       }
> +
> +       ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, subdev->grp_id,
> +                                        core, s_std, *std_id);
> +       if (ret < 0) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
> +               goto unlock_out;
> +       }
> +       ret = vpfe_config_image_format(vpfe_dev, std_id);
> +
> +unlock_out:
> +       mutex_unlock(&vpfe_dev->lock);
> +       return ret;
> +}
> +
> +static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_std\n");
> +
> +       *std_id = vpfe_standards[vpfe_dev->std_index].std_id;
> +       return 0;
> +}
> +/*
> + *  Videobuf operations
> + */
> +static int vpfe_videobuf_setup(struct videobuf_queue *vq,
> +                               unsigned int *count,
> +                               unsigned int *size)
> +{
> +       struct vpfe_fh *fh = vq->priv_data;
> +       struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_setup\n");
> +       *size = config_params.device_bufsize;
> +
> +       if (*count < config_params.min_numbuffers)
> +               *count = config_params.min_numbuffers;
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> +               "count=%d, size=%d\n", *count, *size);
> +       return 0;
> +}
> +
> +static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
> +                               struct videobuf_buffer *vb,
> +                               enum v4l2_field field)
> +{
> +       struct vpfe_fh *fh = vq->priv_data;
> +       struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_prepare\n");
> +
> +       /* If buffer is not initialized, initialize it */
> +       if (VIDEOBUF_NEEDS_INIT == vb->state) {
> +               vb->width = vpfe_dev->fmt.fmt.pix.width;
> +               vb->height = vpfe_dev->fmt.fmt.pix.height;
> +               vb->size = vpfe_dev->fmt.fmt.pix.sizeimage;
> +               vb->field = field;
> +       }
> +       vb->state = VIDEOBUF_PREPARED;
> +       return 0;
> +}
> +
> +static void vpfe_videobuf_queue(struct videobuf_queue *vq,
> +                               struct videobuf_buffer *vb)
> +{
> +       /* Get the file handle object and device object */
> +       struct vpfe_fh *fh = vq->priv_data;
> +       struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +       unsigned long flags;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_queue\n");
> +
> +       /* add the buffer to the DMA queue */
> +       spin_lock_irqsave(&vpfe_dev->dma_queue_lock, flags);
> +       list_add_tail(&vb->queue, &vpfe_dev->dma_queue);
> +       spin_unlock_irqrestore(&vpfe_dev->dma_queue_lock, flags);
> +
> +       /* Change state of the buffer */
> +       vb->state = VIDEOBUF_QUEUED;
> +}
> +
> +static void vpfe_videobuf_release(struct videobuf_queue *vq,
> +                                 struct videobuf_buffer *vb)
> +{
> +       struct vpfe_fh *fh = vq->priv_data;
> +       struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +       unsigned long flags;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_videobuf_release\n");
> +
> +       /*
> +        * We need to flush the buffer from the dma queue since
> +        * they are de-allocated
> +        */
> +       spin_lock_irqsave(&vpfe_dev->dma_queue_lock, flags);
> +       INIT_LIST_HEAD(&vpfe_dev->dma_queue);
> +       spin_unlock_irqrestore(&vpfe_dev->dma_queue_lock, flags);
> +       videobuf_dma_contig_free(vq, vb);
> +       vb->state = VIDEOBUF_NEEDS_INIT;
> +}
> +
> +static struct videobuf_queue_ops vpfe_videobuf_qops = {
> +       .buf_setup      = vpfe_videobuf_setup,
> +       .buf_prepare    = vpfe_videobuf_prepare,
> +       .buf_queue      = vpfe_videobuf_queue,
> +       .buf_release    = vpfe_videobuf_release,
> +};
> +
> +/*
> + * vpfe_reqbufs. currently support REQBUF only once opening
> + * the device.
> + */
> +static int vpfe_reqbufs(struct file *file, void *priv,
> +                       struct v4l2_requestbuffers *req_buf)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +       int ret = 0;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs\n");
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != req_buf->type) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buffer type\n");
> +               return -EINVAL;
> +       }
> +
> +       if (V4L2_MEMORY_USERPTR == req_buf->memory) {
> +               /* we don't support user ptr IO */
> +               v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs:"
> +                        " USERPTR IO not supported>\n");
> +               return  -EINVAL;
> +       }
> +
> +       ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +       if (ret)
> +               return ret;
> +
> +       if (vpfe_dev->io_usrs != 0) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Only one IO user allowed\n");
> +               ret = -EBUSY;
> +               goto unlock_out;
> +       }
> +
> +       vpfe_dev->memory = req_buf->memory;
> +       videobuf_queue_dma_contig_init(&vpfe_dev->buffer_queue,
> +                               &vpfe_videobuf_qops,
> +                               NULL,
> +                               &vpfe_dev->irqlock,
> +                               req_buf->type,
> +                               vpfe_dev->fmt.fmt.pix.field,
> +                               sizeof(struct videobuf_buffer),
> +                               fh);
> +
> +       fh->io_allowed = 1;
> +       vpfe_dev->io_usrs = 1;
> +       INIT_LIST_HEAD(&vpfe_dev->dma_queue);
> +       ret = videobuf_reqbufs(&vpfe_dev->buffer_queue, req_buf);
> +unlock_out:
> +       mutex_unlock(&vpfe_dev->lock);
> +       return ret;
> +}
> +
> +static int vpfe_querybuf(struct file *file, void *priv,
> +                        struct v4l2_buffer *buf)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querybuf\n");
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf->type) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +               return  -EINVAL;
> +       }
> +
> +       if (vpfe_dev->memory != V4L2_MEMORY_MMAP) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Invalid memory\n");
> +               return -EINVAL;
> +       }
> +       /* Call videobuf_querybuf to get information */
> +       return videobuf_querybuf(&vpfe_dev->buffer_queue, buf);
> +}
> +
> +static int vpfe_qbuf(struct file *file, void *priv,
> +                    struct v4l2_buffer *p)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_qbuf\n");
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != p->type) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       /*
> +        * If this file handle is not allowed to do IO,
> +        * return error
> +        */
> +       if (!fh->io_allowed) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
> +               return -EACCES;
> +       }
> +       return videobuf_qbuf(&vpfe_dev->buffer_queue, p);
> +}
> +
> +static int vpfe_dqbuf(struct file *file, void *priv,
> +                     struct v4l2_buffer *buf)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_dqbuf\n");
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf->type) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +               return -EINVAL;
> +       }
> +       return videobuf_dqbuf(&vpfe_dev->buffer_queue,
> +                                     buf, file->f_flags & O_NONBLOCK);
> +}
> +
> +/*
> + * vpfe_calculate_offsets : This function calculates buffers offset
> + * for top and bottom field
> + */
> +static void vpfe_calculate_offsets(struct vpfe_device *vpfe_dev)
> +{
> +       struct v4l2_rect image_win;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_calculate_offsets\n");
> +
> +       ccdc_dev->hw_ops.get_image_window(&image_win);
> +       vpfe_dev->field_off = image_win.height * image_win.width;
> +}
> +
> +/* vpfe_start_ccdc_capture: start streaming in ccdc/isif */
> +static void vpfe_start_ccdc_capture(struct vpfe_device *vpfe_dev)
> +{
> +       ccdc_dev->hw_ops.enable(1);
> +       if (ccdc_dev->hw_ops.enable_out_to_sdram)
> +               ccdc_dev->hw_ops.enable_out_to_sdram(1);
> +       vpfe_dev->started = 1;
> +}
> +
> +/*
> + * vpfe_streamon. Assume the DMA queue is not empty.
> + * application is expected to call QBUF before calling
> + * this ioctl. If not, driver returns error
> + */
> +static int vpfe_streamon(struct file *file, void *priv,
> +                        enum v4l2_buf_type buf_type)
> +{
> +       struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +       struct vpfe_subdev_info *subdev;
> +       unsigned long addr;
> +       int ret = 0;
> +
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamon\n");
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf_type) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       /* If file handle is not allowed IO, return error */
> +       if (!fh->io_allowed) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
> +               return -EACCES;
> +       }
> +
> +       subdev = vpfe_dev->current_subdev;
> +       ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, subdev->grp_id,
> +                                       video, s_stream, 1);
> +
> +       if (ret && (ret != -ENOIOCTLCMD)) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "stream on failed in subdev\n");
> +               return -EINVAL;
> +       }
> +
> +       /* If buffer queue is empty, return error */
> +       if (list_empty(&vpfe_dev->buffer_queue.stream)) {
> +               v4l2_err(&vpfe_dev->v4l2_dev, "buffer queue is empty\n");
> +               return EIO;

return -EIO?

-- 
Best regards, Klimov Alexey
