Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:32709 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005Ab0GTBIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:08:44 -0400
Subject: [PATCH 00/17] cx23885: Add CX23885 integrated IR controller Rx
 support
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>,
	Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	Jean Delvare <khali@linux-fr.org>,
	"Igor M.Liplianin" <liplianin@me.by>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:08:04 -0400
Message-ID: <1279588084.28153.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a respin of a patch series that has been rotting away in an hg repo
of mine for 6 months.  I needed the IO pin configuration fixes to start on
CX23888 IR Tx support.   Since Kenney Phillis reported that he had no
problems with the entire set for his HVR-1250, I've ported them all forward.

The patches affect the cx23885 driver along with the v4l2-subdev header, and
are a major addition to the cx25840 module.  Thus I'm providing the patches to
the list for any possible comments.

They can also be found in my linuxtv.org git repo at

	ssh://linuxtv.org/git/awalls/v4l-dvb.git cx-ir

(and whatever that translates to using http://)

Regards,
Andy

Andy Walls (14):
  cx25840: Make cx25840 i2c register read transactions atomic
  cx23885: Add correct detection of the HVR-1250 model 79501
  cx23885: Add a VIDIOC_LOG_STATUS ioctl function for analog video devices
  v4l2_subdev: Add s_io_pin_config to v4l2_subdev_core_ops
  cx25840: Add s_io_pin_config core subdev ops for the CX2388[578]
  v4l2_subdev, cx23885: Differentiate IR carrier sense and I/O pin inversion
  cx23885: For CX23888 IR, configure the IO pin mux IR pins explcitly
  v4l2_subdev: Move interrupt_service_routine ptr to v4l2_subdev_core_ops
  cx25840: Add support for CX2388[57] A/V core integrated IR controllers
  cx23885: Add a v4l2_subdev group id for the CX2388[578] integrated AV core
  cx23885: Add preliminary IR Rx support for the HVR-1250 and TeVii S470
  cx23885: Protect PCI interrupt mask manipulations with a spinlock
  cx23885: Move AV Core irq handling to a work handler
  cx23885: Require user to explicitly enable CX2388[57] IR via module param

Jean Delvare (3):
  cx23885: Return -ENXIO on slave nack
  cx23885: Check for slave nack on all transactions
  cx23885: i2c_wait_done returns 0 or 1, don't check for < 0 return value

 drivers/media/video/cx23885/Makefile        |    5 +-
 drivers/media/video/cx23885/cx23885-av.c    |   35 +
 drivers/media/video/cx23885/cx23885-av.h    |   27 +
 drivers/media/video/cx23885/cx23885-cards.c |  114 +++-
 drivers/media/video/cx23885/cx23885-core.c  |  124 +++-
 drivers/media/video/cx23885/cx23885-i2c.c   |   27 +-
 drivers/media/video/cx23885/cx23885-input.c |   48 +-
 drivers/media/video/cx23885/cx23885-ir.c    |   24 +-
 drivers/media/video/cx23885/cx23885-reg.h   |    1 +
 drivers/media/video/cx23885/cx23885-vbi.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c |   23 +-
 drivers/media/video/cx23885/cx23885.h       |    9 +-
 drivers/media/video/cx23885/cx23888-ir.c    |   35 +-
 drivers/media/video/cx25840/Makefile        |    2 +-
 drivers/media/video/cx25840/cx25840-core.c  |  339 +++++++-
 drivers/media/video/cx25840/cx25840-core.h  |   28 +
 drivers/media/video/cx25840/cx25840-ir.c    | 1262 +++++++++++++++++++++++++++
 include/media/cx25840.h                     |   75 ++
 include/media/v4l2-subdev.h                 |   44 +-
 19 files changed, 2135 insertions(+), 89 deletions(-)
 create mode 100644 drivers/media/video/cx23885/cx23885-av.c
 create mode 100644 drivers/media/video/cx23885/cx23885-av.h
 create mode 100644 drivers/media/video/cx25840/cx25840-ir.c


