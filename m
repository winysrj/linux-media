Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0IPFTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 01:19:51 -0400
Date: Thu, 16 Sep 2010 01:19:32 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH 0/4] IR/imon: split out mouse events and fix bugs
Message-ID: <20100916051932.GA23299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

These patches make the imon driver slightly less distasteful. The meat of
the changes are from David's patch to split the IR mouse mode and
panel/knob events out onto their own input device, leaving just IR keys to
come through the IR device. This facilitates further abstraction of the
ir/rc-core interface, but allows us to get these patches in ahead of
David's major reshuffle that is targeted for post-2.6.37-rc1 (basically,
after Dmitry's large keycode patches are merged in mainline).

Additionally, while David's patch unknowingly addressed many of the issues
in https://bugzilla.kernel.org/show_bug.cgi?id=16351, there are a few more
issues addressed by the spinlock patch (at least, in theory, since in
practice, it doesn't really seem to matter much to me, but Anssi suggested
that some locking may be a good idea in the bug :).

Finally, there's a bit of reshuffling of auto-config bits for the 0xffdc
imon devices so the mce-only ones get set up w/the mce key table by
default instead of the imon pad one (based on input from Anders Eriksson
over on the lirc list).

David Härdeman (1):
      imon: split mouse events to a separate input dev

Jarod Wilson (3):
      IR: export ir_keyup so imon driver can use it directly
      IR/imon: protect ictx's kc and last_keycode w/spinlock
      IR/imon: set up mce-only devices w/mce keytable

 drivers/media/IR/imon.c        |  583 +++++++++++++++++++++++-----------------
 drivers/media/IR/ir-keytable.c |    3 +-
 include/media/ir-core.h        |    1 +
 3 files changed, 344 insertions(+), 243 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

