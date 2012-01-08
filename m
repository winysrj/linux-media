Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:28261 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab2AHVQR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jan 2012 16:16:17 -0500
Message-ID: <4F0A079F.5060100@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 23:16:15 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 07/17] v4l: Add pixelrate to struct v4l2_mbus_framefmt
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-7-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201061126.40692.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201061126.40692.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Tuesday 20 December 2011 21:27:59 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Pixelrate is an essential part of the image data parameters. Add this.
>> Together, the current parameters also define the frame rate.
>>
>> Sensors do not have a concept of frame rate; pixelrate is much more
>> meaningful in this context. Also, it is best to combine the pixelrate with
>> the other format parameters since there are dependencies between them.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  Documentation/DocBook/media/v4l/subdev-formats.xml |   10 +++++++++-
>>  include/linux/v4l2-mediabus.h                      |    4 +++-
>>  2 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> b/Documentation/DocBook/media/v4l/subdev-formats.xml index
>> 49c532e..a6a6630 100644
>> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
>> @@ -35,7 +35,15 @@
>>  	</row>
>>  	<row>
>>  	  <entry>__u32</entry>
>> -	  <entry><structfield>reserved</structfield>[7]</entry>
>> +	  <entry><structfield>pixelrate</structfield></entry>
>> +	  <entry>Pixel rate in kp/s.
> 
> kPix/s or kPixel/s ?

Hmm. kilo-pixels / second?

Albeit I have to say I'm increasingly inclined to think this field
doesn't really belong to this struct --- we should discuss that tomorrow.

There are two things this is needed in the user space:

1) To calculate detailed hardware timing information.

2) To figure out whether streaming is possible, or to figure out why it
failed in case it did.

And in kernel space:

1) To configure devices. The OMAP 3 ISP CSI-2 receiver and CCDC blocks
must be configured based on the pixel rate.

2) Validate pipeline pixel rate for each subdev. Some subdevs require it
to be withint limits. A good example is the OMAP 3 ISP where most blocks
have 100 Mp/s maximum whereas the CSI-2 receiver has 200 Mp/s maximum.

This could be implemented using pad-specific controls. In drivers the
subdev in sink end of the link would get the controls from the source.

>> This clock is the maximum rate at
> 
> Is it really a clock ?
> 
>> +	  which pixels are transferred on the bus. The
>> +	  <structfield>pixelrate</structfield> field is
>> +	  read-only.</entry>
> 
> Does that mean that userspace isn't required to propagate the value down the 
> pipeline when configuring it ? I'm fine with that, but it should probably be 
> documented explictly somewhere to make sure that drivers don't rely on it.
> 
>> +	</row>
>> +	<row>
>> +	  <entry>__u32</entry>
>> +	  <entry><structfield>reserved</structfield>[6]</entry>
>>  	  <entry>Reserved for future extensions. Applications and drivers must
>>  	  set the array to zero.</entry>
>>  	</row>
>> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
>> index 5ea7f75..35c6b96 100644
>> --- a/include/linux/v4l2-mediabus.h
>> +++ b/include/linux/v4l2-mediabus.h
>> @@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
>>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>>   * @field:	used interlacing type (from enum v4l2_field)
>>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
>> + * @pixel_clock: pixel clock, in kHz
> 
> I think you forgot to update the comment.
> 
>>   */
>>  struct v4l2_mbus_framefmt {
>>  	__u32			width;
>> @@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
>>  	__u32			code;
>>  	__u32			field;
>>  	__u32			colorspace;
>> -	__u32			reserved[7];
>> +	__u32			pixelrate;
>> +	__u32			reserved[6];
>>  };
>>
>>  #endif
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
