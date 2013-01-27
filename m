Return-path: <linux-media-owner@vger.kernel.org>
Received: from fold.natur.cuni.cz ([195.113.57.32]:55864 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754159Ab3A0Qly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 11:41:54 -0500
Message-ID: <510558CE.9000600@fold.natur.cuni.cz>
Date: Sun, 27 Jan 2013 17:41:50 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Yijing Wang <wangyijing0307@gmail.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com>
In-Reply-To: <5105491E.9050907@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chris Clayton wrote:
> 
> 
> On 01/27/13 14:26, Martin Mokrejs wrote:
>> Chris Clayton wrote:
>>>
>>>
>>> On 01/27/13 12:18, Yijing Wang wrote:
>>>> 于 2013-01-27 19:19, Chris Clayton 写道:
>>>>> Hi Yijing
>>>>>
>>>>> On 01/27/13 02:45, Yijing Wang wrote:
>>>>>> 于 2013-01-27 4:54, Chris Clayton 写道:
>>>>>>> Hi Martin,
>>>>>>>
>>>>>>> On 01/24/13 19:21, Martin Mokrejs wrote:
>>>>>>>> Hi Chris,
>>>>>>>>       try to include in kernel only acpiphp and omit pciehp. Don't use modules but include
>>>>>>>> them statically. And try, in addition, check whether "pcie_aspm=off" in grub.conf helped.
>>>>>>>>
>>>>>>>
>>>>>>> Thanks for the tip. I had the pciehp driver installed, but it was a module and not loaded. I didn't have acpiphp enabled at all. Building them both in statically, appears to have papered over the cracks of the oops :-)
>>>>>>
>>>>>> Not loaded pciehp driver? Remove the device from this slot without poweroff ?
>>>>>>
>>>>>
>>>>> That's correct. When I first encountered the oops, I did not have the pciehp driver loaded and removing the device from the slot whilst the laptop was powered on resulted in the oops.
>>>>
>>>> Hmm, that's unsafe and dangerous, because device now may be running.
>>>> There are two ways to trigger pci hot-add or hot-remove in linux, after loaded pciehp or acpiphp module
>>>> (the two modules only one can loaded into system at the same time). You can trigger hot-add/hot-remove by
>>>> sysfs interface under /sys/bus/pci/slots/[slot-name]/power or attention button on hardware (if your laptop supports that).
>>>>
>>>
>>> OK, thanks for the advice.
>>>
>>>>>>>
>>>>>>>>       The best would if you subscribe to linux-pci, and read my recent threads
>>>>>>>> about similar issues I had with express cards with Dell Vostro 3550. Further, there is
>>>>>>>> a lot of changes to PCI hotplug done by Yingahi Liu and Rafael Wysockij, just browse the
>>>>>>>> archives of linux-pci and see the pacthes and the discussion.
>>>>>>>
>>>>>>> Those discussions are way above my level of knowledge. I guess all this work will be merged into mainline in due course, so I'll watch for them in 3.9 or later. Unless, of course, there is a tree I could clone and help test the changes with my laptop and expresscard.
>>>>>>>
>>>>>>> Hotplug isn't working at all on my Fujitsu laptop, so I can only get the card recognised by rebooting with the card inserted (or by writing 1 to/sys/bus/pci/rescan). There seem to be a few reports on this in the kernel bugzilla, so I'll look through them and see what's being done.
>>>>>>
>>>>>> Hi Chris,
>>>>>>       What about use #modprobe pciehp pciehp_debug=1 pciehp_poll_mode=1 pciehp_poll_time=1 ?
>>>>>>
>>>>>> Can you resend the dmesg log and "lspci -vvv" info after hotplug device from your Fujitsu laptop with above module parameters?
>>>>>>
>>>>>
>>>>> I wasn't sure whether or not the pciehp driver should be loaded on its own or with the acpiphp driver also loaded. So I built them both as modules and planned to try both, pciehp only and acpiphp only. However, I've found that acpiphp will not load (regardless of whether or not pciehp is already loaded). What I get is:
>>>>>
>>>>> [chris:~]$ sudo modprobe acpiphp debug=1
>>>>> modprobe: ERROR: could not insert 'acpiphp': No such device
>>
>> Are you sure you had pciehp already loaded?
>>
> Yes, I'm sure it was.

Ah, sorry, wanted to say "Are you sure you had NOT pciehp already loaded (loaded before)?". If you retry without loading it ever you might succeed with acpiphp.

>>>>>
>>>>
>>>> Currently, If your hardware support pciehp native hotplug, acpiphp driver will be rejected when loading it in system
>>>> (you can force loading it by add boot parameter pcie_aspm=off as Martin said).
>>>>
>>>
>>> OK, thanks again for the advice. I've disabled the acpiphp driver.
>>
>> Pitty. For me only with acpiphp works detection of express card in the slot. With pciehp
>> the PresDet is not updated properly upon removal/insertion and sometimes, probably as a result
>> of the previous, PresDet on the SltSta: line of lspci is not correct. So I moved away from pciehp.
>> I have a SandyBridge based laptop so I was hoping with your i5-based laptop you have also great
>> chance to get rid of pciehp issues.
>>
> 
> I've just (very carefully) set this up again (i.e. no pciehp driver (module or builtin), acpiphp driver built in and pcie_aspm=off on the kernel command line (via grub). My card is not detected on insertion. :-(

Do you have any other express card around to try if it works at all? Try that always after a cold boot.

Posting a diff result of the below procedure might help:

# lspci -vvvxxx > lspci.before_insertion.txt

[plug your card into the slot]

# lspci -vvvxxx > lspci.after_insertion.txt

[ unplug your card]

# lspci -vvvxxx > lspci.after_1st_removal.txt

[re-plug your card into the slot]

# lspci -vvvxxx > lspci.after_1st_re-insertion.txt

[ unplug your card]

# lspci -vvvxxx > lspci.after_2nd_removal.txt

Then compare them using diff. These should have no difference:

diff lspci.after_insertion.txt lspci.after_1st_re-insertion.txt
diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt


These may have only little difference, or none:

diff lspci.before_insertion.txt lspci.after_1st_removal.txt
diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt



Finally, these should confirm whether the PresDet works for you (for me NOT with pciehp but does work with acpiphp).
You should see PresDet- to PresDet+ changes in:

diff lspci.before_insertion.txt lspci.after_insertion.txt
diff lspci.after_1st_removal.txt lspci.after_1st_re-insertion.txt

You should see PresDet+ to PresDet- changes in:
diff lspci.after_insertion.txt lspci.after_1st_removal.txt
diff lspci.after_1st_re-insertion.txt lspci.after_2nd_removal.txt


I did plenty of these with my laptop using 3.3.x and 3.7.1 and the conclusion was
that pciehp got broken since some 3.6? (commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a)
but I can live on 3.7.x with acpiphp and pcie_aspm=off. The above test could tell you what
works in your case. Of course, you can try separately pciehp and acpiphp. With 3.4
series I lived with pciehp and pcie_aspm=force.


Martin
BTW: Re-post your dmesg output so that we can see if you those OSC errors
(for details see "Re: Dell Vostro 3550: pci_hotplug+acpiphp require 'pcie_aspm=force' on kernel command-line for hotplug to work" thread).
