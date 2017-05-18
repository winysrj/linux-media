Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46489 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbdERKqb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 06:46:31 -0400
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video
 device nodes
To: Todor Tomov <todor.tomov@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org>
 <1480085841-28276-7-git-send-email-todor.tomov@linaro.org>
 <3060297.EOJqEVJIo3@avalon> <58809839.8050301@linaro.org>
Cc: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Todor Tomov <ttomov@mm-sol.com>
Message-ID: <591D79E3.9060501@mm-sol.com>
Date: Thu, 18 May 2017 13:39:31 +0300
MIME-Version: 1.0
In-Reply-To: <58809839.8050301@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/19/2017 12:43 PM, Todor Tomov wrote:
> Hi Laurent,
> 
> Thank you for the detailed review.
> 
> On 12/05/2016 05:22 PM, Laurent Pinchart wrote:
>> Hi Todor,
>>
>> Thank you for the patch.
>>
>> On Friday 25 Nov 2016 16:57:20 Todor Tomov wrote:
>>> These files handle the video device nodes of the camss driver.
>>
>> camss is a quite generic, I'm a bit concerned about claiming that acronym in 
>> the global kernel namespace. Would it be too long if we prefixed symbols with 
>> msm_camss instead ?
> 
> Ok. Are you concerned about camss_enable_clocks() and camss_disable_clocks() or
> you have something else in mind too?

Could you please add more details about this?

> 
>>
>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/camss-8x16/video.c | 597 ++++++++++++++++++++++
>>>  drivers/media/platform/qcom/camss-8x16/video.h |  67 +++
>>>  2 files changed, 664 insertions(+)
>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
>>>
>>> diff --git a/drivers/media/platform/qcom/camss-8x16/video.c
>>> b/drivers/media/platform/qcom/camss-8x16/video.c new file mode 100644
>>> index 0000000..0bf8ea9
>>> --- /dev/null
>>> +++ b/drivers/media/platform/qcom/camss-8x16/video.c

<snip>

>>> +/* ------------------------------------------------------------------------
>>> + * V4L2 file operations
>>> + */
>>> +
>>> +/*
>>> + * video_init_format - Helper function to initialize format
>>> + *
>>> + * Initialize all pad formats with default values.
>>> + */
>>> +static int video_init_format(struct file *file, void *fh)
>>> +{
>>> +	struct v4l2_format format;
>>> +
>>> +	memset(&format, 0, sizeof(format));
>>> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +
>>> +	return video_s_fmt(file, fh, &format);
>>
>> This will set the active format every time you open the device node, I don't 
>> think that's what you want.
> 
> Well, actually this is what I wanted. I wanted to keep in sync the pixel format
> on the video node and the media bus format on the subdev node (i.e. the pixel
> format will be always correct for the current media bus format). For the current
> version there is a direct correspondence between the pixel format and the media
> format so this will work I think. For the future there might be multiple pixel
> formats for one media bus format and a second open of the video node could reset
> the pixel format to unwanted value so this will need a change. I'm wondering about
> (and still not able to find) a good moment/event when to perform the initialization
> of the format on the video node. As it gets the current format from the subdev
> node, the moment of the registration will be too early as the media link is still
> not created. But after that I couldn't find a suitable callback/event where to do
> it. If you can share any idea about this, please do :)

I still haven't found a better solution for this. If you have something in mind,
please share.

> 
>>
>>> +}
>>> +
>>> +static int video_open(struct file *file)
>>> +{
>>> +	struct video_device *vdev = video_devdata(file);
>>> +	struct camss_video *video = video_drvdata(file);
>>> +	struct camss_video_fh *handle;
>>> +	int ret;
>>> +
>>> +	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
>>> +	if (handle == NULL)
>>> +		return -ENOMEM;
>>> +
>>> +	v4l2_fh_init(&handle->vfh, video->vdev);
>>> +	v4l2_fh_add(&handle->vfh);
>>> +
>>> +	handle->video = video;
>>> +	file->private_data = &handle->vfh;
>>> +
>>> +	ret = v4l2_pipeline_pm_use(&vdev->entity, 1);
>>> +	if (ret < 0) {
>>> +		dev_err(video->camss->dev, "Failed to power up pipeline\n");
>>> +		goto error_pm_use;
>>> +	}
>>> +
>>> +	ret = video_init_format(file, &handle->vfh);
>>> +	if (ret < 0) {
>>> +		dev_err(video->camss->dev, "Failed to init format\n");
>>> +		goto error_init_format;
>>> +	}
>>> +
>>> +	return 0;
>>> +
>>> +error_init_format:
>>> +	v4l2_pipeline_pm_use(&vdev->entity, 0);
>>> +
>>> +error_pm_use:
>>> +	v4l2_fh_del(&handle->vfh);
>>> +	kfree(handle);
>>> +
>>> +	return ret;
>>> +}

-- 
Best regards,
Todor Tomov
