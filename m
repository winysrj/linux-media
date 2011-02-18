Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33563 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab1BRBLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:11:35 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1BTnC015010
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:11:32 GMT
Subject: [PATCH 0/13] lirc_zilog: Ref-counting and locking cleanup
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:11:42 -0500
Message-ID: <1297991502.9399.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following 13 patches are a substantial rework of lirc_zilog
reference counting, object allocation and deallocation, and object
locking.

With these changes, devices can now disappear out from under lircd +
lirc_dev + lirc_zilog with no adverse effects.  I tested this with irw +
lircd + lirc_dev + lirc_zilog + cx18 + HVR-1600.  I could unload the
cx18 driver without any oops or application crashes.  When I reloaded
the cx18 driver, irw started receiving RX button presses again, and
irsend worked without a problem (and I didn't even need to restart
lircd!).

The ref counting fixes aren't finished as lirc_zilog itself can still be
unloaded by the user when it shouldn't be, but a hot unplug of an
HD-PVR, PVR-USB2, or HVR-1950 isn't going to trigger that.

These changes are base off of Jarod Wilson's git repo

	http://git.linuxtv.org/jarod/linux-2.6-ir.git for-2.6.38 (IIRC)

Regards,
Andy

The following changes since commit c369acfb63914f9f502baef032bacfd5a53a871f:

  mceusb: really fix remaining keybounce issues (2011-01-26 10:56:29 -0500)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git z8-wilson-38

Andy Walls (13):
      lirc_zilog: Restore checks for existence of the IR_tx object
      lirc_zilog: Remove broken, ineffective reference counting
      lirc_zilog: Convert ir_device instance array to a linked list
      lirc_zilog: Convert the instance open count to an atomic_t
      lirc_zilog: Use kernel standard methods for marking device non-seekable
      lirc_zilog: Don't acquire the rx->buf_lock in the poll() function
      lirc_zilog: Remove unneeded rx->buf_lock
      lirc_zilog: Always allocate a Rx lirc_buffer object
      lirc_zilog: Move constants from ir_probe() into the lirc_driver template
      lirc_zilog: Add ref counting of struct IR, IR_tx, and IR_rx
      lirc_zilog: Add locking of the i2c_clients when in use
      lirc_zilog: Fix somewhat confusing information messages in ir_probe()
      lirc_zilog: Update TODO list based on work completed and revised plans

 drivers/staging/lirc/TODO.lirc_zilog |   51 +--
 drivers/staging/lirc/lirc_zilog.c    |  802 +++++++++++++++++++++-------------
 2 files changed, 523 insertions(+), 330 deletions(-)


