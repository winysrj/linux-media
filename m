Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp09.wxs.nl ([195.121.247.23]:46332 "EHLO psmtp09.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0AHH25 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jan 2010 02:28:57 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp09.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KVX008Y53G3B5@psmtp09.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 08 Jan 2010 08:28:51 +0100 (MET)
Date: Fri, 08 Jan 2010 08:28:49 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Compro VideoMate U80 DVB-T USB 2.0 High Definition Digital TV Stick
In-reply-to: <4B46AC9E.1050408@iinet.net.au>
To: drappa <drappa@iinet.net.au>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Message-id: <4B46DEB1.1020301@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B3ABD9D.6040207@iinet.net.au> <4B4661ED.3070606@hoogenraad.net>
 <4B46AC9E.1050408@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So: it is a Realtek 2831 device.

Please first check /lib/udev/rules.d/50-udev-default.rules.
There seems to be a generic problem with Karmac there.
Look at http://ubuntuforums.org/showthread.php?t=1327337 which gives 
solution for the problem by installing a new rule:-
/etc/udev/rules.d/50-udev.rules

Under Ubuntu Karmac, I have heard that the anttip/rtl2831u driver works 
  (alas without IR support) with this workaround. Of the 
jhoogenraad/rtl2831-2 I have no confirmation yet.

http://ubuntuforums.org/showthread.php?t=960113

Which one have you downloaded ?


drappa wrote:
> Jan Hoogenraad wrote:
>> Can you give us the USB ID
>> (type on the command line: lsusb, and report the output)
>>
>> The U90 has a RTL2831 in it. More info on the driver on:
>> http://www.linuxtv.org/wiki/index.php/Rtl2831_devices
> Hi Jan
> 
> USB ID is :  185b-0150  Compro
> 
> I built the driver as per the link but the device does not initialise.
> 
> Tested using an Ubuntu Studio Karmic installation with two afatech 9015 
> USB devices connected ok
> 
> Thanks
> drappa
> 
> 
>>
>> drappa wrote:
>>> Hi All
>>>
>>> http://www.comprousa.com/en/product/u80/u80.html
>>>
>>> I'd be grateful if anyone can tell me if this device is supported 
>>> yet, and if so, any pointers to getting it working.
>>>
>>> Thanks
>>> Drappa
>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
