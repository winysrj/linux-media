Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0KIVjZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 16:39:25 -0500
Date: Tue, 9 Nov 2010 16:39:21 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: [PATCH 0/3 v2] mceusb: buffer parsing and keymap cleanups
Message-ID: <20101109213921.GD11073@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This v2 series is actually one patch light from v1, as the Conexant device
support patch has already been merged into the for_v2.6.38 tree, but adds
another patch not in v1 which simply cleans up the mce keytable a bit and
adds a missing mapping for one of my mce remotes.

The core good done by this patchset is to fix the reporting of trailing
spaces, which makes lirc decode work again, and some necessary buffer
parsing fixes specific to the first-gen device. v2 of the trailing space
fix implements multiple suggestions from David Härdeman that greatly
simplify the buffer parsing state machine.

Jarod Wilson (3):
    mceusb: fix up reporting of trailing space
    mceusb: buffer parsing fixups for 1st-gen device
    IR: add tv power scancode to rc6 mce keymap

-- 
Jarod Wilson
jarod@redhat.com

