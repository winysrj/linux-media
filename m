Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0083.outbound.protection.outlook.com ([104.47.42.83]:52160
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751115AbeFHKdd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Jun 2018 06:33:33 -0400
From: Krzysztof Witos <kwitos@cadence.com>
CC: Krzysztof Witos <kwitos@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:CADENCE MIPI-CSI2 BRIDGES" <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] cadence: csirx: Add Cadence dphy support 
Date: Fri, 8 Jun 2018 11:33:02 +0100
Message-ID: <20180608103304.16054-1-kwitos@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The main goal is to provide Cadence DPHY support for CSI2RX driver.
It is implemented basing on the DSITX DPHY solution.

Krzysztof Witos (2):
  csirx updated doc for csirx with dphy supported
  added support for csirx dphy

 .../devicetree/bindings/media/cdns,csi2rx.txt      |  32 +-
 drivers/media/platform/cadence/cdns-csi2rx.c       | 342 +++++++++++++++++++--
 2 files changed, 341 insertions(+), 33 deletions(-)

-- 
2.15.0
