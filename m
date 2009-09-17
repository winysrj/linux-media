Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:37495 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366AbZIQJS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 05:18:26 -0400
Message-ID: <4AB1FEDC.6020308@cynove.com>
Date: Thu, 17 Sep 2009 11:18:20 +0200
From: =?ISO-8859-1?Q?Jean-Philippe_Fran=E7ois?= <jp.francois@cynove.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: V4L - Support for video timings at the input/output	interface
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>	<200909150853.19902.hverkuil@xs4all.nl>	<A69FA2915331DC488A831521EAE36FE40155157076@dlee06.ent.ti.com> <200909162349.24772.hverkuil@xs4all.nl>
In-Reply-To: <200909162349.24772.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil a écrit :

>> and so forth. So for a camera that supports pre-defined presets can
>> set the CAP_FIXED_FRAME_RATE capability. So Auto exposure may not
>> be available. If Auto exposure is available, the driver can indicate
>> CAP_VARIABLE_FRAME_RATE. If a driver supports both, then both flags
>> can be set and based on the value of fps can decide which mode to
>> operate on (0/0 - for variable mode, 30/1 - to do 30fps rate).
> 
> Setting up a sensor is rather messy at the moment. You have the
> ENUM_FRAMESIZES and ENUM_FRAMEINTERVALS ioctls that basically give you the
> 'presets' of a sensor. For exposure we have camera controls. Yet we also
> have S_PARM to set the framerate. And to set the resolution we abuse S_FMT.
>
Some sensor are very versatile, and so a preset is just an arbitrary 
resolution. Yet most of the application will be happy with a few preset 
to choose from. I agree that it should be easy to just "set the resolution".

We should have preset, it should still be possible to access all 
capabilities of the sensor. I have not contributed any code, but here 
are some use case that are quite difficult to handle :

* I don't like the presets.
How should I change resolution ?
-VIDIOC_S_FMT ?
-VIDIOC_S_DV_TIMINGS ?

* I use the sensor with another hardware, I can't handle the default 
pixelclock :
-VIDIOC_G/S_DV_TIMINGS seems really handy here. Except I don't necessary
care about / can set the other parameters


* I wan't to change the field of view.
-should I use S_CROP ? But I am not really doing any cropping here, just 
changing the firts row, first column.

* Both the sensor and the hardware provide the cropping capability.
-For example, let's say I want to capture a 800x600 windows in the 
center of a 5 MPixel sensor, and I work with a video port that has 
cropping capabilities.
- solution A : The sensor is configured for a 800x600 capture, and the 
video port takes it all.
-solution B : the sensor is configured for a full field capture (5Mpx), 
and the videoport takes only some part of the data.

Of course solution A is faster, because the sensor does a readout of 
much less data. But with some sensor I will only get solution B.

IMO, S/G_FMT should deal with solution A, and S/G_CROP with solution B.

* Repeat the former point with white balance, exposure, gain, gamma,
rgb2yuv etc...

* "Preview" and "capture mode" ex : MT9D131. I can have the following :
- Full field capture (1600x1200) but 800x600 output
- Full field capture, full resolution output
Ok, this can be handheld with ENUM_FRAME_SIZE
- Windowed 800x600 capture, full resolution output (800x600)
Same resolution, similar or identical framerate.
The possibility to move the window, gives you a very quick zoom 
capability anywhere in the picture.
But it is a PITA with the current API

That is why I think the VIDIOC_S_DV_PRESET is a good idea, when you just 
want to set a standard resolution.
Regarding the custom timings, I think it puts and emphasis on the timing 
  problem, while CMOS sensor has some other interesting parameters.

I am glad I can change pixelclock, but changing the capture windows 
position would be great to !

Should S_FMT be changed ?
This is the format as seen by the application, changing the windows 
position does not change the ouptut format.

Should I use S_CROP ?
See my example with solution A and B. Obviously, solution A is not 
really cropping.

Should it be exposed in a CTRL ?
That is the current solution i am using. Hacking the driver. Of course 
then I move on a new project because my boss does not want me to spend 
time having my change merged upstream. Typical embedded reaction :(

Should we enhance the custom timings RFC proposed by TI to include not 
only timing, but perhaps windows pos, and perhaps skipping/binning as well ?


> I don't think we should use preset for anything else besides just uniquely
> identifying a particular video timing. It is a good idea though to add the
> width, height and fps to struct v4l2_dv_enum_presets. That way apps can
> actually know what the preset resolution and fps is.
> 
> To be honest I don't have any brilliant ideas at the moment on how to solve
> setting sensor timings. 
Neither do I, and I prefer a simple driver I can hack, to a "let's 
expose all messiness to userspace, and let them fill a dozen struct"
At the LPC we have both the UVC maintainer (Laurent
> Pinchart) and the libv4l and gspca developer Hans de Goede present, so we
> should be able to come up with a good solution to this. My knowledge of
> sensors is limited, so I will need help with this.
> 
> Regards,
> 
> 	Hans
> 

