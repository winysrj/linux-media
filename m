Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56712 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1HQUWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 16:22:32 -0400
Received: by eyx24 with SMTP id 24so814373eyx.19
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 13:22:31 -0700 (PDT)
Message-ID: <4E4C2302.3060105@gmail.com>
Date: Wed, 17 Aug 2011 22:22:26 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: RFC: Negotiating frame buffer size between sensor subdevs and
 bridge devices
References: <4E31968B.9080603@samsung.com> <20110816222512.GF7436@valkosipuli.localdomain>
In-Reply-To: <20110816222512.GF7436@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/17/2011 12:25 AM, Sakari Ailus wrote:
> On Thu, Jul 28, 2011 at 07:04:11PM +0200, Sylwester Nawrocki wrote:
>> Hello,
> 
> Hi Sylwester,

Hi Sakari,

kiitos commentti ;)

> 
>> Trying to capture images in JPEG format with regular "image sensor ->
>> mipi-csi receiver ->  host interface" H/W configuration I've found there
>> is no standard way to communicate between the sensor subdev and the host
>> driver what is exactly a required maximum buffer size to capture a frame.
>>
>> For the raw formats there is no issue as the buffer size can be easily
>> determined from the pixel format and resolution (or sizeimage set on
>> a video node).
>> However compressed data formats are a bit more complicated, the required
>> memory buffer size depends on multiple factors, like compression ratio,
>> exact file header structure etc.
>>
>> Often it is at the sensor driver where all information required to
>> determine size of the allocated memory is present. Bridge/host devices
>> just do plain DMA without caring much what is transferred. I know of
>> hardware which, for some pixel formats, once data capture is started,
>> writes to memory whatever amount of data the sensor is transmitting,
>> without any means to interrupt on the host side. So it is critical
>> to assure the buffer allocation is done right, according to the sensor
>> requirements, to avoid buffer overrun.
>>
>>
>> Here is a link to somehow related discussion I could find:
>> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg27138.html
>>
>>
>> In order to let the host drivers query or configure subdevs with required
>> frame buffer size one of the following changes could be done at V4L2 API:
>>
>> 1. Add a 'sizeimage' field in struct v4l2_mbus_framefmt and make subdev
>>   drivers optionally set/adjust it when setting or getting the format with
>>   set_fmt/get_fmt pad level ops (and s/g_mbus_fmt ?)
>>   There could be two situations:
>>   - effective required frame buffer size is specified by the sensor and the
>>     host driver relies on that value when allocating a buffer;
>>   - the host driver forces some arbitrary buffer size and the sensor performs
>>     any required action to limit transmitted amount of data to that amount
>>     of data;
>> Both cases could be covered similarly as it's done with VIDIOC_S_FMT.
>>
>> Introducing 'sizeimage' field is making the media bus format struct looking
>> more similar to struct v4l2_pix_format and not quite in line with media bus
>> format meaning, i.e. describing data on a physical bus, not in the memory.
>> The other option I can think of is to create separate subdev video ops.
>> 2. Add new s/g_sizeimage subdev video operations
>>
>> The best would be to make this an optional callback, not sure if it makes sense
>> though. It has an advantage of not polluting the user space API. Although
>> 'sizeimage' in user space might be useful for some purposes I rather tried to
>> focus on "in-kernel" calls.
> 
> I prefer this second approach over the first once since the maxiumu size of
> the image in bytes really isn't a property of the bus.

After thinking some more about it I came to similar conclusion. I intended to
find some better name for s/g_sizeimage callbacks and post relevant patch
for consideration.
Although I haven't yet found some time to carry on with this.

> 
> How about a regular V4L2 control? You would also have minimum and maximum
> values, I'm not quite sure whather this is a plus, though. :)

My intention was to have these calls used only internally in the kernel and
do not allow the userspace to mess with it. All in all, if anything had 
interfered and the host driver would have allocated too small buffer the system
would crash miserably due to buffer overrun.

The final buffer size for a JFIF/EXIF file will depend on other factors, like
main image resolution, JPEG compression ratio, the thumbnail inclusion and its
format/resolution, etc. I imagine we should be rather creating controls
for those parameters.   

Also the driver would most likely have to validate the buffer size during 
STREAMON call.

> 
> Btw. how does v4l2_mbus_framefmt suit for compressed formats in general?
> 

Well, there is really nothing particularly addressing the compressed formats
in that struct. But we need to use it as the compressed data flows through 
the media bus in same way as the raw data.
It's rather hard to define the pixel codes using existing convention as there
is no simple relationship between the pixel data and what is transferred on
the bus.
Yet I haven't run into issues other than no means to specify the whole image
size.


--
Regards,
Sylwester
