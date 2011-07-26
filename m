Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1GZR5X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 13:57:23 -0400
Message-ID: <4E2EFFF0.3000904@redhat.com>
Date: Tue, 26 Jul 2011 13:57:04 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Chris W <lkml@psychogeeks.com>
CC: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH] [media] imon: don't parse scancodes until intf configured
References: <D7E52A85-331A-4650-94F0-C1477F457457@redhat.com> <1311091967-2791-1-git-send-email-jarod@redhat.com> <4E25FFB7.70205@psychogeeks.com> <20110720131830.GC9799@redhat.com> <4E275D2A.9070200@psychogeeks.com>
In-Reply-To: <4E275D2A.9070200@psychogeeks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chris W wrote:
> On 20/07/11 23:18, Jarod Wilson wrote:
>> On Wed, Jul 20, 2011 at 08:05:43AM +1000, Chris W wrote:
>>> On 20/07/11 02:12, Jarod Wilson wrote:
>>>> The imon devices have either 1 or 2 usb interfaces on them, each wired
>>>> up to its own urb callback. The interface 0 urb callback is wired up
>>>> before the imon context's rc_dev pointer is filled in, which is
>>>> necessary for imon 0xffdc device auto-detection to work properly, but
>>>> we need to make sure we don't actually run the callback routines until
>>>> we've entirely filled in the necessary bits for each given interface,
>>>> lest we wind up oopsing. Technically, any imon device could have hit
>>>> this, but the issue is exacerbated on the 0xffdc devices, which send a
>>>> constant stream of interrupts, even when they have no valid key data.
>>>
>>>
>>> OK.  The patch applies and everything continues to work.   There is no
>>> obvious difference in the dmesg output on module load, with my device
>>> remaining unidentified.  I don't know if that is indicative of anything.
>> Did you apply this patch on top of the earlier patch, or instead of it?
>
> On top of it.   I've reversed the patches and installed just the last
> one with this result on loading the module:
>
> input: iMON Panel, Knob and Mouse(15c2:ffdc) as
> /devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/input/input8
> imon 4-2:1.0: 0xffdc iMON VFD, iMON IR (id 0x24)
> Registered IR keymap rc-imon-pad
> input: iMON Remote (15c2:ffdc) as
> /devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/rc/rc3/input9
> rc3: iMON Remote (15c2:ffdc) as
> /devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/rc/rc3
> imon 4-2:1.0: iMON device (15c2:ffdc, intf0) on usb<4:3>  initialized
> usbcore: registered new interface driver imon
>
> Much better.

Yeah, that looks sane now. We missed 3.0, but I'll try to flag this one 
to go into the various stable trees when it gets merged for 3.1.


>>> intf0 decoded packet: 00 00 00 00 00 00 24 01
>>> intf0 decoded packet: 00 00 00 00 00 00 24 01
>>> intf0 decoded packet: 00 00 00 00 00 00 24 01
>> One other amusing tidbit: you get continuous spew like the above, because
>> to date, I thought all the ffdc devices had "nothing to report" spew that
>> started with 0xffffff, which we filter out. Sigh. I hate imon hardware...
>
> I am beginning to understand why. That output was only printed with the
> "debug=1" option and is not printed with the patched module.

Yup. The additional filtering was added because my own ffdc imon devices 
were so noisy, it was next to impossible to see what was going on when 
trying to debug anything.


-- 
Jarod Wilson
jarod@redhat.com


