Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40612 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbbGXNrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 09:47:31 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5BBD02A00AA
	for <linux-media@vger.kernel.org>; Fri, 24 Jul 2015 15:46:19 +0200 (CEST)
Message-ID: <55B241AB.5060008@xs4all.nl>
Date: Fri, 24 Jul 2015 15:46:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] Various fixes, R-Car JPEG Processing Unit driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:

  [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3d

for you to fetch changes up to f53b579ed8c08d1714678faa535c9e115b5b85aa:

  DocBook: Fix typo in intro.xml (2015-07-24 15:45:02 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      v4l2-mem2mem: drop lock in v4l2_m2m_fop_mmap
      tc358743: remove unused variable

Laura Abbott (1):
      v4l2-ioctl: Give more information when device_caps are missing

Masanari Iida (1):
      DocBook: Fix typo in intro.xml

Mikhail Ulyanov (3):
      V4L2: platform: Add Renesas R-Car JPEG codec driver
      devicetree: bindings: Document Renesas R-Car JPEG Processing Unit
      MAINTAINERS: V4L2: PLATFORM: Add entry for Renesas JPEG Processing Unit driver

 Documentation/DocBook/media/dvb/intro.xml               |    5 +-
 Documentation/devicetree/bindings/media/renesas,jpu.txt |   24 +
 MAINTAINERS                                             |    6 +
 drivers/media/i2c/tc358743.c                            |    3 -
 drivers/media/platform/Kconfig                          |   12 +
 drivers/media/platform/Makefile                         |    1 +
 drivers/media/platform/rcar_jpu.c                       | 1794 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c                    |    5 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c                  |   12 +-
 9 files changed, 1843 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,jpu.txt
 create mode 100644 drivers/media/platform/rcar_jpu.c
