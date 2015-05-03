Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36298 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbECHoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 May 2015 03:44:38 -0400
Received: by iebrs15 with SMTP id rs15so112637576ieb.3
        for <linux-media@vger.kernel.org>; Sun, 03 May 2015 00:44:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55442943.2070304@gmx.net>
References: <55439450.1080206@shic.co.uk>
	<55442943.2070304@gmx.net>
Date: Sun, 3 May 2015 09:44:37 +0200
Message-ID: <CAAZRmGz=KVkKf6+z9r2yoZ+8nTenUN-2briAFtV0ogcfW0iAEQ@mail.gmail.com>
Subject: Re: Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - Linux driver.
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

I've got the device in question and can confirm that it works ok.

lsusb definitely should work ok - maybe there's indeed something wrong
with your device. As suggested by P. van Gaans, maybe you can try your
device on another computer or even on Windows and see if it works
there.

Cheers,
-olli


On 2 May 2015 at 03:32, P. van Gaans <w3ird_n3rd@gmx.net> wrote:
> On 05/01/2015 04:57 PM, Steve wrote:
>>
>> Hi,
>>
>> I'm trying a direct mail to you as you are associated with this page:
>>
>>      http://linuxtv.org/wiki/index.php/DVB-S2_USB_Devices
>>
>> I have bought a Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - but
>> it doesn't work with my 3.19 kernel, which I'd assumed it would from the
>> above page.
>>
>> I've tried asking about the problem in various ways - first to
>> "AskUbuntu":
>>
>>
>> http://askubuntu.com/questions/613406/absent-frontend0-with-usb-dvbsky-s960-s860-driver-bug
>>
>>
>> ... and, more recently, on the Linux-Media mailing list.  Without
>> convincing myself that I've contacted the right person/people to give
>> constructive feedback.
>>
>> By any chance can you offer me some advice about who it is best to
>> approach?  (Obviously I'd also be grateful if you can shed any light on
>> this problem.)
>>
>> Steve
>>
>>
>
> Hi Steve,
>
> The page actually states "Support in-kernel is expected in Linux kernel
> 3.18.". Devil's advocate, but it doesn't say it's actually there or
> guarantees it ever will. At the time it was written, 3.18 wasn't out yet.
> Looking at your dmesg output however it seems your kernel is aware of the
> device. (so the patch made it) As for me, I was offered a bargain for
> another device so I have no S960.
>
> Linux-media mailing list is the right place. (and here we are) A few quick
> suggestions:
>
> Did you really, really, really get the right firmware and are you absolutely
> positive it's in the right location and has the right filename? Does dmesg
> mention the firmware being loaded?
>
> Get/compile the latest v4l-dvb sources.
> (http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers)
> Maybe it's just a bug that has already been fixed.
>
> Try another program to access the device. But if even lsusb hangs, this is
> pretty much moot.
>
> Make sure the power supply/device is functioning properly. Try it on another
> OS to make sure it's not defective.
>
> Try another computer, preferably with another chipset. If your RAM is faulty
> or you have a funky USB-controller, you can experience strange problems.
>
> Good luck!
>
> Best regards,
>
> P. van Gaans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
