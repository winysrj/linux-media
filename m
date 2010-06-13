Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59928 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0FMOVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 10:21:41 -0400
Message-ID: <4C14E971.5020604@gmail.com>
Date: Sun, 13 Jun 2010 16:21:37 +0200
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "C. Hemsing" <C.Hemsing@gmx.net>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: was: af9015, af9013 DVB-T problems. now: Intermittent USB disconnects
 with many (2.0) high speed devices
References: <Pine.LNX.4.44L0.1006130954180.22182-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006130954180.22182-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.06.2010 15:57, schrieb Alan Stern:
> On Sun, 13 Jun 2010, thomas schorpp wrote:
>
>> ehci-hcd is broken and halts silently or disconnects after hours or a few days, with the wlan usb adapter
>
> How do you know the bug is in ehci-hcd and not in the hardware?

All 3 usb devices and 2 different series VIA usb hosts and Hemsing's and many other broken i2c comms reporter's on linux-media are broken instead?
Well, if we get that confirmed, I'll buy 2 of those with NEC chipset:
http://cgi.ebay.de/ws/eBayISAPI.dll?ViewItem&item=190318779935

>
>> I was able to catch a dmesg err message like "ehci...force halt... handshake failed" once only.
>
> Can you please post the error message?

Jun  3 08:38:29 tom3 kernel: [75071.004062] ehci_hcd 0000:00:0e.2: force halt; handhake cc9c0814 0000c000 00000000 -> -110
Jun  3 08:45:13 tom3 kernel: [75475.004061] ehci_hcd 0000:00:0e.2: force halt; handhake cc9c0814 0000c000 00000000 -> -110
Previous debian testing version of Linux tom3 2.6.32-5-686 #1 SMP Tue Jun 1 04:59:47 UTC 2010 i686 GNU/Linux,
not yet reproduced with current version.
>
>> The disconnects with dvb-usb need reboot cause driver cannot be removed with modprobe.
>
> That sounds like it might be a bug in dvb-usb driver.  It always should
> be possible to remove the driver.

Sure.

>
>> This long standing bug is really nasty and makes permanent high speed usb connections unusable on Linux,
>> at least with this VIA hardware.
>>
>> No debug parms in modules, we need to ask linux-usb how to debug this.
>
> You can start by building a kernel with CONFIG_USB_DEBUG enabled.

Yes, will do it, thx.

>
> Alan Stern
>
>

y
tom
