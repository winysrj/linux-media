Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZLARhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 12:37:31 -0500
Message-ID: <4B15543F.1000604@redhat.com>
Date: Tue, 01 Dec 2009 15:37:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Jon Smirl <jonsmirl@gmail.com>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com> <1259682428.18599.10.camel@maxim-laptop>
In-Reply-To: <1259682428.18599.10.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxim Levitsky wrote:
> On Tue, 2009-12-01 at 10:08 -0500, Jon Smirl wrote: 
>> While reading all of these IR threads another way of handling IR
>> occurred to me that pretty much eliminates the need for LIRC and
>> configuration files in default cases. The best way to make everything
>> "just work" is to eliminate it.
>>
>> The first observation is that the IR profile of various devices are
>> well known. Most devices profiles are in the published One-for-All
>> database. These device profiles consist of vendor/device/command
>> triplets. There is one triplet for each command like play, pause, 1,
>> 2, 3, power, etc.
>>
>> The second observation is that universal remotes know how to generate
>> commands for all of the common devices.
>>
>> Let's define evdev messages for IR than contain vendor/device/command
>> triplets. I already posted code for doing that in my original patch
>> set. These messages are generated from in-kernel code.
>>
>> Now add a small amount of code to MythTV, etc to act on these evdev
>> messages. Default MythTV, etc to respond to the IR commands for a
>> common DVR device. Program your universal remote to send the commands
>> for this device. You're done. Everything will "just work" - no LIRC,
>> no irrecord, no config files, no command mapping, etc.
> You are making one  big wrong assumption that everyone that has a remote
> uses mythtv, and only it.
> 
> Many users including me, use the remote just like a keyboard, or even
> like a mouse.

+1. 

I also use the remote as a keyboard replacement. I used an IR like
that for a long time while teaching, using a standard USB video board,
as a way to remotely control my notebook.

Well, now I have an USB IR for this usage, using HID, that emulates
both keyboard and mouse. In fact, the application didn't change. 
I'm just using the standard USB class for HID, instead of using
vendor class to generate the same kind of evdev events ;)

Cheers,
Mauro.
