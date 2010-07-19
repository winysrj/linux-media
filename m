Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:32265 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab0GSEsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 00:48:54 -0400
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Andy Walls <awalls@md.metrocast.net>
To: Kenney Phillisjr <kphillisjr@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	stoth@kernellabs.com, hverkuil@xs4all.nl
In-Reply-To: <1279457773.2451.14.camel@localhost>
References: <1278707305.25199.6.camel@dandel-desktop>
	 <1279457773.2451.14.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 00:49:19 -0400
Message-ID: <1279514959.4539.8.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-07-18 at 08:56 -0400, Andy Walls wrote:
> On Fri, 2010-07-09 at 15:28 -0500, Kenney Phillisjr wrote:
> > I know this is an old thread, however i have an card that meets the
> > requirements to be tested by the patches made by andy, and so far
> > with what i've tried it's been doing really well for input.
> > 
> > I pretty much just downloaded and tested Andy's patch set...
> > http://linuxtv.org/hg/~awalls/cx23885-ir2
> 
> 
> I'll be porting most of these 32 patches forward to my v4l-dvb.git tree
> (on the cx-ir branch) later today.  I need the I/O pin configuration
> stuff for the CX23885 and CX23888 IR transmitter pin configuration.

> > The tests where done on ubuntu 10.04 with kernel 2.6.32-23-generic
> > (64-bit) and this appears to be working perfectly. (This even properly
> > identifies the card I'm using down to the model)
> > 
> > card notes: Hauppauge WinTV-HVR1250 (Model: 79001)
> 
> I don't have an original HVR-1250 or any other card with a genuine
> CX23885 chip anymore, so I'll be unable to test.
> 
> I will likely add a module parameter that end users will be required to
> set explcitly to enable the IR integrated in the CX23885 chip.  Igor's
> testing with the TeVii S470 resulted in the infinite IR interrupts
> making his system unusable.

Kenney,

I've ported my changes forward.  I haven't sent a patch bomb yet,
because I want to make one more change to disable the TeVii S470 IR by
default (since it is reported to hang a user's machine), and I'm too
tired ATM.  I also wanted to get some bit of Tx operational beyond
setting the LED drive level correctly, but again, I'm too tired ATM.

Anyway, here's the stats on the updated patch set.  Please test if you
can.  These patches will likely require a 2.6.33 or greater kernel
(IIRC) due to the kfifo API change.

The following changes since commit f6242ad1007df90691fd5b70f0808320fe7aee07:

  V4L/DVB: xc5000: Fix a few warnings (2010-07-05 18:38:46 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/v4l-dvb.git cx-ir

Andy Walls (13):
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

Jean Delvare (3):
      cx23885: Return -ENXIO on slave nack
      cx23885: Check for slave nack on all transactions
      cx23885: i2c_wait_done returns 0 or 1, don't check for < 0 return value

 drivers/media/video/cx23885/Makefile        |    5 +-
 drivers/media/video/cx23885/cx23885-av.c    |   35 +
 drivers/media/video/cx23885/cx23885-av.h    |   27 +
 drivers/media/video/cx23885/cx23885-cards.c |   97 ++-
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
 19 files changed, 2118 insertions(+), 89 deletions(-)
 create mode 100644 drivers/media/video/cx23885/cx23885-av.c
 create mode 100644 drivers/media/video/cx23885/cx23885-av.h
 create mode 100644 drivers/media/video/cx25840/cx25840-ir.c




