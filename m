Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48557 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEQnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 12:43:43 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 1/9] vpfe-capture bridge driver for DM355 & DM6446
Date: Fri, 5 Jun 2009 18:43:40 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1242412559-11325-1-git-send-email-m-karicheri2@ti.com> <200905270140.53696.laurent.pinchart@skynet.be> <A69FA2915331DC488A831521EAE36FE4013557AC64@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4013557AC64@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906051843.41105.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've removed the points to which my response would just have been 'ok'.

On Wednesday 03 June 2009 16:46:05 Karicheri, Muralidharan wrote:
> > > +#include <media/tvp514x.h>
> >
> > We should try to get rid of the TVP514x dependency. See below where
> > TVP5146 support is explicit for a discussion on this.
>
> [MK]Agree. Only reason this is included is to configure the vpfe hw
> interface based on the sub device (tvp5146) output format. The output from
> TVP device is BT656. The bridge driver is expected to work with multiple
> interfaces such as BT.656, BT.1120, RAW image data bus consisting of 10 bit
> data, vsync, hsync etc. So I need to have a way of getting/setting hw
> interface parameters based on sub device output interface. Currently this
> support is not available in sub device.

Unfortunately. However, it's the right way to go. Let's all cross our fingers 
and hope Hans will be able to find some time in his busy schedule to comment 
on this :-)

> I see some discussion in the mailing list for allowing bridge driver to set
> the platform data in the sub device using s_config or 
> v4l2_i2c_subdev_board(). I am not sure what will come out of this. Hans had
> a comment against DM6467 display driver to use the new v4l2 api
> v4l2_i2c_new_probed_subdev_addr(). When using this API, I find that the i2c
> driver is probed without setting the platform data (assume this is not
> defined statically using i2c_board_info in board setup file). Since both
> sub-device and bridge driver needs to be aware of the interface or bus that
> are used for connecting the devices, I strongly feel a need for defining a
> structure for interface configuration in the v4l2-subdev.h, define the
> values in board setup file and pass the same from bridge driver to sub
> device as an argument to v4l2_i2c_new_probed_subdev_addr() and set the same
> before calling the probe. I have posted an RFC for this in the linux media
> mailing list. So this cannot be done at this time.

I'll try to comment your RFC, but I'm not familiar with v4l2-subdev yet.

> > > +            /* Since this is hw default, we will find this pix format
> > > */ +            temp = vpfe_lookup_hw_format(pixfmt->pixelformat); +
> > > +    } else {
> > > +            /* check if hw supports it */
> > > +            pix_fmt = &vpfe_pix_fmts[temp];
> > > +            temp = 0;
> > > +            found = 0;
> > > +            while (ccdc_dev->hw_ops.enum_pix(&hw_pix, temp) >= 0) {
> > > +                    if (pix_fmt->hw_fmt == hw_pix) {
> > > +                            found = 1;
> > > +                            break;
> > > +                    }
> > > +                    temp++;
> >
> >Wouldn't it be better to have a try_frame_format CCDC operation for this ?
>
> [MK] vpfe capture can support multiple formats based on platform and ccdc
> and previewer/resizer's availability. So vpfe capture has to query both
> ccdc and previewer/resizer hw modules to check if a given pixel format can
> be used. Since try_frame_format() generally adjust the values to match
> hardware, this cannot work in this situation. In my implementation, I can
> query previewer/resizer if a pixel format is not supported in ccdc.

Are the formats supported by the CCDC, previewer and resizer modules dynamic ? 
If they can't change at runtime it would be easier to store them in a table 
that can be directly accessed by the VPFE driver instead of using an 
enumeration callback.

> > > +
> > > +static int vpfe_g_fmt_vid_cap(struct file *file, void *priv,
> > > +                            struct v4l2_format *fmt)
> > > +{
> > > +    struct vpfe_device *vpfe_dev = video_drvdata(file);
> > > +    int ret = 0;
> > > +
> > > +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt_vid_cap\n");
> > > +    /*
> > > +     * Fill in the information about
> > > +     * format
> > > +     */
> > > +    ret = mutex_lock_interruptible(&vpfe_dev->lock);
> >
> > Do we really need to make it interruptible (here and in most other
> > places) ?
>
> [MK] Generally interruptible is used since application can catch signal
> and take appropriate action as needed. What is your suggestion? I have
> investigated it's usage among v4l2 drivers in the tree. Most of them uses
> mutex_lock()/unlock(), while few like vino.c uses
> mutex_lock_interruptible() version for handling ioctls. The dm6467_vpif
> display driver recently reviewed and approved by Hans uses interruptible()
> version. I am not sure if this comment is to be addressed or leave as is.
> Please respond.

Using an interruptible mutex might not be worth it if the code that runs with 
the mutex held is guaranteed to be fast. However, it won't hurt as the C 
library will retry the syscall. I'm fine with interruptible mutexes.

> > I'm under the impression that it should have a defined value, but the code
> > is hard to follow and I might be wrong.
>
> [MK] I thought you understood the code very well, if not there wouldn't be
> this much comment :)

Let's say I understand it will enough to make a bunch of annoying comments ;-)

> > > +{
> > > +    struct vpfe_device *vpfe_dev = video_drvdata(file);
> > > +    struct vpfe_config *cfg = vpfe_dev->cfg;
> > > +    struct vpfe_fh *fh = file->private_data;
> > > +    struct vpfe_subdev_info *subdev;
> > > +    unsigned long addr;
> > > +    int ret = 0;
> > > +
> > > +    v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamon\n");
> > > +
> > > +    if (V4L2_BUF_TYPE_VIDEO_CAPTURE != i) {
> > > +            v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> > > +            return -EINVAL;
> > > +    }
> > > +
> > > +    /* If file handle is not allowed IO, return error */
> > > +    if (!fh->io_allowed) {
> > > +            v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
> > > +            return -EACCES;
> > > +    }
> > > +
> > > +    subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
> > > +    ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> > > subdev->grp_id, +                                    video, s_stream,
> > > 1);
> > > +
> > > +    if (ret && (ret != -ENOIOCTLCMD)) {
> > > +            v4l2_err(&vpfe_dev->v4l2_dev, "stream on failed in
> > > subdev\n"); +            return -EINVAL;
> > > +    }
> > > +
> > > +    /* Call videobuf_streamon to start streaming * in videobuf */
> > > +    ret = videobuf_streamon(&vpfe_dev->buffer_queue);
> > > +    if (ret)
> > > +            return ret;
> > > +
> > > +    ret = mutex_lock_interruptible(&vpfe_dev->lock);
> > > +    if (ret)
> > > +            goto streamoff;
> > > +    /* If buffer queue is empty, return error */
> > > +    if (list_empty(&vpfe_dev->dma_queue)) {
> > > +            v4l2_err(&vpfe_dev->v4l2_dev, "buffer queue is empty\n");
> > > +            ret = -EIO;
> > > +            goto unlock_out;
> > > +    }
> >
> > Why don't you check that before starting the stream ?
>
> [MK] I think you are confused by the comment. I changed it to indicate it
> is dma_queue. As part of videobuf_streamon(), v4l2 buffer layer calls
> videobuf_queue, where buffers are moved from buffer_queue to dma_queue by
> vpfe_capture. So this is correct.

Maybe you could check for list_empyt(&vpfe_dev->buffer_queue.stream) before 
starting the stream instead. If I remember correctly, while the driver doesn't 
support VIDIOC_STREAM without any queued buffer, we plan to fix that (and 
other small issues such as VIDIOC_REQBUFS being called multiple times) later, 
so the code will go away eventually.

Best regards,

Laurent Pinchart

