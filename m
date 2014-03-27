Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37598 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaC0XoB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 19:44:01 -0400
Date: Fri, 28 Mar 2014 00:43:57 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dib0700 NEC scancode question
Message-ID: <20140327234357.GA22491@hardeman.nu>
References: <20140327120728.GA13748@hardeman.nu>
 <20140327214041.GA21302@hardeman.nu>
 <1464013.AGHbqAynQ4@lappi3>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1464013.AGHbqAynQ4@lappi3>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 27, 2014 at 11:13:35PM +0100, Patrick Boettcher wrote:
>Hi David,
>
>On Thursday 27 March 2014 22:40:41 David Härdeman wrote:
>> On Thu, Mar 27, 2014 at 01:07:28PM +0100, David Härdeman wrote:
>> >Hi Patrick,
>> >
>> >a quick question regarding the dib0700 driver:
>> 
>> >in ./media/usb/dvb-usb/dib0700_core.c the RC RX packet is defined as:
>> ...
>> 
>> >The NEC protocol transmits in the order:
>> ...
>> 
>> >Does the dib0700 fw really reorder the bytes, or could the order of
>> >not_system and system in struct dib0700_rc_response have been
>> >accidentally reversed?
>
>It feels like a hundred years I haven't work on that. I'm not sure whether 
>this knowledge can still be retrieved as of today or not. I would lie if I 
>told you that I look the archives... and I can't want to do that (lying and 
>looking).
>
>However, I realize that your assumption might not be totally far-fetched. If 
>you can find another IR-receiver just check whether the same remote control 
>delivers swapped bytes or not (if I understood it correctly, that's your real 
>question). Then you have you answer, haven't you? 

If I had the hardware, yes :)

I don't, I just want to refactor some parts of the IR handling code
across several drivers, which is why I came across this...I guess there
are others who do have the hardware who will complain loudly if I try
changing it and my assumptions turn out to be incorrect though...

-- 
David Härdeman
