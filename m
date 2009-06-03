Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60395 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZFCOqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 10:46:01 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 3 Jun 2009 09:46:05 -0500
Subject: RE: [PATCH 1/9] vpfe-capture bridge driver for DM355 & DM6446
Message-ID: <A69FA2915331DC488A831521EAE36FE4013557AC64@dlee06.ent.ti.com>
References: <1242412559-11325-1-git-send-email-m-karicheri2@ti.com>
 <200905270140.53696.laurent.pinchart@skynet.be>
In-Reply-To: <200905270140.53696.laurent.pinchart@skynet.be>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

See my responses below. I have accepted and modified the code based on your comments. Few are discussed here for conclusion.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

>> +#include <media/tvp514x.h>
>
>We should try to get rid of the TVP514x dependency. See below where TVP5146
>support is explicit for a discussion on this.
>
[MK]Agree. Only reason this is included is to configure the vpfe hw interface based on the sub device (tvp5146) output format. The output from TVP device is BT656. The bridge driver is expected to work with multiple interfaces such as BT.656, BT.1120, RAW image data bus consisting of 10 bit data, vsync, hsync etc. So I need to have a way of getting/setting hw interface parameters based on sub device output interface. Currently this support is not available in sub device. I see some discussion in the mailing list for allowing bridge driver to set the platform data in the sub device using s_config or v4l2_i2c_subdev_board(). I am not sure what will come out of this. Hans had a comment against DM6467 display driver to use the new v4l2 api v4l2_i2c_new_probed_subdev_addr(). When using this API, I find that the i2c driver is probed without setting the platform data (assume this is not defined statically using i2c_board_info in board setup file). Since both sub-device and bridge driver needs to be aware of the interface or bus that are used for connecting the devices, I strongly feel a need for defining a structure for interface configuration in the v4l2-subdev.h, define the values in board setup file and pass the same from bridge driver to sub device as an argument to v4l2_i2c_new_probed_subdev_addr() and set the same before calling the probe. I have posted an RFC for this in the linux media mailing list. So this cannot be done at this time.

