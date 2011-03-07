Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:45268 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1CGVTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 16:19:19 -0500
Message-ID: <4D754BD3.7090204@ti.com>
Date: Mon, 7 Mar 2011 15:19:15 -0600
From: Sergio Aguirre <saaguirre@ti.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Query][soc_camera] How to handle hosts w/color conversion built
 in?
References: <4D75430E.8070001@ti.com> <Pine.LNX.4.64.1103072202070.29543@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103072202070.29543@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

Thanks for replying.

On 03/07/2011 03:05 PM, Guennadi Liakhovetski wrote:
> On Mon, 7 Mar 2011, Sergio Aguirre wrote:
>
>> Hi Guennadi and all,
>>
>> I've been trying to make my omap4 camera host driver to allow YUYV ->  NV12
>> color conversion, and add that to the supported host-client formats, but I
>> think I have hit the wall with the host design.
>>
>> I noticed that the soc_camera seems to be designed to just pass-through the
>> client supported formats (i.e. if my sensor supports YUYV and JPEG, those will
>> be the supported formats only)
>
> No, this is not the case.

Ok.

>
>> Now, in my host driver, I have a feature to do a color conversion to NV12, but
>> I'm still not sure on how to expand the supported formats to, say: YUYV, JPEG,
>> and NV12 (which would be available only if the client outputs YUYV, of
>> course).
>>
>> I was trying adding a customized get_formats function, but as
>> soc_camera_init_user_formats anyways depends heavly on the sensor's
>> enum_mbus_fmt, it's hard to add supported formats that the sensor doesn't
>> directly support.
>>
>> Has this been done before? Any advice?
>
> Of course, this is supported. See sh_mobile_ceu.c, mx3_camera, pxa_camera,
> omap1_camera. Just search for the format array defined with "static const
> struct soc_mbus_pixelfmt" and see how it is used. Feel free to ask again,
> if you have more questions.

Ahh... OK. I understand now :)

So, you basically first determine the count of sensor formats, by 
looping through enum_mbus_fmt in the sensor, and with every call to 
get_formats with the index range, you can return 2 or more formats.

In my case, when the sensor supports YUYV, I'll return 2 and update the 
xlate array with 2 entries, instead of just one, is that right?

Sorry for the noise, and thanks for the patience :)

I've been focusing more on the actual HW functionality, rather than the 
clean design. But now it's time to clean things up and prepare for 
upstreaming :)

Regards,
Sergio

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

