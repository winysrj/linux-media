Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:30473 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727250AbeKCBI3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 21:08:29 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 0/4] i2c: adv748x: add support for CSI-2 TXA to work 
Date: Fri,  2 Nov 2018 17:00:05 +0100
Message-Id: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series allows the TXA CSI-2 transmitter of the adv748x to function
in 1-, 2- and 4- lane mode. Currently the driver fixes the hardware in
4-lane mode. The driver looks at the standard DT property 'data-lanes'
to determine which mode it should operate in.

Patch 1/4 lists the 'data-lanes' DT property as mandatory for endpoints
describing the CSI-2 transmitters. Patch 2/4 refactors the 
initialization sequence of the adv748x to be able to reuse more code.
Patch 3/4 adds the DT parsing and storing of the number of lanes. Patch
4/4 merges the TXA and TXB power up/down procedure while also taking the
configurable number of lanes into account.

The series is based on the latest media-tree master and is tested on
Renesas M3-N in 1-, 2- and 4- lane mode.

Niklas Söderlund (4):
  dt-bindings: adv748x: make data-lanes property mandatory for CSI-2
    endpoints
  i2c: adv748x: reuse power up sequence when initializing CSI-2
  i2c: adv748x: store number of CSI-2 lanes described in device tree
  i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter

 .../devicetree/bindings/media/i2c/adv748x.txt |   4 +-
 drivers/media/i2c/adv748x/adv748x-core.c      | 235 ++++++++++--------
 drivers/media/i2c/adv748x/adv748x.h           |   1 +
 3 files changed, 135 insertions(+), 105 deletions(-)

-- 
2.19.1
