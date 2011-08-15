Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:35763 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1HOIjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 04:39:18 -0400
Subject: Re: PCTV 290e - assorted problems
From: Steve Kerrison <steve@stevekerrison.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1313366738.66383.YahooMailClassic@web121710.mail.ne1.yahoo.com>
References: <1313366738.66383.YahooMailClassic@web121710.mail.ne1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 09:39:11 +0100
Message-ID: <1313397551.2818.5.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is most likely the em28xx locking bug. It'll happen when you plug a
second em28xx device in, or plug one in for a second time. The steps
you've shown include that process. Try doing `rmmod em28xx-dvb` before
re-plugging the device. If that 'cures' it, you're a victim of the same
problem.

I'm not overtly familiar with the interactions of em28xx with the rest
of the kernel & userland and why the bug manifests, but it is on my list
of things to (try to) fix, although I'm hoping somebody more able than
me figures it out first :)

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Sun, 2011-08-14 at 17:05 -0700, Chris Rankin wrote:
> >> INFO: task khubd:1100 blocked for more than 120 seconds.
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> khubd           D 0000000000000000     0  1100      2 0x00000000
> >>  ffff8801a694e930 0000000000000046 ffff8801a691ffd8 ffffffff8162b020
> >>  0000000000010280 ffff8801a691ffd8 0000000000004000 0000000000010280
> >>  ffff8801a691ffd8 ffff8801a694e930 0000000000010280 ffff8801a691e000
> >> Call Trace:
> >>  [<ffffffff8128580e>] ? apic_timer_interrupt+0xe/0x20
> >>  [<ffffffff8113ffff>] ? memscan+0x3/0x18
> >>  [<ffffffff8128354e>] ? __mutex_lock_slowpath+0x15c/0x295
> >>  [<ffffffff81283690>] ? mutex_lock+0x9/0x18
> >>  [<ffffffffa06af671>] ? dvb_init+0x99/0xcc8 [em28xx_dvb]
> >>  [<ffffffffa067d459>] ? em28xx_init_extension+0x35/0x53 [em28xx]
> >>  [<ffffffffa067b938>] ? em28xx_usb_probe+0x827/0x8df [em28xx]
> >
> > I think it crashes before it even goes to PCTV 290e specific part. I
> > suspect it is bug somewhere in em28xx driver.
> 
> The scenario that triggers this crash is:
> a) Plug the 290e in, and allow it to initialise correctly
> b) Use xine to watch any DVB-T channel successfully
> c) Try switching to previously-tuned DVB-T2 channel; this makes xine hang.
> d) Kill xine
> e) Physically replug adapter
> 
> em28xx re-initialisation will now fail:
> 
> ...
> tda18271: performing RF tracking filter calibration
> tda18271: RF tracking filter calibration complete
> usb 4-1: USB disconnect, device number 3
> em28xx #0: disconnecting em28xx #0 video
> em28xx #0: V4L2 device video1 deregistered
> tda18271 7-0060: destroying instance
> usb 4-1: new high speed USB device number 4 using ehci_hcd
> em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
> em28xx #0: chip ID is em28174
> em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
> Registered IR keymap rc-pinnacle-pctv-hd
> input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-1/rc/rc1/input8
> rc1: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-1/rc/rc1
> em28xx #0: v4l2 driver version 0.1.2
> em28xx #0: V4L2 video device registered as video1
> INFO: task khubd:1217 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> khubd           D 0000000000000000     0  1217      2 0x00000000
>  ffff8801a7081ef0 0000000000000046 ffff8801a69a9fd8 ffffffff8162b020
>  0000000000010280 ffff8801a69a9fd8 0000000000004000 0000000000010280
>  ffff8801a69a9fd8 ffff8801a7081ef0 0000000000010280 ffff8801a69a8000
> Call Trace:
>  [<ffffffff8128580e>] ? apic_timer_interrupt+0xe/0x20
>  [<ffffffff8113ffff>] ? memscan+0x3/0x18
>  [<ffffffff8128354e>] ? __mutex_lock_slowpath+0x15c/0x295
>  [<ffffffff81283690>] ? mutex_lock+0x9/0x18
>  [<ffffffffa0694671>] ? dvb_init+0x99/0xcc8 [em28xx_dvb]
>  [<ffffffffa0662459>] ? em28xx_init_extension+0x35/0x53 [em28xx]
>  [<ffffffffa0660938>] ? em28xx_usb_probe+0x827/0x8df [em28xx]
> 
> Cheers,
> Chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

