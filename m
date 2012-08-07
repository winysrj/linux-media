Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2HGLlQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 07:41:16 -0400
Message-ID: <5020FED2.2040109@redhat.com>
Date: Tue, 07 Aug 2012 08:41:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] az6007: handle CI during suspend/resume
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com> <1344188679-8247-4-git-send-email-mchehab@redhat.com> <501FB6DC.3040200@iki.fi>
In-Reply-To: <501FB6DC.3040200@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 09:21, Antti Palosaari escreveu:
> On 08/05/2012 08:44 PM, Mauro Carvalho Chehab wrote:
>> The dvb-usb-v2 core doesn't know anything about CI. So, the
>> driver needs to handle it by hand. This patch stops CI just
>> before stopping URB's/RC, and restarts it before URB/RC start.
>>
>> It should be noticed that suspend/resume is not yet working properly,
>> as the PM model requires the implementation of reset_resume:
>>     dvb_usb_az6007 1-6:1.0: no reset_resume for driver dvb_usb_az6007?
>> But this is not implemented there at dvb-usb-v2 yet.
> 
> That is true, but it is coming:
> http://blog.palosaari.fi/2012/07/dvb-power-management-on-suspend.html
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/dvb_core3
> 
> At the time I added initial suspend/resume support for dvb-usb-v2 I left those out purposely as I saw some study and changes are needed for DVB-core/frontend.
> 
> Normally suspend keeps USB-device powered and calls .resume() on resume. But on certain conditions USB device could lose power
> during suspend and on that case reset_resume() is called, and if there is no reset_resume() is calls disconnect() (and probe() after that).

This should depend on BIOS settings, and what of the following type of suspend[1]
was done: 
	S1: All processor caches are flushed, and the CPU(s) stops executing instructions.
	    Power to the CPU(s) and RAM is maintained; devices that do not indicate they 
	    must remain on may be powered down.
	S2: CPU powered off. Dirty cache is flushed to RAM.
	S3: Commonly referred to as Standby, Sleep, or Suspend to RAM. RAM remains powered
	S4: Hibernation or Suspend to Disk. All content of main memory is saved to non-volatile
	    memory such as a hard drive, and is powered down.

[1] http://en.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface

There are also some per-device sysfs nodes that control how PM will work for them.
See:

 $ tree /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8/dvb/dvb0.frontend0
/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8/dvb/dvb0.frontend0
├── dev
├── device -> ../../../1-8
├── power
│   ├── async
│   ├── autosuspend_delay_ms
│   ├── control
│   ├── runtime_active_kids
│   ├── runtime_active_time
│   ├── runtime_enabled
│   ├── runtime_status
│   ├── runtime_suspended_time
│   └── runtime_usage
├── subsystem -> ../../../../../../../class/dvb
└── uevent

There are a number of pm functions that can change the power management behavior
as well.

Not sure how to control it, but, IMHO, for a media device, it only makes sense
to keep it powered on suspend if the device has IR and if the power button of 
the IR could be used to wake up the hardware. Otherwise, the better is to just
power it off, to save battery (for notebooks).

Maybe it makes sense to talk with Raphael Wysocki to be sure that it will cover
all possible cases: auto-suspend, S1/S2/S3/S4 and "wake on IR").


> regards
> Antti

