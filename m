Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:48309 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752460AbdLLP2m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 10:28:42 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Dmitry Osipenko <digetx@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16] staging/media: add NVIDIA Tegra video decoder
 driver
Message-ID: <27cd85c2-4e27-707d-6b94-bfad274d1806@xs4all.nl>
Date: Tue, 12 Dec 2017 16:28:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a new NVIDIA Tegra video decoder driver. It is depending on the
request API work since it is a stateless codec, so for now park this in staging.

The dts patches should go through nvidia's tree.

Regards,

	Hans

The following changes since commit 330dada5957e3ca0c8811b14c45e3ac42c694651:

  media: dvb_frontend: fix return error code (2017-12-12 07:50:14 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tegradec

for you to fetch changes up to c3c530f45e48b33a2cc49cdeec246d255a5ca7db:

  staging: media: Introduce NVIDIA Tegra video decoder driver (2017-12-12 16:06:06 +0100)

----------------------------------------------------------------
Dmitry Osipenko (2):
      media: dt: bindings: Add binding for NVIDIA Tegra Video Decoder Engine
      staging: media: Introduce NVIDIA Tegra video decoder driver

 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt |   55 +++
 MAINTAINERS                                                  |    9 +
 drivers/staging/media/Kconfig                                |    2 +
 drivers/staging/media/Makefile                               |    1 +
 drivers/staging/media/tegra-vde/Kconfig                      |    7 +
 drivers/staging/media/tegra-vde/Makefile                     |    1 +
 drivers/staging/media/tegra-vde/TODO                         |    4 +
 drivers/staging/media/tegra-vde/tegra-vde.c                  | 1213 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/tegra-vde/uapi.h                       |   78 +++
 9 files changed, 1370 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
 create mode 100644 drivers/staging/media/tegra-vde/Kconfig
 create mode 100644 drivers/staging/media/tegra-vde/Makefile
 create mode 100644 drivers/staging/media/tegra-vde/TODO
 create mode 100644 drivers/staging/media/tegra-vde/tegra-vde.c
 create mode 100644 drivers/staging/media/tegra-vde/uapi.h
