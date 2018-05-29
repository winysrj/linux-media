Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:45791 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935380AbeE2PG0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 11:06:26 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 0/8] media: rcar-vin: Brush endpoint properties
Date: Tue, 29 May 2018 17:05:51 +0200
Message-Id: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   3rd version of VIN endpoint brushing series.

Slightly enlarged the linux-media receiver list, as this new version
introduces a common property in 'video-interfaces.txt'.

Quite some changes compared to v1/v2:
- First patch in the series changed to include Niklas' comments on using
  spaces for indent over tabs in documentation and as suggested by Rob and
  Laurent to refer to 'video-interfaces.txt' in property description.
- As suggested by Rob this series introduces a new property 'data-enable-active'
  to describe data enable signal polarity instead of using 'data-active' which
  refers to the data lanes polarity.
- Use this new property to control CLKENB pin polarity in VIN driver
- Introduce a new custom property to describe the 'use HSYNC as data-enable'
  function provided by VIN. In previous iterations I used the presence of
  'data-active' to enable/disable this functionality. That was confusing and
  not correct as it used the wrong property. As this is a VIN specificity, I
  thought a custom property is more suited.
- Last patch is still there and I know it is debated. My opinion is that it is
  still needed, as the presence of those un-documented and un-parsed properties
  confuses users which may expect changing those properties value to reflect on
  the video interface configuration, which does not happens instead.

Individual changelog per patch when relevant.

Thanks
    j

Jacopo Mondi (8):
  dt-bindings: media: rcar-vin: Describe optional ep properties
  dt-bindings: media: Document data-enable-active property
  media: v4l2-fwnode: parse 'data-enable-active' prop
  dt-bindings: media: rcar-vin: Add 'data-enable-active'
  media: rcar-vin: Handle data-enable polarity
  dt-bindings: rcar-vin: Add 'hsync-as-de' custom prop
  media: rcar-vin: Handle 'hsync-as-de' property
  ARM: dts: rcar-gen2: Remove unused VIN properties

 Documentation/devicetree/bindings/media/rcar_vin.txt     | 16 +++++++++++++++-
 .../devicetree/bindings/media/video-interfaces.txt       |  2 ++
 arch/arm/boot/dts/r8a7790-lager.dts                      |  3 ---
 arch/arm/boot/dts/r8a7791-koelsch.dts                    |  3 ---
 arch/arm/boot/dts/r8a7791-porter.dts                     |  1 -
 arch/arm/boot/dts/r8a7793-gose.dts                       |  3 ---
 arch/arm/boot/dts/r8a7794-alt.dts                        |  1 -
 arch/arm/boot/dts/r8a7794-silk.dts                       |  1 -
 drivers/media/platform/rcar-vin/rcar-core.c              |  6 ++++++
 drivers/media/platform/rcar-vin/rcar-dma.c               | 11 +++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h               |  2 ++
 drivers/media/v4l2-core/v4l2-fwnode.c                    |  5 +++++
 include/media/v4l2-mediabus.h                            |  2 ++
 13 files changed, 43 insertions(+), 13 deletions(-)

--
2.7.4
