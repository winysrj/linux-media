Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33212 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbbJSLIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2015 07:08:44 -0400
Received: by lffv3 with SMTP id v3so109782532lff.0
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2015 04:08:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FABD50.8050900@xs4all.nl>
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
 <1440163169-18047-7-git-send-email-ricardo.ribalda@gmail.com>
 <55E978DA.1040604@xs4all.nl> <55FABD50.8050900@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 Oct 2015 13:08:23 +0200
Message-ID: <CAPybu_2FfMxMQmgHP0d1PYEifCxQ88LDxpLpDBOzAgSmKRAbiA@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent

Could you take a look to this patch.


Thanks!

On Thu, Sep 17, 2015 at 3:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 09/04/15 12:56, Hans Verkuil wrote:
>> Laurent, can you review this?
>
> Ping! If I have an Ack on Monday at the latest, then I can make a pull request
> for this series before I leave for 2 1/2 weeks.
>
> Regards,
>
>         Hans
>
>>
>> Regards,
>>
>>       Hans
>>
>> On 08/21/2015 03:19 PM, Ricardo Ribalda Delgado wrote:
>>> This driver does not use the control infrastructure.
>>> Add support for the new field which on structure
>>>  v4l2_ext_controls
>>>
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> ---
>>>  drivers/media/usb/uvc/uvc_v4l2.c | 14 +++++++++++++-
>>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
>>> index 2764f43607c1..e6d3a1bcfa2f 100644
>>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
>>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>>> @@ -980,6 +980,7 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
>>>      struct uvc_fh *handle = fh;
>>>      struct uvc_video_chain *chain = handle->chain;
>>>      struct v4l2_ext_control *ctrl = ctrls->controls;
>>> +    struct v4l2_queryctrl qc;
>>>      unsigned int i;
>>>      int ret;
>>>
>>> @@ -988,7 +989,14 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
>>>              return ret;
>>>
>>>      for (i = 0; i < ctrls->count; ++ctrl, ++i) {
>>> -            ret = uvc_ctrl_get(chain, ctrl);
>>> +            if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
>>> +                    qc.id = ctrl->id;
>>> +                    ret = uvc_query_v4l2_ctrl(chain, &qc);
>>> +                    if (!ret)
>>> +                            ctrl->value = qc.default_value;
>>> +            } else
>>> +                    ret = uvc_ctrl_get(chain, ctrl);
>>> +
>>>              if (ret < 0) {
>>>                      uvc_ctrl_rollback(handle);
>>>                      ctrls->error_idx = i;
>>> @@ -1010,6 +1018,10 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
>>>      unsigned int i;
>>>      int ret;
>>>
>>> +    /* Default value cannot be changed */
>>> +    if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL)
>>> +            return -EINVAL;
>>> +
>>>      ret = uvc_ctrl_begin(chain);
>>>      if (ret < 0)
>>>              return ret;
>>>
>>



-- 
Ricardo Ribalda
