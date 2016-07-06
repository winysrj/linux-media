Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36005 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbcGFXh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:37:27 -0400
Received: by mail-pa0-f54.google.com with SMTP id uj8so584706pab.3
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:36:55 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 0/6] ARM: dts: imx6-sabre*: add video capture nodes
Date: Wed,  6 Jul 2016 16:36:37 -0700
Message-Id: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam (6):
  ARM: dts: imx6-sabrelite: add video capture devices and connections
  ARM: dts: imx6-sabresd: add video capture devices and connections
  ARM: dts: imx6-sabreauto: create i2cmux for i2c3
  ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
  ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
  ARM: dts: imx6-sabreauto: add video capture devices and connections

 arch/arm/boot/dts/imx6dl-sabresd.dts     |  42 +++++++++
 arch/arm/boot/dts/imx6q-sabresd.dts      |  14 +++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 154 ++++++++++++++++++++++++++-----
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi |  95 +++++++++++++++++++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi   | 130 +++++++++++++++++++++++++-
 5 files changed, 413 insertions(+), 22 deletions(-)

-- 
1.9.1

