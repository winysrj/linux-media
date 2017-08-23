Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41394 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932419AbdHWQxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 12:53:40 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Todor Tomov <todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Qualcomm 8x16 Camera Subsystem driver
Message-ID: <f2be5a49-49c4-c30b-8056-8711c1b27718@xs4all.nl>
Date: Wed, 23 Aug 2017 18:53:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From "[PATCH v4 00/21] Qualcomm 8x16 Camera Subsystem driver":

This patchset adds basic support for the Qualcomm Camera Subsystem found
on Qualcomm MSM8916 and APQ8016 processors.

The driver implements V4L2, Media controller and V4L2 subdev interfaces.
Camera sensor using V4L2 subdev interface in the kernel is supported.

The driver is implemented using as a reference the Qualcomm Camera
Subsystem driver for Android as found in Code Aurora [1].

The driver is tested on Dragonboard 410C (APQ8016) with one and two
OV5645 camera sensors. media-ctl [2] and yavta [3] applications were
used for testing. Also Gstreamer 1.10.4 with v4l2src plugin is supported.

More information is present in the document added by the third patch.

[1] https://source.codeaurora.org/quic/la/kernel/msm-3.10/
[2] https://git.linuxtv.org//v4l-utils.git
[3] http://git.ideasonboard.org/yavta.git


The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git camss

for you to fetch changes up to 94ab754a924656083d165077aab0def966bf1b9e:

  media: camss: Add abbreviations explanation (2017-08-23 18:40:54 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      v4l: Add packed Bayer raw12 pixel formats

Todor Tomov (22):
      dt-bindings: media: Binding document for Qualcomm Camera subsystem driver
      MAINTAINERS: Add Qualcomm Camera subsystem driver
      doc: media/v4l-drivers: Add Qualcomm Camera Subsystem driver document
      media: camss: Add CSIPHY files
      media: camss: Add CSID files
      media: camss: Add ISPIF files
      media: camss: Add VFE files
      media: camss: Add files which handle the video device nodes
      media: camms: Add core files
      media: camss: Enable building
      camss: vfe: Format conversion support using PIX interface
      doc: media/v4l-drivers: Qualcomm Camera Subsystem - PIX Interface
      camss: vfe: Support for frame padding
      camss: vfe: Add interface for scaling
      camss: vfe: Configure scaler module in VFE
      camss: vfe: Add interface for cropping
      camss: vfe: Configure crop module in VFE
      doc: media/v4l-drivers: Qualcomm Camera Subsystem - Scale and crop
      camss: Use optimal clock frequency rates
      doc: media/v4l-drivers: Qualcomm Camera Subsystem - Media graph
      doc: media/v4l-drivers/qcom_camss: Add abbreviations explanation
      media: camss: Add abbreviations explanation

 Documentation/devicetree/bindings/media/qcom,camss.txt |  197 +++
 Documentation/media/uapi/v4l/pixfmt-rgb.rst            |    1 +
 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst       |  103 ++
 Documentation/media/v4l-drivers/qcom_camss.rst         |  156 +++
 Documentation/media/v4l-drivers/qcom_camss_graph.dot   |   41 +
 MAINTAINERS                                            |    8 +
 drivers/media/platform/Kconfig                         |    7 +
 drivers/media/platform/Makefile                        |    2 +
 drivers/media/platform/qcom/camss-8x16/Makefile        |   11 +
 drivers/media/platform/qcom/camss-8x16/camss-csid.c    | 1092 ++++++++++++++++
 drivers/media/platform/qcom/camss-8x16/camss-csid.h    |   82 ++
 drivers/media/platform/qcom/camss-8x16/camss-csiphy.c  |  890 +++++++++++++
 drivers/media/platform/qcom/camss-8x16/camss-csiphy.h  |   77 ++
 drivers/media/platform/qcom/camss-8x16/camss-ispif.c   | 1175 +++++++++++++++++
 drivers/media/platform/qcom/camss-8x16/camss-ispif.h   |   85 ++
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c     | 3088 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h     |  123 ++
 drivers/media/platform/qcom/camss-8x16/camss-video.c   |  860 ++++++++++++
 drivers/media/platform/qcom/camss-8x16/camss-video.h   |   70 +
 drivers/media/platform/qcom/camss-8x16/camss.c         |  746 +++++++++++
 drivers/media/platform/qcom/camss-8x16/camss.h         |  106 ++
 drivers/media/v4l2-core/v4l2-ioctl.c                   |   12 +-
 include/uapi/linux/videodev2.h                         |    5 +
 23 files changed, 8933 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_graph.dot
 create mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.h
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
