Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42060 "HELO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932741AbZLMBZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 20:25:49 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Matthias Fechner <idefix@fechner.net>
In-Reply-To: <200912121822.01184.liplianin@me.by>
References: <200912120230.36902.liplianin@me.by>
	 <200912121349.58436.liplianin@me.by>
	 <1260627327.3104.13.camel@palomino.walls.org>
	 <200912121822.01184.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 11:59:34 -0500
Message-Id: <1260637174.3085.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-12-12 at 18:22 +0200, Igor M. Liplianin wrote:
> On 12 декабря 2009 16:15:27 Andy Walls wrote:
> > V4L2_SUBDEV_IO_PIN_ACTIVE_LOW
> After I removed this from ir_rx_pin_cfg, interrupts stopped.

If we are lucky, that was the problem.

If it was the problem, now it is a matter of setting the 

	params.modulation
	params.invert_level

properly for the TeVii S470 in cx23885-input.c to have the hardware
generate interrupts when it makes a few pulse measurements.


If it was not the problem, then we still have some interrupt(s) coming
from the AV Core and have just supressed all of the interrupts from the
AV Core. :)

Regards,
Andy

