Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab2HGMkN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 08:40:13 -0400
Message-ID: <50210CA2.3060507@redhat.com>
Date: Tue, 07 Aug 2012 09:40:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] az6007: handle CI during suspend/resume
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com> <1344188679-8247-4-git-send-email-mchehab@redhat.com> <501FB6DC.3040200@iki.fi> <5020FED2.2040109@redhat.com> <50210619.7030408@iki.fi>
In-Reply-To: <50210619.7030408@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-08-2012 09:12, Antti Palosaari escreveu:
> On 08/07/2012 02:41 PM, Mauro Carvalho Chehab wrote:
>> Em 06-08-2012 09:21, Antti Palosaari escreveu:
>>> On 08/05/2012 08:44 PM, Mauro Carvalho Chehab wrote:
>>>> The dvb-usb-v2 core doesn't know anything about CI. So, the
>>>> driver needs to handle it by hand. This patch stops CI just
>>>> before stopping URB's/RC, and restarts it before URB/RC start.
>>>>
>>>> It should be noticed that suspend/resume is not yet working properly,
>>>> as the PM model requires the implementation of reset_resume:
>>>>      dvb_usb_az6007 1-6:1.0: no reset_resume for driver dvb_usb_az6007?
>>>> But this is not implemented there at dvb-usb-v2 yet.
>>>
>>> That is true, but it is coming:
>>> http://blog.palosaari.fi/2012/07/dvb-power-management-on-suspend.html
>>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/dvb_core3
>>>
>>> At the time I added initial suspend/resume support for dvb-usb-v2 I left those out purposely as I saw some study and changes are needed for DVB-core/frontend.
>>>
>>> Normally suspend keeps USB-device powered and calls .resume() on resume. But on certain conditions USB device could lose power
>>> during suspend and on that case reset_resume() is called, and if there is no reset_resume() is calls disconnect() (and probe() after that).
>>
>> This should depend on BIOS settings, and what of the following type of suspend[1]
>> was done:
>>     S1: All processor caches are flushed, and the CPU(s) stops executing instructions.
>>         Power to the CPU(s) and RAM is maintained; devices that do not indicate they
>>         must remain on may be powered down.
>>     S2: CPU powered off. Dirty cache is flushed to RAM.
>>     S3: Commonly referred to as Standby, Sleep, or Suspend to RAM. RAM remains powered
>>     S4: Hibernation or Suspend to Disk. All content of main memory is saved to non-volatile
>>         memory such as a hard drive, and is powered down.
>>
>> [1] http://en.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface
> 
> That was something I was already aware. There is even S5 and S4b mentioned by Kernel documentation. But in real life you have to care only:
> S3, Suspend, suspend to ram
> S4, Hibernation, suspend to disk

At least on some of my machines, BIOS allow to select between S1 and S3 for suspend.
Not sure how USB PM suspend works for either case.

> And from the USB-driver point of view those are covered by there three callbacks:
> .suspend()
> .resume()
> .reset_resume()
> * if reset_resume() does not exits .disconnect() + .probe() is called instead
> 
> What is my current understanding S3 level leaves USB/PCI powered normally, but device 
> driver should drop device to low power state. In case of DVB -device this means all 
> sub-drivers should put sleep.

Yes. It might make sense to keep IR working (maybe at a lower polling rate, for non-
interrupt based drivers), in order to wake machine up, if the power button is pressed,
but this would be an additional feature, and I've no idea how this would be implemented.

> S4 naturally powers everything off. Also worth to mention laptops will switch from S3 to S4 if battery drains empty during S3.

I'm not a PM expert, but as BIOS may support features like wake on LAN, it would make
sense to keep USB power, at least on those devices that may wake up the device (hid
and network devices, for example).

> 
>> There are also some per-device sysfs nodes that control how PM will work for them.
>> See:
>>
>>   $ tree /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8/dvb/dvb0.frontend0
>> /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8/dvb/dvb0.frontend0
>> ├── dev
>> ├── device -> ../../../1-8
>> ├── power
>> │   ├── async
>> │   ├── autosuspend_delay_ms
>> │   ├── control
>> │   ├── runtime_active_kids
>> │   ├── runtime_active_time
>> │   ├── runtime_enabled
>> │   ├── runtime_status
>> │   ├── runtime_suspended_time
>> │   └── runtime_usage
>> ├── subsystem -> ../../../../../../../class/dvb
>> └── uevent
>>
>> There are a number of pm functions that can change the power management behavior
>> as well.
>>
>> Not sure how to control it, but, IMHO, for a media device, it only makes sense
>> to keep it powered on suspend if the device has IR and if the power button of
>> the IR could be used to wake up the hardware. Otherwise, the better is to just
>> power it off, to save battery (for notebooks).
> 
> yeah, and it was already done.
> 
>> Maybe it makes sense to talk with Raphael Wysocki to be sure that it will cover
>> all possible cases: auto-suspend, S1/S2/S3/S4 and "wake on IR").
> 
> That IR was something I wasn't noticed at all. Currently it stops IR polling too.
> If that kind of functionality is needed it is surely some more work as you cannot 
> stop IR-polling. 

Yes. There's also an addidional case: dib0700, for example, doesn't do IR polling. 
Instead, they send an URB on a separate endpoint. When a key is pressed, the device
answers to that pending URB request with the keypress.

> Maybe I will skip it that time as I don't have time for it currently :) 
> If someone wish to learn how USB polling remote could be used for wake-up computer 
> then feel free to do that.

This is likely important for people working with embedded devices, and for people
who use softwares like mythtv to do their media centers.

Regards,
Mauro
