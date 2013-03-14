Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23107 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3CNLjh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 07:39:37 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJN00DHGEW3ENA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Mar 2013 11:39:35 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MJN00GJQF1YHR00@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Mar 2013 11:39:34 +0000 (GMT)
Message-id: <5141B6F6.7080909@samsung.com>
Date: Thu, 14 Mar 2013 12:39:34 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH RFC v3 2/6] v4l2-ctrl: Add helper function for control
 range update
References: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
 <1358979721-17473-3-git-send-email-sylvester.nawrocki@gmail.com>
 <201303120756.25167.hverkuil@xs4all.nl> <201303140810.57504.hverkuil@xs4all.nl>
In-reply-to: <201303140810.57504.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/14/2013 08:10 AM, Hans Verkuil wrote:
> On Tue March 12 2013 07:56:25 Hans Verkuil wrote:
>> Hi Sylwester,
>>
>> On Wed January 23 2013 23:21:57 Sylwester Nawrocki wrote:
>>> This patch adds a helper function that allows to modify range,
>>> i.e. minimum, maximum, step and default value of a v4l2 control,
>>> after the control has been created and initialized. This is helpful
>>> in situations when range of a control depends on user configurable
>>> parameters, e.g. camera sensor absolute exposure time depending on
>>> an output image resolution and frame rate.
>>>
>>> v4l2_ctrl_modify_range() function allows to modify range of an
>>> INTEGER, BOOL, MENU, INTEGER_MENU and BITMASK type controls.
>>>
>>> Based on a patch from Hans Verkuil http://patchwork.linuxtv.org/patch/8654.
>>>
>>> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> I've been playing around with this a bit, using this vivi patch:
>>
>> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
>> index c46d2e8..85bc314 100644
>> --- a/drivers/media/platform/vivi.c
>> +++ b/drivers/media/platform/vivi.c
>> @@ -1093,6 +1093,15 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>>  		return 0;
>>  
>>  	dev->input = i;
>> +	/*
>> +	 * Modify the brightness range depending on the input.
>> +	 * This makes it easy to use vivi to test if applications can
>> +	 * handle control range modifications and is also how this is
>> +	 * typically used in practice as different inputs may be hooked
>> +	 * up to different receivers with different control ranges.
>> +	 */
>> +	v4l2_ctrl_modify_range(dev->brightness,
>> +			128 * i, 255 + 128 * i, 1, 127 + 128 * i);
>>  	precalculate_bars(dev);
>>  	precalculate_line(dev);
>>  	return 0;
>>
>> And it made me wonder if it wouldn't be more sensible if modify_range would
>> also update the current value to the new default value?
> 
> Actually, thinking about it some more, I believe that modify_range should
> actually include the new control value as argument. That way the caller can
> decide what to do: use the current value (which then might be clamped), use
> the default_value or use a remembered previous value.
> 
> If you agree with this, then I'll make a patch for it. I just need to know
> what the only user of this call (ov9650.c) should do. I suspect it should
> use the default value as the new value, but I'm not certain.

Sorry for the delay. I suppose if we choose either clamping the new value
or setting it to the default value there will always be users that wanted
other behaviour than currently implemented. In ov9650 case it seemed clamping
the value of the exposure control to <min, max> when the image size changed
a best option. Using the default value each time control's range changed
would cause changes of the exposure time, even though current exposure value
would still be inside of new range.
Thus I think best option for ov9650 would be to use previous value of the
control, which would then be clamped to <min, max>. This way changes of
the exposure time caused by the output format change could be minimized.

>> You get weird effects otherwise where the new value is clamped to either
>> the minimum or maximum value if the current value falls outside the new
>> range.
>>
>> Regards,
>>
>> 	Hans
>>
>> PS: qv4l2 has been updated to support range update events.

Thanks for updating it, I'll give it a try eventually!

--

Regards,
Sylwester
