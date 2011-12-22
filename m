Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49570 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1LVLf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:35:58 -0500
Received: by werm1 with SMTP id m1so3270784wer.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 03:35:57 -0800 (PST)
Message-ID: <4EF31618.5090404@gmail.com>
Date: Thu, 22 Dec 2011 12:35:52 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 1/2] v4l: Add new framesamples field to struct v4l2_mbus_framefmt
References: <201112120131.24192.laurent.pinchart@ideasonboard.com> <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com> <1323865388-26994-2-git-send-email-s.nawrocki@samsung.com> <201112210120.56888.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112210120.56888.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/21/2011 01:20 AM, Laurent Pinchart wrote:
> On Wednesday 14 December 2011 13:23:07 Sylwester Nawrocki wrote:
>> The purpose of the new field is to allow the video pipeline elements
>> to negotiate memory buffer size for compressed data frames, where
>> the buffer size cannot be derived from pixel width and height and
>> the pixel code.
>>
>> For VIDIOC_SUBDEV_S_FMT and VIDIOC_SUBDEV_G_FMT ioctls, the
>> framesamples parameter should be calculated by the driver from pixel
>> width, height, color format and other parameters if required and
>> returned to the caller. This applies to compressed data formats only.
>>
>> The application should propagate the framesamples value, whatever
>> returned at the first sub-device within a data pipeline, i.e. at the
>> pipeline's data source.
>>
>> For compressed data formats the host drivers should internally
>> validate the framesamples parameter values before streaming is
>> enabled, to make sure the memory buffer size requirements are
>> satisfied along the pipeline.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
...
>> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
>> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> 
>> @@ -160,7 +160,13 @@
>>        guaranteed to be supported by the device. In particular, drivers
>> guarantee that a returned format will not be further changed if passed to
>> an &VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such
>> as
>> -      formats on other pads or links' configuration are not changed).
>> </para>
>> +      formats on other pads or links' configuration are not changed). When
>> +      a device contains a data encoder, the <structfield>
>> +      <link linkend="v4l2-mbus-framefmt-framesamples">framesamples</link>
>> +      </structfield> field value may be further changed, if parameters of
>> the
>> +      encoding process are changed after the format has been negotiated. In
>> +      such situation applications should use &VIDIOC-SUBDEV-G-FMT; ioctl to
>> +      query an updated format.</para>
> 
> Sorry for answering so late. I've been thinking about this topic (as well as 
> the proposed new pixelclock field) quite a lot, and one question strikes me

Sure, that's OK. I knew from the beginning you had your doubts about adding
those new fields.

> here (please don't hate me): does userspace need to care about the 

No problem, the patch was probably good to NACK it.. ;)

> framesamples field ? It looks like the value is only used inside the kernel, 
> and we're relying on on userspace to propagate those values between subdevs.

It's mostly used in the kernel, yes. But I also had in mind retrieving some
metadata directly from a sensor subdev, e.g. using controls. And that metadata
would have relationship with maximum frame length output by the camera.

But that could be handled differently, e.g. by retrieving metadata from
a sensor through subdev callback and appending that to a user buffer as
a separate plane.

> If that's the case, wouldn't it be better to have an in-kernel API to handle 
> this ? I'm a bit concerned about forcing userspace to handle internal 
> information to userspace if there's no reason to do so.

The maximum frame length is relevant only at image source and the host (video
node), hence there should not be really a need to propagate anything. The host
would retrieve frame length internally from subdev.

What I wanted to avoid was creating another pair of subdev callbacks that
would look very similar to the pad level set_fmt/get_fmt or try/g/s_mbus_fmt
operations.

I've found it a bit difficult to handle VIDIOC_TRY_FMT at pipeline's final video
node.
By having framesamples (framelength is probably a better name) in
struct v4l_mbus_framefmt the subdev has most of the information needed to
calculate the framelength in one data structure and thus pad level set_fmt(TRY)
can be used to ask a subdev what is framelength for given media bus pixel format.

I realize this a bit cleaner in-kernel API adds complexity in user space.
Which might not be worth it. But if we shouldn't have framelength in media bus
format then it's even more questionable to have pixelrate there.

> What's the rationale between your solution, is there a need for the 
> framesamples information in userspace ?

It might be useful to control compression quality and file size trade-off directly
at a sensor subdev. However this could be also done with sizeimage field at struct
v4l2_pix_format. Which seems a proper way, since it's a video node that deals with
memory, not a subdev. But Samsung sensors (well cameras) buffer the image data
internally, mix various data (like, JPEG, YUV) in one memory plane and then send
it out in one go. Thus a memory view may be also applicable for them.


--

Thanks,
Sylwester
