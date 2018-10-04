Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:33107 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbeJEDh3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:37:29 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/5] i2c: adv748x: add support for CSI-2 TXA to work in 1-, 2- and 4-lane mode
Date: Thu,  4 Oct 2018 22:41:33 +0200
Message-Id: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Hi,

This series allows the TXA CSI-2 transmitter of the adv748x to function
in 1-, 2- and 4- lane mode. Currently the driver fixes the hardware in
4-lane mode. The driver looks at the standard DT property 'data-lanes'
to determine which mode it should operate in.

Patch 1/5 lists the 'data-lanes' DT property as mandatory for endpoints 
describing the CSI-2 transmitters. Patch 2/5 and 3/5 refactors the 
initialization sequence of the adv748x to be able to reuse more code. 
Patch 4/5 adds the DT parsing and storing of the number of lanes. Patch
5/5 merges the TXA and TXB power up/down procedure while also taking the 
configurable number of lanes into account.

The series is based on the latest media-tree master and is tested on
Renesas M3-N in 1-, 2- and 4- lane mode.

Niklas Söderlund (5):
  dt-bindings: adv748x: make data-lanes property mandatory for CSI-2
    endpoints
  i2c: adv748x: reorder register writes for CSI-2 transmitters
    initialization
  i2c: adv748x: reuse power up sequence when initializing CSI-2
  i2c: adv748x: store number of CSI-2 lanes described in device tree
  i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter

 .../devicetree/bindings/media/i2c/adv748x.txt |   3 +
 drivers/media/i2c/adv748x/adv748x-core.c      | 207 ++++++++++--------
 drivers/media/i2c/adv748x/adv748x.h           |   1 +
 3 files changed, 122 insertions(+), 89 deletions(-)

-- 
2.19.0