>> +    struct v4l2_routing *route =
>> +            &(subdev->routes[vpfe_dev->current_input]);
>
>I think there's something wrong with how the current input is handled.
>current_input as assigned the input index number in vpfe_s_input, which is
>a
>global index across all subdevices. However, you use it as a subdevice
>local
>input index here.
[MK] current_input refers to the current input in the current subdev. When
application set input, vpfe_get_subdev_input_index() is called to do map of
application index to index in a sub device. I will add a description to the vpfe_get_subdev_input_index() function to clarify this.
>
>> +    }
>> +
>> +    /* set if client specific interface param is available */
>> +    if (subdev->pdata) {
>> +            /* each client will have different interface requirements */
>> +            if (!strcmp(subdev->name, "tvp5146")) {
>> +                    struct tvp514x_platform_data *pdata = subdev->pdata;
>> +
>> +                    if (pdata->hs_polarity)
>> +                            vpfe_dev->vpfe_if_params.hdpol =
>> +                                    VPFE_PINPOL_POSITIVE;
>> +                    else
>> +                            vpfe_dev->vpfe_if_params.hdpol =
>> +                                    VPFE_PINPOL_NEGATIVE;
>> +
>> +                    if (pdata->vs_polarity)
>> +                            vpfe_dev->vpfe_if_params.vdpol =
>> +                                    VPFE_PINPOL_POSITIVE;
>> +                    else
>> +                            vpfe_dev->vpfe_if_params.hdpol =
>> +                                    VPFE_PINPOL_NEGATIVE;
>> +            } else {
>> +                    v4l2_err(&vpfe_dev->v4l2_dev, "No interface params"
>> +                            " defined for subdevice, %d\n", route->output);
>> +                    return -EFAULT;
>> +            }
>
>I'd really like to get rid of this. Instead of checking for a specific
>subdevice, we need a way to pass subdevice-agnostic data to the VPFE driver.
>Hans, what's your opinion on this ?
>
[MK] I have posted a RFC to deal with this. I don't have a response yet.
I need to wait on this. If no response, I will do my implementation and
send an RFC patch for this (adding a way to set the interface parameter
in sub device as well as bridge driver).
>> +
>> +/* vpfe_config_default_format: Update format information */
>> +static int vpfe_config_default_format(struct vpfe_device *vpfe_dev)
>> +{
>> +    struct vpfe_config *cfg = vpfe_dev->cfg;
>> +    struct vpfe_subdev_info *sub_dev =
>> +            &cfg->sub_devs[vpfe_dev->current_subdev];
>> +    struct v4l2_rect win;
>> +    int ret = 0;
>> +
>> +    vpfe_dev->crop.top = 0;
>> +    vpfe_dev->crop.left = 0;
>> +    /*
>> +     * first get format information from the decoder.
>> +     * if not available, get it from CCDC
>> +     */
>> +    ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
>> +                    sub_dev->grp_id,
>> +                    video, g_fmt, &vpfe_dev->fmt);
>> +
>> +    if (ret) {
>> +            ret = vpfe_get_image_format(vpfe_dev, &vpfe_dev->fmt);
>> +            if (ret < 0)
>> +                    return ret;
>> +    } else {
>
>Don't you have to setup the CCDC parameters regardless of whether
>v4l2_device_call_until_err() is successful or not ?
>
I have modified the logic here. vpfe capture always set the image parameters in ccdc based on capture standard and native pixel format in the sub device. The new function, described above is used now. It will always set the parameters in ccdc.
>> +            /* set up all parameters in CCDC */
>> +            win.top = vpfe_dev->crop.top;
>> +            win.left = vpfe_dev->crop.left;
>> +            win.width = vpfe_dev->fmt.fmt.pix.width;
>> +            win.height = vpfe_dev->fmt.fmt.pix.height;
>> +            ccdc_dev->hw_ops.set_image_window(&win);
>> +            if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_INTERLACED) {
>> +                    ret = ccdc_dev->hw_ops.set_buftype(
>> +                                    CCDC_BUFTYPE_FLD_INTERLEAVED);
>> +                    if (ret)
>> +                            return ret;
>> +                    ret = ccdc_dev->hw_ops.set_frame_format(
>> +                                    CCDC_FRMFMT_INTERLACED);
>> +                    if (ret)
>> +                            return ret;
>> +            } else if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_SEQ_TB) {
>> +                    ret = ccdc_dev->hw_ops.set_buftype(
>> +                                    CCDC_BUFTYPE_FLD_SEPARATED);
>> +                    if (ret)
>> +                            return ret;
>> +                    ret = ccdc_dev->hw_ops.set_frame_format(
>> +                                    CCDC_FRMFMT_INTERLACED);
>> +                    if (ret)
>> +                            return ret;
>> +            } else if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) {
>> +                    ret = ccdc_dev->hw_ops.set_frame_format(
>> +                                    CCDC_FRMFMT_PROGRESSIVE);
>> +                    if (ret)
>> +                            return ret;
>> +            } else {
>> +                    v4l2_err(&vpfe_dev->v4l2_dev, "Decoder field not"
>> +                             " supported!\n");
>> +                    return -EINVAL;
>> +            }
>
>You could simplify this by storing the buffer type and frame format into
>variables and moving the calls to set_buftype() and set_frame_format()
>outside
>of the if...else blocks. I suspect that set_buftype() needs to be called in
>the V4L2_FIELD_NONE as well, to make sure it's not set to
>CCDC_BUFTYPE_FLD_INTERLEAVED in which case the DM355 and DM6446 CCDC
>drivers
>would setup the hardware differently.
>
[MK] I cleaned this (also for another comment below). I have a single
function vpfe_config_image_format(), that calls vpfe_config_ccdc_image_format() to set parameters in ccdc. This is called
to set defaults in driver based on a selected standard.

