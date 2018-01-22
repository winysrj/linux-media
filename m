Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:60820 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750955AbeAVJHs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 04:07:48 -0500
Subject: Re: [PATCH v6 3/9] v4l: platform: Add Renesas CEU driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <2529707.jzkV7c2yGz@avalon> <4195ec6a-b99d-2fad-3898-9ce9c02fce00@xs4all.nl>
 <1556766.StfJmN1Kpx@avalon>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8363e777-2af8-408a-1a42-65309e48af6b@xs4all.nl>
Date: Mon, 22 Jan 2018 10:07:45 +0100
MIME-Version: 1.0
In-Reply-To: <1556766.StfJmN1Kpx@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/01/18 01:52, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday, 19 January 2018 14:25:39 EET Hans Verkuil wrote:
>> On 01/19/18 13:20, Laurent Pinchart wrote:
>>> On Friday, 19 January 2018 13:20:19 EET Hans Verkuil wrote:
>>>> On 01/16/18 22:44, Jacopo Mondi wrote:
>>>>> Add driver for Renesas Capture Engine Unit (CEU).
>>>>>
>>>>> The CEU interface supports capturing 'data' (YUV422) and 'images'
>>>>> (NV[12|21|16|61]).
>>>>>
>>>>> This driver aims to replace the soc_camera-based sh_mobile_ceu one.
>>>>>
>>>>> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
>>>>> platform GR-Peach.
>>>>>
>>>>> Tested with ov7725 camera sensor on SH4 platform Migo-R.
>>>>>
>>>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>> ---
>>>>>
>>>>>  drivers/media/platform/Kconfig       |    9 +
>>>>>  drivers/media/platform/Makefile      |    1 +
>>>>>  drivers/media/platform/renesas-ceu.c | 1659 +++++++++++++++++++++++++++
>>>>>  3 files changed, 1669 insertions(+)
>>>>>  create mode 100644 drivers/media/platform/renesas-ceu.c
>>>
>>> [snip]
>>>
>>>>> diff --git a/drivers/media/platform/renesas-ceu.c
>>>>> b/drivers/media/platform/renesas-ceu.c new file mode 100644
>>>>> index 0000000..1b8f0ef
>>>>> --- /dev/null
>>>>> +++ b/drivers/media/platform/renesas-ceu.c
>>>
>>> [snip]
>>>
>>>>> +static void ceu_update_plane_sizes(struct v4l2_plane_pix_format *plane,
>>>>> +				   unsigned int bpl, unsigned int szimage)
>>>>> +{
>>>>> +	if (plane->bytesperline < bpl)
>>>>> +		plane->bytesperline = bpl;
>>>>> +	if (plane->sizeimage < szimage)
>>>>> +		plane->sizeimage = szimage;
>>>>
>>>> As mentioned in your cover letter, you do need to check for invalid
>>>> bytesperline values. The v4l2-compliance test is to see what happens
>>>> when userspace gives insane values, so yes, drivers need to be able
>>>> to handle that.
>>>
>>> What limit would you set, what is an acceptable large value versus an
>>> invalid large value ? I think we should have rules for this at the API
>>> level (or at least, if not part of the API, rules that are consistent
>>> across drivers).
>>
>> I would expect this to be the max of what the hardware can support. If
>> that's really high, then this can be, say, 4 times the width.
>>
>> Note that there are very few drivers that can handle a user-specified
>> stride.
> 
> But that's no reason not to handle it here if the hardware permits, right ? 
> :-)

Certainly. But it is the reason why it's hard to find example code in
existing drivers.

>>>> plane->sizeimage is set by the driver, so drop the 'if' before the
>>>> assignment.
>>>
>>> I don't think that's correct. Userspace should be able to control padding
>>> lines at the end of the image, the same way it controls padding pixels at
>>> the end of lines.
>>
>> If userspace wants larger buffers, then it should use VIDIOC_CREATE_BUFS.
>>
>> sizeimage is exclusively set by the driver, applications rely on that.
> 
> The API documentation is pretty confusing about this.
> 
> In pixfmt-v4l2.rst, the field in the v4l2_pix_format structure is documented 
> as
> 
>       - Size in bytes of the buffer to hold a complete image, set by the
>         driver. Usually this is ``bytesperline`` times ``height``. When
>         the image consists of variable length compressed data this is the
>         maximum number of bytes required to hold an image.
> 
> Then in pixfmt-v4l2-mplane.rst, the field in the v4l2_plane_pix_format 
> structure is documented as
> 
>       - Maximum size in bytes required for image data in this plane.

