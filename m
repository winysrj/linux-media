Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZK3MeR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 07:34:17 -0500
Message-ID: <4B13BBBE.3010101@redhat.com>
Date: Mon, 30 Nov 2009 10:34:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, jonsmirl@gmail.com,
	khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc>
In-Reply-To: <BDodf9W1qgB@lirc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Bartelmus wrote:
> Hi Mauro,
> 
> I just don't want to change a working interface just because it could be  
> also implemented in a different way, but having no other visible advantage  
> than using more recent kernel features.

I agree. The main reasons to review the interface is:
	1) to avoid any overlaps (if are there any) with the evdev interface;
	2) to have it stable enough to be used, without changes, for a long
	   time.

>> I haven't seen such limitations on his proposal. We currently have in-kernel
>> decoders for NEC, pulse-distance, RC4 protocols, and some variants. If
>> non-RC5 decoders are missing, we need for sure to add them.
> 
> That was not my point. If you point a NEC remote at the Igor USB device,  
> you won't be able to use a NEC decoder because the device will swallow  
> half of the bits. LIRC won't care unless the resulting scancodes are  
> identical.

If the difference is just the bits order, and assuming that we use a standard
NEC decoder, a (kernel) driver will simply provide a different scancode for
that device, and the keymap table will be different, but it will still work
(an can still be plug and play).

In this specific case, we can opt to simply don't add any special hack for
Igor USB at the driver, but to leting the userspace tool to invert the bits
order when loading the keymap for that device.

>> Providing that we agree on what we'll do, I don't see why not
>> adding it on staging for 2.6.33 and targeting to have
>> everything done for 2.6.34 or 2.6.35.
> 
> The problem that I see here is just that even when we have very talented  
> people working on this, that put together all resources, we won't be able  
> to cover all the corner cases with all the different receivers and remote  
> control protocols out there. It will still require lots of fine-tuning  
> which was done in LIRC over the years.

True, but even if we want to merge lirc drivers "as-is", the drivers will
still need changes, due to kernel CodingStyle, due to the usage of some API's
that may be deprecated, due to some breakage with non-Intel architectures, due
to some bugs that kernel hackers may discover, etc. 

Also, there will be the needs for integrating with V4L/DVB code that may
also require some changes.

So, the drivers will still be different than what you currently have
and they may still need some fine-tuning after the merge.

Cheers,
Mauro
