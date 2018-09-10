Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59576 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbeIJRXa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 13:23:30 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] i.MX PXP scaler/CSC driver
Message-ID: <4654cafe-4e7c-cf73-dd69-56da98f09567@xs4all.nl>
Date: Mon, 10 Sep 2018 14:29:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pull request for v3 of this new driver (https://www.spinics.net/lists/arm-kernel/msg674871.html).

Regards,

	Hans

The following changes since commit d842a7cf938b6e0f8a1aa9f1aec0476c9a599310:

  media: adv7842: enable reduced fps detection (2018-08-31 10:03:51 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git pxp

for you to fetch changes up to e04f2b108133c628747df35e5be42e2faa0325f7:

  MAINTAINERS: add entry for i.MX PXP media mem2mem driver (2018-09-10 13:36:55 +0200)

----------------------------------------------------------------
Philipp Zabel (3):
      dt-bindings: media: Add i.MX Pixel Pipeline binding
      media: imx-pxp: add i.MX Pixel Pipeline driver
      MAINTAINERS: add entry for i.MX PXP media mem2mem driver

 Documentation/devicetree/bindings/media/fsl-pxp.txt |   26 +
 MAINTAINERS                                         |    7 +
 drivers/media/platform/Kconfig                      |    9 +
 drivers/media/platform/Makefile                     |    2 +
 drivers/media/platform/imx-pxp.c                    | 1752 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/imx-pxp.h                    | 1685 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 3481 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-pxp.txt
 create mode 100644 drivers/media/platform/imx-pxp.c
 create mode 100644 drivers/media/platform/imx-pxp.h
