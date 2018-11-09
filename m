Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47348 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbeKIUfH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 15:35:07 -0500
Subject: Re: [PATCH v4 2/2] media: platform: Add Aspeed Video Engine driver
To: Eddie James <eajames@linux.vnet.ibm.com>,
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
 <7027cd38-b8f5-08b2-0536-eed1c6a0516b@linux.vnet.ibm.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c972883e-38fd-64ad-b136-974ea8937467@xs4all.nl>
Date: Fri, 9 Nov 2018 11:54:54 +0100
MIME-Version: 1.0
In-Reply-To: <7027cd38-b8f5-08b2-0536-eed1c6a0516b@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eddie,

Sorry for the delay, I've been away for the past two weeks and I've been
catching up ever since I came back.

On 11/08/18 16:48, Eddie James wrote:
> 
> 
> On 10/19/2018 03:26 PM, Eddie James wrote:
>>
>>
>> On 10/12/2018 07:22 AM, Hans Verkuil wrote:
>>> On 10/05/2018 09:57 PM, Eddie James wrote:
>>>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>>>> can capture and compress video data from digital or analog sources. 
>>>> With
>>>> the Aspeed chip acting a service processor, the Video Engine can 
>>>> capture
>>>> the host processor graphics output.
>>>>
>>>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>>>> Make the video frames available through the V4L2 streaming interface.
>>>>
>>>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>>>> ---
>>>>   MAINTAINERS                           |    8 +
>>>>   drivers/media/platform/Kconfig        |    8 +
>>>>   drivers/media/platform/Makefile       |    1 +
>>>>   drivers/media/platform/aspeed-video.c | 1674 
>>>> +++++++++++++++++++++++++++++++++
>>>>   4 files changed, 1691 insertions(+)
>>>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>>>
>>> <snip>
>>>
>>>> +static int aspeed_video_enum_input(struct file *file, void *fh,
>>>> +                   struct v4l2_input *inp)
>>>> +{
>>>> +    if (inp->index)
>>>> +        return -EINVAL;
>>>> +
>>>> +    strscpy(inp->name, "Host VGA capture", sizeof(inp->name));
>>>> +    inp->type = V4L2_INPUT_TYPE_CAMERA;
>>>> +    inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
>>>> +    inp->status = V4L2_IN_ST_NO_SIGNAL | V4L2_IN_ST_NO_SYNC;
>>> This can't be right. If there is a valid signal, then status should 
>>> be 0.
>>> And ideally you can tell the difference between no signal and no sync
>>> as well.
>>>
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int aspeed_video_get_input(struct file *file, void *fh, 
>>>> unsigned int *i)
>>>> +{
>>>> +    *i = 0;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int aspeed_video_set_input(struct file *file, void *fh, 
>>>> unsigned int i)
>>>> +{
>>>> +    if (i)
>>>> +        return -EINVAL;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int aspeed_video_get_parm(struct file *file, void *fh,
>>>> +                 struct v4l2_streamparm *a)
>>>> +{
>>>> +    struct aspeed_video *video = video_drvdata(file);
>>>> +
>>>> +    a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>>> +    a->parm.capture.readbuffers = 3;
>>>> +    a->parm.capture.timeperframe.numerator = 1;
>>>> +    if (!video->frame_rate)
>>>> +        a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE + 1;
>>>> +    else
>>>> +        a->parm.capture.timeperframe.denominator = video->frame_rate;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int aspeed_video_set_parm(struct file *file, void *fh,
>>>> +                 struct v4l2_streamparm *a)
>>>> +{
>>>> +    unsigned int frame_rate = 0;
>>>> +    struct aspeed_video *video = video_drvdata(file);
>>>> +
>>>> +    a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>>> +    a->parm.capture.readbuffers = 3;
>>>> +
>>>> +    if (a->parm.capture.timeperframe.numerator)
>>>> +        frame_rate = a->parm.capture.timeperframe.denominator /
>>>> +            a->parm.capture.timeperframe.numerator;
>>>> +
>>>> +    if (!frame_rate || frame_rate > MAX_FRAME_RATE) {
>>>> +        frame_rate = 0;
>>>> +
>>>> +        /*
>>>> +         * Set to max + 1 to differentiate between max and 0, which
>>>> +         * means "don't care".
>>> But what does "don't care" mean in practice? It's still not clear to 
>>> me how this
>>> is supposed to work.
>>>
>>>> +         */
>>>> +        a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE + 1;
>>> And regardless of anything else this timeperframe is out of the range 
>>> that
>>> aspeed_video_enum_frameintervals() returns.
>>>
>>>> + a->parm.capture.timeperframe.numerator = 1;
>>>> +    }
>>>> +
>>>> +    if (video->frame_rate != frame_rate) {
>>>> +        video->frame_rate = frame_rate;
>>>> +        aspeed_video_update(video, VE_CTRL, VE_CTRL_FRC,
>>>> +                    FIELD_PREP(VE_CTRL_FRC, frame_rate));
>>>> +    }
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int aspeed_video_enum_framesizes(struct file *file, void *fh,
>>>> +                    struct v4l2_frmsizeenum *fsize)
>>>> +{
>>>> +    struct aspeed_video *video = video_drvdata(file);
>>>> +
>>>> +    if (fsize->index)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (fsize->pixel_format != V4L2_PIX_FMT_JPEG)
>>>> +        return -EINVAL;
>>>> +
>>>> +    fsize->discrete.width = video->pix_fmt.width;
>>>> +    fsize->discrete.height = video->pix_fmt.height;
>>>> +    fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int aspeed_video_enum_frameintervals(struct file *file, void 
>>>> *fh,
>>>> +                        struct v4l2_frmivalenum *fival)
>>>> +{
>>>> +    struct aspeed_video *video = video_drvdata(file);
>>>> +
>>>> +    if (fival->index)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (fival->width != video->width || fival->height != 
>>>> video->height)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (fival->pixel_format != V4L2_PIX_FMT_JPEG)
>>>> +        return -EINVAL;
>>>> +
>>>> +    fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>>>> +
>>>> +    fival->stepwise.min.denominator = MAX_FRAME_RATE;
>>>> +    fival->stepwise.min.numerator = 1;
>>>> +    fival->stepwise.max.denominator = 1;
>>>> +    fival->stepwise.max.numerator = 1;
>>>> +    fival->stepwise.step = fival->stepwise.max;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int aspeed_video_set_dv_timings(struct file *file, void *fh,
>>>> +                       struct v4l2_dv_timings *timings)
>>>> +{
>>>> +    struct aspeed_video *video = video_drvdata(file);
>>>> +
>>> If vb2_is_busy() returns true, then return -EBUSY here. It is not 
>>> allowed to
>>> set the timings while vb2 is busy.
>>
>> Buffer ioctls (Input 0):
>>         fail: v4l2-test-buffers.cpp(344): node->s_dv_timings(timings)
>>         fail: v4l2-test-buffers.cpp(452): testCanSetSameTimings(node)
>>     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>>
>> Streaming ioctls:
>>     test read/write: OK
>>     test blocking wait: OK
>>         fail: v4l2-test-buffers.cpp(344): node->s_dv_timings(timings)
>>         fail: v4l2-test-buffers.cpp(637): testCanSetSameTimings(node)
>>         fail: v4l2-test-buffers.cpp(952): captureBufs(node, q, m2m_q, 
>> frame_count, false)
>>     test MMAP: FAIL
>>
>> Built from v4l-utils c36dbbdfa8b30b2badd4f893b59d0bd4f0bd12aa
>>
>> Adding this causes some of the v4l2-compliance streaming tests to 
>> fail, and prevents my own application from being able to call 
>> S_DV_TIMINGS after detecting a resolution change, despite calling 
>> streamoff and unmapping all the buffers first.
> 
> Any thoughts on this Hans?

The compliance fail is because there is a requirement that if you set
new timings that are equal to the existing timings, then that should
work (and is effectively a NOP operation).

So in the code you can do something similar to what vivid does:

        if (v4l2_match_dv_timings(timings, &dev->dv_timings_cap, 0, false))
                return 0;
        if (vb2_is_busy(&dev->vb_vid_cap_q))
                return -EBUSY;

You can probably get away with just checking width, height and interlaced
in this driver, rather than calling v4l2_match_dv_timings.

If the resolution changes, however, then you need to completely free all
buffers (i.e. close the fd or call VIDIOC_REQBUFS with count = 0) before
you can set new timings. So streamoff + unmap is not enough.

Streamoff only returns the buffers to userspace, it doesn't free them.

Regards,

	Hans
