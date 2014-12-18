Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:60518 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaLRIv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:51:58 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <voice.shen@atmel.com>, <plagnioj@jcrosoft.com>,
	<boris.brezillon@free-electrons.com>,
	<alexandre.belloni@free-electrons.com>,
	<devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
	<linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>,
	<laurent.pinchart@ideasonboard.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/7] ARM: at91: dts: sama5d3: add dt support for atmel isi and ov2640 sensor
Date: Thu, 18 Dec 2014 16:51:00 +0800
Message-ID: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add ISI and ov2640 support on dts files.

As the ov2640 driver dt is still in review. The patch is in: https://patchwork.linuxtv.org/patch/27554/
So I want to send this dt patch early for a review.

Bo Shen (3):
  ARM: at91: dts: sama5d3: split isi pinctrl
  ARM: at91: dts: sama5d3: add missing pins of isi
  ARM: at91: dts: sama5d3: move the isi mck pin to mb

Josh Wu (4):
  ARM: at91: dts: sama5d3: add isi clock
  ARM: at91: dts: sama5d3: change name of pinctrl_isi_{power,reset}
  ARM: at91: dts: sama5d3: add ov2640 camera sensor support
  ARM: at91: sama5: enable atmel-isi and ov2640 in defconfig

 arch/arm/boot/dts/sama5d3.dtsi    | 20 +++++++++++++-----
 arch/arm/boot/dts/sama5d3xmb.dtsi | 43 +++++++++++++++++++++++++++++++++++----
 arch/arm/configs/sama5_defconfig  |  6 ++++++
 3 files changed, 60 insertions(+), 9 deletions(-)

-- 
1.9.1

