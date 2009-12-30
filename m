Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:47930
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZL3TBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 14:01:33 -0500
Subject: Re: [PATCH] input: imon driver for SoundGraph iMON/Antec Veris IR devices
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1430BBF0-3A61-471E-86A9-E85CF153A150@wilsonet.com>
Date: Wed, 30 Dec 2009 14:01:18 -0500
Cc: Jarod Wilson <jarod@redhat.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F1D74CA4-2BD9-43C4-8A8F-08B690A334F3@wilsonet.com>
References: <2044EA95-168E-4ACE-A19E-732BB4A34CA7@gmail.com> <1430BBF0-3A61-471E-86A9-E85CF153A150@wilsonet.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dec 30, 2009, at 3:02 AM, Jarod Wilson wrote:

> On Dec 29, 2009, at 5:30 PM, Dmitry Torokhov wrote:
> 
>> On Tue, Dec 29, 2009 at 12:04:00AM -0500, Jarod Wilson wrote:
>>> On Dec 28, 2009, at 4:31 AM, Dmitry Torokhov wrote:
>>>> 
>>>> Hm, will this work on big-endian?
>>> 
>>> Good question. Not sure offhand. Probably not. Unfortunately, the only devices I have to test with at the moment are integrated into cases with x86 boards in them, so testing isn't particularly straight-forward. I should probably get ahold of one of the plain external usb devices to play with... Mind if I just add a TODO marker near that for now?
>>> 
>> 
>> How about just do le32_to_cpu() instead of memcpy()ing and that's
>> probably it?
> 
> Hrm. My endian-fu sucks. Not sure what the right way to do it without the memcpy is. I thought I had something together than would work, using 2 lines (memcpy, then le32_to_cpu), but I just realized that'll go south on the keys where we're only looking at half the buffer (i.e., the wrong half on big-endian)... Will see what I can do to fix that up in the morning, was hoping to get this out tonight, but its nearly 3am (again)...

Got something that works in place now. Well, definitely works on x86, works in theory on big-endian, haven't got a way to test it on the latter just yet.


>> [...] I'd still want to see larger functions split up a bit though.
> 
> I've hacked imon_probe() up into 6 different functions now:
> 
> imon_probe()
> -> imon_init_intf0()
>  -> imon_init_idev()
>  -> imon_init_display()
> -> imon_init_intf1()
>  -> imon_init_touch()
> 
> (and there was an existing imon_set_ir_protocol() in the mix)
> 
> Quite a bit more manageable and readable now, I think. Haven't looked yet for other candidates for similar refactoring. Were there others you had in mind? At a glance, imon_incoming_packet() seems to be the only remaining function that is particularly hefty. Well, imon_probe() is still ~180 lines, but it used to be north of 400, I think... So perhaps I try trimming imon_probe() a bit more, and see what can be done to make imon_incoming_packet() less chunky.

Making good headway on imon_incoming_packet(), in-progress bits pushed again. Gotta take my son and a buddy to a movie. Life keeps getting in the way of me finishing this as quickly as I'd like... :)

-- 
Jarod Wilson
jarod@wilsonet.com



