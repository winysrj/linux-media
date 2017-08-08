Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:47266 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751880AbdHHOwv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 10:52:51 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Neil Armstrong <narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] v2: Add meson-ao-cec driver
Message-ID: <f3ab3459-b8bc-184d-6a91-e529f3f03815@xs4all.nl>
Date: Tue, 8 Aug 2017 16:52:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1: added MAINTAINERS patch.

Regards,

	Hans

The following changes since commit 079c6eaf80d9fb6d9cea7ad71e590c8425c1b0fe:

  media: v4l2-tpg: fix the SMPTE-2084 transfer function (2017-08-08 07:05:09 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git meson-cec

for you to fetch changes up to 12ff5145fc98317f48ca7ea5100e2b80470a12d1:

  MAINTAINERS: add entry for meson ao cec driver (2017-08-08 16:51:32 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      MAINTAINERS: add entry for meson ao cec driver

Neil Armstrong (2):
      dt-bindings: media: Add Amlogic Meson AO-CEC bindings
      platform: Add Amlogic Meson AO CEC Controller driver

 Documentation/devicetree/bindings/media/meson-ao-cec.txt |  28 ++
 MAINTAINERS                                              |  10 +
 drivers/media/platform/Kconfig                           |  11 +
 drivers/media/platform/Makefile                          |   2 +
 drivers/media/platform/meson/Makefile                    |   1 +
 drivers/media/platform/meson/ao-cec.c                    | 744 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 796 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt
 create mode 100644 drivers/media/platform/meson/Makefile
 create mode 100644 drivers/media/platform/meson/ao-cec.c
