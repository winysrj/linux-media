Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49971 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbZFKJOK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 05:14:10 -0400
Message-ID: <4A30CAD1.3040803@redhat.com>
Date: Thu, 11 Jun 2009 11:13:53 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: =?ISO-8859-1?Q?Jean-Philippe_Fran=E7ois?= <jp.francois@cynove.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9t031 (was RE: [PATCH] adding support for setting bus     
 parameters in sub device)
References: <38851.62.70.2.252.1244709306.squirrel@webmail.xs4all.nl>
In-Reply-To: <38851.62.70.2.252.1244709306.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/11/2009 10:35 AM, Hans Verkuil wrote:
>> Karicheri, Muralidharan a �crit :
>>>>> We need
>>>>> streaming capability in the driver. This is how our driver works
>>>>> with mt9t031 sensor
>>>>> 		  raw-bus (10 bit)
>>>>> vpfe-capture  ----------------- mt9t031 driver
>>>>> 	  |					   |
>>>>> 	  V				         V
>>>>> 	VPFE	 				MT9T031
>>>>>
>>>>> VPFE hardware has internal timing and DMA controller to
>>>>> copy data frame by frame from the sensor output to SDRAM.
>>>>> The PCLK form the sensor is used to generate the internal
>>>>> timing.
>>>> So, what is missing in the driver apart from the ability to specify
>>>> a frame-rate?
>>>>
>>> [MK] Does the mt9t031 output one frame (snapshot) like in a camera or
>>> can it output frame continuously along with PCLK, Hsync and Vsync
>>> signals like in a video streaming device. VPFE capture can accept frames
>>> continuously from the sensor synchronized to PCLK, HSYNC and VSYNC and
>>> output frames to application using QBUF/DQBUF. In our implementation, we
>>> have timing parameters for the sensor to do streaming at various
>>> resolutions and fps. So application calls S_STD to set these timings. I
>>> am not sure if this is an acceptable way of implementing it. Any
>>> comments?
>>>
>> PCLK, HSYNC, VSYNC are generated by the CMOS sensor. I don't think you
>> can set the timings. Depending on sensor settings, pixel clock speed etc
>> .., the frame rate will vary.
>>
>> You could perhaps play with the CMOS sensor registers so that when
>> settings a standard, the driver somehow set the various exposition
>> parameter and pll settings to get a specified framerate.
>>
>> This will vary with each sensor and each platform (because of
>> pixelclock). More over, chances are that it will be conflicting with
>> other control.
>>
>> For example if you set a fixed gain and autoexpo, some sensor will see
>> a drop in fps under low light conditions. I think this kind of
>> arbitration  should be left to userspace.
>>
>> Unless the sensor supports a specific standard, I don't think the driver
>> should try to make behind the scene modification to camera sensor
>> register in response to a S_STD ioctl.
>
> The S_STD call is hopelessly inadequate to deal with these types of
> devices. What is needed is a new call that allows you to set the exact
> timings you want: frame width/height, back/front porch, h/vsync width,
> pixelclock. It is my opinion that the use of S_STD should be limited to
> standard definition type inputs, and not used for other devices like
> sensors or HD video.
>
> Proposals for such a new ioctl are welcome :-)
>

Hmm,

Why would we want the *application* to set things like this *at all* ?
with sensors hsync and vsync and other timing are something between
the bridge and the sensor, actaully in my experience the correct
hsync / vsync timings to program the sensor to are very much bridge 
specific. So IMHO this should not be exposed to userspace at all.

All userspace should be able to control is the resolution and the 
framerate. Although controlling the framerate in many cases also
means controlling the maximum exposure time. So in many cases
one cannot even control the framerate. (Asking for 30 fps in an
artificially illuminated room will get you a very dark, useless
picture, with most sensors). Yes this means that with cams with
use autoexposure (which is something which we really want where ever
possible), the framerate can and will change while streaming.

Regards,

Hans
