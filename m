Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34702 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0CGQl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 11:41:57 -0500
Received: by fxm19 with SMTP id 19so5641056fxm.21
        for <linux-media@vger.kernel.org>; Sun, 07 Mar 2010 08:41:56 -0800 (PST)
Message-ID: <4B93D751.1020008@gmail.com>
Date: Sun, 07 Mar 2010 17:41:53 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
References: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com> <4B93537F.30407@hoogenraad.net>
In-Reply-To: <4B93537F.30407@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jan Hoogenraad wrote:
> Antti has been working on drivers for the RTL283x.
> 
> http://linuxtv.org/hg/~anttip/rtl2831u
> or
> http://linuxtv.org/hg/~anttip/qt1010/

~jhoogenraad/rtl2831-r2 	rtl2831-r2 development repository: *known working version* 	Jan Hoogenraad

Should Jan Slaninka try it? 

> 
> If you have more information on the RTL2832, I'd be happy to add it at:
> http://www.linuxtv.org/wiki/index.php/Rtl2831_devices

Nothing on the Realtek website yet.

> 
> 
> Jan Slaninka wrote:
>> Hi,
>>
>> I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
>> mini running on Linux. So far I was able to fetch latest v4l-dvb from
>> HG, and successfully compiled module dvb_usb_rtl2832u found in

>> 090730_RTL2832U_LINUX_Ver1.1.rar  

Can be considered as GPL code then according to

http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab

Patch to make RTL2831U DVB-T USB2.0 DEVICE work, based on RealTek version 080314

~mchehab/rtl2831 	rtl2831 development repository with *RealTek GPL code* for rtl2831 	Mauro Carvalho Chehab 	24 months ago

?

y
tom
