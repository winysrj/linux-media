Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543Ab0DHTho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 15:37:44 -0400
Date: Thu, 8 Apr 2010 16:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/8] ir-core improvements
Message-ID: <20100408163717.05c3581c@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yet another series of ir-core improvements.

This series contain two fixes, plus those improvements:

1) sysfs: better define the behaviour for in-hardware and in-software raw
   decoders: different types require different functionalities;

2) sysfs: rename Remote Controllers as rc0, rc1, ...
   this is better than rcrcv0, rcrcv1, ..., because some devices have
   also RC transmitters, and they may share some functionality with
   the receiver. So, a receiver and a transmitter will be later be
   differenciated via the associated device nodes;

3) Rework ir-raw-event to support a third type of decoders: in-hardware
   samplers, with in-software decoders. In this case, the IR events
   (duration and type) are provided by the hardware, and the protocol
   decode is done in software.

Those are the patches from this series:

David Härdeman (2):
  V4L/DVB: rename sysfs remote controller devices from rcrcv to rc
  V4L/DVB: Teach drivers/media/IR/ir-raw-event.c to use durations

Mauro Carvalho Chehab (6):
  V4L/DVB: em28xx: fix a regression caused by the rc-map changes
  V4L/DVB: ir: Make sure that the spinlocks are properly initialized
  V4L/DVB: ir-core: Distinguish sysfs attributes for in-hardware and raw decoders
  V4L/DVB: ir-core: properly present the supported and current protocols
  V4L/DVB: ir-core: fix gcc warning noise
  V4L/DVB: ir-core: move subsystem internal calls to ir-core-priv.h

 drivers/media/IR/ir-core-priv.h             |  112 +++++++++++++
 drivers/media/IR/ir-functions.c             |    1 +
 drivers/media/IR/ir-keytable.c              |   19 ++-
 drivers/media/IR/ir-nec-decoder.c           |  241 +++++++++++----------------
 drivers/media/IR/ir-raw-event.c             |  161 ++++++++++--------
 drivers/media/IR/ir-rc5-decoder.c           |  154 +++++++++---------
 drivers/media/IR/ir-sysfs.c                 |  100 ++++++++----
 drivers/media/IR/rc-map.c                   |    3 +-
 drivers/media/video/em28xx/em28xx-input.c   |   21 ++-
 drivers/media/video/saa7134/saa7134-input.c |   11 +-
 include/media/ir-core.h                     |   81 +++-------
 11 files changed, 502 insertions(+), 402 deletions(-)
 create mode 100644 drivers/media/IR/ir-core-priv.h

