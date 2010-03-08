Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp04.wxs.nl ([195.121.247.13]:53155 "EHLO psmtp04.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab0CHVMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Mar 2010 16:12:19 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KYZ00DICEWHHA@psmtp04.wxs.nl> for linux-media@vger.kernel.org;
 Mon, 08 Mar 2010 22:12:18 +0100 (MET)
Date: Mon, 08 Mar 2010 22:12:16 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
In-reply-to: <4B93D751.1020008@gmail.com>
To: thomas.schorpp@gmail.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Message-id: <4B956830.6070508@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com>
 <4B93537F.30407@hoogenraad.net> <4B93D751.1020008@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro:

Can you remove the VERY OLD branch:
http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
It is giving some confusion here.

Thomas & Jan:

I've got the RTL2831 code (mind the last digit) vetted off by LeadTek.
For the rtl2832, I haven't had contact with them.

Certainly, Jan could try any of the three archives.
I know Antti has thoughts on the rtl2832, I'm sure he knows more.

thomas schorpp wrote:
> Jan Hoogenraad wrote:
>> Antti has been working on drivers for the RTL283x.
>>
>> http://linuxtv.org/hg/~anttip/rtl2831u
>> or
>> http://linuxtv.org/hg/~anttip/qt1010/
> 
> ~jhoogenraad/rtl2831-r2     rtl2831-r2 development repository: *known 
> working version*     Jan Hoogenraad
> 
> Should Jan Slaninka try it?
>>
>> If you have more information on the RTL2832, I'd be happy to add it at:
>> http://www.linuxtv.org/wiki/index.php/Rtl2831_devices
> 
> Nothing on the Realtek website yet.
> 
>>
>>
>> Jan Slaninka wrote:
>>> Hi,
>>>
>>> I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
>>> mini running on Linux. So far I was able to fetch latest v4l-dvb from
>>> HG, and successfully compiled module dvb_usb_rtl2832u found in
> 
>>> 090730_RTL2832U_LINUX_Ver1.1.rar  
> 
> Can be considered as GPL code then according to
> 
> http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
> 
> Patch to make RTL2831U DVB-T USB2.0 DEVICE work, based on RealTek 
> version 080314
> 
> ~mchehab/rtl2831     rtl2831 development repository with *RealTek GPL 
> code* for rtl2831     Mauro Carvalho Chehab     24 months ago
> 
> ?
> 
> y
> tom
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