>> +/* ISR for VINT0*/
>> +static irqreturn_t vpfe_isr(int irq, void *dev_id)
>> +{
>> +    struct vpfe_device *vpfe_dev = dev_id;
>> +    struct timeval timevalue;
>> +    enum v4l2_field field;
>> +    unsigned long addr;
>> +    int fid;
>> +
>> +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nStarting vpfe_isr...");
>> +    field = vpfe_dev->fmt.fmt.pix.field;
>> +    do_gettimeofday(&timevalue);
>> +
>> +    /* if streaming not started, don't do anything */
>> +    if (!vpfe_dev->started)
>> +            return IRQ_RETVAL(1);
>> +
>> +    /* only for 6446 this will be applicable */
>> +    if (NULL != ccdc_dev->hw_ops.reset)
>> +            ccdc_dev->hw_ops.reset();
>> +
>> +    if (field == V4L2_FIELD_INTERLACED || field == V4L2_FIELD_SEQ_TB) {
>> +            /* Interlaced */
>> +            /* check which field we are in hardware */
>> +            fid = ccdc_dev->hw_ops.getfid();
>> +            /* switch the software maintained field id */
>> +            vpfe_dev->field_id ^= 1;
>> +            v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "field id = %x:%x.\n",
>> +                    fid, vpfe_dev->field_id);
>> +            if (fid == vpfe_dev->field_id) {
>> +                    /* we are in-sync here,continue */
>> +                    if (fid == 0) {
>> +                            /*
>> +                             * One frame is just being captured. If the
>> +                             * next frame is available, release the current
>> +                             * frame and move on
>> +                             */
>> +                            if (vpfe_dev->cur_frm != vpfe_dev->next_frm) {
>> +                                    /* Copy frame capture time value in
>> +                                     * cur_frm->ts
>> +                                     */
>> +                                    vpfe_dev->cur_frm->ts = timevalue;
>> +                                    vpfe_dev->cur_frm->state =
>> +                                            VIDEOBUF_DONE;
>> +                                    wake_up_interruptible(
>> +                                            &vpfe_dev->cur_frm->done);
>> +                                    vpfe_dev->cur_frm = vpfe_dev->next_frm;
>> +                            }
>
>The code blocks nesting level is getting quite high here. The interrupt
>handler would be easier to read if you split it in several functions (the
>above lines are good candidates as they are reused later in the interrupt
>handler).
>
>By handling error/unusual/small cases first and returning immediately the
>code
>will also move towards the left side. For instance, instead of
>
>if (condition) {
>       lots;
>       of;
>       code;
>       goes;
>       here;
>} else {
>       one liner;
>}
>return IRQ_RETVAL(1);
>
>you could write
>
>if (!condition) {
>       one liner;
>       return IRQ_RETVAL(1);
>}
>lots;
>of;
>code;
>goes;
>here;
>return IRQ_RETVAL(1);
>
>This isn't a mandatory change in any way, just a small hint to help keeping
>the code easy to read. Don't feel pushed to change this specific function
>if
>you don't want to. You might just want to split the interlaced and non-
>interlaced case into separate functions (the compiler will inline them
>anyway).
>
>I've tested all this (splitting interlaced/non-interlaced into separate
>functions, extracting common code in a separate function and handling small
>cases first) for vpfe_isr(). Beside the code readability improvements each
>change had either no impact on the generated assembly code, or it resulted
>in
>a small code size improvement (I haven't checked how running time would be
>affected).
>
[MK]. I have pretty much followed your suggestions. I have two new functions that schedule a buffer(vpfe_schedule_next_buffer()) and mark a buffer as complete (vpfe_process_buffer_complete()). These are called from the isr.
Also avoided nesting as you have suggested.
>> +
>> +/* vpfe capture driver file operations */
>> +static struct v4l2_file_operations vpfe_fops = {
>> +    .owner = THIS_MODULE,
>> +    .open = vpfe_open,
>> +    .release = vpfe_release,
>> +    .ioctl = video_ioctl2,
>> +    .mmap = vpfe_mmap,
>> +    .poll = vpfe_poll
>> +};
>> +
>> +static  struct vpfe_pixel_format *
>> +    vpfe_check_format(struct vpfe_device *vpfe_dev,
>> +                      struct v4l2_pix_format *pixfmt,
>> +                      int check)
>> +{
>> +    int temp, found, hpitch, vpitch, bpp, min_height = 1,
>> +            min_width = 32, max_width, max_height;
>> +    struct vpfe_pixel_format *pix_fmt;
>> +    enum vpfe_hw_pix_format hw_pix;
>> +
>> +    temp = vpfe_lookup_hw_format(pixfmt->pixelformat);
>> +    if (temp < 0) {
>> +            if (check) {
>> +                    v4l2_err(&vpfe_dev->v4l2_dev, "invalid pixel format\n");
>> +                    return NULL;
>> +            }
>
>According to the V4L2 specification, the driver isn't supposed to return an
>error in response to TRY_FMT/S_FMT unless the input is ambiguous or the
>buffer
>type is unsupported. It should instead adjust the requested parameters
>according to its supported capabilities.
>
>It seems to me that most V4L2 drivers don't obey this rule though. It might
>break userspace applications if we "fixed" those drivers. I'd like Hans'
>opinion on this.
>
[MK] modified the vpfe_check_format() to adjust values as per hardware
requirement.
>> +            /* if invalid and this is a try format, then use hw default */
>> +            pixfmt->pixelformat = vpfe_dev->fmt.fmt.pix.pixelformat;
>
>Is this the hardware default format, or current format ?
>
[MK] Use current format. Please next version of the driver for details
>> +            /* Since this is hw default, we will find this pix format */
>> +            temp = vpfe_lookup_hw_format(pixfmt->pixelformat);
>> +
>> +    } else {
>> +            /* check if hw supports it */
>> +            pix_fmt = &vpfe_pix_fmts[temp];
>> +            temp = 0;
>> +            found = 0;
>> +            while (ccdc_dev->hw_ops.enum_pix(&hw_pix, temp) >= 0) {
>> +                    if (pix_fmt->hw_fmt == hw_pix) {
>> +                            found = 1;
>> +                            break;
>> +                    }
>> +                    temp++;
>
>Wouldn't it be better to have a try_frame_format CCDC operation for this ?
>
[MK] vpfe capture can support multiple formats based on platform and ccdc and previewer/resizer's availability. So vpfe capture has to query both ccdc and previewer/resizer hw modules to check if a given pixel format can be
used. Since try_frame_format() generally adjust the values to match hardware, this cannot work in this situation. In my implementation, I can query previewer/resizer if a pixel format is not supported in ccdc.

>> +            }
>> +            if (!found) {
>> +                    if (check) {
>> +                            v4l2_err(&vpfe_dev->v4l2_dev, "hw doesn't"
>> +                                     "support the pixel format\n");
>> +                            return NULL;
>> +                    }
>> +                    /*
>> +                     * Since this is hw default, we will find this
>> +                     * pix format
>> +                     */
>> +                    pixfmt->pixelformat = vpfe_dev->fmt.fmt.pix.pixelformat;
>> +                    temp = vpfe_lookup_hw_format(pixfmt->pixelformat);
>> +            }
>> +    }
>> +    pix_fmt = &vpfe_pix_fmts[temp];
>> +    if (pixfmt->field == V4L2_FIELD_ANY) {
>> +            /* if ANY set the field to match with decoder */
>> +            pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
>> +    }
>> +
>> +    /* Try matching the field with the decoder scan field */
>> +    if (vpfe_dev->fmt.fmt.pix.field != pixfmt->field) {
>> +            if (!(VPFE_VALID_FIELD(pixfmt->field)) && check) {
>> +                    v4l2_err(&vpfe_dev->v4l2_dev, "invalid field format\n");
>> +                    return NULL;
>> +            }
>> +            if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_INTERLACED) {
>> +                    if (pixfmt->field != V4L2_FIELD_SEQ_TB) {
>> +                            if (check) {
>> +                                    v4l2_err(&vpfe_dev->v4l2_dev,
>> +                                            "invalid field format\n");
>> +                                    return NULL;
>> +                            }
>> +                            pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
>> +                    }
>> +            } else if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) {
>> +                    if (check) {
>> +                            v4l2_err(&vpfe_dev->v4l2_dev,
>> +                                    "invalid field format\n");
>> +                            return NULL;
>> +                    }
>> +                    pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
>> +            } else
>> +                    pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
>> +    }
>
>This looks a bit complex. Could you explain the algorithm behind the code ?
>
[MK] I have simplified this and added algorithm to description. Please check the new version.
>> +
>> +static int vpfe_g_fmt_vid_cap(struct file *file, void *priv,
>> +                            struct v4l2_format *fmt)
>> +{
>> +    struct vpfe_device *vpfe_dev = video_drvdata(file);
>> +    int ret = 0;
>> +
>> +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt_vid_cap\n");
>> +    /*
>> +     * Fill in the information about
>> +     * format
>> +     */
>> +    ret = mutex_lock_interruptible(&vpfe_dev->lock);
>
>Do we really need to make it interruptible (here and in most other
>places) ?
>
[MK] Generally interruptible is used since application can catch signal
and take appropriate action as needed. What is your suggestion? I have investigated it's usage among v4l2 drivers in the tree. Most of them uses mutex_lock()/unlock(), while few like vino.c uses mutex_lock_interruptible() version for handling ioctls. The dm6467_vpif display driver recently reviewed and approved by Hans uses interruptible() version. I am not sure if this comment is to be addressed or leave as is. Please respond.
>> +unlock_out:
>> +    mutex_unlock(&vpfe_dev->lock);
>> +    return ret;
>> +}
>> +
>> +static int vpfe_try_fmt_vid_cap(struct file *file, void *priv,
>> +                              struct v4l2_format *f)
>> +{
>> +    struct vpfe_device *vpfe_dev = video_drvdata(file);
>> +    struct vpfe_pixel_format *pix_fmts;
>> +
>> +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_try_fmt_vid_cap\n");
>> +
>> +    pix_fmts = vpfe_check_format(vpfe_dev, &f->fmt.pix, 0);
>> +    if (NULL == pix_fmts)
>> +            return -EINVAL;
>> +    return 0;
>> +}
>> +
>> +static void vpfe_config_format(struct vpfe_device *vpfe_dev)
>> +{
>> +    vpfe_dev->crop.top = 0;
>> +    vpfe_dev->crop.left = 0;
>> +    vpfe_dev->crop.width = vpfe_dev->std_info.activepixels;
>> +    vpfe_dev->fmt.fmt.pix.width = vpfe_dev->crop.width;
>> +    vpfe_dev->crop.height = vpfe_dev->std_info.activelines;
>> +    vpfe_dev->fmt.fmt.pix.height = vpfe_dev->std_info.activelines;
>> +    ccdc_dev->hw_ops.set_image_window(&vpfe_dev->crop);
>> +
>> +    if (vpfe_dev->std_info.frame_format) {
>> +            vpfe_dev->fmt.fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +            ccdc_dev->hw_ops.set_frame_format(CCDC_FRMFMT_INTERLACED);
>> +            ccdc_dev->hw_ops.set_buftype(CCDC_BUFTYPE_FLD_INTERLEAVED);
>> +    } else {
>> +            vpfe_dev->fmt.fmt.pix.field = V4L2_FIELD_NONE;
>> +            ccdc_dev->hw_ops.set_frame_format(CCDC_FRMFMT_PROGRESSIVE);
>> +    }
>> +
>> +    vpfe_dev->fmt.fmt.pix.bytesperline = ccdc_dev-
>>hw_ops.get_line_length();
>> +    vpfe_dev->fmt.fmt.pix.sizeimage = vpfe_dev->fmt.fmt.pix.bytesperline
>*
>> +                                vpfe_dev->fmt.fmt.pix.height;
>> +}
>
>Can you move this function down where it is used, and add a comment to
>describe what it does ? If I'm not mistaken it configures the format width
>and
>height (and related fields such as image size) to default values according
>to
>the select video standard. You might want to call it vpfe_config_standard
>then.
>
[MK] renamed to vpfe_config_image_format(). Also added a description
>> +
>> +static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id
>*std_id)
>> +{
>> +    struct vpfe_device *vpfe_dev = video_drvdata(file);
>> +    struct vpfe_config *cfg = vpfe_dev->cfg;
>> +    struct vpfe_subdev_info *subdev;
>> +    int ret = 0;
>> +
>> +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_std\n");
>> +
>> +    subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
>> +    /* Call decoder driver function to set the standard */
>> +    ret = mutex_lock_interruptible(&vpfe_dev->lock);
>> +    if (ret)
>> +            return ret;
>> +
>> +    /* If streaming is started, return device busy error */
>> +    if (vpfe_dev->started) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "streaming is started\n");
>> +            ret = -EBUSY;
>> +            goto unlock_out;
>> +    }
>> +
>> +    ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, subdev->grp_id,
>> +                                     core, s_std, *std_id);
>> +    if (ret < 0) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
>> +            goto unlock_out;
>> +    }
>> +    ret = vpfe_get_stdinfo(vpfe_dev, std_id);
>> +    /* update the format information for this standard */
>> +    if (ret)
>> +            vpfe_config_format(vpfe_dev);
>
>vpfe_get_stdinfo() and vpfe_config_format() are both used to update the
>vpfe_device structure and configure the CCDC with information computed from
>the just selected video standard. Would it make sense to merge and refactor
>them ?
>
[MK] see response above. I call the new function here
>> +
>> +    ret = mutex_lock_interruptible(&vpfe_dev->lock);
>> +    if (ret)
>> +            return ret;
>> +
>> +    if (vpfe_dev->fmt.fmt.pix.field != V4L2_FIELD_ANY)
>> +            field = vpfe_dev->fmt.fmt.pix.field;
>
>Can vpfe_dev->fmt.fmt.pix.field be set to V4L2_FIELD_ANY when we arrive
>here ?
[MK] This is unnecessary as we set it to a supported value in S_FMT handling. Assuming application always call S_FMT followed by REQBUF, this is not required.
>I'm under the impression that it should have a defined value, but the code
>is
>hard to follow and I might be wrong.
[MK] I thought you understood the code very well, if not there wouldn't be this much comment :)
>
>> +    else if (vpfe_dev->vpfe_if_params.if_type == VPFE_RAW_BAYER)
>> +            field = V4L2_FIELD_NONE;
>> +    else
>> +            field = V4L2_FIELD_INTERLACED;
>> +
>> +    vpfe_dev->memory = p->memory;
>> +    videobuf_queue_dma_contig_init(&vpfe_dev->buffer_queue,
>> +                            &vpfe_videobuf_qops,
>> +                            NULL,
>> +                            &vpfe_dev->irqlock,
>> +                            p->type,
>> +                            field,
>> +                            sizeof(struct videobuf_buffer),
>> +                            fh);
>> +
>> +    fh->io_allowed = 1;
>> +    vpfe_dev->io_usrs = 1;
>> +    INIT_LIST_HEAD(&vpfe_dev->dma_queue);
>> +    ret = videobuf_reqbufs(&vpfe_dev->buffer_queue, p);
>> +    mutex_unlock(&vpfe_dev->lock);
>> +    return ret;
>> +}
>> +
>> +static int vpfe_querybuf(struct file *file, void *priv,
>> +                     struct v4l2_buffer *p)
>> +{
>> +    struct vpfe_device *vpfe_dev = video_drvdata(file);
>> +
>> +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querybuf\n");
>> +
>> +    if (V4L2_BUF_TYPE_VIDEO_CAPTURE != p->type) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
>> +            return  -EINVAL;
>> +    }
>> +    if (vpfe_dev->memory != V4L2_MEMORY_MMAP) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "Invalid memory\n");
>> +            return -EINVAL;
>> +    }
>
>This should be checked in vpfe_reqbufs() instead.
>
[MK] No. Here we just return error if application calls QUERYBUF in case it is using USERPTR IO, which we will support soon.

