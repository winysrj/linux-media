Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41955 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0CIShX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 13:37:23 -0500
Received: by bwz1 with SMTP id 1so4190908bwz.21
        for <linux-media@vger.kernel.org>; Tue, 09 Mar 2010 10:37:22 -0800 (PST)
Message-ID: <4B96955F.8010300@gmail.com>
Date: Tue, 09 Mar 2010 19:37:19 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: LiM <lim@brdo.cz>
CC: linux-media@vger.kernel.org
Subject: Re: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
References: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com> <4B93537F.30407@hoogenraad.net> <4B93D751.1020008@gmail.com> <4B956830.6070508@hoogenraad.net> <4B960276.9030302@brdo.cz>
In-Reply-To: <4B960276.9030302@brdo.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LiM wrote:
> Hi,
> 
> for information...i have the same dongle (LeadTek WinFast DTV Dongle
> Mini - Bus 001 Device 003: ID 0413:6a03 Leadtek Research, Inc. )
> and after compiled RTL2832U + change VID+PID in rtl2832u.h (i changed
> USB_VID_GTEK + USB_PID_GTEK_WARM to leadtek`s 0413:6a03)
> is tuner working!  (me-tv + kaffeine)
> 

Good. Supported tuner chip. Pls do extensive tests (multiple recording streams, long time use usb-disconnects, 
other dvb apps...) and report any issues.

But we must support the MSI and others, too, so introduce an USB-ids array and device detection for 
USB_VID_GTEK + USB_PID_GTEK_WARM, see the other drivers for example code.

I don't have got the devices.

> Installation of Realtek rtl2832u-based DVB-T-USB-Sticks:
> 

> gedit ./linux/drivers/media/dvb/dvb-usb/Makefile

Not acceptable in linux software development, pls *attach* patch to a mail with [PATCH]... in subject line 
by using linux diff utility (man diff) 
Example:
diff -rNU3 <orig code dir> <changed code dir> > ubuntuusers-de-rtl2832u-01.patch
With signed-off-by <author mail adress> 

For patching non-driver user space apps, please contact their project devlists.

y
tom

> Jan Hoogenraad napsal(a):
>> Mauro:
>>
>> Can you remove the VERY OLD branch:
>> http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
>> It is giving some confusion here.
>>
>> Thomas & Jan:
>>
>> I've got the RTL2831 code (mind the last digit) vetted off by LeadTek.
>> For the rtl2832, I haven't had contact with them.
>>
>> Certainly, Jan could try any of the three archives.
>> I know Antti has thoughts on the rtl2832, I'm sure he knows more.
>>
>> thomas schorpp wrote:
>>> Jan Hoogenraad wrote:
>>>> Antti has been working on drivers for the RTL283x.
>>>>
>>>> http://linuxtv.org/hg/~anttip/rtl2831u
>>>> or
>>>> http://linuxtv.org/hg/~anttip/qt1010/
>>> ~jhoogenraad/rtl2831-r2     rtl2831-r2 development repository: *known
>>> working version*     Jan Hoogenraad
>>>
>>> Should Jan Slaninka try it?
>>>> If you have more information on the RTL2832, I'd be happy to add it at:
>>>> http://www.linuxtv.org/wiki/index.php/Rtl2831_devices
>>> Nothing on the Realtek website yet.
>>>
>>>>
>>>> Jan Slaninka wrote:
>>>>> Hi,
>>>>>
>>>>> I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
>>>>> mini running on Linux. So far I was able to fetch latest v4l-dvb from
>>>>> HG, and successfully compiled module dvb_usb_rtl2832u found in
>>>>> 090730_RTL2832U_LINUX_Ver1.1.rar  
>>> Can be considered as GPL code then according to
>>>
>>> http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
>>>
>>> Patch to make RTL2831U DVB-T USB2.0 DEVICE work, based on RealTek
>>> version 080314
>>>
>>> ~mchehab/rtl2831     rtl2831 development repository with *RealTek GPL
>>> code* for rtl2831     Mauro Carvalho Chehab     24 months ago
>>>
>>> ?
>>>
>>> y
>>> tom
