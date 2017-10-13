Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54333 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbdJMWxs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 18:53:48 -0400
From: Pierre-Hugues Husson <phh@phh.me>
To: linux-rockchip@lists.infradead.org
Cc: heiko@sntech.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Pierre-Hugues Husson <phh@phh.me>
Subject: [PATCH 0/3] Enable CEC on rk3399
Date: Sat, 14 Oct 2017 00:53:34 +0200
Message-Id: <20171013225337.5196-1-phh@phh.me>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable CEC on firefly-rk3399.
Tested on a TV with cec-ctl --playback; cec-ctl -S

Pierre-Hugues Husson (3):
  drm: bridge: synopsys/dw-hdmi: Enable cec clock
  arm64: dts: rockchip: add the cec clk for dw-mipi-hdmi on rk3399
  arm64: dts: rockchip: enable cec pin for rk3399 firefly

 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts |  2 ++
 arch/arm64/boot/dts/rockchip/rk3399.dtsi        |  8 ++++++--
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c       | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

-- 
2.14.1
