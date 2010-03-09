Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0CIUcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 15:32:47 -0500
Message-ID: <4B96B069.5000901@infradead.org>
Date: Tue, 09 Mar 2010 17:32:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: thomas.schorpp@gmail.com, linux-media@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
Subject: Re: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
References: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com> <4B93537F.30407@hoogenraad.net> <4B93D751.1020008@gmail.com> <4B956830.6070508@hoogenraad.net>
In-Reply-To: <4B956830.6070508@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jan Hoogenraad wrote:
> Mauro:
> 
> Can you remove the VERY OLD branch:
> http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
> It is giving some confusion here.

Removed. It would be great if you could work on put it at a good shape,
in order to allow its merge upstream.

> 
> Thomas & Jan:
> 
> I've got the RTL2831 code (mind the last digit) vetted off by LeadTek.
> For the rtl2832, I haven't had contact with them.
> 
> Certainly, Jan could try any of the three archives.
> I know Antti has thoughts on the rtl2832, I'm sure he knows more.
> 
> thomas schorpp wrote:
>> Jan Hoogenraad wrote:
>>> Antti has been working on drivers for the RTL283x.
>>>
>>> http://linuxtv.org/hg/~anttip/rtl2831u
>>> or
>>> http://linuxtv.org/hg/~anttip/qt1010/
>>
>> ~jhoogenraad/rtl2831-r2     rtl2831-r2 development repository: *known
>> working version*     Jan Hoogenraad
>>
>> Should Jan Slaninka try it?
>>>
>>> If you have more information on the RTL2832, I'd be happy to add it at:
>>> http://www.linuxtv.org/wiki/index.php/Rtl2831_devices
>>
>> Nothing on the Realtek website yet.
>>
>>>
>>>
>>> Jan Slaninka wrote:
>>>> Hi,
>>>>
>>>> I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
>>>> mini running on Linux. So far I was able to fetch latest v4l-dvb from
>>>> HG, and successfully compiled module dvb_usb_rtl2832u found in
>>
>>>> 090730_RTL2832U_LINUX_Ver1.1.rar  
>>
>> Can be considered as GPL code then according to
>>
>> http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
>>
>> Patch to make RTL2831U DVB-T USB2.0 DEVICE work, based on RealTek
>> version 080314
>>
>> ~mchehab/rtl2831     rtl2831 development repository with *RealTek GPL
>> code* for rtl2831     Mauro Carvalho Chehab     24 months ago
>>
>> ?
>>
>> y
>> tom
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 


-- 

Cheers,
Mauro
