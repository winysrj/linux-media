Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42437 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbcHMKT2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 06:19:28 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2BFDB18026F
	for <linux-media@vger.kernel.org>; Sat, 13 Aug 2016 12:19:23 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] New tw5864 driver
Message-ID: <7b6719bf-24c5-2b5e-e4d3-927d5ca64cbd@xs4all.nl>
Date: Sat, 13 Aug 2016 12:19:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Passed v4l2-compliance, see https://patchwork.linuxtv.org/patch/35671/
for more details about the device.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tw5864

for you to fetch changes up to bca3dd9f1e30a397ae6cd131fb28e0cb3c5c6068:

  pci: Add tw5864 driver (2016-08-13 12:13:34 +0200)

----------------------------------------------------------------
Andrey Utkin (1):
      pci: Add tw5864 driver

 MAINTAINERS                             |    8 +
 drivers/media/pci/Kconfig               |    1 +
 drivers/media/pci/Makefile              |    1 +
 drivers/media/pci/tw5864/Kconfig        |   11 +
 drivers/media/pci/tw5864/Makefile       |    3 +
 drivers/media/pci/tw5864/tw5864-core.c  |  359 ++++++++++
 drivers/media/pci/tw5864/tw5864-h264.c  |  259 ++++++++
 drivers/media/pci/tw5864/tw5864-reg.h   | 2133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/tw5864/tw5864-util.c  |   37 ++
 drivers/media/pci/tw5864/tw5864-video.c | 1514 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/tw5864/tw5864.h       |  205 ++++++
 11 files changed, 4531 insertions(+)
 create mode 100644 drivers/media/pci/tw5864/Kconfig
 create mode 100644 drivers/media/pci/tw5864/Makefile
 create mode 100644 drivers/media/pci/tw5864/tw5864-core.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-h264.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-reg.h
 create mode 100644 drivers/media/pci/tw5864/tw5864-util.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-video.c
 create mode 100644 drivers/media/pci/tw5864/tw5864.h
