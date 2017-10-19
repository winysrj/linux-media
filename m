Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:17057 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752972AbdJSLjB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 07:39:01 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT PULL FOR v4.15] tegra-cec: new Tegra CEC driver
Message-ID: <0c069c30-5d5a-36a1-71d9-b275b5c4a8fd@cisco.com>
Date: Thu, 19 Oct 2017 13:38:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is a new CEC driver for the Tegra. Thierry has merged the dts and the
drm cec-notifier patches for 4.15, so the CEC driver itself can now be merged
in the media subsystem.

Thanks!

	Hans

The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:

  Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tegra-cec2

for you to fetch changes up to dbb7e080c3275d89196a393652ce4fd00eee1924:

  tegra-cec: add Tegra HDMI CEC driver (2017-10-19 13:36:38 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      dt-bindings: document the tegra CEC bindings
      tegra-cec: add Tegra HDMI CEC driver

 Documentation/devicetree/bindings/media/tegra-cec.txt |  27 +++
 MAINTAINERS                                           |   8 +
 drivers/media/platform/Kconfig                        |  11 ++
 drivers/media/platform/Makefile                       |   2 +
 drivers/media/platform/tegra-cec/Makefile             |   1 +
 drivers/media/platform/tegra-cec/tegra_cec.c          | 501 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/tegra-cec/tegra_cec.h          | 127 ++++++++++++++
 7 files changed, 677 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/tegra-cec.txt
 create mode 100644 drivers/media/platform/tegra-cec/Makefile
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.c
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.h
