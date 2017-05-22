Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:39924 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdEVIE5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 04:04:57 -0400
Subject: Re: [PATCH v1] [media] atmel-isi: code cleanup
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1495188292-3113-1-git-send-email-hugues.fruchet@st.com>
 <1495188292-3113-2-git-send-email-hugues.fruchet@st.com>
 <e1973f0e-4ba2-24ca-f013-c3ef20a7bf47@st.com>
 <96e522a2-e12f-9fe4-9469-c5fe7c9a58f8@microchip.com>
 <7a4ef8b6-7c01-88f8-57ee-c3550e4716fa@st.com>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <04c8fd14-7755-2b8d-2ad0-9fdb700584fb@microchip.com>
Date: Mon, 22 May 2017 16:02:43 +0800
MIME-Version: 1.0
In-Reply-To: <7a4ef8b6-7c01-88f8-57ee-c3550e4716fa@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 5/22/2017 15:52, Hugues FRUCHET wrote:
> Hi Songjun,
> 
> It was an advice from Hans, I copy/paste the comment here:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg112338.html
>   >> +     /* Enable stream on the sub device */
>   >> +     ret = v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 1);
>   >> +     if (ret && ret != -ENOIOCTLCMD) {
>   >> +             dev_err(dcmi->dev, "%s: Failed to start streaming, subdev
>   >> streamon error",
>   >> +                     __func__);
>   >> +             goto err_release_buffers;
>   >> +     }
>   >> +
>   >> +     if (clk_enable(dcmi->mclk)) {
>   >> +             dev_err(dcmi->dev, "%s: Failed to start streaming, cannot
>   >> enable clock",
>   >> +                     __func__);
>   >> +             goto err_subdev_streamoff;
>   >> +     }
>   >It feels more natural to me to first enable the clock, then call
>   >s_stream.
> 
> Please note that I have not tested code, but only reported changes done
> in ST DCMI driver to reflect the same on ISI driver, would it be
> possible that you check that it is still functional on your side ?
> 
Hi Hugues,

Thank you for your explanation.
It does not affect the function, but since it is more natural to first 
enable the clock, then call s_stream, I think this patch has no problem.

> Best regards,
> Hugues.
> 
> On 05/22/2017 07:02 AM, Wu, Songjun wrote:
>> Hi Hugues,
>>
>> Thank you for your patch.
>> Is it necessary to ensure ISI is clocked before starting sensor sub device?
>>
>> On 5/19/2017 20:08, Hugues FRUCHET wrote:
>>> Adding Songjun and Ludovic as Atmel maintainers, sorry for inconvenience.
>>>
>>> On 05/19/2017 12:04 PM, Hugues Fruchet wrote:
>>>> Ensure that ISI is clocked before starting sensor sub device.
>>>> Remove un-needed type check in try_fmt().
>>>> Use clamp() macro for hardware capabilities.
>>>> Fix wrong tabulation to space.
>>>>
>>>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
>>>> ---
>>>>     drivers/media/platform/atmel/atmel-isi.c | 24
>>>> ++++++++++--------------
>>>>     1 file changed, 10 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/drivers/media/platform/atmel/atmel-isi.c
>>>> b/drivers/media/platform/atmel/atmel-isi.c
>>>> index e4867f8..7bf9f7d 100644
>>>> --- a/drivers/media/platform/atmel/atmel-isi.c
>>>> +++ b/drivers/media/platform/atmel/atmel-isi.c
>>>> @@ -36,8 +36,8 @@
>>>>     #include "atmel-isi.h"
>>>> -#define MAX_SUPPORT_WIDTH        2048
>>>> -#define MAX_SUPPORT_HEIGHT        2048
>>>> +#define MAX_SUPPORT_WIDTH        2048U
>>>> +#define MAX_SUPPORT_HEIGHT        2048U
>>>>     #define MIN_FRAME_RATE            15
>>>>     #define FRAME_INTERVAL_MILLI_SEC    (1000 / MIN_FRAME_RATE)
>>>> @@ -424,6 +424,8 @@ static int start_streaming(struct vb2_queue *vq,
>>>> unsigned int count)
>>>>         struct frame_buffer *buf, *node;
>>>>         int ret;
>>>> +    pm_runtime_get_sync(isi->dev);
>>>> +
>>>>         /* Enable stream on the sub device */
>>>>         ret = v4l2_subdev_call(isi->entity.subdev, video, s_stream, 1);
>>>>         if (ret && ret != -ENOIOCTLCMD) {
>>>> @@ -431,8 +433,6 @@ static int start_streaming(struct vb2_queue *vq,
>>>> unsigned int count)
>>>>             goto err_start_stream;
>>>>         }
>>>> -    pm_runtime_get_sync(isi->dev);
>>>> -
>>>>         /* Reset ISI */
>>>>         ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
>>>>         if (ret < 0) {
>>>> @@ -455,10 +455,11 @@ static int start_streaming(struct vb2_queue
>>>> *vq, unsigned int count)
>>>>         return 0;
>>>>     err_reset:
>>>> -    pm_runtime_put(isi->dev);
>>>>         v4l2_subdev_call(isi->entity.subdev, video, s_stream, 0);
>>>>     err_start_stream:
>>>> +    pm_runtime_put(isi->dev);
>>>> +
>>>>         spin_lock_irq(&isi->irqlock);
>>>>         isi->active = NULL;
>>>>         /* Release all active buffers */
>>>> @@ -566,20 +567,15 @@ static int isi_try_fmt(struct atmel_isi *isi,
>>>> struct v4l2_format *f,
>>>>         };
>>>>         int ret;
>>>> -    if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>>> -        return -EINVAL;
>>>> -
>>>>         isi_fmt = find_format_by_fourcc(isi, pixfmt->pixelformat);
>>>>         if (!isi_fmt) {
>>>>             isi_fmt = isi->user_formats[isi->num_user_formats - 1];
>>>>             pixfmt->pixelformat = isi_fmt->fourcc;
>>>>         }
>>>> -    /* Limit to Atmel ISC hardware capabilities */
>>>> -    if (pixfmt->width > MAX_SUPPORT_WIDTH)
>>>> -        pixfmt->width = MAX_SUPPORT_WIDTH;
>>>> -    if (pixfmt->height > MAX_SUPPORT_HEIGHT)
>>>> -        pixfmt->height = MAX_SUPPORT_HEIGHT;
>>>> +    /* Limit to Atmel ISI hardware capabilities */
>>>> +    pixfmt->width = clamp(pixfmt->width, 0U, MAX_SUPPORT_WIDTH);
>>>> +    pixfmt->height = clamp(pixfmt->height, 0U, MAX_SUPPORT_HEIGHT);
>>>>         v4l2_fill_mbus_format(&format.format, pixfmt,
>>>> isi_fmt->mbus_code);
>>>>         ret = v4l2_subdev_call(isi->entity.subdev, pad, set_fmt,
>>>> @@ -1058,7 +1054,7 @@ static int isi_graph_notify_complete(struct
>>>> v4l2_async_notifier *notifier)
>>>>         struct atmel_isi *isi = notifier_to_isi(notifier);
>>>>         int ret;
>>>> -    isi->vdev->ctrl_handler    = isi->entity.subdev->ctrl_handler;
>>>> +    isi->vdev->ctrl_handler = isi->entity.subdev->ctrl_handler;
>>>>         ret = isi_formats_init(isi);
>>>>         if (ret) {
>>>>             dev_err(isi->dev, "No supported mediabus format found\n");
