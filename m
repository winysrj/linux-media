Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:32955 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbZDPPPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 11:15:14 -0400
Received: by rv-out-0506.google.com with SMTP id f9so446111rvb.1
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2009 08:15:13 -0700 (PDT)
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Message-Id: <F1B30416-C297-482C-AEB9-F42796D3D96B@gmail.com>
From: Dongsoo Kim <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0904161650360.4947@axis700.grange>
Content-Type: text/plain; charset=EUC-KR; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
Date: Fri, 17 Apr 2009 00:15:06 +0900
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>  <Pine.LNX.4.64.0904151403500.4729@axis700.grange>  <5e9665e10904151919p50c695e2s35140402d2c7345c@mail.gmail.com>  <Pine.LNX.4.64.0904161032050.4947@axis700.grange>  <5e9665e10904160300k7e581910r73710d8ffe5230a8@mail.gmail.com>  <Pine.LNX.4.64.0904161214200.4947@axis700.grange>  <5e9665e10904160409n26ecec11n89569b33d4797c6c@mail.gmail.com>  <Pine.LNX.4.64.0904161328420.4947@axis700.grange> <5e9665e10904160548y410dc680u175a50f96b5c4d7c@mail.gmail.com> <Pine.LNX.4.64.0904161454300.4947@axis700.grange> <2D5C734C-80B1-4A19-881A-BAF02E1A5231@gmail.com> <Pine.LNX.4.64.0904161650360.4947@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


2009. 04. 16, 오후 11:56, Guennadi Liakhovetski 작성:

> On Thu, 16 Apr 2009, Dongsoo Kim wrote:
>
>>>> And about camera client with several inputs question, I will say  
>>>> that
>>>> almost every 3G UMTS phone has dual camera on it. And we can  
>>>> consider
>>>> every 3G UMTS smart phones have dual camera on it with soc camera
>>>> solution.
>>>
>>> No, sorry, this wasn't my question. By "client" I meant one camera  
>>> or
>>> decoder or whatever chip connects to a camera host. I.e., if we  
>>> have a
>>> single chip with several inputs, that should logically be handled  
>>> with
>>> S_INPUT ioctl, this would further add to the confusion of using  
>>> different
>>> inputs on one video device to switch between chips or inputs /  
>>> functions
>>> on one chip.
>>
>> Yes exactly. It was  "single chip with several inputs." that I  
>> intended to
>> tell. but still don't get what the confusion you mean. Sorry ;-()
>> Cheers,
>
> Wow, so, on those phone a "dual camera" is a single (CMOS)  
> controller with
> two sensors / lenses / filters?... Cool, do you have an example of  
> such a
> camera to look for on the net? Preferably with a datasheet available.
>

Oops sorry I didn't mean that.
I just meant one single camera interface on Application Processor and  
two camera modules (sensor, lens, isp) connected. Sorry I explained  
badly.
I considered this as single camera interface with several inputs.

> "Confusion" I meant that in this case switching between inputs  
> sometimes
> switches you to another controller and sometimes to another function
> within the same controller...

I think we don't need to worry about that if  we can query camera  
inputs clearly.
Cheers,

Nate
>
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer

