Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:56752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554Ab0LNQ2h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 11:28:37 -0500
Message-ID: <4D079B30.3010605@redhat.com>
Date: Tue, 14 Dec 2010 17:28:32 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge USB Live 2
References: <4D073F83.8010301@redhat.com> <AANLkTimuS+O1rv1GL_ujj4D=gSXw+VLKh0vMc2mXx1Cd@mail.gmail.com> <4D0779A7.5090807@redhat.com>
In-Reply-To: <4D0779A7.5090807@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/14/10 15:05, Mauro Carvalho Chehab wrote:
> Hi Devin,
>
> Em 14-12-2010 08:06, Devin Heitmueller escreveu:
>> On Tue, Dec 14, 2010 at 4:57 AM, Gerd Hoffmann<kraxel@redhat.com>  wrote:
>>>   Hi folks,
>>>
>>> Got a "Hauppauge USB Live 2" after google found me that there is a linux
>>> driver for it.  Unfortunaly linux doesn't manage to initialize the device.
>>>
>>> I've connected the device to a Thinkpad T60.  It runs a 2.6.37-rc5 kernel
>>> with the linuxtv/staging/for_v2.6.38 branch merged in.
>>>
>>> Kernel log and lsusb output are attached.
>>>
>>> Ideas anyone?
>>
>> Looks like a regression got introduced since I submitted the original
>> support for the device.
>>
>> Mauro?
>
> No idea what happened. The driver is working here with the devices I have.
> Unfortunately, I don't have any USB Live 2 here for testing.
>
> Based on the logs, maybe the driver is directing the I2C commands to the
> wrong bus.
>
> The better would be to bisect the kernel and see what patch broke it.
> The support for USB live2 were added on changeset 4270c3ca.
>
> There aren't many changes on it (45 changes), so, bisecting it shouldn't be hard:
>
> $ git log --oneline --no-merges 4270c3ca.. drivers/media/video/cx231xx
> f5db33f [media] cx231xx: stray unlock on error path

Using that commit directly looks better.  I still see the 
UsbInterface::sendCommand failures, but the driver seems to finish the 
initialization and looks for the firmware.  So it seems something 
between -rc2 and -rc5 in mainline made it regress ...

cheers,
   Gerd

