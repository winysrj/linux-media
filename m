Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:35042 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751369AbeBUHhy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 02:37:54 -0500
Subject: Re: [RFCv4 16/21] v4l2: video_device: support for creating requests
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-17-acourbot@chromium.org>
 <ea10280d-bfb4-b1af-79cc-64f40e1007f1@xs4all.nl>
 <CAPBb6MU+uFyNdEbXavEWO5_AQrYT8d3qBXqZ0LuvLpU_qy-xNA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1da32e17-5bc0-2bf1-c2b5-9dd55fc3c2da@xs4all.nl>
Date: Wed, 21 Feb 2018 08:37:48 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MU+uFyNdEbXavEWO5_AQrYT8d3qBXqZ0LuvLpU_qy-xNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2018 07:01 AM, Alexandre Courbot wrote:
> On Wed, Feb 21, 2018 at 1:35 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/20/2018 05:44 AM, Alexandre Courbot wrote:
>>> Add a new VIDIOC_NEW_REQUEST ioctl, which allows to instanciate requests
>>> on devices that support the request API. Requests created that way can
>>> only control the device they originate from, making them suitable for
>>> simple devices, but not complex pipelines.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>>> ---
>>>  Documentation/ioctl/ioctl-number.txt |  1 +
>>>  drivers/media/v4l2-core/v4l2-dev.c   |  2 ++
>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 25 +++++++++++++++++++++++++
>>>  include/media/v4l2-dev.h             |  2 ++
>>>  include/uapi/linux/videodev2.h       |  3 +++
>>>  5 files changed, 33 insertions(+)
>>>
>>> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
>>> index 6501389d55b9..afdc9ed255b0 100644
>>> --- a/Documentation/ioctl/ioctl-number.txt
>>> +++ b/Documentation/ioctl/ioctl-number.txt
>>> @@ -286,6 +286,7 @@ Code  Seq#(hex)   Include File            Comments
>>>                                       <mailto:oe@port.de>
>>>  'z'  10-4F   drivers/s390/crypto/zcrypt_api.h        conflict!
>>>  '|'  00-7F   linux/media.h
>>> +'|'  80-9F   linux/media-request.h
>>>  0x80 00-1F   linux/fb.h
>>>  0x89 00-06   arch/x86/include/asm/sockios.h
>>>  0x89 0B-DF   linux/sockios.h
>>
>> This ^^^^ doesn't belong in this patch.
> 
> Do you mean we need a separate patch for this?

Yes.

I now also see why you started at 0x80. Let's keep that for now.

