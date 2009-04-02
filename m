Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:35246 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZDBHpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 03:45:55 -0400
Message-ID: <49D46D2E.5090702@hni.uni-paderborn.de>
Date: Thu, 02 Apr 2009 09:45:50 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Questinons regarding soc_camera / pxa_camera
References: <49CBB13F.7090609@hni.uni-paderborn.de> <Pine.LNX.4.64.0903261831430.5438@axis700.grange> <49D32B16.2070101@hni.uni-paderborn.de> <Pine.LNX.4.64.0904011831340.5389@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904011831340.5389@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski schrieb:
>>>> Is there some ongoing work regarding the crop implementation on
>>>> soc_camera?
>>>> If I understand the documentation [1] right, the crop vales should
>>>> represent
>>>> the area
>>>> of the capture device before scaling. What was the reason for the current
>>>> implementation
>>>> combing crop and fmt values?
>>>>     
>>>>         
>>> See this discussion:
>>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/68
>>> besides, my idea was, that the user cannot be bothered with all scalings /
>>> croppings that take place in host and client devices (on camera controllers
>>> and / or sensors). My understanding was: the user uses S_FMT to request a
>>> window of a certain size, say 640x480, the drivers shall try to fit as much
>>> into it as possible using scaling. How many hardware pixels are now used to
>>> build this VGA window the user has no idea about.
>>>       
>> If we use the real pixels for CROP, the user can calculate the scale.
>> (see 1.11.3 Examples for "Image Cropping, Insertion and Scaling" in the
>> documentation)
>>     
>
> In the thread that I pointed you at there's a reply from Mauro, which, as 
> far as we understood each other:-), confirms my understanding of format 
> and cropping functionality. And to me it seems easier for the user to only 
> work in one scale. But we can revisit this later, sure.
>
>   
>>> Then you can use S_CROP to select sub-windows from _that_ area. If you want
>>> a different resolution, you use S_FMT again (after stopping the running
>>> capture), etc. 
>>>       
>> Do you mean you can use S_CROP during a running capture?
>> What happen if you change the width or height of the sub-windows. This will
>> change the resolution
>> / size of the image.
>>
>> I only know the camera driver side of this functions and don't know how it is
>> used,  but I would used
>> S_FMT do set the output format and S_CROP to select the real sensor size and
>> position.
>> For example S_FMT with 320x240 set the sensor area to 1280x960 (max).
>>     
>
> Ok, you mean the user retrieves CROP capabilities, sees 1280x960 as max, 
> selects scale 4 and hence an output window of 320x240:
>
> User request		Sensor window		Scale	User window
> S_FMT(320x240)		1280x960		4:1	320x240
>
>   
>> S_CROP with 600x400 set
>> the sensor area to 640x480, because this is the next supported scale (1,2,4,8)
>> for the fix output format.
>> If I understand the documentation right, S_CROP would use the old scale (4)
>> and change the format to 200x100 to get the requested sensor area.
>>     
>
> (wouldn't the user window be 160x120?) Here the user wants a window of 
> 150x100, so she uses the previously remembered scale of 4 to request 
> 600x400:
>
> S_CROP(600x400)		640x480			4:1	160x120
>   
No, exact this is the difference between your implementation and my 
understanding of CROP.
I interpret user window as a fix value, with can only be change by 
S_FMT. The user wants a window
of 320x240 and sensor area of 600x400, which can not reached by the 
sensor, so the driver adjust the
scale to reach the nearest sensor window to the requested one.

User request                    Sensor window        Scale    User window
S_CROP(600x400)        640x480                  2:1        320x240

But now I understand, why you used the scaled value for the sensor 
window and I agree, that it is the
right way for your implementation.

>> I think for now I take over your implementation of S_FMT and S_CROP.
>> After the v4l2-subdev transition we can update the implementations.
>>     
>
> With my implementation to achieve 160x120 at scale 4:1 you do just
>
> S_FMT(320x240)		1280x960		4:1	320x240
> S_CROP(160x120)		640x480			4:1	160x120
>
> i.e., the user doesn't have to remember the scale. Which, IMHO, is easier 
> for the user. Think about a visual "agent": if you change the window size, 
> you work in terms of your output window size, i.e., you tell the X-server 
> to put a window of 160x120 pixels. With the former approach you have to 
> use different sizes for X and for the camera, with the latter one you only 
> use one unit for both. That's my naive interpretation anyway:-)
>   
The user doesn't have to remember the scale anyway. Only the ways a 
different. You interpret S_CROP
as something like a cutting of the S_FMT window. I interpret S_FMT as a 
output format selection
and S_CROP as a sensor window selection.

S_FMT(160x120)        1280x960        8:1    160x120
S_CROP(640x480)      640x480         4:1    160x120

This approach has the advantage, that you can change the scale (sensor 
window) only by using S_CROP
and that you can get the scale by dividing the FMT values through the 
CROP values.

Regards
    Stefan
