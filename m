Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab1CPUYe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:34 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKOXNu026188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:24:33 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/6] media: trivial IR fixes
Date: Wed, 16 Mar 2011 16:24:25 -0400
Message-Id: <1300307071-19665-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a stack of relatively small miscellaneous IR fixes for 2.6.39.
The ir-kbd-i2c one is actually relatively important, following the
pending changes to the hauppauge keymaps though, and the zilog error's
usefulness becomes apparent the second you try running lirc_zilog on
a pre-2.6.33 kernel which has an older kfifo implementation (there
will be a media_build patch to cope, when I get around to it).

Jarod Wilson (6):
  docs: fix typo in lirc_device_interface.xml
  imon: add more panel scancode mappings
  ir-kbd-i2c: pass device code w/key in hauppauge case
  lirc: silence some compile warnings
  lirc_zilog: error out if buffer read bytes != chunk size
  mceusb: topseed 0x0011 needs gen3 init for tx to work

 Documentation/DocBook/v4l/lirc_device_interface.xml |    2 +-
 drivers/media/rc/imon.c                             |   11 ++++++++++-
 drivers/media/rc/mceusb.c                           |    2 +-
 drivers/media/video/ir-kbd-i2c.c                    |    2 +-
 drivers/staging/lirc/lirc_imon.c                    |    2 +-
 drivers/staging/lirc/lirc_sasem.c                   |    2 +-
 drivers/staging/lirc/lirc_zilog.c                   |    4 ++++
 7 files changed, 19 insertions(+), 6 deletions(-)

 drivers/media/rc/mceusb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

