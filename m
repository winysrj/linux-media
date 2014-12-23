Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:37477 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWOcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 09:32:45 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NH10051AHQJM600@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Dec 2014 23:32:43 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: [RFC 0/6] HDMI-CEC framework
Date: Tue, 23 Dec 2014 15:32:16 +0100
Message-id: <1419345142-3364-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The work on a common CEC framework was started over three years ago by Hans
Verkuil. Unfortunately the work has stalled. As I have received the task of
creating a driver for the CEC interface module present on the Exynos range of
SoCs, I got in touch with Hans. He repied that the work stalled due to his
lack of time.

The driver was done in the most part and there were only minor fixes that needed
to be implemented. I would like to bring back the discussion on a common CEC
interface framework.

There are a few things that were still left as TODO, I think they might need
some discussion - for instance the way how the remote controls should be
handled.

Best wishes,
Kamil Debski

Hans Verkuil (4):
  cec: add new driver for cec support.
  v4l2-subdev: add cec ops.
  adv7604: add cec support.
  adv7511: add cec support.

Kamil Debski (2):
  s5p-cec: Add s5p-cec driver
  dts: add s5p-cec to exynos4412-odroidu3

 .../devicetree/bindings/video/exynos_cec.txt       |   26 +
 arch/arm/boot/dts/exynos4412-odroidu3.dts          |   13 +
 cec-rfc.txt                                        |  319 ++++++
 cec.txt                                            |   40 +
 drivers/media/Kconfig                              |    5 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec.c                                | 1048 ++++++++++++++++++++
 drivers/media/i2c/adv7511.c                        |  325 +++++-
 drivers/media/i2c/adv7604.c                        |  182 ++++
 drivers/media/platform/Kconfig                     |    7 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    4 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   37 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  208 ++++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 ++
 drivers/media/platform/s5p-cec/s5p_cec.c           |  288 ++++++
 drivers/media/platform/s5p-cec/s5p_cec.h           |  113 +++
 include/media/adv7511.h                            |    6 +-
 include/media/cec.h                                |  129 +++
 include/media/v4l2-subdev.h                        |    8 +
 include/uapi/linux/cec.h                           |  222 +++++
 21 files changed, 3071 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/exynos_cec.txt
 create mode 100644 cec-rfc.txt
 create mode 100644 cec.txt
 create mode 100644 drivers/media/cec.c
 create mode 100644 drivers/media/platform/s5p-cec/Makefile
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
 create mode 100644 drivers/media/platform/s5p-cec/regs-cec.h
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.c
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.h
 create mode 100644 include/media/cec.h
 create mode 100644 include/uapi/linux/cec.h

-- 
1.7.9.5
