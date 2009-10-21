Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.uludag.org.tr ([193.140.100.216]:56799 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZJUPil (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 11:38:41 -0400
Message-ID: <4ADF2B06.7090801@pardus.org.tr>
Date: Wed, 21 Oct 2009 18:38:46 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: uvcvideo causes ehci_hcd to halt
References: <Pine.LNX.4.44L0.0910211052200.2847-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910211052200.2847-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:

(Add uvcvideo maintainer to CC)
> [  420.737748] usb 1-5: link qh1024-0001/f6ffe280 start 1 [1/0 us]
>   
>
> The periodic schedule was enabled here.
>
>   
>> [  420.737891] usb 1-5: unlink qh1024-0001/f6ffe280 start 1 [1/0 us]
>>     
>
> And it was disabled here.  Do you have any idea why the uvcvideo driver 
> submits an interrupt URB and then cancels it 150 us later?  The same 
> thing shows up in the usbmon traces.
>
>   
>> [  420.741605] usb 1-5:1.0: uevent
>> [  420.741957] usb 1-5: uevent
>> [  420.745592] usb 1-5:1.0: uevent
>> [  420.807880] ehci_hcd 0000:00:1d.7: reused qh f6ffe280 schedule
>> [  420.807894] usb 1-5: link qh1024-0001/f6ffe280 start 1 [1/0 us]
>>     
>
> Now ehci-hcd tried to re-enable the periodic schedule.  Note that 
> this is 70 ms after it was supposed to be disabled.
>
>   
>> [  420.808780] ehci_hcd 0000:00:1d.7: force halt; handhake f7c6a024
>> 00004000 00000000 -> -110
>>     
>
> This error message means that the disable request from 70 ms earlier
> hasn't taken effect.  It looks like a nasty hardware bug -- the
> controller is supposed to disable the schedule no more than 2 ms after
> being told to do so.
>
> Has this device ever worked with any earlier kernels?
>   

I only tried 2.6.30.9 and 2.6.31.4, both of them is affected by the same
problem but sometimes it works without a problem so I think that this
can be interpreted as *at-least-working* on those kernels from time to time.

> A little more debugging information could confirm this.  After the
> error occurs, go into /sys/kernel/debug/usb/ehci/0000:00:1d.7 and post
> a copy of the "registers" file.  If there's anything of interest in the
> other files, post them too.
>   

OK I'll look at them tomorrow, Thanks.

