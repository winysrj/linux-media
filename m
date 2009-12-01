Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:35409
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZLAOco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 09:32:44 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4B14E747.9060208@redhat.com>
Date: Tue, 1 Dec 2009 09:32:42 -0500
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jonsmirl@gmail.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <119343FC-A4FF-456A-8709-36ED941AC9C3@wilsonet.com>
References: <BDodf9W1qgB@lirc> <4B13BBBE.3010101@redhat.com> <4B14E747.9060208@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dec 1, 2009, at 4:52 AM, Gerd Hoffmann wrote:

> On 11/30/09 13:34, Mauro Carvalho Chehab wrote:
>> Christoph Bartelmus wrote:
>>> Hi Mauro,
>>> 
>>> I just don't want to change a working interface just because it could be
>>> also implemented in a different way, but having no other visible advantage
>>> than using more recent kernel features.
>> 
>> I agree. The main reasons to review the interface is:
>> 	1) to avoid any overlaps (if are there any) with the evdev interface;
> 
> Use lirc for raw samples.
> Use evdev for decoded data.

This is the approach I'm pretty well settled on wanting to take myself.

> Hardware/drivers which can handle both can support both interfaces.

Exactly.

> IMHO it makes no sense at all to squeeze raw samples through the input layer.  It looks more like a serial line than a input device.  In fact you can homebrew a receiver and connect it to the serial port, which was quite common in pre-usb-ir-receiver times.
> 
>> 	2) to have it stable enough to be used, without changes, for a long
>> 	   time.
> 
> It isn't like lirc is a new interface.  It has been used in practice for years.  I don't think API stability is a problem here.

Yeah, in the ~3 years I've been maintaining lirc patches for the Fedora kernels, only once has something happened where new userspace could no longer talk to old kernelspace. The majority of the work has been keeping things running as kernel interfaces change -- the 2.6.31 i2c changes are still biting us, as some capture card devices lagged behind a bit on converting to the new i2c scheme, making it impossible for lirc_i2c and/or lirc_zilog to bind (and ir-kbd-i2c, for that matter).

>> True, but even if we want to merge lirc drivers "as-is", the drivers will
>> still need changes, due to kernel CodingStyle, due to the usage of some API's
>> that may be deprecated, due to some breakage with non-Intel architectures, due
>> to some bugs that kernel hackers may discover, etc.
> 
> I assumed this did happen in already in preparation of this submission?

Yes. There may still be a bit of work to do here, but there was a crew of us about a year, year and a half ago, that did a major sweep through all the lirc drivers, reformatting things so that we were at least mostly checkpatch-clean. The original lirc patches I put into the Fedora Core 6 kernel had several thousand lines of warnings and errors, while with the current lirc patches in Fedora 12, I get:

total: 1 errors, 12 warnings, 15987 lines checked

The error is new, hadn't seen that one before, going to fix it now... :) The warnings are almost all the same thing, "WARNING: struct file_operations should normally be const", need to fix that too, though we actually do edit the lirc_fops on a per-device basis right now, so they can't be const...

Okay, the error and one of the warnings are gone from my local tree, now its all just the above.

But yeah, for the most part, I think the coding style and formatting of the lirc drivers *does* look like kernel code these days, minor fixages suggested in Mauro's review aside. I submitted only a 3-part series (lirc_dev, lirc_mceusb and lirc_imon) to keep from overwhelming anyone (myself included) with too much code at once, and went with the two device drivers that I've personally done the most work on and have several devices driven by (which includes the IR parts I've been using in my "production" MythTV setup for years now).

-- 
Jarod Wilson
jarod@wilsonet.com



