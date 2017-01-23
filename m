Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40439 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750708AbdAWJBV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 04:01:21 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.11] coda: add support for Video Data Order Adapter
Message-ID: <74c99f5d-30f2-f5a8-1208-44e47eefd9ed@xs4all.nl>
Date: Mon, 23 Jan 2017 10:01:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.11c

for you to fetch changes up to 7da44db4d65786332a797aa08b7932e2fb4d421f:

  coda: support YUYV output if VDOA is used (2017-01-23 09:43:46 +0100)

----------------------------------------------------------------
Michael Tretter (3):
      coda: fix frame index to returned error
      coda: use VDOA for un-tiling custom macroblock format
      coda: support YUYV output if VDOA is used

Philipp Zabel (4):
      dt-bindings: Add a binding for Video Data Order Adapter
      coda: add i.MX6 VDOA driver
      coda: correctly set capture compose rectangle
      coda: add debug output about tiling

 Documentation/devicetree/bindings/media/fsl-vdoa.txt |  21 +++
 arch/arm/boot/dts/imx6qdl.dtsi                       |   2 +
 drivers/media/platform/Kconfig                       |   3 +
 drivers/media/platform/coda/Makefile                 |   1 +
 drivers/media/platform/coda/coda-bit.c               |  93 +++++++++----
 drivers/media/platform/coda/coda-common.c            | 177 ++++++++++++++++++++++---
 drivers/media/platform/coda/coda.h                   |   3 +
 drivers/media/platform/coda/imx-vdoa.c               | 338 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/coda/imx-vdoa.h               |  58 ++++++++
 9 files changed, 654 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-vdoa.txt
 create mode 100644 drivers/media/platform/coda/imx-vdoa.c
 create mode 100644 drivers/media/platform/coda/imx-vdoa.h
