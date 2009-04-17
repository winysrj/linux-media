Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:39722 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZDQNna (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 09:43:30 -0400
Date: Fri, 17 Apr 2009 15:42:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Oldrich Jedlicka <oldium.pro@seznam.cz>
Cc: Mark Schultz <n9xmj@yahoo.com>,
	Brian Rogers <brian_rogers@comcast.net>,
	Andy Walls <awalls@radix.net>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090417154234.7c137e1a@hyperion.delvare>
In-Reply-To: <200904092115.30426.oldium.pro@seznam.cz>
References: <20090404142427.6e81f316@hyperion.delvare>
	<20090406104045.58da67c7@hyperion.delvare>
	<1239052236.4925.20.camel@pc07.localdom.local>
	<200904092115.30426.oldium.pro@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oldrich,

On Thu, 9 Apr 2009 21:15:30 +0200, Oldrich Jedlicka wrote:
> I've tried your patches with AverMedia Cardbus Hybrid (E506R) and they works 
> fine.

Thanks for testing and reporting, and sorry for the late answer.

> My current experience with AverMedia's IR chip (I don't know which one is on 
> the card) is that I2C probing didn't find anything, but it got the chip into 
> some strange state - next operation failed (so that the autodetection on 
> address 0x40 and "subaddress" 0x0b/0x0d failed).

OK, that makes sense. Many I2C devices only support a limited subset of
the I2C protocol, and if you try to address them with a message format
they don't support, their state machine goes into a bad state. That's
probably what was happening there. This is the reason why we should
always instantiate I2C devices explicitly when possible: whatever
probing method you use, you have no guarantee that every device will
like it.

> The chip at address 0x40 needs the write first (one byte: 0x0b or 0x0d) and 
> immediate read, otherwise it would not respond. The saa7134's I2C 0xfd quirk 
> (actually I would call it a hack :-)) caused failures in communication with 
> the IR chip.

I didn't know about this hack. The implementation choice seems wrong to
me. The hack should be triggered only when needed, rather than by
default with an exception for address 0x40. This goes beyond the scope
of my patch though, and I don't want to touch that kind of code without
hardware at hand to test my changes.

> The way I'm doing the IR reading is the same as the Windows driver does - I 
> got the information through the Qemu with pci-proxy patch applied.

Thanks,
-- 
Jean Delvare
