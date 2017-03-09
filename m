Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46659
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754811AbdCIBud (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 20:50:33 -0500
Date: Wed, 8 Mar 2017 22:50:25 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [GIT PULL for v4.11-rc2] media fixes
Message-ID: <20170308225025.561afac7@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.11-2

For media regression fixes:

   - serial_ir: fix a Kernel crash during boot on Kernel 4.11-rc1, due
	to an IRQ code called too early;
   - other IR regression fixes at lirc and at the raw IR decoding;
   - a deadlock fix at the RC nuvoton driver;
   - Fix another issue with DMA on stack at dw2102 driver.

There's an extra patch there that change a driver interface for the
SoC VSP1 driver, with is shared between the DRM and V4L2 driver.
The patch itself is trivial, and was acked by David Arlie.
As we're early at -rc, I hope that's ok.

Thanks!
Mauro

The following changes since commit 9eeb0ed0f30938f31a3d9135a88b9502192c18dd:

  [media] mtk-vcodec: fix build warnings without DEBUG (2017-02-08 12:08:20 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.11-2

for you to fetch changes up to 8c71fff434e5ecf5ff27bd61db1bc9ac4c2b2a1b:

  [media] v4l: vsp1: Adapt vsp1_du_setup_lif() interface to use a structure (2017-03-07 13:34:11 -0300)

----------------------------------------------------------------
media fixes for v4.11-rc2

----------------------------------------------------------------
Heiner Kallweit (1):
      [media] rc: nuvoton: fix deadlock in nvt_write_wakeup_codes

Jonathan McDowell (1):
      [media] dw2102: don't do DMA on stack

Kieran Bingham (1):
      [media] v4l: vsp1: Adapt vsp1_du_setup_lif() interface to use a structure

Sean Young (4):
      [media] serial_ir: ensure we're ready to receive interrupts
      [media] lirc: fix dead lock between open and wakeup_filter
      [media] rc: raw decoder for keymap protocol is not loaded on register
      [media] rc: protocol is not set on register for raw IR devices

 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |   8 +-
 drivers/media/platform/vsp1/vsp1_drm.c |  33 +++--
 drivers/media/rc/lirc_dev.c            |   4 +-
 drivers/media/rc/nuvoton-cir.c         |   5 +-
 drivers/media/rc/rc-main.c             |  26 ++--
 drivers/media/rc/serial_ir.c           | 123 ++++++++---------
 drivers/media/usb/dvb-usb/dw2102.c     | 244 ++++++++++++++++++++-------------
 include/media/vsp1.h                   |  13 +-
 8 files changed, 260 insertions(+), 196 deletions(-)
