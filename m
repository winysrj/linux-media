Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:18890 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557Ab1AOP0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 10:26:48 -0500
Subject: Re: [PATCH] hdpvr: enable IR part
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
In-Reply-To: <cwd2gkgtgyb91bkc0m1dtmnx.1295095844198@email.android.com>
References: <cwd2gkgtgyb91bkc0m1dtmnx.1295095844198@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 10:26:24 -0500
Message-ID: <1295105185.3258.32.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-15 at 07:50 -0500, Andy Walls wrote:
> Jarod Wilson <jarod@wilsonet.com> wrote:

> >Forgot to mention: I think it was suggested that one could use ir-kbd-i2c
> >for receive and lirc_zilog for transmit, at the same time. With ir-kbd-i2c
> >already loaded, lirc_zilog currently won't bind to anything.


> With my newly hacked lirc_zilog, try using the 'tx_only' parameter
> please.  It's not quite ready yet, but I'd like to know if it can
> bind.

I have now tested this.

Using the 'tx_only' module parameter to lirc_zilog appears to allow
ir-kbd-i2c and lirc_zilog to coexist, for I2C subsystem binding at
least.

It does not appear to matter what order the two modules are loaded. I
tried it both ways.


However, lirc_zilog sharing of Z8 is not fully functional yet.  I need
to change things to have the bridge drivers provide a IR transceiver
mutex to both lirc_zilog and ir-kbd-i2c.  lirc_zilog and ir-kbd-i2c
would use that mutex for exclusive access to the Z8 when needed, if it
was provided by the bridge driver.

I view proper sharing of the Z8 as an important requirement, because of
two use cases:

1. User only wants to use the Z8 for IR Rx.  User doesn't want to fetch
the lirc_zilog required firmware or perform any LIRC setup.

2. User only wants to use the Z8 for IR Tx.  User uses some other
ir-kbd-i2c supported receiver and remote IR Rx.

Maybe use case #2 is too rare to worry about?
However, if one accepts both use cases as valid, then ir-kbd-i2c must
support the Z8, and lirc_zilog must be able to coexist with ir-kbd-i2c.

Proper sharing of the Z8 is, however, lower on my to-do list than fixing
some internal lirc_zilog problems.

Regards,
Andy

