Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2785 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3CVLoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 07:44:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] solo6x10 driver overhaul
Date: Fri, 22 Mar 2013 12:44:27 +0100
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221244.27521.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is my solo6x10 driver overhaul. It is identical to:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg59864.html

but rebased on top of my const changes (http://patchwork.linuxtv.org/patch/17568/)
and with the source/header rename patches.

This patch series syncs the driver to the latest code from Bluecherry and then
fixes many v4l issues.

Remaining open issues:

1) Most importantly, the video from video0 is broken: it is supposed to be
   either one of the four inputs or a 2x2 image of all four inputs, instead I
   always get the first video line of the input repeated for the whole image.

   I have no idea why and it would be very nice if someone from Bluecherry
   can look at this. I do not see anything wrong in the DMA code, so it is
   a mystery to me.

2) I couldn't get it to work on a big-endian system. Perhaps it is because
   the PCI card is sitting in a PCIe slot using a PCIe-to-PCI adapter.

3) The 'extended streams' have been disabled. Basically you can get two
   encoded streams out of the box: each with different encoder settings
   (e.g. high and low bitrates). This should probably be implemented as
   an extra video node.

4) There is a custom extension for motion detection. Besides adding two
   private ioctls to support regional motion thresholds I left that part
   otherwise unchanged as it doesn't look too bad, but I am unable to test
   it properly. I've ordered a suitable CCTV camera from dealextreme, but that
   will take a few weeks before I have it (dx.com is cheap, but delivery is
   quite slow). I'd like to experiment a bit with this.

5) The tw28* 'drivers' should really be split off as subdevice drivers.

6) Capture of video0 is now using dma-contig. It used to be dma-sg, but due
   to locking issues Bluecherry changed it to dma-contig. So I've kept it
   that way, but it can probably be converted back to dma-sg. But issue 1 should
   be fixed first before we mess with this.

So there is still work to be done, but at least the driver is in a much better
state.

The idea is that Bluecherry will develop from this code base and keep the
kernel driver in sync.

Regards,

        Hans

The following changes since commit 8bf1a5a826d06a9b6f65b3e8dffb9be59d8937c3:

  v4l2-ioctl: add precision when printing names. (2013-03-22 11:59:21 +0100)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git solo3

for you to fetch changes up to 13c810d87b0e332ecefb3a889246f2d2b3d4e749:

  solo6x10: prefix sources with 'solo6x10-' (2013-03-22 12:40:36 +0100)

----------------------------------------------------------------
Hans Verkuil (21):
      solo6x10: sync to latest code from Bluecherry's git repo.
      solo6x10: fix querycap and update driver version.
      solo6x10: add v4l2_device.
      solo6x10: add control framework.
      solo6x10: fix various format-related compliancy issues.
      solo6x10: add support for prio and control event handling.
      solo6x10: move global fields in solo_dev_fh to solo_dev.
      solo6x10: move global fields in solo_enc_fh to solo_enc_dev.
      solo6x10: convert encoder nodes to vb2.
      solo6x10: convert the display node to vb2.
      solo6x10: fix 'BUG: key ffff88081a2a9b58 not in .data!'
      solo6x10: add call to pci_dma_mapping_error.
      solo6x10: drop video_type and add proper s_std support.
      solo6x10: also stop DMA if the SOLO_PCI_ERR_P2M_DESC is raised.
      solo6x10: small big-endian fix.
      solo6x10: use V4L2_PIX_FMT_MPEG4, not _FMT_MPEG
      solo6x10: fix sequence handling.
      solo6x10: disable the 'priv' abuse.
      solo6x10: clean up motion detection handling.
      solo6x10: rename headers.
      solo6x10: prefix sources with 'solo6x10-'

 drivers/staging/media/solo6x10/Kconfig                          |    3 +-
 drivers/staging/media/solo6x10/Makefile                         |    4 +-
 drivers/staging/media/solo6x10/TODO                             |   33 +-
 drivers/staging/media/solo6x10/core.c                           |  321 --------
 drivers/staging/media/solo6x10/offsets.h                        |   74 --
 drivers/staging/media/solo6x10/osd-font.h                       |  154 ----
 drivers/staging/media/solo6x10/p2m.c                            |  306 -------
 drivers/staging/media/solo6x10/solo6x10-core.c                  |  708 ++++++++++++++++
 drivers/staging/media/solo6x10/{disp.c => solo6x10-disp.c}      |  128 ++-
 drivers/staging/media/solo6x10/solo6x10-eeprom.c                |  154 ++++
 drivers/staging/media/solo6x10/{enc.c => solo6x10-enc.c}        |  240 ++++--
 drivers/staging/media/solo6x10/{g723.c => solo6x10-g723.c}      |   93 ++-
 drivers/staging/media/solo6x10/{gpio.c => solo6x10-gpio.c}      |   13 +-
 drivers/staging/media/solo6x10/{i2c.c => solo6x10-i2c.c}        |   26 +-
 drivers/staging/media/solo6x10/solo6x10-jpeg.h                  |   94 ++-
 drivers/staging/media/solo6x10/solo6x10-offsets.h               |   85 ++
 drivers/staging/media/solo6x10/solo6x10-p2m.c                   |  332 ++++++++
 drivers/staging/media/solo6x10/{registers.h => solo6x10-regs.h} |   88 +-
 drivers/staging/media/solo6x10/{tw28.c => solo6x10-tw28.c}      |  187 +++--
 drivers/staging/media/solo6x10/{tw28.h => solo6x10-tw28.h}      |   12 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c              | 1363 ++++++++++++++++++++++++++++++
 drivers/staging/media/solo6x10/solo6x10-v4l2.c                  |  734 +++++++++++++++++
 drivers/staging/media/solo6x10/solo6x10.h                       |  257 ++++--
 drivers/staging/media/solo6x10/v4l2-enc.c                       | 1829 -----------------------------------------
 drivers/staging/media/solo6x10/v4l2.c                           |  961 ----------------------
 25 files changed, 4161 insertions(+), 4038 deletions(-)
 delete mode 100644 drivers/staging/media/solo6x10/core.c
 delete mode 100644 drivers/staging/media/solo6x10/offsets.h
 delete mode 100644 drivers/staging/media/solo6x10/osd-font.h
 delete mode 100644 drivers/staging/media/solo6x10/p2m.c
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-core.c
 rename drivers/staging/media/solo6x10/{disp.c => solo6x10-disp.c} (74%)
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-eeprom.c
 rename drivers/staging/media/solo6x10/{enc.c => solo6x10-enc.c} (50%)
 rename drivers/staging/media/solo6x10/{g723.c => solo6x10-g723.c} (83%)
 rename drivers/staging/media/solo6x10/{gpio.c => solo6x10-gpio.c} (91%)
 rename drivers/staging/media/solo6x10/{i2c.c => solo6x10-i2c.c} (92%)
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-offsets.h
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-p2m.c
 rename drivers/staging/media/solo6x10/{registers.h => solo6x10-regs.h} (90%)
 rename drivers/staging/media/solo6x10/{tw28.c => solo6x10-tw28.c} (84%)
 rename drivers/staging/media/solo6x10/{tw28.h => solo6x10-tw28.h} (88%)
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-v4l2.c
 delete mode 100644 drivers/staging/media/solo6x10/v4l2-enc.c
 delete mode 100644 drivers/staging/media/solo6x10/v4l2.c
