Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:39857 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2CWSQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 14:16:43 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 5B6B6EBC61
	for <linux-media@vger.kernel.org>; Fri, 23 Mar 2012 20:16:41 +0200 (EET)
Received: from kuusi.koti (a88-112-23-125.elisa-laajakaista.fi [88.112.23.125])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 23B8E41BE3
	for <linux-media@vger.kernel.org>; Fri, 23 Mar 2012 20:16:39 +0200 (EET)
Message-ID: <4F6CBE07.6040904@kolumbus.fi>
Date: Fri, 23 Mar 2012 20:16:39 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Various nits, fixes and hacks for mantis CA support on
 SMP
References: <20120228010330.GA25786@uio.no> <4F514CCB.8020502@kolumbus.fi> <20120302232136.GB31447@uio.no>
In-Reply-To: <20120302232136.GB31447@uio.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

03.03.2012 01:21, Steinar H. Gunderson kirjoitti:
> On Sat, Mar 03, 2012 at 12:42:19AM +0200, Marko Ristola wrote:
>> I'm not happy with I2CDONE busy looping either.
>> I've tried twice lately to swith into I2C IRQ, but those patches have caused I2CDONE timeouts.
> 
> Note that there are already timeouts with the current polling code, but they
> are ignored (my patch makes them at least be printed with verbose=5). I can't
> immediately recall if it's on RACK, DONE or both.

I think that occasional timeouts belong to the picture (RACK missing means: packet lost).
If I2CDONE comes immediately when I2C command has been emitted,
it is a driver software bug (some earlier I2C command).

> 
>> Do my following I2C logic thoughts make any sense?
> 
> Well, note first of all that I know next to nothing about I2C, and I've never
> seen any hardware documentation on the Mantis card (is there any?). But
> generally it makes sense to me, except that I've never heard of the demand of
> radio silence for 10 ms before.
Ok. Radio silence for 10 ms isn't your problem: when you have a FE_LOCK,
10 ms requirement is no more relevant.

> 
>> There might be race conditions, that the driver possibly manages:
>> 1. If two threads talk into DVB frontend, one could turn off the I2C gate, while the other is talking to DVB frontend.
>>    This would case lack of I2CRACK: only way to recover would be to turn
>>    the I2C gate on, and then redo the I2C transfer.
> 
> Note that I've tried putting mutexes around the I2C functions, and it didn't
> help on the I2C timeouts; however, that was largely on a single-character
> level, so it might not be enough. (You can see these mutexes being commented
> out in my patch.)

I have now a new idea for what to try with I2C interrupts.
It all depends, whether I understand the driver coding well enough.

> 
> /* Steinar */

I have also a low interest for Mantis coding:
Ideas come fast, and if the new code doesn't work right away,
I back up the code somewhere and drop it.

Some years ago during Summer Holiday time I could get something done
and even patches got applied into Linux kernel.

Marko Ristola
