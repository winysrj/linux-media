Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:2394 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733249AbeHAMSQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 08:18:16 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Todor Tomov <todor.tomov@linaro.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT PULL FOR v4.18 or v4.19] Qualcomm Camera Subsystem driver - 8x96
 support
Message-ID: <aaaabfff-391a-f36c-d6aa-6c3684408fe7@cisco.com>
Date: Wed, 1 Aug 2018 12:33:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds camera support for Qualcomm's 8x96.

Since 4.18 is delayed by another week (see lwn.net) I am hoping this can still
be applied for 4.18. If not, then it can go to 4.19.

Regards,

	Hans

The following changes since commit 1d06352e18ef502e30837cedfe618298816fb48c:

  media: tvp5150: add g_std callback (2018-07-30 20:04:33 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git camss

for you to fetch changes up to d0151162ad654a9999a2d8be51f6cf08f108f976:

  media: camss: csid: Add support for events triggered by user controls (2018-08-01 12:30:01 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      doc-rst: Add packed Bayer raw14 pixel formats

Todor Tomov (33):
      media: v4l: Add new 2X8 10-bit grayscale media bus code
      media: v4l: Add new 10-bit packed grayscale format
      media: Rename CAMSS driver path
      media: camss: Use SPDX license headers
      media: camss: Fix OF node usage
      media: camss: csiphy: Ensure clock mux config is done before the rest
      media: dt-bindings: media: qcom, camss: Unify the clock names
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
      media: camss: csiphy: Split to hardware dependent and independent parts
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
      media: doc: media/v4l-drivers: Update Qualcomm CAMSS driver document for 8x96
      media: camss: csid: Add support for events triggered by user controls

 Documentation/devicetree/bindings/media/qcom,camss.txt           |  128 ++--
 Documentation/media/uapi/v4l/pixfmt-rgb.rst                      |    1 +
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst                 |  127 ++++
 Documentation/media/uapi/v4l/pixfmt-y10p.rst                     |   33 +
 Documentation/media/uapi/v4l/subdev-formats.rst                  |   72 ++
 Documentation/media/uapi/v4l/yuv-formats.rst                     |    1 +
 Documentation/media/v4l-drivers/qcom_camss.rst                   |   93 ++-
 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot        |  104 +++
 MAINTAINERS                                                      |    2 +-
 drivers/media/platform/Kconfig                                   |    2 +-
 drivers/media/platform/Makefile                                  |    2 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h               |  123 ----
 drivers/media/platform/qcom/{camss-8x16 => camss}/Makefile       |    4 +
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.c   |  471 ++++++++++---
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.h   |   17 +-
 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c         |  176 +++++
 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c         |  256 +++++++
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.c |  363 ++++------
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.h |   37 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.c  |  264 ++++++-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.h  |   23 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c                | 1018 +++++++++++++++++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c                | 1140 ++++++++++++++++++++++++++++++
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-vfe.c    | 1569 +++++++++++-------------------------------
 drivers/media/platform/qcom/camss/camss-vfe.h                    |  186 +++++
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.c  |  133 +++-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.h  |   12 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss.c        |  450 +++++++++---
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss.h        |   43 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                             |    5 +
 include/uapi/linux/media-bus-format.h                            |    3 +-
 include/uapi/linux/videodev2.h                                   |    6 +
 32 files changed, 4960 insertions(+), 1904 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10p.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/Makefile (68%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.c (69%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.h (74%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.c (71%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.h (60%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.c (80%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.h (68%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-1.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-7.c
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-vfe.c (54%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe.h
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.c (81%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.h (74%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss.c (61%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss.h (75%)
