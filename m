Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52335 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588AbbEDJY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 05:24:29 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>
Subject: [PATCH v2 0/3] Add media bdisp driver for stihxxx platforms
Date: Mon, 4 May 2015 11:24:18 +0200
Message-ID: <1430731461-8496-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches adds the support of v4l2 2D blitter driver for
STMicroelectronics SOC.

version 2:
	- Renamed to STI_BDISP, inserted the sti directory.
	- Reworked the cropping vs selection API.
	- Used additional v4l2_m2m helpers and fops.
	- Dropped pixel format description.
	- Fixed memory release issue.

version 1:
	- Initial submission.

The following features are supported and tested:
- Color format conversion (RGB32, RGB24, RGB16, NV12, YUV420P)
- Copy
- Scale
- Flip
- Deinterlace
- Wide (4K) picture support
- Crop

This driver uses the v4l2 mem2mem framework and its implementation was largely
inspired by the Exynos G-Scaler (exynos-gsc) driver.

The driver is mainly implemented across two files:
- bdisp-v4l2.c
- bdisp-hw.c
bdisp-v4l2.c uses v4l2_m2m to manage the V4L2 interface with the userland.
It calls the HW services that are implemented in bdisp-hw.c.

The additional bdisp-debug.c file manages some debugfs entries.

Fabien Dessenne (3):
  [media] bdisp: add DT bindings documentation
  [media] bdisp: 2D blitter driver using v4l2 mem2mem framework
  [media] bdisp: add debug file system

 .../devicetree/bindings/media/st,stih4xx.txt       |   32 +
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/sti/bdisp/Kconfig           |    9 +
 drivers/media/platform/sti/bdisp/Makefile          |    3 +
 drivers/media/platform/sti/bdisp/bdisp-debug.c     |  668 ++++++++++
 drivers/media/platform/sti/bdisp/bdisp-filter.h    |  346 +++++
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |  823 ++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-reg.h       |  235 ++++
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 1408 ++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp.h           |  216 +++
 11 files changed, 3752 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stih4xx.txt
 create mode 100644 drivers/media/platform/sti/bdisp/Kconfig
 create mode 100644 drivers/media/platform/sti/bdisp/Makefile
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-debug.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-filter.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-hw.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-reg.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-v4l2.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp.h

-- 
1.9.1

