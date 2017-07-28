Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39117 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751992AbdG1NFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 09:05:12 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Neil Armstrong <narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Add meson-ao-cec driver
Message-ID: <77ba4a16-c11e-bf65-b2c9-943dddcab0f7@xs4all.nl>
Date: Fri, 28 Jul 2017 15:05:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git meson-cec

for you to fetch changes up to 098b47db51270f6e671773160411e3d285ea0d66:

  dt-bindings: media: Add Amlogic Meson AO-CEC bindings (2017-07-28 14:58:38 +0200)

----------------------------------------------------------------
Neil Armstrong (2):
      platform: Add Amlogic Meson AO CEC Controller driver
      dt-bindings: media: Add Amlogic Meson AO-CEC bindings

 Documentation/devicetree/bindings/media/meson-ao-cec.txt |  28 ++
 drivers/media/platform/Kconfig                           |  11 +
 drivers/media/platform/Makefile                          |   2 +
 drivers/media/platform/meson/Makefile                    |   1 +
 drivers/media/platform/meson/ao-cec.c                    | 744 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 786 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt
 create mode 100644 drivers/media/platform/meson/Makefile
 create mode 100644 drivers/media/platform/meson/ao-cec.c
