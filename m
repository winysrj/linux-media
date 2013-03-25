Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1331 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3CYIvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 04:51:11 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2P8p6Y9002267
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 09:51:08 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 90A5811E013F
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 09:51:04 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] solo6x10 driver overhaul
Date: Mon, 25 Mar 2013 09:51:04 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303250951.04980.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request is identical to:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg60150.html

but the slab.h includes have been kept as requested by Mauro.

Regards,

	Hans

The following changes since commit b781e6be79a394cd6980e9cd8fd5c25822d152b6:

  [media] sony-btf-mpx: v4l2_tuner struct is now constant (2013-03-24 14:04:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git solo4

for you to fetch changes up to 053aecaa6e1e24cea0e1f5222dd169b0106b6b28:

  solo6x10: prefix sources with 'solo6x10-' (2013-03-25 09:47:48 +0100)

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
 drivers/staging/media/solo6x10/solo6x10-core.c                  |  709 ++++++++++++++++
 drivers/staging/media/solo6x10/{disp.c => solo6x10-disp.c}      |  128 ++-
 drivers/staging/media/solo6x10/solo6x10-eeprom.c                |  154 ++++
 drivers/staging/media/solo6x10/{enc.c => solo6x10-enc.c}        |  239 ++++--
 drivers/staging/media/solo6x10/{g723.c => solo6x10-g723.c}      |   94 ++-
 drivers/staging/media/solo6x10/{gpio.c => solo6x10-gpio.c}      |   13 +-
 drivers/staging/media/solo6x10/{i2c.c => solo6x10-i2c.c}        |   26 +-
 drivers/staging/media/solo6x10/solo6x10-jpeg.h                  |   94 ++-
 drivers/staging/media/solo6x10/solo6x10-offsets.h               |   85 ++
 drivers/staging/media/solo6x10/solo6x10-p2m.c                   |  333 ++++++++
 drivers/staging/media/solo6x10/{registers.h => solo6x10-regs.h} |   88 +-
 drivers/staging/media/solo6x10/{tw28.c => solo6x10-tw28.c}      |  187 +++--
 drivers/staging/media/solo6x10/{tw28.h => solo6x10-tw28.h}      |   12 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c              | 1363 ++++++++++++++++++++++++++++++
 drivers/staging/media/solo6x10/solo6x10-v4l2.c                  |  734 +++++++++++++++++
 drivers/staging/media/solo6x10/solo6x10.h                       |  259 ++++--
 drivers/staging/media/solo6x10/v4l2-enc.c                       | 1829 -----------------------------------------
 drivers/staging/media/solo6x10/v4l2.c                           |  961 ----------------------
 25 files changed, 4165 insertions(+), 4038 deletions(-)
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
