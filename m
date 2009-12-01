Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZLANMH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 08:12:07 -0500
Message-ID: <4B15161A.80101@redhat.com>
Date: Tue, 01 Dec 2009 11:11:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B13BBBE.3010101@redhat.com> <4B14E747.9060208@redhat.com>
In-Reply-To: <4B14E747.9060208@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann wrote:
> On 11/30/09 13:34, Mauro Carvalho Chehab wrote:
>> Christoph Bartelmus wrote:
>>> Hi Mauro,
>>>
>>> I just don't want to change a working interface just because it could be
>>> also implemented in a different way, but having no other visible
>>> advantage
>>> than using more recent kernel features.
>>
>> I agree. The main reasons to review the interface is:
>>     1) to avoid any overlaps (if are there any) with the evdev interface;
> 
> Use lirc for raw samples.
> Use evdev for decoded data.
> 
> Hardware/drivers which can handle both can support both interfaces.
> IMHO it makes no sense at all to squeeze raw samples through the input
> layer.  It looks more like a serial line than a input device.  In fact
> you can homebrew a receiver and connect it to the serial port, which was
> quite common in pre-usb-ir-receiver times.

I agree. 
> 
>>     2) to have it stable enough to be used, without changes, for a long
>>        time.
> 
> It isn't like lirc is a new interface.  It has been used in practice for
> years.  I don't think API stability is a problem here.

You're probably right here, but, as, currently, changing the API is not a problem,
I don't doubt that the API has changed during those years (I haven't followed
lirc API, so this is just an educated guess).

So, all I'm saying is that we should do a final review considering API stability
before merging it, eventually considering to add a few reserved fields there, if
we suspect that we might need more space for some reason.

>> True, but even if we want to merge lirc drivers "as-is", the drivers will
>> still need changes, due to kernel CodingStyle, due to the usage of
>> some API's
>> that may be deprecated, due to some breakage with non-Intel
>> architectures, due
>> to some bugs that kernel hackers may discover, etc.
> 
> I assumed this did happen in already in preparation of this submission?

Yes, for just a few drivers that went on the first series of patches (on Jerod's
proposal, only 2 drivers were submitted).

Cheers,
Mauro.
