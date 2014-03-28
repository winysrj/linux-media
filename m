Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37604 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbaC1Aiu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 20:38:50 -0400
Date: Fri, 28 Mar 2014 01:38:47 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: tvboxspy@gmail.com
Cc: linux-media@vger.kernel.org
Subject: lmedm04 NEC scancode question
Message-ID: <20140328003847.GA23351@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malcolm,

I'm trying to make sure that the extended NEC parsing is consistent
across drivers and I have a question regarding
drivers/media/usb/dvb-usb-v2/lmedm04.c

In commit 616a4b83 you changed the scancode from something like this:

	ibuf[2] << 24 | ibuf[3] << 16 | ibuf[4] << 8 | ibuf[5]

into:

	if ((ibuf[4] + ibuf[5]) == 0xff) {
		key = ibuf[5];
		key += (ibuf[3] > 0)
			? (ibuf[3] ^ 0xff) << 8 : 0;
		key += (ibuf[2] ^ 0xff) << 16;

which can be written as:

	(ibuf[2] ^ 0xff) << 16 |
	(ibuf[3] > 0) ? (ibuf[3] ^ 0xff) << 8 : 0 |
	ibuf[5]

At the same time the keymap was changed from (one example from each
type):

	0xef12ba45 = KEY_0
	0xff40ea15 = KEY_0
	0xff00e31c = KEY_0

into:

	0x10ed45   = KEY_0 (0x10ed = ~0xef12; 0x45 = ~0xba)
	0xbf15     = KEY_0 (0xbf = 0x00bf = ~0xff40; 0x15 = ~0xea)
	0x1c       = KEY_0 (0x1c = 0x001c; this is a NEC16 coding?)

I am assuming (given the ^ 0xff) that the hardware sends inverted bytes?
And that the reason ibuf[5] does not need ^ 0xff is that it already is
the inverted command (i.e. ibuf[5] == ~ibuf[4]).

To put it differently:

        ibuf[2] = ~addr         = not_addr;
        ibuf[3] = ~not_addr     = addr;
        ibuf[4] = ~cmd          = not_cmd;
        ibuf[5] = ~not_cmd      = cmd;

And the scancode can then be understood as:

	addr << 16 | not_addr << 8 | cmd

Except for when addr = 0x00 in which case the scancode is simply NEC16:

	0x00 << 8 | cmd

Is my interpretation correct?

-- 
David Härdeman
