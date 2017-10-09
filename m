Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44953 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754818AbdJIP0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 11:26:06 -0400
Subject: Re: [PATCH v2 01/25] media: lirc: implement scancode sending
To: Sean Young <sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
 <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
 <5d67a4a0-d04b-5052-c9c9-cbd46401975e@xs4all.nl>
 <20171009151153.aq2hrhkbbddfi7bq@gofer.mess.org>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <28d494a5-d6b7-25d4-0408-91c3f29d841d@xs4all.nl>
Date: Mon, 9 Oct 2017 17:26:04 +0200
MIME-Version: 1.0
In-Reply-To: <20171009151153.aq2hrhkbbddfi7bq@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 17:11, Sean Young wrote:
> On Mon, Oct 09, 2017 at 11:14:28AM +0200, Hans Verkuil wrote:
>> On 05/10/17 10:45, Sean Young wrote:
> -snip-
>>> +/*
>>> + * struct lirc_scancode - decoded scancode with protocol for use with
>>> + *	LIRC_MODE_SCANCODE
>>> + *
>>> + * @timestamp: Timestamp in nanoseconds using CLOCK_MONOTONIC when IR
>>> + *	was decoded.
>>> + * @flags: should be 0 for transmit. When receiving scancodes,
>>> + *	LIRC_SCANCODE_FLAG_TOGGLE or LIRC_SCANCODE_FLAG_REPEAT can be set
>>> + *	depending on the protocol
>>> + * @target: target for transmit. Unused, set to 0.
>>> + * @source: source for receive. Unused, set to 0.
>>> + * @unused: set to 0.
>>> + * @rc_proto: see enum rc_proto
>>> + * @scancode: the scancode received or to be sent
>>> + */
>>> +struct lirc_scancode {
>>> +	__u64	timestamp;
>>> +	__u32	flags;
>>> +	__u8	target;
>>> +	__u8	source;
>>> +	__u8	unused;
>>> +	__u8	rc_proto;
>>> +	__u64	scancode;
>>
>> I'm thinking how this will be implemented using CEC. Some RC commands take arguments
>> (up to 4 bytes for the 0x67 (Tune Function) code), so how will they be handled?
>>
>> See CEC table 6 in the HDMI 1.4 spec.
>>
>> Should they be part of the scancode, or would it be better to add a '__u8 args[8];'
>> field?
>>
>> I've no idea what makes sense, it's a weird corner case.
> 
> I've given it some more thought.
> 
> For cec remote control passthrough, you have the tv with the IR receiver (A),
> which then transmits CEC_MSG_USER_CONTROL_PRESSED and
> CEC_MSG_USER_CONTROL_RELEASED cec messages to the correct target, with
> arguments. Then on the target (B), it reads those commands and should execute
> them as if it received them itself.
> 
> First of all (B) is already implemented in cec using rc-core. If RC
> passthrough is enabled, then cec will pass those keycodes to rc-core (which
> end up in an input device).
> 
> So the problem we are trying to solve here is (A). How I would see this
> implemented is:
> 
> 1) A physical IR receiver exists which has an rc-core driver and a /dev/lircN
>    device. This is configured using ir-keytable to map to regular input events
> 
> 2) A process receives input events, and decides that a particular key/command
>    is not for itself (e.g. tell top set box to tune), so it knows what the
>    target cec address is and the tune arguments, so it fills out a 
>    cec_msg with the target, CEC_MSG_USER_CONTROL_PRESSED, 0x67, arguments,
>    and then transmits it using the ioctl CEC_TRANSMIT, followed by
>    another CEC_MSG_USER_CONTROL_RELEASED cec_msg sent using ioctl CEC_TRANSMIT.
> 
> In this way of viewing things, an rc-core device is either cec or lirc, and
> thus rc-core lirc devices have a /dev/lircN and rc-core cec devices have a
> /dev/cecN.
> 
> So, the alternative which is being proposed is that a cec device has both
> a /dev/cecN and a /dev/lircN. In this case step 2) would look like:
> 
> 2) A process receives input events, and decides that a particular key/command
>    is not for itself (e.g. tell top set box to tune), so it knows what the
>    target cec address is and the tune arguments, so it fills in a 
>    lirc_scancode with the target, CEC_MSG_USER_CONTROL_PRESSED, 0x67, arguments,
>    and then transmits it using write() to the /dev/lircN device, which
>    then passes it on to cec_transmit() in drivers/media/cec/cec-api.c
>    (without having a cec_fh), and then another lirc_scancode is
>    filled in CEC_MSG_USER_CONTROL_RELEASED and sent.
> 
> Now, I think that this has a number of problems:
> 
>  - It's a lot of API for simply doing a CEC_TRANSMIT
> 
>  - and another chardev for a cec device (i.e. /dev/lircN).
> 
>  - lirc scancode tx deals with scancodes, for cec rc passthrough it isn't
>    really scancodes.
> 
>  - Wiring this up is not going to be pretty or easy.
> 
>  - The lirc chardev has no other function other than sending
>    CEC_MSG_USER_CONTROL_PRESSED and CEC_MSG_USER_CONTROL_RELEASED cec messages.
>  
> So what I am proposing is that we don't use lirc for sending rc passthrough
> messages for cec.
> 
> I hope this makes sense and where not, please *do* tell me exactly where I
> am wrong. I think that I missed something about the scancode tx idea.

You are right, it makes no sense. Let's forget about this.

Regards,

	Hans

> 
>>
>>> +};
>>> +
>>> +#define LIRC_SCANCODE_FLAG_TOGGLE	1
>>> +#define LIRC_SCANCODE_FLAG_REPEAT	2
>>
>> These flags need documentation.
> 
> They do, fair point.
> 
> Thanks,
> 
> Sean
> 
