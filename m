Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53730 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753428AbdC0OZl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 10:25:41 -0400
Subject: Re: [PATCH v6] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Helen Koike <helen.koike@collabora.co.uk>,
        Helen Koike <helen.koike@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, jgebben@codeaurora.org,
        mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>
References: <ee909db9-eb2b-d81a-347a-fe12112aa1cf@xs4all.nl>
 <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
 <20170125130345.GD7139@valkosipuli.retiisi.org.uk>
 <8d3e1bb3-3b08-d42f-0c5f-53af5bd7b0b4@collabora.co.uk>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <e52b9d82-91e1-3da7-5ac3-8086545692c7@iki.fi>
Date: Sun, 26 Mar 2017 16:25:55 +0300
MIME-Version: 1.0
In-Reply-To: <8d3e1bb3-3b08-d42f-0c5f-53af5bd7b0b4@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Please see my comments below.

Helen Koike wrote:
> On 2017-01-25 11:03 AM, Sakari Ailus wrote:
...
>>> +     * the videobuf2 framework will allocate this struct based on
>>> +     * buf_struct_size and use the first sizeof(struct vb2_buffer)
>>> bytes of
>>> +     * memory as a vb2_buffer
>>> +     */
>>> +    struct vb2_v4l2_buffer vb2;
>>> +    struct list_head list;
>>> +};
>>> +
>>> +static int vimc_cap_querycap(struct file *file, void *priv,
>>> +                 struct v4l2_capability *cap)
>>> +{
>>> +    struct vimc_cap_device *vcap = video_drvdata(file);
>>> +
>>> +    strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
>>> +    strlcpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
>>> +    snprintf(cap->bus_info, sizeof(cap->bus_info),
>>> +         "platform:%s", vcap->v4l2_dev->name);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int vimc_cap_enum_input(struct file *file, void *priv,
>>> +                   struct v4l2_input *i)
>>> +{
>>> +    /* We only have one input */
>>> +    if (i->index > 0)
>>> +        return -EINVAL;
>>> +
>>> +    i->type = V4L2_INPUT_TYPE_CAMERA;
>>> +    strlcpy(i->name, "VIMC capture", sizeof(i->name));
>>
>> Isn't this (*INPUT IOCTLs) something that should be handled in a
>> sub-device
>> driver, such as a TV tuner?
> 
> 
> Can the ioctl VIDIOC_ENUMINPUT enumerate no inputs at all? Can I just
> return -EINVAL here in G_INPUT and S_INPUT as well?
> I thought I had to enumerate at least one input, and between
> V4L2_INPUT_TYPE_TUNER and V4L2_INPUT_TYPE_CAMERA, this last
> one seems more appropriated

I don't think other drivers that provide MC interface do this on video
nodes either. The VIMC driver could know what's connected to it, but
generally that's not the case.

> 
> 
>>
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned
>>> int *i)
>>> +{
>>> +    /* We only have one input */
>>> +    *i = 0;
>>> +    return 0;
>>> +}
>>> +
>>> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned
>>> int i)
>>> +{
>>> +    /* We only have one input */
>>> +    return i ? -EINVAL : 0;
>>> +}
>>> +
>>> +static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
>>> +                  struct v4l2_format *f)
>>> +{
>>> +    struct vimc_cap_device *vcap = video_drvdata(file);
>>> +
>>> +    f->fmt.pix = vcap->format;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
>>> +                     struct v4l2_fmtdesc *f)
>>> +{
>>> +    struct vimc_cap_device *vcap = video_drvdata(file);
>>> +
>>> +    if (f->index > 0)
>>> +        return -EINVAL;
>>> +
>>> +    /* We only support one format for now */
>>> +    f->pixelformat = vcap->format.pixelformat;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static const struct v4l2_file_operations vimc_cap_fops = {
>>> +    .owner        = THIS_MODULE,
>>> +    .open        = v4l2_fh_open,
>>> +    .release    = vb2_fop_release,
>>> +    .read           = vb2_fop_read,
>>> +    .poll        = vb2_fop_poll,
>>> +    .unlocked_ioctl = video_ioctl2,
>>> +    .mmap           = vb2_fop_mmap,
>>> +};
>>> +
>>> +static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
>>> +    .vidioc_querycap = vimc_cap_querycap,
>>> +
>>> +    .vidioc_enum_input = vimc_cap_enum_input,
>>> +    .vidioc_g_input = vimc_cap_g_input,
>>> +    .vidioc_s_input = vimc_cap_s_input,
>>> +
>>> +    .vidioc_g_fmt_vid_cap = vimc_cap_fmt_vid_cap,
>>> +    .vidioc_s_fmt_vid_cap = vimc_cap_fmt_vid_cap,
>>> +    .vidioc_try_fmt_vid_cap = vimc_cap_fmt_vid_cap,
>>> +    .vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap,
>>> +
>>> +    .vidioc_reqbufs = vb2_ioctl_reqbufs,
>>> +    .vidioc_create_bufs = vb2_ioctl_create_bufs,
>>> +    .vidioc_querybuf = vb2_ioctl_querybuf,
>>> +    .vidioc_qbuf = vb2_ioctl_qbuf,
>>> +    .vidioc_dqbuf = vb2_ioctl_dqbuf,
>>> +    .vidioc_expbuf = vb2_ioctl_expbuf,
>>> +    .vidioc_streamon = vb2_ioctl_streamon,
>>> +    .vidioc_streamoff = vb2_ioctl_streamoff,
>>> +};
>>> +
>>> +static void vimc_cap_return_all_buffers(struct vimc_cap_device *vcap,
>>> +                    enum vb2_buffer_state state)
>>> +{
>>> +    struct vimc_cap_buffer *vbuf, *node;
>>> +
>>> +    spin_lock(&vcap->qlock);
>>> +
>>> +    list_for_each_entry_safe(vbuf, node, &vcap->buf_list, list) {
>>> +        vb2_buffer_done(&vbuf->vb2.vb2_buf, state);
>>> +        list_del(&vbuf->list);
>>> +    }
>>> +
>>> +    spin_unlock(&vcap->qlock);
>>> +}
>>> +
>>> +static int vimc_cap_pipeline_s_stream(struct vimc_cap_device *vcap,
>>> int enable)
>>> +{
>>> +    int ret;
>>> +    struct media_pad *pad;
>>> +    struct media_entity *entity;
>>> +    struct v4l2_subdev *sd;
>>> +
>>> +    /* Start the stream in the subdevice direct connected */
>>> +    entity = &vcap->vdev.entity;
>>> +    pad = media_entity_remote_pad(&entity->pads[0]);
>>
>> You could use vcap->vdev.entity.pads here, without assigning to
>> entity. Then
>> entity would only be used to refer to the remove entity at the other
>> end of
>> the link. Up to you.
>>
>>> +
>>> +    /* If we are not connected to any subdev node, it means there is
>>> nothing
>>
>> /*
>>  * Multi line
>>  * comment.
>>  */
>>
>>> +     * to activate on the pipe (e.g. we can be connected with an input
>>> +     * device or we are not connected at all)
>>> +     */
>>> +    if (pad == NULL || !is_media_entity_v4l2_subdev(pad->entity))
>>> +        return 0;
>>> +
>>> +    entity = pad->entity;
>>> +    sd = media_entity_to_v4l2_subdev(entity);
>>
>> And if you used pad->entity here, you could remove the entity variable
>> altogether.
>>
>>> +
>>> +    ret = v4l2_subdev_call(sd, video, s_stream, enable);
>>> +    if (ret && ret != -ENOIOCTLCMD)
>>> +        return ret;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned
>>> int count)
>>> +{
>>> +    struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
>>> +    struct media_entity *entity;
>>> +    int ret;
>>> +
>>> +    vcap->sequence = 0;
>>> +
>>> +    /* Start the media pipeline */
>>> +    entity = &vcap->vdev.entity;
>>> +    ret = media_entity_pipeline_start(entity, &vcap->pipe);
>>> +    if (ret) {
>>> +        vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
>>> +        return ret;
>>> +    }
>>> +
>>> +    /* Enable streaming from the pipe */
>>> +    ret = vimc_cap_pipeline_s_stream(vcap, 1);
>>> +    if (ret) {
>>> +        vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
>>> +        return ret;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +/*
>>> + * Stop the stream engine. Any remaining buffers in the stream queue
>>> are
>>> + * dequeued and passed on to the vb2 framework marked as STATE_ERROR.
>>> + */
>>> +static void vimc_cap_stop_streaming(struct vb2_queue *vq)
>>> +{
>>> +    struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
>>> +
>>> +    /* Disable streaming from the pipe */
>>> +    vimc_cap_pipeline_s_stream(vcap, 0);
>>> +
>>> +    /* Stop the media pipeline */
>>> +    media_entity_pipeline_stop(&vcap->vdev.entity);
>>> +
>>> +    /* Release all active buffers */
>>> +    vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_ERROR);
>>> +}
>>> +
>>> +static void vimc_cap_buf_queue(struct vb2_buffer *vb2_buf)
>>> +{
>>> +    struct vimc_cap_device *vcap =
>>> vb2_get_drv_priv(vb2_buf->vb2_queue);
>>> +    struct vimc_cap_buffer *buf = container_of(vb2_buf,
>>> +                           struct vimc_cap_buffer,
>>> +                           vb2.vb2_buf);
>>> +
>>> +    spin_lock(&vcap->qlock);
>>> +    list_add_tail(&buf->list, &vcap->buf_list);
>>> +    spin_unlock(&vcap->qlock);
>>> +}
>>> +
>>> +static int vimc_cap_queue_setup(struct vb2_queue *vq, unsigned int
>>> *nbuffers,
>>> +                unsigned int *nplanes, unsigned int sizes[],
>>> +                struct device *alloc_devs[])
>>> +{
>>> +    struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
>>> +
>>> +    if (*nplanes)
>>> +        return sizes[0] < vcap->format.sizeimage ? -EINVAL : 0;
>>
>> Why? The user could later reconfigure the device to use with a buffer of
>> this size. This might not be a concern for vimc, but the code from
>> example
>> drivers tends to get copied around.
> 
> 
> This first version only support a fixed sizeimage, this will be changed
> in the next patch series where
> I add support for multiple sizes

Sounds good to me. Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
