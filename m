Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1888 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab3GZOmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 10:42:25 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id r6QEgL92073895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 16:42:24 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [192.168.1.10] (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id BD09335E03B6
	for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 16:42:20 +0200 (CEST)
Message-ID: <51F28ACD.90001@xs4all.nl>
Date: Fri, 26 Jul 2013 16:42:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.12] Accumulated patches for 3.12
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are all outstanding patches for v4l2 drivers and video receivers/transmitters.
If I missed any, then please let me know!

Regards,

	Hans

The following changes since commit c859e6ef33ac0c9a5e9e934fe11a2232752b4e96:

  [media] dib0700: add support for PCTV 2002e & PCTV 2002e SE (2013-07-22 07:48:11 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.12

for you to fetch changes up to 80db3da9d332840b5029756ed44420c31e923f5d:

  em28xx: Fix vidioc fmt vid cap v4l2 compliance (2013-07-26 15:26:01 +0200)

----------------------------------------------------------------
Alban Browaeys (1):
      em28xx: Fix vidioc fmt vid cap v4l2 compliance

Alexey Khoroshilov (2):
      tlg2300: implement error handling in poseidon_probe()
      tlg2300: fix checking firmware in poseidon_probe()

Ezequiel Garcia (2):
      stk1160: Allow to change input while streaming
      media: stk1160: Ignore unchanged standard set

Lad, Prabhakar (13):
      media: i2c: ths8200: support asynchronous probing
      media: i2c: ths8200: add OF support
      media: i2c: adv7343: add support for asynchronous probing
      media: i2c: tvp7002: add support for asynchronous probing
      media: i2c: tvp514x: add support for asynchronous probing
      media: davinci: vpif: capture: add V4L2-async support
      media: davinci: vpif: display: add V4L2-async support
      media: davinci: vpbe_venc: convert to devm_* api
      media: davinci: vpbe_osd: convert to devm_* api
      media: davinci: vpbe_display: convert to devm* api
      media: davinci: vpss: convert to devm* api
      media: i2c: adv7343: make the platform data members as array
      media: i2c: adv7343: add OF support

Libin Yang (7):
      marvell-ccic: add MIPI support for marvell-ccic driver
      marvell-ccic: add clock tree support for marvell-ccic driver
      marvell-ccic: reset ccic phy when stop streaming for stability
      marvell-ccic: refine mcam_set_contig_buffer function
      marvell-ccic: add new formats support for marvell-ccic driver
      marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
      marvell-ccic: switch to resource managed allocation and request

Libo Chen (1):
      drivers/media/radio/radio-maxiradio: Convert to module_pci_driver

Lubomir Rintel (1):
      usbtv: Add S-Video input support

Ondrej Zary (4):
      tea575x-tuner: move HW init to a separate function
      bttv: stop abusing mbox_we for sw_status
      radio-aztech: Convert to generic lm7000 implementation
      radio-aztech: Implement signal strength detection and fix stereo detection

Vladimir Barinov (1):
      ml86v7667: override default field interlace order

Wei Yongjun (1):
      usbtv: remove unused including <linux/version.h>

 Documentation/devicetree/bindings/media/i2c/adv7343.txt |  48 ++++++++++
 Documentation/devicetree/bindings/media/i2c/ths8200.txt |  19 ++++
 arch/arm/mach-davinci/board-da850-evm.c                 |   6 +-
 drivers/media/i2c/adv7343.c                             |  89 +++++++++++++++----
 drivers/media/i2c/ml86v7667.c                           |   3 +-
 drivers/media/i2c/ths8200.c                             |  18 +++-
 drivers/media/i2c/tvp514x.c                             |  20 +++--
 drivers/media/i2c/tvp7002.c                             |   6 ++
 drivers/media/pci/bt8xx/bttv-cards.c                    |  26 ++----
 drivers/media/pci/bt8xx/bttvp.h                         |   3 +
 drivers/media/platform/davinci/vpbe_display.c           |  23 ++---
 drivers/media/platform/davinci/vpbe_osd.c               |  45 +++-------
 drivers/media/platform/davinci/vpbe_venc.c              |  97 ++++----------------
 drivers/media/platform/davinci/vpif_capture.c           | 151 ++++++++++++++++++++++----------
 drivers/media/platform/davinci/vpif_capture.h           |   2 +
 drivers/media/platform/davinci/vpif_display.c           | 210 +++++++++++++++++++++++++++-----------------
 drivers/media/platform/davinci/vpif_display.h           |   3 +-
 drivers/media/platform/davinci/vpss.c                   |  62 +++----------
 drivers/media/platform/marvell-ccic/cafe-driver.c       |   4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c         | 325 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 drivers/media/platform/marvell-ccic/mcam-core.h         |  50 ++++++++++-
 drivers/media/platform/marvell-ccic/mmp-driver.c        | 274 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/media/radio/radio-aztech.c                      |  81 ++++++-----------
 drivers/media/radio/radio-maxiradio.c                   |  13 +--
 drivers/media/usb/em28xx/em28xx-video.c                 |   1 +
 drivers/media/usb/stk1160/stk1160-v4l.c                 |   6 +-
 drivers/media/usb/tlg2300/pd-main.c                     |  37 ++++++--
 drivers/media/usb/usbtv/usbtv.c                         | 100 +++++++++++++++++----
 include/media/adv7343.h                                 |  20 +----
 include/media/davinci/vpif_types.h                      |   4 +
 include/sound/tea575x-tuner.h                           |   1 +
 sound/i2c/other/tea575x-tuner.c                         |  19 ++--
 32 files changed, 1199 insertions(+), 567 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths8200.txt
