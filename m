Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65436 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2BRPvy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 10:51:54 -0500
Received: by eaah12 with SMTP id h12so1669514eaa.19
        for <linux-media@vger.kernel.org>; Sat, 18 Feb 2012 07:51:52 -0800 (PST)
Message-ID: <4F3FC914.9060702@gmail.com>
Date: Sat, 18 Feb 2012 16:51:48 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/6] V4L: Add V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 media
 bus format
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <1329416639-19454-2-git-send-email-s.nawrocki@samsung.com> <20120216194615.GF7784@valkosipuli.localdomain> <4F3E6395.4070208@samsung.com> <20120217181501.GH7784@valkosipuli.localdomain>
In-Reply-To: <20120217181501.GH7784@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/17/2012 07:15 PM, Sakari Ailus wrote:
> On Fri, Feb 17, 2012 at 03:26:29PM +0100, Sylwester Nawrocki wrote:
>> On 02/16/2012 08:46 PM, Sakari Ailus wrote:
>>> On Thu, Feb 16, 2012 at 07:23:54PM +0100, Sylwester Nawrocki wrote:
>>>> This patch adds media bus pixel code for the interleaved JPEG/YUYV image
>>>> format used by S5C73MX Samsung cameras. The interleaved image data is
>>>> transferred on MIPI-CSI2 bus as User Defined Byte-based Data.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>> ---
>>>>   include/linux/v4l2-mediabus.h |    3 +++
>>>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
>>>> index 5ea7f75..c2f0e4e 100644
>>>> --- a/include/linux/v4l2-mediabus.h
>>>> +++ b/include/linux/v4l2-mediabus.h
>>>> @@ -92,6 +92,9 @@ enum v4l2_mbus_pixelcode {
>>>>
>>>>   	/* JPEG compressed formats - next is 0x4002 */
>>>>   	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
>>>> +
>>>> +	/* Interleaved JPEG and YUV formats - next is 0x4102 */
>>>> +	V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 = 0x4101,
>>>>   };
>>>
>>> Thanks for the patch. Just a tiny comment:
>>>
>>> I'd go with a new hardware-specific buffer range, e.g. 0x5000.
>>
>> Sure, that makes more sense. But I guess you mean "format" not "buffer" range ?
> 
> Yeah, a format that begins a new range.
> 
>>> Guennadi also proposed an interesting idea: a "pass-through" format. Does
>>> your format have dimensions that the driver would use for something or is
>>> that just a blob?
>>
>> It's just a blob for the drivers, dimensions may be needed for subdevs to
>> compute overall size of data for example. But the host driver, in case of
>> Samsung devices, basically just needs to know the total size of frame data.
>>
>> I'm afraid the host would have to additionally configure subdevs in the data
>> pipeline in case of hardware-specific format, when we have used a single
>> binary blob media bus format identifier. For example MIPI-CSI2 data format
>> would have to be set up along the pipeline. There might be more attributes
>> in the future like this. Not sure if we want to go that path ?
>>
>> I'll try and see how it would look like with a single "pass-through" format.
>> Probably using g/s_mbus_config operations ?
> 
> I think we could use the framesize control to tell the size of the frame, or
> however it is done for jpeg blobs.

Yes, we could add a standard framesize control to the Image Source class but it
will solve only part of the problem. Nevertheless it might be worth to have it.
It could be used by applications to configure subdevs directly, while the host 
drivers could use e.g. s/g_frame_config op for that.

> The issue I see in the pass-through mode is that the user would have no
> information whatsoever what he's getting. This would be perhaps fixed by
> adding the frame format descriptor: it could contain information how to
> handle the data. (Just thinking out loud. :))

Do you mean a user space application by "user" ?

I'd like to clearly separate blob media bus pixel codes and hardware-specific
blob fourccs. If we don't want to change fundamental assumptions of V4L2
we likely need separate fourccs for each weird format.

I can imagine "pass-through" media bus pixel code but a transparent fourcc
sounds like a higher abstraction. :)
 
> I'm fine keeping this approach with sensor specific pixel code for now at
> least, but we must mark it experimental IMHO.

Good point, I'm eventually going to add a relevant note in the DocBook.

--

Thanks,
Sylwester
