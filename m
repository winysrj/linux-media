Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm19-vm6.bullet.mail.ne1.yahoo.com ([98.138.91.112]:26359 "HELO
	nm19-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750783Ab1HOAFj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 20:05:39 -0400
Message-ID: <1313366738.66383.YahooMailClassic@web121710.mail.ne1.yahoo.com>
Date: Sun, 14 Aug 2011 17:05:38 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: PCTV 290e - assorted problems
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> INFO: task khubd:1100 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> khubd           D 0000000000000000     0  1100      2 0x00000000
>>  ffff8801a694e930 0000000000000046 ffff8801a691ffd8 ffffffff8162b020
>>  0000000000010280 ffff8801a691ffd8 0000000000004000 0000000000010280
>>  ffff8801a691ffd8 ffff8801a694e930 0000000000010280 ffff8801a691e000
>> Call Trace:
>>  [<ffffffff8128580e>] ? apic_timer_interrupt+0xe/0x20
>>  [<ffffffff8113ffff>] ? memscan+0x3/0x18
>>  [<ffffffff8128354e>] ? __mutex_lock_slowpath+0x15c/0x295
>>  [<ffffffff81283690>] ? mutex_lock+0x9/0x18
>>  [<ffffffffa06af671>] ? dvb_init+0x99/0xcc8 [em28xx_dvb]
>>  [<ffffffffa067d459>] ? em28xx_init_extension+0x35/0x53 [em28xx]
>>  [<ffffffffa067b938>] ? em28xx_usb_probe+0x827/0x8df [em28xx]
>
> I think it crashes before it even goes to PCTV 290e specific part. I
> suspect it is bug somewhere in em28xx driver.

The scenario that triggers this crash is:
a) Plug the 290e in, and allow it to initialise correctly
b) Use xine to watch any DVB-T channel successfully
c) Try switching to previously-tuned DVB-T2 channel; this makes xine hang.
d) Kill xine
e) Physically replug adapter

em28xx re-initialisation will now fail:

...
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete
usb 4-1: USB disconnect, device number 3
em28xx #0: disconnecting em28xx #0 video
em28xx #0: V4L2 device video1 deregistered
tda18271 7-0060: destroying instance
usb 4-1: new high speed USB device number 4 using ehci_hcd
em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
em28xx #0: chip ID is em28174
em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
Registered IR keymap rc-pinnacle-pctv-hd
input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-1/rc/rc1/input8
rc1: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-1/rc/rc1
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video1
INFO: task khubd:1217 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd           D 0000000000000000     0  1217      2 0x00000000
 ffff8801a7081ef0 0000000000000046 ffff8801a69a9fd8 ffffffff8162b020
 0000000000010280 ffff8801a69a9fd8 0000000000004000 0000000000010280
 ffff8801a69a9fd8 ffff8801a7081ef0 0000000000010280 ffff8801a69a8000
Call Trace:
 [<ffffffff8128580e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8113ffff>] ? memscan+0x3/0x18
 [<ffffffff8128354e>] ? __mutex_lock_slowpath+0x15c/0x295
 [<ffffffff81283690>] ? mutex_lock+0x9/0x18
 [<ffffffffa0694671>] ? dvb_init+0x99/0xcc8 [em28xx_dvb]
 [<ffffffffa0662459>] ? em28xx_init_extension+0x35/0x53 [em28xx]
 [<ffffffffa0660938>] ? em28xx_usb_probe+0x827/0x8df [em28xx]

Cheers,
Chris

