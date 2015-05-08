Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58195 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbbEHBu5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2015 21:50:57 -0400
Message-ID: <554C1674.2020305@gmx.net>
Date: Fri, 08 May 2015 03:50:44 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: Steve <sjh_lmml@shic.co.uk>,
	linux-media <linux-media@vger.kernel.org>
CC: Olli Salonen <olli.salonen@iki.fi>
Subject: Re: Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - Linux driver.
References: <55439450.1080206@shic.co.uk>	<55442943.2070304@gmx.net> <CAAZRmGz=KVkKf6+z9r2yoZ+8nTenUN-2briAFtV0ogcfW0iAEQ@mail.gmail.com> <554A449C.4090101@shic.co.uk>
In-Reply-To: <554A449C.4090101@shic.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Olli, what kernel version/v4l-dvb are you running? (I want to update the 
wiki)

Steve, you can download Windows software from 
http://www.dvbsky.net/Support_win.html. It looks like the device should 
work with the driver+player.

Bestunar doesn't sound like something to worry about. Seems to be a 
sub-brand of DVBsky or something. Since the device works for Olli and 
yours is misbehaving the same way on a different system (I understand 
you installed Ubuntu in VirtualBox on the Dell) it's probably time to 
try and run it on Windows native to verify the device itself isn't 
simply a DOA.

Warning, Windows talk:

If you're not allowed (or don't want) to install drivers/software on the 
host OS for the Dell laptop but you can use USB 2.0 in VirtualBox, you 
may be able to just install Windows in VirtualBox. You can just take 
Windows 7 installation media (don't enter any serial) or Windows 8.1 
(with public trial key) or Windows 10 preview (public) and install that 
in VirtualBox. When it's expired (30 days for 7, instantly for 8.1) 
it'll just nag you, make the background black (actually an improvement) 
and maybe disables some advanced features, but all essential functions 
you need to troubleshoot the device will work.

To get media:

http://www.heidoc.net/joomla/technology-science/microsoft/70-windows-8-x-and-windows-10-iso-direct-download-links

For Windows 10, just get the preview, completely legal. For Windows 8.1, 
use the MS media creation tool on the Dell laptop. As you don't have to 
download from any illegal source, don't activate and enter a trial 
serial this generally won't get you into trouble. (but when in doubt, 
ask your lawyer) For Windows 7 you may not be able to legally obtain a 
copy of the installation media. If you go down that route, check the 
hash against hashes as released by MS.

If the device works on Windows, try to get the same system Olli has. 
(distro/kernel) If that doesn't work, it would be nice if you could 
provide a photograph of the inside of your device (but this could void 
your warranty) as perhaps it really is a new revision.

If the system Olli uses works for you, we need to find the difference 
between the systems.

Best regards,

P. van Gaans.



