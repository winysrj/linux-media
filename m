Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:48874 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110AbZJEGva (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 02:51:30 -0400
Message-ID: <4AC992EA.2070905@hni.uni-paderborn.de>
Date: Mon, 05 Oct 2009 08:32:10 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera + mt9m1111:  Failed to configure for format 50323234
References: <20091002213530.104a5009.ospite@studenti.unina.it>	<Pine.LNX.4.64.0910030116270.12093@axis700.grange>	<20091003161328.36419315.ospite@studenti.unina.it>	<Pine.LNX.4.64.0910040024070.5857@axis700.grange> <20091004171924.7579b589.ospite@studenti.unina.it>
In-Reply-To: <20091004171924.7579b589.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antonio Ospite schrieb:
> On Sun, 4 Oct 2009 00:31:24 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>
>   
>> On Sat, 3 Oct 2009, Antonio Ospite wrote:
>>
>>     
> [...]
>   
>>> Anyways your patch works, but the picture is now shifted, see:
>>> http://people.openezx.org/ao2/a780-pxa-camera-mt9m111-shifted.jpg
>>>
>>> Is this because of the new cropping code?
>>>       
>> Hm, it shouldn't be. Does it look always like this - reproducible? What 
>> program are you using? What about other geometry configurations? Have you 
>> ever seen this with previous kernel versions? New cropping - neither 
>> mplayer nor gstreamer use cropping normally. This seems more like a HSYNC 
>> problem to me. Double-check platform data? Is it mioa701 or some custom 
>> board?
>>
>>     
>
> It seemed to be reproducible yesterday, but I can't get it today, maybe
> it happens in low battery conditions. I am using capture-example.c from
> v4l2-apps. Never seen before. I am testing this on a Motorola A780,
> the soc-camera platform code is not in mainline yet.
>   
Only for your information. Maybe it helps to reproduce the error.

I have the same problem with my own ov9655 driver on a pxa platform 
since I update to kernel 2.6.30
and add crop support. Every  first open of the camera after system reset 
the image looks like yours.
If I use the camera the next time without changing the resolution 
everything is OK. Only during the
first open the resolution of the camera is changed  and function fmt set 
in the ov9655 driver is called
twice. I use the camera with my one program and it doesn't use crop.
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>>     
>
> Ciao ciao,
>    Antoni
Regards,
    Stefan
