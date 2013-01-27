Return-path: <linux-media-owner@vger.kernel.org>
Received: from fold.natur.cuni.cz ([195.113.57.32]:60032 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755404Ab3A0O0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 09:26:34 -0500
Message-ID: <51053917.6060400@fold.natur.cuni.cz>
Date: Sun, 27 Jan 2013 15:26:31 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Yijing Wang <wangyijing0307@gmail.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com>
In-Reply-To: <51052DB2.4090702@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chris Clayton wrote:
> 
> 
> On 01/27/13 12:18, Yijing Wang wrote:
>> 于 2013-01-27 19:19, Chris Clayton 写道:
>>> Hi Yijing
>>>
>>> On 01/27/13 02:45, Yijing Wang wrote:
>>>> 于 2013-01-27 4:54, Chris Clayton 写道:
>>>>> Hi Martin,
>>>>>
>>>>> On 01/24/13 19:21, Martin Mokrejs wrote:
>>>>>> Hi Chris,
>>>>>>      try to include in kernel only acpiphp and omit pciehp. Don't use modules but include
>>>>>> them statically. And try, in addition, check whether "pcie_aspm=off" in grub.conf helped.
>>>>>>
>>>>>
>>>>> Thanks for the tip. I had the pciehp driver installed, but it was a module and not loaded. I didn't have acpiphp enabled at all. Building them both in statically, appears to have papered over the cracks of the oops :-)
>>>>
>>>> Not loaded pciehp driver? Remove the device from this slot without poweroff ?
>>>>
>>>
>>> That's correct. When I first encountered the oops, I did not have the pciehp driver loaded and removing the device from the slot whilst the laptop was powered on resulted in the oops.
>>
>> Hmm, that's unsafe and dangerous, because device now may be running.
>> There are two ways to trigger pci hot-add or hot-remove in linux, after loaded pciehp or acpiphp module
>> (the two modules only one can loaded into system at the same time). You can trigger hot-add/hot-remove by
>> sysfs interface under /sys/bus/pci/slots/[slot-name]/power or attention button on hardware (if your laptop supports that).
>>
> 
> OK, thanks for the advice.
> 
>>>>>
>>>>>>      The best would if you subscribe to linux-pci, and read my recent threads
>>>>>> about similar issues I had with express cards with Dell Vostro 3550. Further, there is
>>>>>> a lot of changes to PCI hotplug done by Yingahi Liu and Rafael Wysockij, just browse the
>>>>>> archives of linux-pci and see the pacthes and the discussion.
>>>>>
>>>>> Those discussions are way above my level of knowledge. I guess all this work will be merged into mainline in due course, so I'll watch for them in 3.9 or later. Unless, of course, there is a tree I could clone and help test the changes with my laptop and expresscard.
>>>>>
>>>>> Hotplug isn't working at all on my Fujitsu laptop, so I can only get the card recognised by rebooting with the card inserted (or by writing 1 to/sys/bus/pci/rescan). There seem to be a few reports on this in the kernel bugzilla, so I'll look through them and see what's being done.
>>>>
>>>> Hi Chris,
>>>>      What about use #modprobe pciehp pciehp_debug=1 pciehp_poll_mode=1 pciehp_poll_time=1 ?
>>>>
>>>> Can you resend the dmesg log and "lspci -vvv" info after hotplug device from your Fujitsu laptop with above module parameters?
>>>>
>>>
>>> I wasn't sure whether or not the pciehp driver should be loaded on its own or with the acpiphp driver also loaded. So I built them both as modules and planned to try both, pciehp only and acpiphp only. However, I've found that acpiphp will not load (regardless of whether or not pciehp is already loaded). What I get is:
>>>
>>> [chris:~]$ sudo modprobe acpiphp debug=1
>>> modprobe: ERROR: could not insert 'acpiphp': No such device

Are you sure you had pciehp already loaded?

>>>
>>
>> Currently, If your hardware support pciehp native hotplug, acpiphp driver will be rejected when loading it in system
>> (you can force loading it by add boot parameter pcie_aspm=off as Martin said).
>>
> 
> OK, thanks again for the advice. I've disabled the acpiphp driver.

Pitty. For me only with acpiphp works detection of express card in the slot. With pciehp
the PresDet is not updated properly upon removal/insertion and sometimes, probably as a result
of the previous, PresDet on the SltSta: line of lspci is not correct. So I moved away from pciehp.
I have a SandyBridge based laptop so I was hoping with your i5-based laptop you have also great
chance to get rid of pciehp issues.

Martin
