Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50324 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbbD0ITo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 04:19:44 -0400
Message-ID: <553DF118.7020703@xs4all.nl>
Date: Mon, 27 Apr 2015 10:19:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Lars Op den Kamp' <lars@opdenkamp.eu>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	'Hans Verkuil' <hansverk@cisco.com>
Subject: Re: [PATCH v4 06/10] cec: add HDMI CEC framework
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com> <1429794192-20541-7-git-send-email-k.debski@samsung.com> <553A14FC.6090200@opdenkamp.eu> <"08b501d080c1$835d07e0$8a1717a0$@debski"@samsung.com>
In-Reply-To: <"08b501d080c1$835d07e0$8a1717a0$@debski"@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

My thanks as well for your comments.

I'd like to add some background information as well as to why we move
the core CEC support into the kernel: the main reason for doing this
is to support the HEAC part of the CEC protocol. Specifically the ARC
support and handling the hotplug detect CEC/HEAC messages. This has to
be handled in the kernel and cannot be left to userspace. While the
current framework does not yet handle these messages support for this
will appear, probably later this year since I will have to work on ARC.

Out of curiosity: have you ever seen CEC adapters that implement the
ethernet part of HEAC? My understanding is that nobody uses that part
since wifi is the standard these days. But perhaps you know of examples
where it was actually implemented.

Regards,

	Hans

On 04/27/2015 10:09 AM, Kamil Debski wrote:
> Hi Lars, 
> 
> Thank you for your comments.
> 
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Lars Op den Kamp
> Sent: Friday, April 24, 2015 12:04 PM
>  
>> Hi Kamil, Hans,
>>
>> I'm the main developer of libCEC
>> (https://github.com/Pulse-Eight/libcec). Sorry for the late time to
>> jump
>> in here, but I wasn't signed up to this mailing list and someone
>> pointed
>> me to this discussion.
>>
>> Unfortunately this approach will not work with half the TVs that are
>> out
>> there. I'll explain why:
>>
>> * because of how some (common) brands implemented CEC in their TVs,
>> this
>> implementation will not work, as the TV will just reject it. In libCEC,
>> we've created work arounds for brands like this. Without these work
>> arounds, your in-kernel implementation will be very vendor specific.
>> e.g. this implementation will work for Samsung's TVs, but not for the
>> TVs made by another big TV brand. All commands, including CEC_OP_ABORT,
>> should be passed to userspace to make it work with all brands.
>>
>> * it should be made possible to not have the kernel send any CEC
>> message, try to process any received CEC message, or ack to any logical
>> address at all, to allow libraries like libCEC to fully handle all CEC
>> traffic. Some brands only enable routing of some CEC keys when a
>> specific device type is used. libCEC will allocate a logical address of
>> the correct type for the brand that's used. If another address is first
>> allocated by the kernel, and the TV communicates with it to find out
>> it's name and things like that, and libCEC allocates another address a
>> bit later when initialised, then you'll end up with multiple entries in
>> the device list on the TV, and only one of them will work.
> 
> Adding a special mode in the CEC framework that disables parsing and
> processing seems like a good idea for me. This way libCEC could be
> completely
> in charge of how the communication is handled. 
> 
> I discussed this with Hans and he is for this solution. This way there would
> be two modes:
> - One with handling of CEC messages enabled in the kernel, in idea behind
>   this is to have processing adhere to the CEC spec as closely as possible.
>   It should work with equipment that also follows the spec and has little
>   vendor specific quirks.
> - Second, the passthrough mode, in which the handling of CEC messages would
>   be left to userspace application. Kernel would not be sending or
>   receiving messages, unless specifically told to do so. Below you mentioned
>   that allocating logical addresses and sending ACKs could be done in
> kernel.
> 
>   The way I see it is following: If allocation of a logical address is made
>   then ACKs will be handled by the framework. If no allocation is made then
>   the userspace can still send and receive messages. However no filtering is
>   done based on the logical address - all received messages are sent to the
>   userspace.
> 
>>
>> * CEC is *very* vendor specific. The main reason is, in my opinion, the
>> use of the word "should" instead of "shall" in the spec. It's addressed
>> in the new version, but it'll take years before all the non 2.x devices
>> are gone. What works for vendor A will simply not work for vendor B.
>> libCEC aims to address this, in a library that can be used on all major
>> platforms and by all major programming languages. You could duplicate
>> the work done there in the kernel to make make the implementation work
>> with all brands, but I think that this does simply not belong in the
>> kernel when it can be handled in userspace perfectly.
> 
> CEC being very vendor specific is a huge problem. I agree with you that
> there is no need to duplicate the effort to mitigate all the vendor quirks.
> Especially that a working implementation (libCEC) is already done.
> 
>> So I suggest that you limit the in-kernel implementation to handling
>> raw
>> traffic only, to have it do this (and nothing more):
>> * allocate one or more logical addresses, and ack CEC traffic sent to
>> those logical addresses
>> * receive CEC traffic and forward it to userspace (traffic sent to all
>> addresses is preferred, not just traffic sent to the logical address
>> used by the device running this code)
>> * transmit CEC traffic initiated by userspace
> 
> As mentioned above, I propose a "passthorugh" mode in which handling of
> CEC messages by the kernel CEC framework will be very limited. I think
> that the three functions listed above should be enough.
> 
> Any comments on this solution?
> 
>>
>> thanks,
>>
>> Lars Op den Kamp
> 
> Best wishes,
> 

