Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZKZRtY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 12:49:24 -0500
Message-ID: <4B0EBF99.1070404@redhat.com>
Date: Thu, 26 Nov 2009 15:49:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com> <4B0E889C.9060405@redhat.com> <4B0EBBB5.5090303@wilsonet.com>
In-Reply-To: <4B0EBBB5.5090303@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> On 11/26/2009 08:54 AM, Mauro Carvalho Chehab wrote:
>> Jarod Wilson wrote:
>>> On Nov 23, 2009, at 7:53 PM, Andy Walls wrote:
>>>
>>>> On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
>>> ...
>>>> I generally don't understand the LIRC aversion I perceive in this
>>>> thread
>>>> (maybe I just have a skewed perception).  Aside for a video card's
>>>> default remote setup, the suggestions so far don't strike me as any
>>>> simpler for the end user than LIRC -- maybe I'm just used to LIRC. 
>>>> LIRC
>>>> already works for both transmit and receive and has existing support in
>>>> applications such as MythTV and mplayer.
>>>
>>> There's one gripe I agree with, and that is that its still not
>>> plug-n-play.
>>> Something where udev auto-loads a sane default remote config for say,
>>> mceusb transceivers, and the stock mce remote Just Works would be nice,
>>> but auto-config is mostly out the window the second you involve
>>> transmitters
>>> and universal remotes anyway.
>>
>> For several devices, an udev rule that auto-loads a sane default
>> keymap does work.
>> Of course, this won't cover 100% of the usages, and I lirc is a very
>> good way
>> of covering the holes.
>>
>>> But outside of that, I think objections are largely philosophical --
>>> in a nutshell, the kernel has an input layer, remotes are input devices,
>>> and lirc doesn't conform to input layer standards.
>>
>> Yes. I think this is mainly the issue.
>>
>> The other issue is how to migrate the existing drivers to a new API
>> without
>> causing regressions. If we decide that IR's that receive raw pulse/code
>> should use the raw input interface, this means that a large task force
>> will be
>> needed to convert the existing drivers to use it.
> 
> Aversion to regression is definitely a major concern. And why I'm liking
> the idea of a hybrid approach, at least initially.

Yes. This indeed seems to be a very good idea.
> 
>> What do you think of adding lirc at staging while we discuss/improve
>> the API's and lircd
>> support for the input event interface? Do you think this would work?
> 
> Sure, I don't see why not. And I've got another dozen or so drivers to
> follow those first three... :)

Ok. As you said you'll do some work at the patches, could you please send us v3
in order to add it into drivers/staging? 

In the case of the API header file, I would tag at the header file that the API
is experimental, so can be changed without prior announcements, etc (in order to
avoid people to use and rely on it it outside lirc). IMO, the better is to keep
such announcement there while we're still working at the hybrid approach, as we
may need to change something during the development phase.

Dmitry,

While lirc is basically a series of input drivers, considering that they have lots
in common with the input drivers at V4L/DVB and that we'll need to work on
some glue to merge both, do you mind if I add the lirc drivers at drivers/staging from
my trees? 

Cheers,
Mauro.

