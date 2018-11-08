Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38386 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726584AbeKIBYZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 20:24:25 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA8FiNvv175360
        for <linux-media@vger.kernel.org>; Thu, 8 Nov 2018 10:48:19 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2nmpcrwb2j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 10:48:18 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Thu, 8 Nov 2018 15:48:17 -0000
Subject: Re: [PATCH v4 2/2] media: platform: Add Aspeed Video Engine driver
From: Eddie James <eajames@linux.vnet.ibm.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1538769466-14860-1-git-send-email-eajames@linux.ibm.com>
 <1538769466-14860-3-git-send-email-eajames@linux.ibm.com>
 <bf07eb1f-bc17-ac59-d341-f19e2ab0c2e2@xs4all.nl>
 <b64d0a4b-f74a-e887-366d-c242ac3f0d1c@linux.vnet.ibm.com>
Date: Thu, 8 Nov 2018 09:48:10 -0600
MIME-Version: 1.0
In-Reply-To: <b64d0a4b-f74a-e887-366d-c242ac3f0d1c@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Message-Id: <7027cd38-b8f5-08b2-0536-eed1c6a0516b@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/19/2018 03:26 PM, Eddie James wrote:
>
>
> On 10/12/2018 07:22 AM, Hans Verkuil wrote:
>> On 10/05/2018 09:57 PM, Eddie James wrote:
>>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>>> can capture and compress video data from digital or analog sources. 
>>> With
>>> the Aspeed chip acting a service processor, the Video Engine can 
>>> capture
>>> the host processor graphics output.
>>>
>>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>>> Make the video frames available through the V4L2 streaming interface.
>>>
>>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>>> ---
>>>   MAINTAINERS                           |    8 +
>>>   drivers/media/platform/Kconfig        |    8 +
>>>   drivers/media/platform/Makefile       |    1 +
>>>   drivers/media/platform/aspeed-video.c | 1674 
>>> +++++++++++++++++++++++++++++++++
>>>   4 files changed, 1691 insertions(+)
>>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>>
>> <snip>
>>
>>> +static int aspeed_video_enum_input(struct file *file, void *fh,
>>> +                   struct v4l2_input *inp)
>>> +{
>>> +    if (inp->index)
>>> +        return -EINVAL;
>>> +
>>> +    strscpy(inp->name, "Host VGA capture", sizeof(inp->name));
>>> +    inp->type = V4L2_INPUT_TYPE_CAMERA;
>>> +    inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
>>> +    inp->status = V4L2_IN_ST_NO_SIGNAL | V4L2_IN_ST_NO_SYNC;
>> This can't be right. If there is a valid signal, then status should 
>> be 0.
>> And ideally you can tell the difference between no signal and no sync
>> as well.
>>
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_get_input(struct file *file, void *fh, 
>>> unsigned int *i)
>>> +{
>>> +    *i = 0;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_set_input(struct file *file, void *fh, 
>>> unsigned int i)
>>> +{
>>> +    if (i)
>>> +        return -EINVAL;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_get_parm(struct file *file, void *fh,
>>> +                 struct v4l2_streamparm *a)
>>> +{
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>> +    a->parm.capture.readbuffers = 3;
>>> +    a->parm.capture.timeperframe.numerator = 1;
>>> +    if (!video->frame_rate)
>>> +        a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE + 1;
>>> +    else
>>> +        a->parm.capture.timeperframe.denominator = video->frame_rate;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_set_parm(struct file *file, void *fh,
>>> +                 struct v4l2_streamparm *a)
>>> +{
>>> +    unsigned int frame_rate = 0;
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>> +    a->parm.capture.readbuffers = 3;
>>> +
>>> +    if (a->parm.capture.timeperframe.numerator)
>>> +        frame_rate = a->parm.capture.timeperframe.denominator /
>>> +            a->parm.capture.timeperframe.numerator;
>>> +
>>> +    if (!frame_rate || frame_rate > MAX_FRAME_RATE) {
>>> +        frame_rate = 0;
>>> +
>>> +        /*
>>> +         * Set to max + 1 to differentiate between max and 0, which
>>> +         * means "don't care".
>> But what does "don't care" mean in practice? It's still not clear to 
>> me how this
>> is supposed to work.
>>
>>> +         */
>>> +        a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE + 1;
>> And regardless of anything else this timeperframe is out of the range 
>> that
>> aspeed_video_enum_frameintervals() returns.
>>
>>> + a->parm.capture.timeperframe.numerator = 1;
>>> +    }
>>> +
>>> +    if (video->frame_rate != frame_rate) {
>>> +        video->frame_rate = frame_rate;
>>> +        aspeed_video_update(video, VE_CTRL, VE_CTRL_FRC,
>>> +                    FIELD_PREP(VE_CTRL_FRC, frame_rate));
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_framesizes(struct file *file, void *fh,
>>> +                    struct v4l2_frmsizeenum *fsize)
>>> +{
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    if (fsize->index)
>>> +        return -EINVAL;
>>> +
>>> +    if (fsize->pixel_format != V4L2_PIX_FMT_JPEG)
>>> +        return -EINVAL;
>>> +
>>> +    fsize->discrete.width = video->pix_fmt.width;
>>> +    fsize->discrete.height = video->pix_fmt.height;
>>> +    fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_frameintervals(struct file *file, void 
>>> *fh,
>>> +                        struct v4l2_frmivalenum *fival)
>>> +{
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    if (fival->index)
>>> +        return -EINVAL;
>>> +
>>> +    if (fival->width != video->width || fival->height != 
>>> video->height)
>>> +        return -EINVAL;
>>> +
>>> +    if (fival->pixel_format != V4L2_PIX_FMT_JPEG)
>>> +        return -EINVAL;
>>> +
>>> +    fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>>> +
>>> +    fival->stepwise.min.denominator = MAX_FRAME_RATE;
>>> +    fival->stepwise.min.numerator = 1;
>>> +    fival->stepwise.max.denominator = 1;
>>> +    fival->stepwise.max.numerator = 1;
>>> +    fival->stepwise.step = fival->stepwise.max;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_set_dv_timings(struct file *file, void *fh,
>>> +                       struct v4l2_dv_timings *timings)
>>> +{
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>> If vb2_is_busy() returns true, then return -EBUSY here. It is not 
>> allowed to
>> set the timings while vb2 is busy.
>
> Buffer ioctls (Input 0):
>         fail: v4l2-test-buffers.cpp(344): node->s_dv_timings(timings)
>         fail: v4l2-test-buffers.cpp(452): testCanSetSameTimings(node)
>     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>
> Streaming ioctls:
>     test read/write: OK
>     test blocking wait: OK
>         fail: v4l2-test-buffers.cpp(344): node->s_dv_timings(timings)
>         fail: v4l2-test-buffers.cpp(637): testCanSetSameTimings(node)
>         fail: v4l2-test-buffers.cpp(952): captureBufs(node, q, m2m_q, 
> frame_count, false)
>     test MMAP: FAIL
>
> Built from v4l-utils c36dbbdfa8b30b2badd4f893b59d0bd4f0bd12aa
>
> Adding this causes some of the v4l2-compliance streaming tests to 
> fail, and prevents my own application from being able to call 
> S_DV_TIMINGS after detecting a resolution change, despite calling 
> streamoff and unmapping all the buffers first.

Any thoughts on this Hans?

Thanks,
Eddie

>
> Thanks,
> Eddie
>
>>
>>> +    if (video->width != timings->bt.width ||
>>> +        video->height != timings->bt.height)
>>> +        return -EINVAL;
>>> +
>>> +    video->pix_fmt.width = timings->bt.width;
>>> +    video->pix_fmt.height = timings->bt.height;
>>> +    video->pix_fmt.sizeimage = video->max_compressed_size;
>>> +    video->timings.width = timings->bt.width;
>>> +    video->timings.height = timings->bt.height;
>>> +
>>> +    timings->type = V4L2_DV_BT_656_1120;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_get_dv_timings(struct file *file, void *fh,
>>> +                       struct v4l2_dv_timings *timings)
>>> +{
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    timings->type = V4L2_DV_BT_656_1120;
>>> +    timings->bt = video->timings;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_query_dv_timings(struct file *file, void *fh,
>>> +                     struct v4l2_dv_timings *timings)
>>> +{
>>> +    int rc;
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    if (file->f_flags & O_NONBLOCK) {
>>> +        if (test_bit(VIDEO_RES_CHANGE, &video->flags))
>>> +            return -EAGAIN;
>>> +    } else {
>>> +        rc = wait_event_interruptible(video->wait,
>>> +                          !test_bit(VIDEO_RES_CHANGE,
>>> +                            &video->flags));
>>> +        if (rc)
>>> +            return -EINTR;
>>> +    }
>>> +
>>> +    timings->type = V4L2_DV_BT_656_1120;
>>> +    timings->bt = video->timings;
>>> +    timings->bt.width = video->width;
>>> +    timings->bt.height = video->height;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_dv_timings(struct file *file, void *fh,
>>> +                    struct v4l2_enum_dv_timings *timings)
>>> +{
>>> +    if (timings->index)
>>> +        return -EINVAL;
>>> +
>>> +    return aspeed_video_get_dv_timings(file, fh, &timings->timings);
>>> +}
>>> +
>>> +static int aspeed_video_dv_timings_cap(struct file *file, void *fh,
>>> +                       struct v4l2_dv_timings_cap *cap)
>>> +{
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    cap->type = V4L2_DV_BT_656_1120;
>>> +    cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE;
>>> +    cap->bt.min_width = video->width;
>>> +    cap->bt.max_width = video->width;
>>> +    cap->bt.min_height = video->height;
>>> +    cap->bt.max_height = video->height;
>> This should return the capabilities of the aspeed. In this case I'd
>> guess that the max width/height is 1920x1080 (or perhaps 1200).
>>
>> The minimum is probably the VGA resolution.
>>
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_sub_event(struct v4l2_fh *fh,
>>> +                  const struct v4l2_event_subscription *sub)
>>> +{
>>> +    switch (sub->type) {
>>> +    case V4L2_EVENT_SOURCE_CHANGE:
>>> +        return v4l2_src_change_event_subscribe(fh, sub);
>>> +    }
>>> +
>>> +    return v4l2_ctrl_subscribe_event(fh, sub);
>>> +}
>>> +
>>> +static const struct v4l2_ioctl_ops aspeed_video_ioctl_ops = {
>>> +    .vidioc_querycap = aspeed_video_querycap,
>>> +
>>> +    .vidioc_enum_fmt_vid_cap = aspeed_video_enum_format,
>>> +    .vidioc_g_fmt_vid_cap = aspeed_video_get_format,
>>> +    .vidioc_s_fmt_vid_cap = aspeed_video_get_format,
>>> +    .vidioc_try_fmt_vid_cap = aspeed_video_get_format,
>>> +
>>> +    .vidioc_reqbufs = vb2_ioctl_reqbufs,
>>> +    .vidioc_querybuf = vb2_ioctl_querybuf,
>>> +    .vidioc_qbuf = vb2_ioctl_qbuf,
>>> +    .vidioc_dqbuf = vb2_ioctl_dqbuf,
>>> +    .vidioc_create_bufs = vb2_ioctl_create_bufs,
>>> +    .vidioc_prepare_buf = vb2_ioctl_prepare_buf,
>>> +    .vidioc_streamon = vb2_ioctl_streamon,
>>> +    .vidioc_streamoff = vb2_ioctl_streamoff,
>>> +
>>> +    .vidioc_enum_input = aspeed_video_enum_input,
>>> +    .vidioc_g_input = aspeed_video_get_input,
>>> +    .vidioc_s_input = aspeed_video_set_input,
>>> +
>>> +    .vidioc_g_parm = aspeed_video_get_parm,
>>> +    .vidioc_s_parm = aspeed_video_set_parm,
>>> +    .vidioc_enum_framesizes = aspeed_video_enum_framesizes,
>>> +    .vidioc_enum_frameintervals = aspeed_video_enum_frameintervals,
>>> +
>>> +    .vidioc_s_dv_timings = aspeed_video_set_dv_timings,
>>> +    .vidioc_g_dv_timings = aspeed_video_get_dv_timings,
>>> +    .vidioc_query_dv_timings = aspeed_video_query_dv_timings,
>>> +    .vidioc_enum_dv_timings = aspeed_video_enum_dv_timings,
>>> +    .vidioc_dv_timings_cap = aspeed_video_dv_timings_cap,
>>> +
>>> +    .vidioc_subscribe_event = aspeed_video_sub_event,
>>> +    .vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>>> +};
>>> +
>>> +static void aspeed_video_update_jpeg_quality(struct aspeed_video 
>>> *video)
>>> +{
>>> +    u32 comp_ctrl = FIELD_PREP(VE_COMP_CTRL_DCT_LUM, 
>>> video->jpeg_quality) |
>>> +        FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>>> +
>>> +    aspeed_video_update(video, VE_COMP_CTRL,
>>> +                VE_COMP_CTRL_DCT_LUM | VE_COMP_CTRL_DCT_CHR,
>>> +                comp_ctrl);
>>> +}
>>> +
>>> +static void aspeed_video_update_subsampling(struct aspeed_video 
>>> *video)
>>> +{
>>> +    if (video->jpeg.virt)
>>> +        aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>>> +
>>> +    if (video->yuv420)
>>> +        aspeed_video_update(video, VE_SEQ_CTRL, 0, 
>>> VE_SEQ_CTRL_YUV420);
>>> +    else
>>> +        aspeed_video_update(video, VE_SEQ_CTRL, VE_SEQ_CTRL_YUV420, 
>>> 0);
>>> +}
>>> +
>>> +static int aspeed_video_set_ctrl(struct v4l2_ctrl *ctrl)
>>> +{
>>> +    struct aspeed_video *video = container_of(ctrl->handler,
>>> +                          struct aspeed_video,
>>> +                          ctrl_handler);
>>> +
>>> +    switch (ctrl->id) {
>>> +    case V4L2_CID_JPEG_COMPRESSION_QUALITY:
>>> +        video->jpeg_quality = ctrl->val;
>>> +        aspeed_video_update_jpeg_quality(video);
>>> +        break;
>>> +    case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>>> +        if (ctrl->val == V4L2_JPEG_CHROMA_SUBSAMPLING_420) {
>>> +            video->yuv420 = true;
>>> +            aspeed_video_update_subsampling(video);
>>> +        } else {
>>> +            video->yuv420 = false;
>>> +            aspeed_video_update_subsampling(video);
>>> +        }
>>> +        break;
>>> +    default:
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static const struct v4l2_ctrl_ops aspeed_video_ctrl_ops = {
>>> +    .s_ctrl = aspeed_video_set_ctrl,
>>> +};
>>> +
>>> +static void aspeed_video_resolution_work(struct work_struct *work)
>>> +{
>>> +    int rc;
>>> +    struct delayed_work *dwork = to_delayed_work(work);
>>> +    struct aspeed_video *video = container_of(dwork, struct 
>>> aspeed_video,
>>> +                          res_work);
>>> +
>>> +    /* No clients remaining after delay */
>>> +    if (atomic_read(&video->clients) == 0)
>>> +        goto done;
>>> +
>>> +    aspeed_video_on(video);
>>> +
>>> +    aspeed_video_init_regs(video);
>>> +
>>> +    rc = aspeed_video_get_resolution(video);
>>> +    if (rc)
>>> +        dev_err(video->dev,
>>> +            "resolution changed; couldn't get new resolution\n");
>>> +    else if (test_bit(VIDEO_STREAMING, &video->flags))
>>> +        aspeed_video_start_frame(video);
>>> +
>>> +    if (video->width != video->pix_fmt.width ||
>>> +        video->height != video->pix_fmt.height) {
>>> +        static const struct v4l2_event ev = {
>>> +            .type = V4L2_EVENT_SOURCE_CHANGE,
>>> +            .u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>>> +        };
>>> +
>>> +        v4l2_event_queue(&video->vdev, &ev);
>>> +    }
>>> +
>>> +done:
>>> +    clear_bit(VIDEO_RES_CHANGE, &video->flags);
>>> +    wake_up_interruptible_all(&video->wait);
>>> +}
>>> +
>>> +static int aspeed_video_open(struct file *file)
>>> +{
>>> +    int rc;
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    mutex_lock(&video->video_lock);
>>> +
>>> +    if (atomic_inc_return(&video->clients) == 1) {
>>> +        rc = aspeed_video_start(video);
>>> +        if (rc) {
>>> +            dev_err(video->dev, "Failed to start video engine\n");
>>> +            atomic_dec(&video->clients);
>>> +            mutex_unlock(&video->video_lock);
>>> +            return rc;
>>> +        }
>>> +    }
>>> +
>>> +    mutex_unlock(&video->video_lock);
>>> +
>>> +    return v4l2_fh_open(file);
>>> +}
>>> +
>>> +static int aspeed_video_release(struct file *file)
>>> +{
>>> +    int rc;
>>> +    struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +    rc = vb2_fop_release(file);
>>> +
>>> +    mutex_lock(&video->video_lock);
>>> +
>>> +    if (atomic_dec_return(&video->clients) == 0)
>>> +        aspeed_video_stop(video);
>>> +
>>> +    mutex_unlock(&video->video_lock);
>>> +
>>> +    return rc;
>>> +}
>>> +
>>> +static const struct v4l2_file_operations aspeed_video_v4l2_fops = {
>>> +    .owner = THIS_MODULE,
>>> +    .read = vb2_fop_read,
>>> +    .poll = vb2_fop_poll,
>>> +    .unlocked_ioctl = video_ioctl2,
>>> +    .mmap = vb2_fop_mmap,
>>> +    .open = aspeed_video_open,
>>> +    .release = aspeed_video_release,
>>> +};
>>> +
>>> +static int aspeed_video_queue_setup(struct vb2_queue *q,
>>> +                    unsigned int *num_buffers,
>>> +                    unsigned int *num_planes,
>>> +                    unsigned int sizes[],
>>> +                    struct device *alloc_devs[])
>>> +{
>>> +    struct aspeed_video *video = vb2_get_drv_priv(q);
>>> +
>>> +    if (*num_planes) {
>>> +        if (sizes[0] < video->max_compressed_size)
>>> +            return -EINVAL;
>>> +
>>> +        return 0;
>>> +    }
>>> +
>>> +    *num_planes = 1;
>>> +    sizes[0] = video->max_compressed_size;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_buf_prepare(struct vb2_buffer *vb)
>>> +{
>>> +    struct aspeed_video *video = vb2_get_drv_priv(vb->vb2_queue);
>>> +
>>> +    if (vb2_plane_size(vb, 0) < video->max_compressed_size)
>>> +        return -EINVAL;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_start_streaming(struct vb2_queue *q,
>>> +                    unsigned int count)
>>> +{
>>> +    int rc;
>>> +    struct aspeed_video *video = vb2_get_drv_priv(q);
>>> +
>>> +    rc = aspeed_video_start_frame(video);
>>> +    if (rc) {
>>> +        aspeed_video_bufs_done(video, VB2_BUF_STATE_QUEUED);
>>> +        return rc;
>>> +    }
>>> +
>>> +    video->sequence = 0;
>>> +    set_bit(VIDEO_STREAMING, &video->flags);
>>> +    return 0;
>>> +}
>>> +
>>> +static void aspeed_video_stop_streaming(struct vb2_queue *q)
>>> +{
>>> +    int rc;
>>> +    struct aspeed_video *video = vb2_get_drv_priv(q);
>>> +
>>> +    clear_bit(VIDEO_STREAMING, &video->flags);
>>> +
>>> +    rc = wait_event_timeout(video->wait,
>>> +                !test_bit(VIDEO_FRAME_INPRG, &video->flags),
>>> +                STOP_TIMEOUT);
>>> +    if (!rc) {
>>> +        dev_err(video->dev, "Timed out when stopping streaming\n");
>>> +        aspeed_video_stop(video);
>>> +    }
>>> +
>>> +    aspeed_video_bufs_done(video, VB2_BUF_STATE_ERROR);
>>> +}
>>> +
>>> +static void aspeed_video_buf_queue(struct vb2_buffer *vb)
>>> +{
>>> +    struct aspeed_video *video = vb2_get_drv_priv(vb->vb2_queue);
>>> +    struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>>> +    struct aspeed_video_buffer *avb = to_aspeed_video_buffer(vbuf);
>>> +    unsigned long flags;
>>> +
>>> +    spin_lock_irqsave(&video->lock, flags);
>>> +    list_add_tail(&avb->link, &video->buffers);
>>> +    spin_unlock_irqrestore(&video->lock, flags);
>>> +}
>>> +
>>> +static const struct vb2_ops aspeed_video_vb2_ops = {
>>> +    .queue_setup = aspeed_video_queue_setup,
>>> +    .wait_prepare = vb2_ops_wait_prepare,
>>> +    .wait_finish = vb2_ops_wait_finish,
>>> +    .buf_prepare = aspeed_video_buf_prepare,
>>> +    .start_streaming = aspeed_video_start_streaming,
>>> +    .stop_streaming = aspeed_video_stop_streaming,
>>> +    .buf_queue =  aspeed_video_buf_queue,
>>> +};
>>> +
>>> +static int aspeed_video_setup_video(struct aspeed_video *video)
>>> +{
>>> +    const u64 mask = ~(BIT(V4L2_JPEG_CHROMA_SUBSAMPLING_444) |
>>> +               BIT(V4L2_JPEG_CHROMA_SUBSAMPLING_420));
>>> +    struct v4l2_device *v4l2_dev = &video->v4l2_dev;
>>> +    struct vb2_queue *vbq = &video->queue;
>>> +    struct video_device *vdev = &video->vdev;
>>> +    int rc;
>>> +
>>> +    video->pix_fmt.pixelformat = V4L2_PIX_FMT_JPEG;
>>> +    video->pix_fmt.field = V4L2_FIELD_NONE;
>>> +    video->pix_fmt.colorspace = V4L2_COLORSPACE_SRGB;
>>> +    video->pix_fmt.quantization = V4L2_QUANTIZATION_FULL_RANGE;
>>> +
>>> +    rc = v4l2_device_register(video->dev, v4l2_dev);
>>> +    if (rc) {
>>> +        dev_err(video->dev, "Failed to register v4l2 device\n");
>>> +        return rc;
>>> +    }
>>> +
>>> +    v4l2_ctrl_handler_init(&video->ctrl_handler, 2);
>>> +    v4l2_ctrl_new_std(&video->ctrl_handler, &aspeed_video_ctrl_ops,
>>> +              V4L2_CID_JPEG_COMPRESSION_QUALITY, 0,
>>> +              ASPEED_VIDEO_JPEG_NUM_QUALITIES - 1, 1, 0);
>>> +    v4l2_ctrl_new_std_menu(&video->ctrl_handler, 
>>> &aspeed_video_ctrl_ops,
>>> +                   V4L2_CID_JPEG_CHROMA_SUBSAMPLING,
>>> +                   V4L2_JPEG_CHROMA_SUBSAMPLING_420, mask,
>>> +                   V4L2_JPEG_CHROMA_SUBSAMPLING_444);
>>> +
>>> +    if (video->ctrl_handler.error) {
>>> +        v4l2_ctrl_handler_free(&video->ctrl_handler);
>>> +        v4l2_device_unregister(v4l2_dev);
>>> +
>>> +        dev_err(video->dev, "Failed to init controls: %d\n",
>>> +            video->ctrl_handler.error);
>>> +        return rc;
>>> +    }
>>> +
>>> +    v4l2_dev->ctrl_handler = &video->ctrl_handler;
>>> +
>>> +    vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +    vbq->io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
>>> +    vbq->dev = v4l2_dev->dev;
>>> +    vbq->lock = &video->video_lock;
>>> +    vbq->ops = &aspeed_video_vb2_ops;
>>> +    vbq->mem_ops = &vb2_dma_contig_memops;
>>> +    vbq->drv_priv = video;
>>> +    vbq->buf_struct_size = sizeof(struct aspeed_video_buffer);
>>> +    vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>>> +    vbq->min_buffers_needed = 3;
>>> +
>>> +    rc = vb2_queue_init(vbq);
>>> +    if (rc) {
>>> +        v4l2_ctrl_handler_free(&video->ctrl_handler);
>>> +        v4l2_device_unregister(v4l2_dev);
>>> +
>>> +        dev_err(video->dev, "Failed to init vb2 queue\n");
>>> +        return rc;
>>> +    }
>>> +
>>> +    vdev->queue = vbq;
>>> +    vdev->fops = &aspeed_video_v4l2_fops;
>>> +    vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
>> READWRITE doesn't work for JPEG since there is no clear end of a 
>> frame. Just drop
>> this and the read op in aspeed_video_v4l2_fops.
>>
>>> +        V4L2_CAP_STREAMING;
>>> +    vdev->v4l2_dev = v4l2_dev;
>>> +    strscpy(vdev->name, DEVICE_NAME, sizeof(vdev->name));
>>> +    vdev->vfl_type = VFL_TYPE_GRABBER;
>>> +    vdev->vfl_dir = VFL_DIR_RX;
>>> +    vdev->release = video_device_release_empty;
>>> +    vdev->ioctl_ops = &aspeed_video_ioctl_ops;
>>> +    vdev->lock = &video->video_lock;
>>> +
>>> +    video_set_drvdata(vdev, video);
>>> +    rc = video_register_device(vdev, VFL_TYPE_GRABBER, 0);
>>> +    if (rc) {
>>> +        vb2_queue_release(vbq);
>>> +        v4l2_ctrl_handler_free(&video->ctrl_handler);
>>> +        v4l2_device_unregister(v4l2_dev);
>>> +
>>> +        dev_err(video->dev, "Failed to register video device\n");
>>> +        return rc;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_init(struct aspeed_video *video)
>>> +{
>>> +    int irq;
>>> +    int rc;
>>> +    struct device *dev = video->dev;
>>> +
>>> +    irq = irq_of_parse_and_map(dev->of_node, 0);
>>> +    if (!irq) {
>>> +        dev_err(dev, "Unable to find IRQ\n");
>>> +        return -ENODEV;
>>> +    }
>>> +
>>> +    rc = devm_request_irq(dev, irq, aspeed_video_irq, IRQF_SHARED,
>>> +                  DEVICE_NAME, video);
>>> +    if (rc < 0) {
>>> +        dev_err(dev, "Unable to request IRQ %d\n", irq);
>>> +        return rc;
>>> +    }
>>> +
>>> +    video->eclk = devm_clk_get(dev, "eclk");
>>> +    if (IS_ERR(video->eclk)) {
>>> +        dev_err(dev, "Unable to get ECLK\n");
>>> +        return PTR_ERR(video->eclk);
>>> +    }
>>> +
>>> +    video->vclk = devm_clk_get(dev, "vclk");
>>> +    if (IS_ERR(video->vclk)) {
>>> +        dev_err(dev, "Unable to get VCLK\n");
>>> +        return PTR_ERR(video->vclk);
>>> +    }
>>> +
>>> +    video->rst = devm_reset_control_get_exclusive(dev, NULL);
>>> +    if (IS_ERR(video->rst)) {
>>> +        dev_err(dev, "Unable to get VE reset\n");
>>> +        return PTR_ERR(video->rst);
>>> +    }
>>> +
>>> +    rc = of_reserved_mem_device_init(dev);
>>> +    if (rc) {
>>> +        dev_err(dev, "Unable to reserve memory\n");
>>> +        return rc;
>>> +    }
>>> +
>>> +    rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>>> +    if (rc) {
>>> +        dev_err(dev, "Failed to set DMA mask\n");
>>> +        of_reserved_mem_device_release(dev);
>>> +        return rc;
>>> +    }
>>> +
>>> +    if (!aspeed_video_alloc_buf(video, &video->jpeg,
>>> +                    VE_JPEG_HEADER_SIZE)) {
>>> +        dev_err(dev, "Failed to allocate DMA for JPEG header\n");
>>> +        of_reserved_mem_device_release(dev);
>>> +        return rc;
>>> +    }
>>> +
>>> +    aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_probe(struct platform_device *pdev)
>>> +{
>>> +    int rc;
>>> +    struct resource *res;
>>> +    struct aspeed_video *video = kzalloc(sizeof(*video), GFP_KERNEL);
>>> +
>>> +    if (!video)
>>> +        return -ENOMEM;
>>> +
>>> +    video->frame_rate = 30;
>>> +    video->dev = &pdev->dev;
>>> +    mutex_init(&video->video_lock);
>>> +    init_waitqueue_head(&video->wait);
>>> +    INIT_DELAYED_WORK(&video->res_work, aspeed_video_resolution_work);
>>> +    INIT_LIST_HEAD(&video->buffers);
>>> +
>>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +
>>> +    video->base = devm_ioremap_resource(video->dev, res);
>>> +
>>> +    if (IS_ERR(video->base))
>>> +        return PTR_ERR(video->base);
>>> +
>>> +    rc = aspeed_video_init(video);
>>> +    if (rc)
>>> +        return rc;
>>> +
>>> +    rc = aspeed_video_setup_video(video);
>>> +    if (rc)
>>> +        return rc;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int aspeed_video_remove(struct platform_device *pdev)
>>> +{
>>> +    struct device *dev = &pdev->dev;
>>> +    struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
>>> +    struct aspeed_video *video = to_aspeed_video(v4l2_dev);
>>> +
>>> +    video_unregister_device(&video->vdev);
>>> +
>>> +    vb2_queue_release(&video->queue);
>>> +
>>> +    v4l2_ctrl_handler_free(&video->ctrl_handler);
>>> +
>>> +    v4l2_device_unregister(v4l2_dev);
>>> +
>>> +    dma_free_coherent(video->dev, VE_JPEG_HEADER_SIZE, 
>>> video->jpeg.virt,
>>> +              video->jpeg.dma);
>>> +
>>> +    of_reserved_mem_device_release(dev);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static const struct of_device_id aspeed_video_of_match[] = {
>>> +    { .compatible = "aspeed,ast2400-video-engine" },
>>> +    { .compatible = "aspeed,ast2500-video-engine" },
>>> +    {}
>>> +};
>>> +MODULE_DEVICE_TABLE(of, aspeed_video_of_match);
>>> +
>>> +static struct platform_driver aspeed_video_driver = {
>>> +    .driver = {
>>> +        .name = DEVICE_NAME,
>>> +        .of_match_table = aspeed_video_of_match,
>>> +    },
>>> +    .probe = aspeed_video_probe,
>>> +    .remove = aspeed_video_remove,
>>> +};
>>> +
>>> +module_platform_driver(aspeed_video_driver);
>>> +
>>> +MODULE_DESCRIPTION("ASPEED Video Engine Driver");
>>> +MODULE_AUTHOR("Eddie James");
>>> +MODULE_LICENSE("GPL v2");
>>>
>> Regards,
>>
>>     Hans
>>
>
