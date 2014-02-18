Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:47847 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbaBROCj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 09:02:39 -0500
Date: Tue, 18 Feb 2014 14:02:37 +0000
From: Sean Young <sean@mess.org>
To: Rune Petersen <rune@megahurts.dk>
Cc: linux-media@vger.kernel.org
Subject: Re: Some questions timeout in rc_dev
Message-ID: <20140218140236.GA10790@pequod.mess.org>
References: <53013379.70403@megahurts.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53013379.70403@megahurts.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 16, 2014 at 10:54:01PM +0100, Rune Petersen wrote:
> The intent of the timeout member in the rc_dev struct is a little unclear to me.
> In rc-core.h it is described as:
> 	@timeout: optional time after which device stops sending data.
> 
> But if I look at the usage, it is used to detect idle in ir_raw.c
> which again is used by the RC-6 decoder to detect end of RC-6 6A
> transmissions.
> 
> This leaves me with a few questions:
>  - Without the timeout (which is optional) the RC-6 decoder will not work
>    properly with RC-6 6A transmissions wouldn't that make it required?

That sounds like a bug to me. The decoders shouldn't rely on the length 
of trailing space, probably it would be best to not rely on receiving the
trailing space if possible.

>  - Why are the timeout set in the individual drivers so varied, shouldn't it
>    depend on the encoding rather then the hardware used?
>    The timeout set in the drivers ranges from 2750us(redrat3)
>    to 1000000us(fintek_cir) and all the way to weird(streamzap)

The various devices have different timeouts; they will stop sending IR data
when there has been no activity for that amount of time.

>  - Why is the timeout value controlled by the IR driver, when it us only
>    used	by the rc-core.
>    Wouldn't it make sense to have the timeout initialized to a sane value
>    in a single place?

I guess the rc_dev->timeout is used for different things:

1) So that the drivers can advertise what timeout the hardware uses
2) The ttusbir and iguanair are devices which never timeout, so they
   rely on ir_raw_store_with_filter() to do timeout handling for them.

Some drivers have both hardware timeouts and use ir_raw_store_with_filter()
so timeout handling is done both in hardware and software.

> I would like to get rc to a state where it just works for me without
> modifications, I "just" need to know which changes I can get away
> without breaking it for everybody else =)
> 
> As things are right now the RC input feel very sluggish and
> unresponsive using a RC-6 6A remote and a ite-cir receiver.


Sean
