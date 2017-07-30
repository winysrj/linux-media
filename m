Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59935 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750991AbdG3NHt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:07:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/4] drm/bridge/adv7511: add CEC support
Date: Sun, 30 Jul 2017 15:07:39 +0200
Message-Id: <20170730130743.19681-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds CEC support to the drm adv7511/adv7533 drivers.

I have tested this with the Qualcomm Dragonboard C410 (adv7533 based)
and the Renesas R-Car Koelsch board (adv7511 based).

Note: the Dragonboard needs this patch:

https://patchwork.kernel.org/patch/9824773/

Archit, can you confirm that this patch will go to kernel 4.14?

And the Koelsch board needs this 4.13 fix:

https://patchwork.kernel.org/patch/9836865/

I only have the Koelsch board to test with, but it looks like other
R-Car boards use the same adv7511. It would be nice if someone can
add CEC support to the other R-Car boards as well. The main thing
to check is if they all use the same 12 MHz fixed CEC clock source.

Anyone who wants to test this will need the CEC utilities that
are part of the v4l-utils git repository:

git clone git://linuxtv.org/v4l-utils.git
cd v4l-utils
./bootstrap.sh
./configure
make
sudo make install

Now configure the CEC adapter as a Playback device:

cec-ctl --playback

Discover other CEC devices:

cec-ctl -S

Regards,

	Hans

Hans Verkuil (4):
  dt-bindings: adi,adv7511.txt: document cec clock
  arm: dts: qcom: add cec clock for apq8016 board
  arm: dts: renesas: add cec clock for Koelsch board
  drm: adv7511/33: add HDMI CEC support

 .../bindings/display/bridge/adi,adv7511.txt        |   4 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |   8 +
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi          |   2 +
 drivers/gpu/drm/bridge/adv7511/Kconfig             |   8 +
 drivers/gpu/drm/bridge/adv7511/Makefile            |   1 +
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |  45 ++-
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       | 314 +++++++++++++++++++++
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 152 +++++++++-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |  30 +-
 9 files changed, 514 insertions(+), 50 deletions(-)
 create mode 100644 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c

-- 
2.13.1
