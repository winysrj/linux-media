Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45757 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab2AFOEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 09:04:16 -0500
Received: by eekc4 with SMTP id c4so1070996eek.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 06:04:15 -0800 (PST)
Message-ID: <4F06FF5B.8050707@gmail.com>
Date: Fri, 06 Jan 2012 15:04:11 +0100
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
Content-Type: text/plain; charset=ISO-8859-15
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
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> --
>> There is no changes in this patch comparing to v3.
>> ---
>>   Documentation/DocBook/media/v4l/dev-subdev.xml     |   10 ++++++++--
>>   Documentation/DocBook/media/v4l/subdev-formats.xml |    9 ++++++++-
>>   include/linux/v4l2-mediabus.h                      |    4 +++-
>>   3 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
>> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 0916a73..b9d24eb
>> 100644
>> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
>> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
>
>> @@ -160,7 +160,13 @@
>>         guaranteed to be supported by the device. In particular, drivers
>> guarantee that a returned format will not be further changed if passed to
>> an&VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such
>> as
>> -      formats on other pads or links' configuration are not changed).
>> </para>
>> +      formats on other pads or links' configuration are not changed). When
>> +      a device contains a data encoder, the<structfield>
>> +<link linkend="v4l2-mbus-framefmt-framesamples">framesamples</link>
>> +</structfield>  field value may be further changed, if parameters of
>> the
>> +      encoding process are changed after the format has been negotiated. In
>> +      such situation applications should use&VIDIOC-SUBDEV-G-FMT; ioctl to
>> +      query an updated format.</para>
>
> Sorry for answering so late. I've been thinking about this topic (as well as
> the proposed new pixelclock field) quite a lot, and one question strikes me
> here (please don't hate me): does userspace need to care about the
> framesamples field ? It looks like the value is only used inside the kernel,
> and we're relying on on userspace to propagate those values between subdevs.

How about a requirements for applications to configure the frame length only 
on sensor (data source) subdev ? The sensor subdev would adjust it, if it 
wouldn't have been consistent with other parameters in struct 
v4l2_mbus_framefmt. And having it "undefined" for non-compressed formats 
rather than requiring it to be set by subdevs to 0 ?

A standard function in the media core could be implemented, if ever needed,
to set framesamples on any remaining subdevs in the pipeline. 

Also the name "framesamples" is a bit odd, just "length" sounds better to me.

> If that's the case, wouldn't it be better to have an in-kernel API to handle
> this ? I'm a bit concerned about forcing userspace to handle internal
> information to userspace if there's no reason to do so.
>
> What's the rationale between your solution, is there a need for the
> framesamples information in userspace ?

Yes, it would be useful. And the control API doesn't seem relevant for it.
Maximum frame length is really a property of data frame on the media bus
which struct v4l2_framefmt describes.
Some sensors allow fine grained configuration of their embedded JPEG 
encoders and having frame length configurable directly on subdevs would
be useful.

--
Regards,
Sylwester

>>         <para>Drivers automatically propagate formats inside sub-devices.
>> When a try or active format is set on a pad, corresponding formats on
>> other pads diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> b/Documentation/DocBook/media/v4l/subdev-formats.xml index
>> 49c532e..7c202a1 100644
>> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
>> @@ -33,9 +33,16 @@
>>   	<entry>Image colorspace, from&v4l2-colorspace;. See
>>   	<xref linkend="colorspaces" />  for details.</entry>
>>   	</row>
>> +	<row id="v4l2-mbus-framefmt-framesamples">
>> +	<entry>__u32</entry>
>> +	<entry><structfield>framesamples</structfield></entry>
>> +	<entry>Maximum number of bus samples per frame for compressed data
>> +	    formats. For uncompressed formats drivers and applications must
>> +	    set this parameter to zero.</entry>
>> +	</row>
>>   	<row>
>>   	<entry>__u32</entry>
>> -	<entry><structfield>reserved</structfield>[7]</entry>
>> +	<entry><structfield>reserved</structfield>[6]</entry>
>>   	<entry>Reserved for future extensions. Applications and drivers must
>>   	  set the array to zero.</entry>
>>   	</row>
>> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
>> index 5ea7f75..f18d6cd 100644
>> --- a/include/linux/v4l2-mediabus.h
>> +++ b/include/linux/v4l2-mediabus.h
>> @@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
>>    * @code:	data format code (from enum v4l2_mbus_pixelcode)
>>    * @field:	used interlacing type (from enum v4l2_field)
>>    * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
>> + * @framesamples: maximum number of bus samples per frame
>>    */
>>   struct v4l2_mbus_framefmt {
>>   	__u32			width;
>> @@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
>>   	__u32			code;
>>   	__u32			field;
>>   	__u32			colorspace;
>> -	__u32			reserved[7];
>> +	__u32			framesamples;
>> +	__u32			reserved[6];
>>   };
>>
>>   #endif