This should contain the same text as in pixfmt-v4l2.rst.

> 
> Finally, in vidioc-create-bufs.rst, we have
> 
> The buffers created by this ioctl will have as minimum size the size
> defined by the ``format.pix.sizeimage`` field (or the corresponding
> fields for other format types). Usually if the ``format.pix.sizeimage``
> field is less than the minimum required for the given format, then an
> error will be returned since drivers will typically not allow this. If
> it is larger, then the value will be used as-is. In other words, the
> driver may reject the requested size, but if it is accepted the driver
> will use it unchanged.
> 
> The VIDIOC_CREATE_BUFS documentation contradicts the v4l2_pix_format 
> documentation, as the multiplane case doesn't state anything about who sets 
> the sizeimage field. We should clarify the documentation.

The pixfmt-v4l2-mplane.rst is the one that's incomplete. I noticed the same
thing when I looked at it.

> 
>>>>> +}
>>>
>>> [snip]
>>>
>>>>> +static const struct v4l2_ioctl_ops ceu_ioctl_ops = {
>>>>> +	.vidioc_querycap		= ceu_querycap,
>>>>> +
>>>>> +	.vidioc_enum_fmt_vid_cap_mplane	= ceu_enum_fmt_vid_cap,
>>>>> +	.vidioc_try_fmt_vid_cap_mplane	= ceu_try_fmt_vid_cap,
>>>>> +	.vidioc_s_fmt_vid_cap_mplane	= ceu_s_fmt_vid_cap,
>>>>> +	.vidioc_g_fmt_vid_cap_mplane	= ceu_g_fmt_vid_cap,
>>>>> +
>>>>> +	.vidioc_enum_input		= ceu_enum_input,
>>>>> +	.vidioc_g_input			= ceu_g_input,
>>>>> +	.vidioc_s_input			= ceu_s_input,
>>>>> +
>>>>> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
>>>>> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
>>>>> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
>>>>> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
>>>>> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
>>>>> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
>>>>> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
>>>>> +	.vidioc_streamon		= vb2_ioctl_streamon,
>>>>> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
>>>>> +
>>>>> +	.vidioc_g_parm			= ceu_g_parm,
>>>>> +	.vidioc_s_parm			= ceu_s_parm,
>>>>> +	.vidioc_enum_framesizes		= ceu_enum_framesizes,
>>>>> +	.vidioc_enum_frameintervals	= ceu_enum_frameintervals,
>>>>
>>>> You're missing these ioctls:
>>>>         .vidioc_log_status              = v4l2_ctrl_log_status,
>>>
>>> Is log status mandatory ?
>>
>> No, but it doesn't hurt to add this one. It comes for free.
> 
> Possibly a bit out of scope, but now that the standard debugging interface 
> seems to be debugfs, wouldn't it make sense to implement log status through 
> there instead of as an ioctl ?

Why? The ioctl has been there for many many years and it works very well (Cisco
uses this on a daily basis). I see no reason to do a lot of work for no good
purpose. It's probably less useful for sensors but for video receivers (HDMI or
analog) I couldn't do without. With HDMI/analog video receivers you never
know what sort of video you receive, so being able to log the current status
is great. We use it in regression tests and error reporting all the time.

Sure, today we'd design this using debugfs, but I don't think it existed when
LOG_STATUS was created. In any case, I see no reason to change this. In fact,
that would break our tests.

Regards,

	Hans

> 
>>>>         .vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
>>>>         .vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
>>>>
>>>> These missing _event ops are the reason for this compliance failure:
>>>>
>>>> fail: v4l2-test-controls.cpp(782): subscribe event for control 'User
>>>> Controls' failed
>>>>
>>>>> +};
>>>
>>> [snip]
> 
