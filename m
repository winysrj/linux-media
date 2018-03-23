Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41374 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752628AbeCWM7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 08:59:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 0/3] dw-hdmi: add property to disable CEC
Date: Fri, 23 Mar 2018 13:59:12 +0100
Message-Id: <20180323125915.13986-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some boards (amlogic) have two CEC controllers: the DesignWare controller
and their own CEC controller (meson ao-cec).

Since the CEC line is not hooked up to the DW controller we need a way
to disable that controller. This patch series adds the cec-disable
property for that purpose.

Regards,

	Hans

Changes since v1:

- Move the dts change to meson-gx.dtsi since according to Neil it is
  valid for all meson-gx boards.
- Fix bad subject line of patch 1.

Hans Verkuil (3):
  dt-bindings: display: dw_hdmi.txt: add cec-disable property
  drm: bridge: dw-hdmi: check the cec-disable property
  arm64: dts: meson-gx.dtsi: add cec-disable

 Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt | 3 +++
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                    | 1 +
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                    | 3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.15.1
