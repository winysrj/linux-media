Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4146 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3I3MLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 08:11:24 -0400
Message-ID: <52496A5B.40700@xs4all.nl>
Date: Mon, 30 Sep 2013 14:11:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2: Support for multiple selections
References: <1379336058-31178-1-git-send-email-ricardo.ribalda@gmail.com> <524950B1.5010307@xs4all.nl> <CAPybu_2kGgPjawBhDS4bHkb86QAsVExwDqXYVAWxged6TwGOQg@mail.gmail.com>
In-Reply-To: <CAPybu_2kGgPjawBhDS4bHkb86QAsVExwDqXYVAWxged6TwGOQg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/30/2013 01:17 PM, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> As allways thank you very much for your comments.
> 
> On Mon, Sep 30, 2013 at 12:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ricardo,
>>
>> Sorry for the delayed review, but I'm finally catching up with my backlog.
>>
>> I've got a number of comments regarding this patch. I'm ignoring the platform
>> driver patches for now until the core support is correct.
>>
>> On 09/16/2013 02:54 PM, Ricardo Ribalda Delgado wrote:
>>> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>>
>>> Extend v4l2 selection API to support multiple selection areas, this way
>>> sensors that support multiple readout areas can work with multiple areas
>>> of insterest.
>>>
>>> The struct v4l2_selection and v4l2_subdev_selection has been extented
>>> with a new field rectangles. If it is value is different than zero the
>>> pr array is used instead of the r field.
>>>
>>> A new structure v4l2_ext_rect has been defined, containing 4 reserved
>>> fields for future improvements, as suggested by Hans.
>>>
>>> A new function in v4l2-comon (v4l2_selection_flat_struct) is in charge
>>> of converting a pr pointer with one item to a flatten struct. This
>>> function is used in all the old drivers that dont support multiple
>>> selections.
>>>
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> ---
>>>  drivers/media/platform/exynos-gsc/gsc-m2m.c      |  6 +++
>>>  drivers/media/platform/exynos4-is/fimc-capture.c |  6 +++
>>>  drivers/media/platform/exynos4-is/fimc-lite.c    |  6 +++
>>>  drivers/media/platform/s3c-camif/camif-capture.c |  6 +++
>>>  drivers/media/platform/s5p-jpeg/jpeg-core.c      |  3 ++
>>>  drivers/media/platform/s5p-tv/mixer_video.c      |  6 +++
>>>  drivers/media/platform/soc_camera/soc_camera.c   |  6 +++
>>>  drivers/media/v4l2-core/v4l2-common.c            | 13 ++++++
>>>  drivers/media/v4l2-core/v4l2-ioctl.c             | 54 +++++++++++++++++++++---
>>>  include/media/v4l2-common.h                      |  2 +
>>>  include/uapi/linux/v4l2-subdev.h                 | 10 ++++-
>>>  include/uapi/linux/videodev2.h                   | 15 ++++++-
>>>  12 files changed, 122 insertions(+), 11 deletions(-)
>>>
>>
>> <snip>
>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
>>> index a95e5e2..cd20567 100644
>>> --- a/drivers/media/v4l2-core/v4l2-common.c
>>> +++ b/drivers/media/v4l2-core/v4l2-common.c
>>> @@ -886,3 +886,16 @@ void v4l2_get_timestamp(struct timeval *tv)
>>>       tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>>>  }
>>>  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
>>> +
>>> +int v4l2_selection_flat_struct(struct v4l2_selection *s)
>>> +{
>>> +     if (s->rectangles == 0)
>>> +             return 0;
>>> +
>>> +     if (s->rectangles != 1)
>>> +             return -EINVAL;
>>> +
>>> +     s->r = s->pr[0].r;
>>
>> This would overwrite the pr pointer. Not a good idea.
> 
> That was exactly the point. The helper function convert the
> multi_selection, ext_rect to the legacy struct. This way the drivers
> needed almost no modification, just a call to the helper at the
> beginning of the handler.

That doesn't work: G and S_SELECTION are IOWR, so the driver can modify the
rectangles and those will have to be passed back to userspace. So you cannot
just change the contents of struct v4l2_selection.

> 
> Otherwise we need your get_rect helper, and then a set_rect helper at
> every exit.
> 
> If you think this is the way, then lets do it. Right now there are not
> too many drivers that supports selection, so it is right time to make
> such a decisions.
> 
>>
>> I would make a helper function like this:
>>
>> int v4l2_selection_get_rect(struct v4l2_selection *s, struct v4l2_ext_rect *r)
>> {
>>         if (s->rectangles > 1)
>>                 return -EINVAL;
>>         if (s->rectangles == 1) {
>>                 *r = s->pr[0];
>>                 return 0;
>>         }
>>         if (s->r.width < 0 || s->r.height < 0)
>>                 return -EINVAL;
>>         r->left = s->r.left;
>>         r->top = s->r.top;
>>         r->width = s->r.width;
>>         r->height = s->r.height;
>>         memset(r->reserved, 0, sizeof(r->reserved));
>>         return 0;
>> }
>>
>> See also my proposed v4l2_ext_rect definition below.
>>
>>> +     return 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(v4l2_selection_flat_struct);
>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index 68e6b5e..fe92f6b 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -572,11 +572,22 @@ static void v4l_print_crop(const void *arg, bool write_only)
>>>  static void v4l_print_selection(const void *arg, bool write_only)
>>>  {
>>>       const struct v4l2_selection *p = arg;
>>> +     int i;
>>>
>>> -     pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
>>> -             prt_names(p->type, v4l2_type_names),
>>> -             p->target, p->flags,
>>> -             p->r.width, p->r.height, p->r.left, p->r.top);
>>> +     if (p->rectangles == 0)
>>> +             pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
>>> +                     prt_names(p->type, v4l2_type_names),
>>> +                     p->target, p->flags,
>>> +                     p->r.width, p->r.height, p->r.left, p->r.top);
>>> +     else{
>>> +             pr_cont("type=%s, target=%d, flags=0x%x rectangles=%d\n",
>>> +                     prt_names(p->type, v4l2_type_names),
>>> +                     p->target, p->flags, p->rectangles);
>>> +             for (i = 0; i < p->rectangles; i++)
>>> +                     pr_cont("rectangle %d: wxh=%dx%d, x,y=%d,%d\n",
>>> +                             i, p->r.width, p->r.height,
>>> +                             p->r.left, p->r.top);
>>> +     }
>>>  }
>>>
>>>  static void v4l_print_jpegcompression(const void *arg, bool write_only)
>>> @@ -1645,6 +1656,7 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
>>>       struct v4l2_crop *p = arg;
>>>       struct v4l2_selection s = {
>>>               .type = p->type,
>>> +             .rectangles = 0,
>>
>> No need for this. In initializers like this fields that aren't initialized
>> explicitly will be zeroed by the compiler.
>>
>>>       };
>>>       int ret;
>>>
>>> @@ -1673,6 +1685,7 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
>>>       struct v4l2_selection s = {
>>>               .type = p->type,
>>>               .r = p->c,
>>> +             .rectangles = 0,
>>>       };
>>>
>>>       if (ops->vidioc_s_crop)
>>> @@ -1692,7 +1705,10 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>>>                               struct file *file, void *fh, void *arg)
>>>  {
>>>       struct v4l2_cropcap *p = arg;
>>> -     struct v4l2_selection s = { .type = p->type };
>>> +     struct v4l2_selection s = {
>>> +             .type = p->type,
>>> +             .rectangles = 0,
>>> +     };
>>>       int ret;
>>>
>>>       if (ops->vidioc_cropcap)
>>> @@ -1726,6 +1742,30 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>>>       return 0;
>>>  }
>>>
>>> +static int v4l_s_selection(const struct v4l2_ioctl_ops *ops,
>>> +                             struct file *file, void *fh, void *arg)
>>> +{
>>> +     struct v4l2_selection *s = arg;
>>> +
>>> +     if (s->rectangles &&
>>> +             !access_ok(VERIFY_READ, s->pr, s->rectangles * sizeof(*s->pr)))
>>> +             return -EFAULT;
>>
>> No, this isn't necessary. Instead add support for the selection array to
>> check_array_args() in v4l2-ioctl.c. That's where this should be handled.
>> video_usercopy() will then do the copy_from/to_user for you and drivers don't
>> need to care about it.
>>
>> Note that you also need to update v4l2-compat-ioctl32.c!
>>
>>> +
>>> +     return ops->vidioc_s_selection(file, fh, s);
>>> +}
>>> +
>>> +static int v4l_g_selection(const struct v4l2_ioctl_ops *ops,
>>> +                             struct file *file, void *fh, void *arg)
>>> +{
>>> +     struct v4l2_selection *s = arg;
>>> +
>>> +     if (s->rectangles &&
>>> +             !access_ok(VERIFY_WRITE, s->pr, s->rectangles * sizeof(*s->pr)))
>>> +             return -EFAULT;
>>> +
>>> +     return ops->vidioc_g_selection(file, fh, s);
>>> +}
>>> +
>>>  static int v4l_log_status(const struct v4l2_ioctl_ops *ops,
>>>                               struct file *file, void *fh, void *arg)
>>>  {
>>> @@ -2018,8 +2058,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>>>       IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
>>>       IOCTL_INFO_FNC(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
>>>       IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
>>> -     IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, 0),
>>> -     IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO),
>>> +     IOCTL_INFO_FNC(VIDIOC_G_SELECTION, v4l_g_selection, v4l_print_selection, 0),
>>> +     IOCTL_INFO_FNC(VIDIOC_S_SELECTION, v4l_s_selection, v4l_print_selection, INFO_FL_PRIO),
>>>       IOCTL_INFO_STD(VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp, v4l_print_jpegcompression, 0),
>>>       IOCTL_INFO_STD(VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp, v4l_print_jpegcompression, INFO_FL_PRIO),
>>>       IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
>>> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
>>> index 015ff82..b0a3d2b 100644
>>> --- a/include/media/v4l2-common.h
>>> +++ b/include/media/v4l2-common.h
>>> @@ -216,4 +216,6 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
>>>
>>>  void v4l2_get_timestamp(struct timeval *tv);
>>>
>>> +int v4l2_selection_flat_struct(struct v4l2_selection *s);
>>> +
>>>  #endif /* V4L2_COMMON_H_ */
>>> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
>>> index a33c4da..b5ee08b 100644
>>> --- a/include/uapi/linux/v4l2-subdev.h
>>> +++ b/include/uapi/linux/v4l2-subdev.h
>>> @@ -133,6 +133,8 @@ struct v4l2_subdev_frame_interval_enum {
>>>   *       defined in v4l2-common.h; V4L2_SEL_TGT_* .
>>>   * @flags: constraint flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
>>>   * @r: coordinates of the selection window
>>> + * @pr:              array of rectangles containing the selection windows
>>> + * @rectangles:      Number of rectangles in pr structure. If zero, r is used instead
>>>   * @reserved: for future use, set to zero for now
>>>   *
>>>   * Hardware may use multiple helper windows to process a video stream.
>>> @@ -144,8 +146,12 @@ struct v4l2_subdev_selection {
>>>       __u32 pad;
>>>       __u32 target;
>>>       __u32 flags;
>>> -     struct v4l2_rect r;
>>> -     __u32 reserved[8];
>>> +     union{
>>
>> Add space after 'union'.
>>
>>> +             struct v4l2_rect r;
>>> +             struct v4l2_ext_rect        *pr;
>>> +     };
>>> +     __u32 rectangles;
>>> +     __u32 reserved[7];
>>>  };
>>
>> I suspect this should get the packed attribute. It's a good idea anyone to add that,
>> but we have to check that the sizeof(struct v4l2_subdev_selection) doesn't change
>> for both 32 and 64 bit compilations.
>>
>>>
>>>  struct v4l2_subdev_edid {
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 95ef455..db8b1a5 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -211,6 +211,11 @@ struct v4l2_rect {
>>>       __s32   height;
>>>  };
>>>
>>> +struct v4l2_ext_rect {
>>> +     struct v4l2_rect r;
>>> +     __u32   reserved[4];
>>> +};
>>
>> I actually would prefer this:
>>
>> struct v4l2_ext_rect {
>>         __s32 left;
>>         __s32 top;
>>         __u32 width;
>>         __u32 height;
>>         __u32 reserved[4];
>> };
>>
>> It has always annoyed me that width and height were signed, and this fixes that problem.
> 
> Just one comment. On the bmp standard a negative height means that the
> image is upside down. With multiple selections it could be a nice
> thing to allow such a behavious, so one selection can be inverted (if
> all are inverted, I guess vflip is more correct).

Negative width/height values are completely out of spec. No driver supports that, and
as you say, we have vflip/hflip for mirroring.

Regards,

	Hans

> 
>>
>> This is also why I was using v4l2_ext_rect in the selection helper function: that way
>> drivers do not need to check for negative width/height values.
>>
>>> +
>>>  struct v4l2_fract {
>>>       __u32   numerator;
>>>       __u32   denominator;
>>> @@ -804,6 +809,8 @@ struct v4l2_crop {
>>>   *           defined in v4l2-common.h; V4L2_SEL_TGT_* .
>>>   * @flags:   constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
>>>   * @r:               coordinates of selection window
>>> + * @pr:              array of rectangles containing the selection windows
>>> + * @rectangles:      Number of rectangles in pr structure. If zero, r is used instead
>>>   * @reserved:        for future use, rounds structure size to 64 bytes, set to zero
>>>   *
>>>   * Hardware may use multiple helper windows to process a video stream.
>>> @@ -814,8 +821,12 @@ struct v4l2_selection {
>>>       __u32                   type;
>>>       __u32                   target;
>>>       __u32                   flags;
>>> -     struct v4l2_rect        r;
>>> -     __u32                   reserved[9];
>>> +     union{
>>
>> Add space after 'union'.
>>
>>> +             struct v4l2_rect        r;
>>> +             struct v4l2_ext_rect        *pr;
>>> +     };
>>> +     __u32                   rectangles;
>>> +     __u32                   reserved[8];
>>>  };
>>>
>>>
>>>

