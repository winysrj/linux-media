Return-path: <linux-media-owner@vger.kernel.org>
Received: from csmtp3.one.com ([91.198.169.23]:53924 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaBRXu4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 18:50:56 -0500
Message-ID: <5303F063.2070400@megahurts.dk>
Date: Wed, 19 Feb 2014 00:44:35 +0100
From: Rune Petersen <rune@megahurts.dk>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: linux-media@vger.kernel.org
Subject: Re: Some questions timeout in rc_dev
References: <53013379.70403@megahurts.dk> <20140218140236.GA10790@pequod.mess.org>
In-Reply-To: <20140218140236.GA10790@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/02/14 15:02, Sean Young wrote:
> On Sun, Feb 16, 2014 at 10:54:01PM +0100, Rune Petersen wrote:
>> The intent of the timeout member in the rc_dev struct is a little unclear to me.
>> In rc-core.h it is described as:
>> 	@timeout: optional time after which device stops sending data.
>>
>> But if I look at the usage, it is used to detect idle in ir_raw.c
>> which again is used by the RC-6 decoder to detect end of RC-6 6A
>> transmissions.
>>
>> This leaves me with a few questions:
>>   - Without the timeout (which is optional) the RC-6 decoder will not work
>>     properly with RC-6 6A transmissions wouldn't that make it required?
>
> That sounds like a bug to me. The decoders shouldn't rely on the length
> of trailing space, probably it would be best to not rely on receiving the
> trailing space if possible.

I can find no specs on RC-6 6A, but the length is supposed to be variable 8-128 
bits and there doesn't appear to be any bits for length in the transmission.
So the only way to detect the end is a space of 2667+us.

>
>>   - Why are the timeout set in the individual drivers so varied, shouldn't it
>>     depend on the encoding rather then the hardware used?
>>     The timeout set in the drivers ranges from 2750us(redrat3)
>>     to 1000000us(fintek_cir) and all the way to weird(streamzap)
>
> The various devices have different timeouts; they will stop sending IR data
> when there has been no activity for that amount of time.

Thought experiment:
Suppose the ir_raw_store_with_filter() code has a timeout _longer_ than this 
device timeout, it will never enter the idle state.
Suppose the ir_raw_store_with_filter() code has a timeout _shorter_ than this 
device timeout, it will enter the idle state, just faster.

Wouldn't this mean that the device timeout cannot be exceeded which I thought 
was the purpose of max_timeout in dev_rc?
>
>>   - Why is the timeout value controlled by the IR driver, when it us only
>>     used	by the rc-core.
>>     Wouldn't it make sense to have the timeout initialized to a sane value
>>     in a single place?
>
> I guess the rc_dev->timeout is used for different things:
>
> 1) So that the drivers can advertise what timeout the hardware uses
> 2) The ttusbir and iguanair are devices which never timeout, so they
>     rely on ir_raw_store_with_filter() to do timeout handling for them.
>
> Some drivers have both hardware timeouts and use ir_raw_store_with_filter()
> so timeout handling is done both in hardware and software.
>
>> I would like to get rc to a state where it just works for me without
>> modifications, I "just" need to know which changes I can get away
>> without breaking it for everybody else =)
>>
>> As things are right now the RC input feel very sluggish and
>> unresponsive using a RC-6 6A remote and a ite-cir receiver.
>
>
> Sean
>

Rune
