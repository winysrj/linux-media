Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49368 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1LOWTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 17:19:45 -0500
Received: by eekc4 with SMTP id c4so2616097eek.19
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 14:19:44 -0800 (PST)
Message-ID: <4EEA727C.6010906@gmail.com>
Date: Thu, 15 Dec 2011 23:19:40 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: Re: [RFC 1/3] v4l: Add pixel clock to struct v4l2_mbus_framefmt
References: <20111201143044.GI29805@valkosipuli.localdomain> <1323876147-18107-1-git-send-email-sakari.ailus@iki.fi> <4EEA6AAE.80405@gmail.com> <20111215220150.GH3677@valkosipuli.localdomain>
In-Reply-To: <20111215220150.GH3677@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2011 11:01 PM, Sakari Ailus wrote:
>>>  	  <entry>__u32</entry>
>>> -	  <entry><structfield>reserved</structfield>[7]</entry>
>>> +	  <entry><structfield>pixel_clock</structfield></entry>
>>> +	  <entry>Pixel clock in kHz. This clock is the maximum rate at
>>> +	  which pixels are transferred on the bus. The pixel_clock
>>> +	  field is read-only.</entry>
>>
>> I searched a couple of datasheets to find out where I could use this pixel_clock
>> field but didn't find any so far. I haven't tried too hard though ;)
>> There seems to be more benefits from having the link frequency control.
> 
> There are a few reasons to have the pixel clock available to the user space.
> 
> The previously existing reason is that the user may get information on the
> pixel rates, including cases where the pixel rate of a subdev isn't enough
> for the streaming to be possible. Earlier on it just failed. Such cases are
> common on the OMAP 3 ISP, for example.
> 
> The second reason is to provide that for timing calculations in the user
> space.

Fair enough. Perhaps, if I have worked more with image signal processing
algorithms in user space I would not ask about that in the first place :-)

> 
>> It might be easy to confuse pixel_clock with the bus clock. The bus clock is
>> often referred in datasheets as Pixel Clock (PCLK, AFAIU it's described with
>> link frequency in your RFC). IMHO your original proposal was better, i.e.
>> using more explicit pixel_rate. Also why it is in kHz ? Doesn't it make more
>> sense to use bits or pixels  per second ?
> 
> Oh, yes, now that you mention it I did call it pixel rate. I'm fine
> withrenaming it back to e.g. "pixelrate".

I'm fine with that too, sounds good!

> 
> I picked kHz since the 32-bit field would allow rates up to 4 GiP/s. Not
> sure if that's overkill though. Could be. But in practice it should give
> good enough precision this way, too.

All right, however I was more concerned by the "Hz" part, rather than "k" ;)
It might be good to have the relevant unit defined in the spec, to avoid
misinterpretation and future interoperability issues .

>>> +	</row>
>>> +	<row>
>>> +	  <entry>__u32</entry>
>>> +	  <entry><structfield>reserved</structfield>[6]</entry>
>>>  	  <entry>Reserved for future extensions. Applications and drivers must
>>>  	  set the array to zero.</entry>
>>>  	</row>
>>> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
>>> index 5ea7f75..76a0df2 100644
>>> --- a/include/linux/v4l2-mediabus.h
>>> +++ b/include/linux/v4l2-mediabus.h
>>> @@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
>>>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>>>   * @field:	used interlacing type (from enum v4l2_field)
>>>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
>>> + * @pixel_clock: pixel clock, in kHz
>>>   */
>>>  struct v4l2_mbus_framefmt {
>>>  	__u32			width;
>>> @@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
>>>  	__u32			code;
>>>  	__u32			field;
>>>  	__u32			colorspace;
>>> -	__u32			reserved[7];
>>> +	__u32			pixel_clock;
>>
>> I'm wondering, whether it is worth to make it 'pixelclock' for consistency
>> with other fields? Perhaps it would make more sense to have color_space and
>> pixel_clock.
> 
> "pixelrate" is fine for me.

Ack.

-- 
Regards,
Sylwester
