Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:44898 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750823AbdISHdh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 03:33:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCHv2 0/2] drm/bridge/adv7511: add CEC support
Date: Tue, 19 Sep 2017 09:33:29 +0200
Message-Id: <20170919073331.29007-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I should have posted this a month ago, but I completely forgot about
it. Apologies for that.

This patch series adds CEC support to the drm adv7511/adv7533 drivers.

I have tested this with the Qualcomm Dragonboard C410 (adv7533 based)
and the Renesas R-Car Koelsch board (adv7511 based).

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

Changes since v1:
- Incorporate Archit's comments:
	use defines for irq masks
	combine the adv7511/33 regmap_configs
	adv7511_cec_init now handles dt parsing & CEC registration
- Use the new (4.14) CEC_CAP_DEFAULTS define

Hans Verkuil (2):
  dt-bindings: adi,adv7511.txt: document cec clock
  drm: adv7511/33: add HDMI CEC support

 .../bindings/display/bridge/adi,adv7511.txt        |   4 +
 drivers/gpu/drm/bridge/adv7511/Kconfig             |   8 +
 drivers/gpu/drm/bridge/adv7511/Makefile            |   1 +
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |  43 ++-
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       | 337 +++++++++++++++++++++
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 116 ++++++-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |  38 +--
 7 files changed, 489 insertions(+), 58 deletions(-)
 create mode 100644 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c

-- 
2.14.1
