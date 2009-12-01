Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbZLAJwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 04:52:31 -0500
Message-ID: <4B14E747.9060208@redhat.com>
Date: Tue, 01 Dec 2009 10:52:07 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B13BBBE.3010101@redhat.com>
In-Reply-To: <4B13BBBE.3010101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/30/09 13:34, Mauro Carvalho Chehab wrote:
> Christoph Bartelmus wrote:
>> Hi Mauro,
>>
>> I just don't want to change a working interface just because it could be
>> also implemented in a different way, but having no other visible advantage
>> than using more recent kernel features.
>
> I agree. The main reasons to review the interface is:
> 	1) to avoid any overlaps (if are there any) with the evdev interface;

Use lirc for raw samples.
Use evdev for decoded data.

Hardware/drivers which can handle both can support both interfaces.

IMHO it makes no sense at all to squeeze raw samples through the input 
layer.  It looks more like a serial line than a input device.  In fact 
you can homebrew a receiver and connect it to the serial port, which was 
quite common in pre-usb-ir-receiver times.

> 	2) to have it stable enough to be used, without changes, for a long
> 	   time.

It isn't like lirc is a new interface.  It has been used in practice for 
years.  I don't think API stability is a problem here.

> True, but even if we want to merge lirc drivers "as-is", the drivers will
> still need changes, due to kernel CodingStyle, due to the usage of some API's
> that may be deprecated, due to some breakage with non-Intel architectures, due
> to some bugs that kernel hackers may discover, etc.

I assumed this did happen in already in preparation of this submission?

cheers,
   Gerd

