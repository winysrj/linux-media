Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63297 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0FMTKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 15:10:04 -0400
Message-ID: <4C152D08.7060007@gmail.com>
Date: Sun, 13 Jun 2010 21:10:00 +0200
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "C. Hemsing" <C.Hemsing@gmx.net>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: was: af9015, af9013 DVB-T problems. now: Intermittent USB disconnects
 with many (2.0) high speed devices
References: <Pine.LNX.4.44L0.1006131117530.23535-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006131117530.23535-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.06.2010 17:22, schrieb Alan Stern:
> On Sun, 13 Jun 2010, thomas schorpp wrote:
>
>> Am 13.06.2010 15:57, schrieb Alan Stern:
>>> On Sun, 13 Jun 2010, thomas schorpp wrote:
>>>
>>>> ehci-hcd is broken and halts silently or disconnects after hours or a few days, with the wlan usb adapter
>>>
>>> How do you know the bug is in ehci-hcd and not in the hardware?
>>
>> All 3 usb devices and 2 different series VIA usb hosts and Hemsing's and many other broken i2c comms reporter's on linux-media are broken instead?
>
> It's certainly possible and has been known to happen.
>
>> Well, if we get that confirmed, I'll buy 2 of those with NEC chipset:
>> http://cgi.ebay.de/ws/eBayISAPI.dll?ViewItem&item=190318779935
>>
>>>
>>>> I was able to catch a dmesg err message like "ehci...force halt... handshake failed" once only.
>>>
>>> Can you please post the error message?
>>
>> Jun  3 08:38:29 tom3 kernel: [75071.004062] ehci_hcd 0000:00:0e.2: force halt; handhake cc9c0814 0000c000 00000000 ->  -110
>> Jun  3 08:45:13 tom3 kernel: [75475.004061] ehci_hcd 0000:00:0e.2: force halt; handhake cc9c0814 0000c000 00000000 ->  -110
>> Previous debian testing version of Linux tom3 2.6.32-5-686 #1 SMP Tue Jun 1 04:59:47 UTC 2010 i686 GNU/Linux,
>> not yet reproduced with current version.

Reproducible with the new debian testing kernel:

[90395.572222] usb 4-4: USB disconnect, address 3
[90395.585864] wlan0: deauthenticating from 00:19:cb:87:5e:4a by local choice (reason=3)
[90396.100206] usb 4-4: new high speed USB device using ehci_hcd and address 4
[90411.192304] hub 4-0:1.0: unable to enumerate USB device on port 4
[90411.448242] usb 3-2: new full speed USB device using uhci_hcd and address 3
[90411.635297] usb 3-2: not running at top speed; connect to a high speed hub
[90411.757316] usb 3-2: New USB device found, idVendor=148f, idProduct=2573
...
[90412.212601] Registered led device: rt73usb-phy4::quality
[90414.004060] ehci_hcd 0000:00:0e.2: force halt; handhake cca1a814 0000c000 00000000 -> -110

Trying to reproduce in full speed only mode without ehci_hcd driver loaded.

>
> You may need to copy the "broken periodic workaround" code from the
> PCI_VENDOR_ID_INTEL case in ehci_pci_setup(),
> drivers/usb/host/ehci-pci.c into the PCI_VENDOR_ID_VIA case.

Yes, will do this on the machine with the 2.6.34 kernel and watch the dvb-usb stick for disconnects to report.

>
> Alan Stern
>
>

Thank You very much,
y
tom
