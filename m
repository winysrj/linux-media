Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:18501 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbZKXJbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 04:31:31 -0500
Message-ID: <4B0BA3F5.2090408@hni.uni-paderborn.de>
Date: Tue, 24 Nov 2009 10:14:29 +0100
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Kai Tiwisina <kai_tiwisina@gmx.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: image capture with ov9655 camera and intel pxa270C5C520
References: <20091123183928.206900@gmx.net> <Pine.LNX.4.64.0911232131590.4207@axis700.grange> <4B0B30B8.5030602@gmx.de>
In-Reply-To: <4B0B30B8.5030602@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Kai Tiwisina schrieb:
> Hello everyone,
>
> here is a little update to my question and to the source code.
>
> After i implemented an function with the VIDIOC_ENUM_FMT ioctl i 
> recognized, that only two formats are support by the driver by now. 
> (Thanks to Mr. Liakhovetski by the way ;) )
> The output.txt shows the output of this function and mentions the two 
> different types.
>
> One is definately the V4L2_PIX_FMT_YUYV format but i don't know the 
> other one exactly...
>
> I changed my set_format function after i got this information and 
> unfortunately nothing has changed...
>
> Perhaps there are some further possibilities to solve this Problem.
>
> Maybe there have some other v4l2 structures to be initialized, befor 
> the VIDIOC_S_FMT ioctl runs?
You have to set fmt.fmt.pix.field toV4L2_FIELD_ANY and only YUV is 
supported at the moment.

Regards,
    Stefan
> Guennadi Liakhovetski wrote:
>> Hi Kai
>>
>> On Mon, 23 Nov 2009, Kai Tiwisina wrote:
>>
>>  
>>> Hello,
>>>
>>> my name is Kai Tiwisina and i'm a student in germany and i'm trying 
>>> to communicate with a Omnivision ov9655 camera which is atteched 
>>> with my embedded linux system via the v4l commands.
>>>
>>> I've written a small testprogram which should grow step by step 
>>> while i'm trying one ioctl after another.
>>> Everything worked fine until i tried to use the VIDIOC_S_FMT ioctl. 
>>> It's always giving me an "invalid argument" failure and i don't know 
>>> why.
>>>     
>>
>> Since you don't seem to have the source of the driver at hand, I'd 
>> suggest to use the VIDIOC_ENUM_FMT 
>> http://v4l2spec.bytesex.org/spec/r8367.htm ioctl to enumerate all 
>> pixel formats supported be the driver. If the driver you're using is 
>> the same, that Stefan (cc'ed) has submitted to the list, then indeed 
>> it does not support the V4L2_PIX_FMT_RGB555 format, that you're 
>> requesting, only various YUV (and a Bayer?) formats.
>>
>>  
>>> Perhaps someone of you is able to help me with this ioctl and give 
>>> an advice for a simple flow chart for a single frame image capture. 
>>> Which ioctl steps are neccessary and where do i need loops and for 
>>> what, because the capture-example.c from bytesex.org is way too 
>>> general for my purpose.
>>>     
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>>
>>   
>


-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Heinz Nixdorf Institute
University of Paderborn 
System and Circuit Technology 
Fürstenallee 11
D-33102 Paderborn (Germany)

office : F0.415
phone  : + 49 5251 - 60 6342
fax    : + 49 5251 - 60 6351

mailto : hbmeier@hni.upb.de

www    : http://wwwhni.upb.de/sct/mitarbeiter/hbmeier


