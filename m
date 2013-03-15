Return-path: <linux-media-owner@vger.kernel.org>
Received: from ct35.7wei.com ([199.192.200.35]:35728 "EHLO ct35.911domain.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab3COS5Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 14:57:24 -0400
Date: Fri, 15 Mar 2013 12:45:39 -0600 (CST)
From: Moasat <moasat@moasat.dyndns.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: DVB memory leak?
Message-ID: <d5e07f9e-2bc6-4684-b00e-ea8ffbd556b9@zimbra.mdabbs.org>
In-Reply-To: <CAGoCfixans=6fOCDivGFw1yauOp-J9mrg3G+ENV5B4a7j_FfZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From: "Devin Heitmueller" <dheitmueller@kernellabs.com>
>To: moasat@moasat.dyndns.org
>Cc: linux-media@vger.kernel.org
>Sent: Friday, March 15, 2013 11:06:28 AM
>Subject: Re: DVB memory leak?
>
>On Fri, Mar 15, 2013 at 11:19 AM,  <moasat@moasat.dyndns.org> wrote:
>> I've been fighting a situation where the kernel appears to be running out of memory over a period of time.  I originally had my >low address space reserve set to 4096 and memory compaction on.  I would get this error within a few days of reboot:
>>
>
>There are probably a couple of different issues here.  It's possible
>I've got a leak in the DVB side of the au0828 where we aren't properly
>deallocating all the URBs.  Separate from that though, the allocation
>failure should be returned up the stack and the application should
>note the failure condition.  Either I've got a bug in the driver where
>it doesn't get back to userland, or MythTV doesn't actually check the
>error condition and report the failure.
>
>I've got some other fixes coming down the pipe for that driver.  Will
>take a look over the next couple of weeks and see if I can spot the
>leak.

Thanks for looking into it.  It wouldn't surprise me to find out that Myth is not checking the error condition.  But even if it did, would that keep the card functioning?  As it is, the card is useless from this point on until I reboot.  I might have to just watch logs and schedule a reboot or something until something changes.  If I was convinced that reloading the module would work I would do just that but there are some dependencies that I haven't worked out yet.  I will probably try this at some point to keep from having to reboot the entire machine.

If there's something I can help with, let me know.  I have two of these devices in the machine right now.  I can isolate one of them to another machine for testing if it would help.  I've done some kernel module development in the past so I sort of know my way around if you need me to try a patch or something.

Thanks!