> 
>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>>> index 0301fe426a43..062ebee5bffc 100644
>>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>>> @@ -559,6 +559,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
>>>               set_bit(_IOC_NR(VIDIOC_TRY_EXT_CTRLS), valid_ioctls);
>>>       if (vdev->ctrl_handler || ops->vidioc_querymenu)
>>>               set_bit(_IOC_NR(VIDIOC_QUERYMENU), valid_ioctls);
>>> +     if (vdev->req_mgr)
>>> +             set_bit(_IOC_NR(VIDIOC_NEW_REQUEST), valid_ioctls);
>>>       SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
>>>       SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
>>>       SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index ab4968ea443f..a45fe078f8ae 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -21,6 +21,7 @@
>>>
>>>  #include <linux/videodev2.h>
>>>
>>> +#include <media/media-request.h>
>>>  #include <media/v4l2-common.h>
>>>  #include <media/v4l2-ioctl.h>
>>>  #include <media/v4l2-ctrls.h>
>>> @@ -842,6 +843,13 @@ static void v4l_print_freq_band(const void *arg, bool write_only)
>>>                       p->rangehigh, p->modulation);
>>>  }
>>>
>>> +static void vidioc_print_new_request(const void *arg, bool write_only)
>>> +{
>>> +     const struct media_request_new *new = arg;
>>> +
>>> +     pr_cont("fd=0x%x\n", new->fd);
>>
>> I'd use %d since fds are typically shown as signed integers.
> 
> Right.
> 
>>
>>> +}
>>> +
>>>  static void v4l_print_edid(const void *arg, bool write_only)
>>>  {
>>>       const struct v4l2_edid *p = arg;
>>> @@ -2486,6 +2494,22 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
>>>       return -ENOTTY;
>>>  }
>>>
>>> +static int vidioc_new_request(const struct v4l2_ioctl_ops *ops,
>>> +                           struct file *file, void *fh, void *arg)
>>> +{
>>> +#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
>>> +     struct media_request_new *new = arg;
>>> +     struct video_device *vfd = video_devdata(file);
>>> +
>>> +     if (!vfd->req_mgr)
>>> +             return -ENOTTY;
>>> +
>>> +     return media_request_ioctl_new(vfd->req_mgr, new);
>>> +#else
>>> +     return -ENOTTY;
>>> +#endif
>>> +}
>>
>> You don't need the #ifdef's here. media_request_ioctl_new() will be stubbed if
>> CONFIG_MEDIA_REQUEST_API isn't set.
> 
> Correct.
> 
>>
>>> +
>>>  struct v4l2_ioctl_info {
>>>       unsigned int ioctl;
>>>       u32 flags;
>>> @@ -2617,6 +2641,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>>>       IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
>>>       IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
>>>       IOCTL_INFO_FNC(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
>>> +     IOCTL_INFO_FNC(VIDIOC_NEW_REQUEST, vidioc_new_request, vidioc_print_new_request, 0),
>>>  };
>>>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>>>
>>> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
>>> index 53f32022fabe..e6c4e10889bc 100644
>>> --- a/include/media/v4l2-dev.h
>>> +++ b/include/media/v4l2-dev.h
>>> @@ -209,6 +209,7 @@ struct v4l2_file_operations {
>>>   * @entity: &struct media_entity
>>>   * @intf_devnode: pointer to &struct media_intf_devnode
>>>   * @pipe: &struct media_pipeline
>>> + * @req_mgr: request manager to use if this device supports creating requests
>>>   * @fops: pointer to &struct v4l2_file_operations for the video device
>>>   * @device_caps: device capabilities as used in v4l2_capabilities
>>>   * @dev: &struct device for the video device
>>> @@ -251,6 +252,7 @@ struct video_device
>>>       struct media_intf_devnode *intf_devnode;
>>>       struct media_pipeline pipe;
>>>  #endif
>>> +     struct media_request_mgr *req_mgr;
>>>       const struct v4l2_file_operations *fops;
>>>
>>>       u32 device_caps;
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 91cfe0cbd5c5..35706204e81d 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -63,6 +63,7 @@
>>>  #include <linux/compiler.h>
>>>  #include <linux/ioctl.h>
>>>  #include <linux/types.h>
>>> +#include <linux/media-request.h>
>>>  #include <linux/v4l2-common.h>
>>>  #include <linux/v4l2-controls.h>
>>>
>>> @@ -2407,6 +2408,8 @@ struct v4l2_create_buffers {
>>>
>>>  #define VIDIOC_QUERY_EXT_CTRL        _IOWR('V', 103, struct v4l2_query_ext_ctrl)
>>>
>>> +#define VIDIOC_NEW_REQUEST   _IOWR('V', 104, struct media_request_new)
>>
>> Hmm, I probably call this VIDIOC_CREATE_REQUEST (analogous to CREATE_BUFS).
>> Ditto struct media_create_request and MEDIA_IOC_CREATE_REQUEST.
> 
> Agree, it is better to keep consistency somehow.
> 
>>
>> I'm still not convinced this is the right approach (as opposed to using the media
>> device node). I plan to dig deeper into the data structures tomorrow morning.
> 
> I see no reason why this would not work. This seems more elegant than
> relying on the media node for this, and also does not require pulling
> the whole media controller support just to use requests on a simple
> codec or m2m device.
> 
> But of course, I may not be seeing everything. :)
> 
> Thanks for the review!
> Alex.
> 

Regards,

	Hans
