Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:43937 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755299AbeCSLnx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 07:43:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH 0/3] dw-hdmi: add property to disable CEC
Date: Mon, 19 Mar 2018 12:43:42 +0100
Message-Id: <20180319114345.29837-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some boards (amlogic) have two CEC controllers: the DesignWare controller
and their own CEC controller (meson ao-cec).

Since the CEC line is not hooked up to the DW controller we need a way
to disable that controller. This patch series adds the cec-disable
property for that purpose.

Neil, I have added cec-disable to meson-gxl-s905x-libretech-cc.dts
only, but I suspect it is probably valid for all meson-glx devices?
Should I move it to meson-gxl.dtsi?

Regards,

	Hans

Hans Verkuil (3):
  dt-bindings: display: dw_hdmi.txt
  drm: bridge: dw-hdmi: check the cec-disable property
  arm64: dts: meson-gxl-s905x-libretech-cc: add cec-disable

 Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt | 3 +++
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts | 1 +
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                    | 3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.15.1
