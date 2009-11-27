Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:41659 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZK0VL0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 16:11:26 -0500
Subject: cx25840: GPIO settings wrong for HVR-1850 IR Tx
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org, stoth@kernellabs.com
Cc: mkrufky@kernellabs.com, hverkuil@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 16:10:32 -0500
Message-Id: <1259356232.2353.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve,

This code in cx25840-core.c mucks up HVR-1850 IR Tx:

        /* Drive GPIO2 direction and values for HVR1700
         * where an onboard mux selects the output of demodulator
         * vs the 417. Failure to set this results in no DTV.
         * It's safe to set this across all Hauppauge boards
         * currently, regardless of the board type.
         */
        cx25840_write(client, 0x160, 0x1d);
        cx25840_write(client, 0x164, 0x00);

This changes the IR_TX pin to act as GPIO_20 and defaults it to low,
keeping the IR Transmitter LED illuminated.

Setting register 0x160 to 0x1f makes the pin the IR Tx function again.
I don't want to hack it in there though, as I don't know the
implications for other CX2388[578] boards.  I also perceive the cx23885
module GPIOs could be an easy place to introduce regressions if not
careful.


Steve and Hans,

Any ideas?

I know on the list I had bantered around a configure, enable, set, get
etc v4l2_subdev ops for gpio, but I can't remember the details nor the
requirements.

The cx25840 module really needs a way for the cx23885 bridge driver to
set GPIOs cleanly.

Regards,
Andy