On 05/06/2015 06:43 PM, Steve wrote:
> Hi, thanks for your help so far...
>
> It's taken a few days - but I've now tried a variety of things without
> arriving at any resolution.
>
> Prior to posting, I had not downloaded any firmware.
>
> I placed the firmware from
> http://www.dvbsky.net/download/linux/dvbsky-firmware.tar.gz into
> /lib/firmware... I rebooted - the only difference I discovered is that,
> this time, my keyboard and mouse stopped working when the SaTiX device
> was plugged in.  Investigating syslog (after a reboot) suggested the
> error messages (previously posted) remained.
>
> I downloaded and built the latest v4l-dvb sources.  The upshot was that
> the device returned to failing as in my original post (i.e. without
> stopping my keyboard/mouse from working.)
>
> I tried several USB cables - no improvement.
>
> I hooked the SaTiX device up to a modern, Dell, Windows 8.1 laptop.
> Windows recognised the device as an S960, but was not able to
> (automatically) determine any drivers for it.  (I have no windows
> software for this device.)
>
> I installed Ubuntu onto a VirtualBox instance, and configured it to use
> the SaTiX.  At first, I thought I'd made progress as lsusb worked...
> however I quickly discovered an error message:
>
>          dvb_usb_v2: this USB2.0 device cannot be run on a USB1.1 port
> (it lacks a hardware PID filter)
>
> Having installed the extension pack for VirtualBox (to support virtual
> USB 2.0) the SaTiX device behaved identically to on the original (Ubuntu
> native) PC - i.e. the same errors in dmesg and lsusb fails to work after
> the device has been attached.
>
> The only new information that I have are the device diagnostics from
> Windows - the device reports:
>
>         Bestunar S960                            <--  I was surprised
>         not to see "SaTiX" here.
>         Vendor ID : 0572
>         Product ID : 6831
>         Version : 0000
>         Revision : 20130511
>
> The green light, on the front of the device, only comes on once Linux
> has recognised the device...
>
> Can anyone offer any other advice?  Have I been sent a different
> Sky-S960 clone to the one I ordered?
>
> On 03/05/15 08:44, Olli Salonen wrote:
>> Hi Steve,
>>
>> I've got the device in question and can confirm that it works ok.
>>
>> lsusb definitely should work ok - maybe there's indeed something wrong
>> with your device. As suggested by P. van Gaans, maybe you can try your
>> device on another computer or even on Windows and see if it works
>> there.
>>
>> Cheers,
>> -olli
>>
>>
>> On 2 May 2015 at 03:32, P. van Gaans <w3ird_n3rd@gmx.net> wrote:
>>> On 05/01/2015 04:57 PM, Steve wrote:
>>>> Hi,
>>>>
>>>> I'm trying a direct mail to you as you are associated with this page:
>>>>
>>>>       http://linuxtv.org/wiki/index.php/DVB-S2_USB_Devices
>>>>
>>>> I have bought a Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - but
>>>> it doesn't work with my 3.19 kernel, which I'd assumed it would from
>>>> the
>>>> above page.
>>>>
>>>> I've tried asking about the problem in various ways - first to
>>>> "AskUbuntu":
>>>>
>>>>
>>>> http://askubuntu.com/questions/613406/absent-frontend0-with-usb-dvbsky-s960-s860-driver-bug
>>>>
>>>>
>>>>
>>>> ... and, more recently, on the Linux-Media mailing list.  Without
>>>> convincing myself that I've contacted the right person/people to give
>>>> constructive feedback.
>>>>
>>>> By any chance can you offer me some advice about who it is best to
>>>> approach?  (Obviously I'd also be grateful if you can shed any light on
>>>> this problem.)
>>>>
>>>> Steve
>>>>
>>>>
>>> Hi Steve,
>>>
>>> The page actually states "Support in-kernel is expected in Linux kernel
>>> 3.18.". Devil's advocate, but it doesn't say it's actually there or
>>> guarantees it ever will. At the time it was written, 3.18 wasn't out
>>> yet.
>>> Looking at your dmesg output however it seems your kernel is aware of
>>> the
>>> device. (so the patch made it) As for me, I was offered a bargain for
>>> another device so I have no S960.
>>>
>>> Linux-media mailing list is the right place. (and here we are) A few
>>> quick
>>> suggestions:
>>>
>>> Did you really, really, really get the right firmware and are you
>>> absolutely
>>> positive it's in the right location and has the right filename? Does
>>> dmesg
>>> mention the firmware being loaded?
>>>
>>> Get/compile the latest v4l-dvb sources.
>>> (http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers)
>>>
>>> Maybe it's just a bug that has already been fixed.
>>>
>>> Try another program to access the device. But if even lsusb hangs,
>>> this is
>>> pretty much moot.
>>>
>>> Make sure the power supply/device is functioning properly. Try it on
>>> another
>>> OS to make sure it's not defective.
>>>
>>> Try another computer, preferably with another chipset. If your RAM is
>>> faulty
>>> or you have a funky USB-controller, you can experience strange problems.
>>>
>>> Good luck!
>>>
>>> Best regards,
>>>
>>> P. van Gaans
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

