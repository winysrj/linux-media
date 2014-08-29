Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2045 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaH2GaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 02:30:22 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7T6UJrL097117
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 08:30:20 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C275B2A0757
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 08:30:16 +0200 (CEST)
Message-ID: <54001DF8.2070503@xs4all.nl>
Date: Fri, 29 Aug 2014 08:30:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] Add vivid test driver, remove old vivi test
 driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This adds the new vivid driver as a replacement for the old vivi.

This pull request is identical to the v2 patch series posted earlier:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/81354

except for the final patch that removes the vivi driver which is new to this
pull request.

One question: the vivid driver (like the vivi driver) is not build by default.
Should that be changed? In my opinion this driver should be enabled by distros,
so I am in favor of changing Kconfig. Let me know if you agree and I'll make a
follow up patch or you can change this yourself.

Regards,

	Hans

The following changes since commit b250392f7b5062cf026b1423e27265e278fd6b30:

  [media] media: ttpci: fix av7110 build to be compatible with CONFIG_INPUT_EVDEV (2014-08-21 15:25:38 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vivid2

for you to fetch changes up to d5f410f54e87ba420de839dec4e806707cc2aff2:

  vivi: remove driver, it's replaced by vivid. (2014-08-25 13:49:53 +0200)

----------------------------------------------------------------
Hans Verkuil (13):
      vb2: fix multiplanar read() with non-zero data_offset
      vivid.txt: add documentation for the vivid driver
      vivid: add core driver code
      vivid: add the control handling code
      vivid: add the video capture and output parts
      vivid: add VBI capture and output code
      vivid: add the kthread code that controls the video rate
      vivid: add a simple framebuffer device for overlay testing
      vivid: add the Test Pattern Generator
      vivid: add support for radio receivers and transmitters
      vivid: add support for software defined radio
      vivid: enable the vivid driver
      vivi: remove driver, it's replaced by vivid.

 Documentation/video4linux/vivid.txt               | 1109 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/Kconfig                    |   15 +-
 drivers/media/platform/Makefile                   |    2 +-
 drivers/media/platform/vivi.c                     | 1542 -----------------------------------------------------------------
 drivers/media/platform/vivid/Kconfig              |   19 +
 drivers/media/platform/vivid/Makefile             |    6 +
 drivers/media/platform/vivid/vivid-core.c         | 1390 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-core.h         |  520 ++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-ctrls.c        | 1502 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-ctrls.h        |   34 ++
 drivers/media/platform/vivid/vivid-kthread-cap.c  |  885 +++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-kthread-cap.h  |   26 ++
 drivers/media/platform/vivid/vivid-kthread-out.c  |  304 +++++++++++++
 drivers/media/platform/vivid/vivid-kthread-out.h  |   26 ++
 drivers/media/platform/vivid/vivid-osd.c          |  400 +++++++++++++++++
 drivers/media/platform/vivid/vivid-osd.h          |   27 ++
 drivers/media/platform/vivid/vivid-radio-common.c |  189 ++++++++
 drivers/media/platform/vivid/vivid-radio-common.h |   40 ++
 drivers/media/platform/vivid/vivid-radio-rx.c     |  287 ++++++++++++
 drivers/media/platform/vivid/vivid-radio-rx.h     |   31 ++
 drivers/media/platform/vivid/vivid-radio-tx.c     |  141 ++++++
 drivers/media/platform/vivid/vivid-radio-tx.h     |   29 ++
 drivers/media/platform/vivid/vivid-rds-gen.c      |  165 +++++++
 drivers/media/platform/vivid/vivid-rds-gen.h      |   53 +++
 drivers/media/platform/vivid/vivid-sdr-cap.c      |  499 +++++++++++++++++++++
 drivers/media/platform/vivid/vivid-sdr-cap.h      |   34 ++
 drivers/media/platform/vivid/vivid-tpg-colors.c   |  310 +++++++++++++
 drivers/media/platform/vivid/vivid-tpg-colors.h   |   64 +++
 drivers/media/platform/vivid/vivid-tpg.c          | 1439 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-tpg.h          |  438 +++++++++++++++++++
 drivers/media/platform/vivid/vivid-vbi-cap.c      |  356 +++++++++++++++
 drivers/media/platform/vivid/vivid-vbi-cap.h      |   40 ++
 drivers/media/platform/vivid/vivid-vbi-gen.c      |  248 +++++++++++
 drivers/media/platform/vivid/vivid-vbi-gen.h      |   33 ++
 drivers/media/platform/vivid/vivid-vbi-out.c      |  247 +++++++++++
 drivers/media/platform/vivid/vivid-vbi-out.h      |   34 ++
 drivers/media/platform/vivid/vivid-vid-cap.c      | 1729 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.h      |   71 +++
 drivers/media/platform/vivid/vivid-vid-common.c   |  571 ++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-common.h   |   61 +++
 drivers/media/platform/vivid/vivid-vid-out.c      | 1205 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-out.h      |   57 +++
 drivers/media/v4l2-core/videobuf2-core.c          |    6 +
 43 files changed, 14628 insertions(+), 1556 deletions(-)
 create mode 100644 Documentation/video4linux/vivid.txt
 delete mode 100644 drivers/media/platform/vivi.c
 create mode 100644 drivers/media/platform/vivid/Kconfig
 create mode 100644 drivers/media/platform/vivid/Makefile
 create mode 100644 drivers/media/platform/vivid/vivid-core.c
 create mode 100644 drivers/media/platform/vivid/vivid-core.h
 create mode 100644 drivers/media/platform/vivid/vivid-ctrls.c
 create mode 100644 drivers/media/platform/vivid/vivid-ctrls.h
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-out.h
 create mode 100644 drivers/media/platform/vivid/vivid-osd.c
 create mode 100644 drivers/media/platform/vivid/vivid-osd.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-common.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-common.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-rx.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-rx.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-tx.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-tx.h
 create mode 100644 drivers/media/platform/vivid/vivid-rds-gen.c
 create mode 100644 drivers/media/platform/vivid/vivid-rds-gen.h
 create mode 100644 drivers/media/platform/vivid/vivid-sdr-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-sdr-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.c
 create mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.h
 create mode 100644 drivers/media/platform/vivid/vivid-tpg.c
 create mode 100644 drivers/media/platform/vivid/vivid-tpg.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-gen.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-gen.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-out.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-common.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-common.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-out.h
