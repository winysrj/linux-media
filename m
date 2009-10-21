Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34496 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753711AbZJUPHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 11:07:48 -0400
Date: Wed, 21 Oct 2009 11:07:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <4ADEC4C5.8010707@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0910211052200.2847-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Oct 2009, [UTF-8] Ozan Çağlayan wrote:

> Nope it didn't help. Here's the DEBUG enabled dmesg output:

...
> [  420.737748] usb 1-5: link qh1024-0001/f6ffe280 start 1 [1/0 us]

The periodic schedule was enabled here.

> [  420.737891] usb 1-5: unlink qh1024-0001/f6ffe280 start 1 [1/0 us]

And it was disabled here.  Do you have any idea why the uvcvideo driver 
submits an interrupt URB and then cancels it 150 us later?  The same 
thing shows up in the usbmon traces.

> [  420.741605] usb 1-5:1.0: uevent
> [  420.741957] usb 1-5: uevent
> [  420.745592] usb 1-5:1.0: uevent
> [  420.807880] ehci_hcd 0000:00:1d.7: reused qh f6ffe280 schedule
> [  420.807894] usb 1-5: link qh1024-0001/f6ffe280 start 1 [1/0 us]

Now ehci-hcd tried to re-enable the periodic schedule.  Note that 
this is 70 ms after it was supposed to be disabled.

> [  420.808780] ehci_hcd 0000:00:1d.7: force halt; handhake f7c6a024
> 00004000 00000000 -> -110

This error message means that the disable request from 70 ms earlier
hasn't taken effect.  It looks like a nasty hardware bug -- the
controller is supposed to disable the schedule no more than 2 ms after
being told to do so.

Has this device ever worked with any earlier kernels?

A little more debugging information could confirm this.  After the
error occurs, go into /sys/kernel/debug/usb/ehci/0000:00:1d.7 and post
a copy of the "registers" file.  If there's anything of interest in the
other files, post them too.

Alan Stern

