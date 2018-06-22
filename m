Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46336 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933915AbeFVPeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:00 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 00/32] Qualcomm Camera Subsystem driver - 8x96 support
Date: Fri, 22 Jun 2018 18:33:09 +0300
Message-Id: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds support for the Qualcomm Camera Subsystem found
on Qualcomm MSM8996 and APQ8096 SoC to the existing driver which
used to support MSM8916 and APQ8016.

The camera subsystem hardware on 8x96 is similar to 8x16 but
supports more cameras and features. More details are added in the
driver document by the last patch.

The first 3 patches are dependencies which have already been on
the mainling list but I'm adding them here for completeness.

The following 11 patches add general updates and fixes to the driver.
Then the rest add the support for the new hardware.

The driver is tested on Dragonboard 410c (APQ8016) and Dragonboard 820c
(APQ8096) with OV5645 camera sensors. media-ctl [1], yavta [2] and
GStreamer were used for testing.

[1] https://git.linuxtv.org//v4l-utils.git
[2] http://git.ideasonboard.org/yavta.git


Sakari Ailus (1):
  doc-rst: Add packed Bayer raw14 pixel formats

Todor Tomov (31):
  media: v4l: Add new 2X8 10-bit grayscale media bus code
  media: v4l: Add new 10-bit packed grayscale format
  media: Rename CAMSS driver path
  media: camss: Use SPDX license headers
  media: camss: Fix OF node usage
  media: camss: csiphy: Ensure clock mux config is done before the rest
  media: camss: Unify the clock names
  media: camss: csiphy: Update settle count calculation
  media: camss: csid: Configure data type and decode format properly
  media: camss: vfe: Fix to_vfe() macro member name
  media: camss: vfe: Get line pointer as container of video_out
  media: camss: vfe: Do not disable CAMIF when clearing its status
  media: dt-bindings: media: qcom,camss: Fix whitespaces
  media: dt-bindings: media: qcom,camss: Add 8996 bindings
  media: camss: Add 8x96 resources
  media: camss: Add basic runtime PM support
  media: camss: csiphy: Split to hardware dependent and independent
    parts
  media: camss: csiphy: Unify lane handling
  media: camss: csiphy: Add support for 8x96
  media: camss: csid: Add support for 8x96
  media: camss: ispif: Add support for 8x96
  media: camss: vfe: Split to hardware dependent and independent parts
  media: camss: vfe: Add support for 8x96
  media: camss: Format configuration per hardware version
  media: camss: vfe: Different format support on source pad
  media: camss: vfe: Add support for UYVY output from VFE on 8x96
  media: camss: csid: Different format support on source pad
  media: camss: csid: MIPI10 to Plain16 format conversion
  media: camss: Add support for RAW MIPI14 on 8x96
  media: camss: Add support for 10-bit grayscale formats
  media: doc: media/v4l-drivers: Update Qualcomm CAMSS driver document
    for 8x96

 .../devicetree/bindings/media/qcom,camss.txt       |  128 +-
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst   |  127 +
 Documentation/media/uapi/v4l/pixfmt-y10p.rst       |   33 +
 Documentation/media/uapi/v4l/subdev-formats.rst    |   72 +
 Documentation/media/uapi/v4l/yuv-formats.rst       |    1 +
 Documentation/media/v4l-drivers/qcom_camss.rst     |   93 +-
 .../media/v4l-drivers/qcom_camss_8x96_graph.dot    |  104 +
 MAINTAINERS                                        |    2 +-
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/Makefile                    |    2 +-
 drivers/media/platform/qcom/camss-8x16/Makefile    |   11 -
 .../media/platform/qcom/camss-8x16/camss-csid.c    | 1094 -------
 .../media/platform/qcom/camss-8x16/camss-csid.h    |   82 -
 .../media/platform/qcom/camss-8x16/camss-csiphy.c  |  893 ------
 .../media/platform/qcom/camss-8x16/camss-csiphy.h  |   77 -
 .../media/platform/qcom/camss-8x16/camss-ispif.c   | 1178 --------
 .../media/platform/qcom/camss-8x16/camss-ispif.h   |   85 -
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 3093 --------------------
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  123 -
 .../media/platform/qcom/camss-8x16/camss-video.c   |  859 ------
 .../media/platform/qcom/camss-8x16/camss-video.h   |   70 -
 drivers/media/platform/qcom/camss-8x16/camss.c     |  751 -----
 drivers/media/platform/qcom/camss-8x16/camss.h     |  106 -
 drivers/media/platform/qcom/camss/Makefile         |   15 +
 drivers/media/platform/qcom/camss/camss-csid.c     | 1376 +++++++++
 drivers/media/platform/qcom/camss/camss-csid.h     |   77 +
 .../platform/qcom/camss/camss-csiphy-2ph-1-0.c     |  177 ++
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |  256 ++
 drivers/media/platform/qcom/camss/camss-csiphy.c   |  761 +++++
 drivers/media/platform/qcom/camss/camss-csiphy.h   |   89 +
 drivers/media/platform/qcom/camss/camss-ispif.c    | 1367 +++++++++
 drivers/media/platform/qcom/camss/camss-ispif.h    |   78 +
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c  | 1018 +++++++
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c  | 1140 ++++++++
 drivers/media/platform/qcom/camss/camss-vfe.c      | 2341 +++++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe.h      |  183 ++
 drivers/media/platform/qcom/camss/camss-video.c    |  958 ++++++
 drivers/media/platform/qcom/camss/camss-video.h    |   62 +
 drivers/media/platform/qcom/camss/camss.c          | 1027 +++++++
 drivers/media/platform/qcom/camss/camss.h          |  115 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
 include/uapi/linux/media-bus-format.h              |    3 +-
 include/uapi/linux/videodev2.h                     |    6 +
 44 files changed, 11530 insertions(+), 8507 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10p.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.c
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.h
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.c
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.h
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.c
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.c
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.h
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
 create mode 100644 drivers/media/platform/qcom/camss/Makefile
 create mode 100644 drivers/media/platform/qcom/camss/camss-csid.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-csid.h
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy.h
 create mode 100644 drivers/media/platform/qcom/camss/camss-ispif.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-ispif.h
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-1.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-7.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe.h
 create mode 100644 drivers/media/platform/qcom/camss/camss-video.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-video.h
 create mode 100644 drivers/media/platform/qcom/camss/camss.c
 create mode 100644 drivers/media/platform/qcom/camss/camss.h

-- 
2.7.4