>> +{
>> +    struct vpfe_device *vpfe_dev = video_drvdata(file);
>> +    struct vpfe_config *cfg = vpfe_dev->cfg;
>> +    struct vpfe_fh *fh = file->private_data;
>> +    struct vpfe_subdev_info *subdev;
>> +    unsigned long addr;
>> +    int ret = 0;
>> +
>> +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamon\n");
>> +
>> +    if (V4L2_BUF_TYPE_VIDEO_CAPTURE != i) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
>> +            return -EINVAL;
>> +    }
>> +
>> +    /* If file handle is not allowed IO, return error */
>> +    if (!fh->io_allowed) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
>> +            return -EACCES;
>> +    }
>> +
>> +    subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
>> +    ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, subdev->grp_id,
>> +                                    video, s_stream, 1);
>> +
>> +    if (ret && (ret != -ENOIOCTLCMD)) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "stream on failed in subdev\n");
>> +            return -EINVAL;
>> +    }
>> +
>> +    /* Call videobuf_streamon to start streaming * in videobuf */
>> +    ret = videobuf_streamon(&vpfe_dev->buffer_queue);
>> +    if (ret)
>> +            return ret;
>> +
>> +    ret = mutex_lock_interruptible(&vpfe_dev->lock);
>> +    if (ret)
>> +            goto streamoff;
>> +    /* If buffer queue is empty, return error */
>> +    if (list_empty(&vpfe_dev->dma_queue)) {
>> +            v4l2_err(&vpfe_dev->v4l2_dev, "buffer queue is empty\n");
>> +            ret = -EIO;
>> +            goto unlock_out;
>> +    }
>
>Why don't you check that before starting the stream ?
>
[MK] I think you are confused by the comment. I changed it to indicate it is dma_queue. As part of videobuf_streamon(), v4l2 buffer layer calls videobuf_queue, where buffers are moved from buffer_queue to dma_queue by vpfe_capture. So this is correct.


