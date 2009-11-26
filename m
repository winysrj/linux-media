Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:41354
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031AbZKZR1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 12:27:39 -0500
Message-ID: <4B0EBBB5.5090303@wilsonet.com>
Date: Thu, 26 Nov 2009 12:32:37 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com> <4B0E889C.9060405@redhat.com>
In-Reply-To: <4B0E889C.9060405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2009 08:54 AM, Mauro Carvalho Chehab wrote:
> Jarod Wilson wrote:
>> On Nov 23, 2009, at 7:53 PM, Andy Walls wrote:
>>
>>> On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
>> ...
>>> I generally don't understand the LIRC aversion I perceive in this thread
>>> (maybe I just have a skewed perception).  Aside for a video card's
>>> default remote setup, the suggestions so far don't strike me as any
>>> simpler for the end user than LIRC -- maybe I'm just used to LIRC.  LIRC
>>> already works for both transmit and receive and has existing support in
>>> applications such as MythTV and mplayer.
>>
>> There's one gripe I agree with, and that is that its still not plug-n-play.
>> Something where udev auto-loads a sane default remote config for say,
>> mceusb transceivers, and the stock mce remote Just Works would be nice,
>> but auto-config is mostly out the window the second you involve transmitters
>> and universal remotes anyway.
>
> For several devices, an udev rule that auto-loads a sane default keymap does work.
> Of course, this won't cover 100% of the usages, and I lirc is a very good way
> of covering the holes.
>
>> But outside of that, I think objections are largely philosophical --
>> in a nutshell, the kernel has an input layer, remotes are input devices,
>> and lirc doesn't conform to input layer standards.
>
> Yes. I think this is mainly the issue.
>
> The other issue is how to migrate the existing drivers to a new API without
> causing regressions. If we decide that IR's that receive raw pulse/code
> should use the raw input interface, this means that a large task force will be
> needed to convert the existing drivers to use it.

Aversion to regression is definitely a major concern. And why I'm liking 
the idea of a hybrid approach, at least initially.

> What do you think of adding lirc at staging while we discuss/improve the API's and lircd
> support for the input event interface? Do you think this would work?

Sure, I don't see why not. And I've got another dozen or so drivers to 
follow those first three... :)

-- 
Jarod Wilson
jarod@wilsonet.com
