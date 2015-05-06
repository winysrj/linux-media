Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw.shic.co.uk ([94.23.159.123]:33446 "EHLO gw.shic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbbEFQuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 12:50:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by gw.shic.co.uk (Postfix) with ESMTP id BC63416C1502
	for <linux-media@vger.kernel.org>; Wed,  6 May 2015 17:50:30 +0100 (BST)
Received: from gw.shic.co.uk ([IPv6:::ffff:192.168.42.2])
	by localhost (localhost [::ffff:127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9HCSyzdjGohA for <linux-media@vger.kernel.org>;
	Wed,  6 May 2015 17:50:27 +0100 (BST)
Received: from [192.168.0.135] (unknown [192.168.0.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by gw.shic.co.uk (Postfix) with ESMTPSA id 893AE16C1124
	for <linux-media@vger.kernel.org>; Wed,  6 May 2015 17:50:27 +0100 (BST)
Message-ID: <554A4653.7070503@shic.co.uk>
Date: Wed, 06 May 2015 17:50:27 +0100
From: Steve <sjh_lmml@shic.co.uk>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - Linux driver.
References: <55439450.1080206@shic.co.uk>	<55442943.2070304@gmx.net> <CAAZRmGz=KVkKf6+z9r2yoZ+8nTenUN-2briAFtV0ogcfW0iAEQ@mail.gmail.com>
In-Reply-To: <CAAZRmGz=KVkKf6+z9r2yoZ+8nTenUN-2briAFtV0ogcfW0iAEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, thanks for your help so far...

It's taken a few days - but I've now tried a variety of things without 
arriving at any resolution.

Prior to posting, I had not downloaded any firmware.

I placed the firmware from 
http://www.dvbsky.net/download/linux/dvbsky-firmware.tar.gz into 
/lib/firmware... I rebooted - the only difference I discovered is that, 
this time, my keyboard and mouse stopped working when the SaTiX device 
was plugged in.  Investigating syslog (after a reboot) suggested the 
error messages (previously posted) remained.

I downloaded and built the latest v4l-dvb sources.  The upshot was that 
the device returned to failing as in my original post (i.e. without 
stopping my keyboard/mouse from working.)

I tried several USB cables - no improvement.

I hooked the SaTiX device up to a modern, Dell, Windows 8.1 laptop. 
Windows recognised the device as an S960, but was not able to 
(automatically) determine any drivers for it.  (I have no windows 
software for this device.)

I installed Ubuntu onto a VirtualBox instance, and configured it to use 
the SaTiX.  At first, I thought I'd made progress as lsusb worked... 
however I quickly discovered an error message:

         dvb_usb_v2: this USB2.0 device cannot be run on a USB1.1 port 
(it lacks a hardware PID filter)

Having installed the extension pack for VirtualBox (to support virtual 
USB 2.0) the SaTiX device behaved identically to on the original (Ubuntu 
native) PC - i.e. the same errors in dmesg and lsusb fails to work after 
the device has been attached.

The only new information that I have are the device diagnostics from 
Windows - the device reports:

        Bestunar S960                            <--  I was surprised
        not to see "SaTiX" here.
        Vendor ID : 0572
        Product ID : 6831
        Version : 0000
        Revision : 20130511

The green light, on the front of the device, only comes on once Linux 
has recognised the device...

Can anyone offer any other advice?  Have I been sent a different 
Sky-S960 clone to the one I ordered?

On 03/05/15 08:44, Olli Salonen wrote:
> Hi Steve,
>
> I've got the device in question and can confirm that it works ok.
>
> lsusb definitely should work ok - maybe there's indeed something wrong
> with your device. As suggested by P. van Gaans, maybe you can try your
> device on another computer or even on Windows and see if it works
> there.
>
> Cheers,
> -olli
>
>
> On 2 May 2015 at 03:32, P. van Gaans<w3ird_n3rd@gmx.net>  wrote:
>> On 05/01/2015 04:57 PM, Steve wrote:
>>> Hi,
>>>
>>> I'm trying a direct mail to you as you are associated with this page:
>>>
>>>       http://linuxtv.org/wiki/index.php/DVB-S2_USB_Devices
>>>
>>> I have bought a Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - but
>>> it doesn't work with my 3.19 kernel, which I'd assumed it would from the
>>> above page.
>>>
>>> I've tried asking about the problem in various ways - first to
>>> "AskUbuntu":
>>>
>>>
>>> http://askubuntu.com/questions/613406/absent-frontend0-with-usb-dvbsky-s960-s860-driver-bug
>>>
>>>
>>> ... and, more recently, on the Linux-Media mailing list.  Without
>>> convincing myself that I've contacted the right person/people to give
>>> constructive feedback.
>>>
>>> By any chance can you offer me some advice about who it is best to
>>> approach?  (Obviously I'd also be grateful if you can shed any light on
>>> this problem.)
>>>
>>> Steve
>>>
>>>
>> Hi Steve,
>>
>> The page actually states "Support in-kernel is expected in Linux kernel
>> 3.18.". Devil's advocate, but it doesn't say it's actually there or
>> guarantees it ever will. At the time it was written, 3.18 wasn't out yet.
>> Looking at your dmesg output however it seems your kernel is aware of the
>> device. (so the patch made it) As for me, I was offered a bargain for
>> another device so I have no S960.
>>
>> Linux-media mailing list is the right place. (and here we are) A few quick
>> suggestions:
>>
>> Did you really, really, really get the right firmware and are you absolutely
>> positive it's in the right location and has the right filename? Does dmesg
>> mention the firmware being loaded?
>>
>> Get/compile the latest v4l-dvb sources.
>> (http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers)
>> Maybe it's just a bug that has already been fixed.
>>
>> Try another program to access the device. But if even lsusb hangs, this is
>> pretty much moot.
>>
>> Make sure the power supply/device is functioning properly. Try it on another
>> OS to make sure it's not defective.
>>
>> Try another computer, preferably with another chipset. If your RAM is faulty
>> or you have a funky USB-controller, you can experience strange problems.
>>
>> Good luck!
>>
>> Best regards,
>>
>> P. van Gaans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html

