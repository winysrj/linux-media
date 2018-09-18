Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:32843 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbeIRHUG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 03:20:06 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/3] i2c: adv748x: add support for CSI-2 TXA to work in 1-, 2- and 4-lane mode
Date: Tue, 18 Sep 2018 03:45:06 +0200
Message-Id: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
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

Patch 1/3 adds the DT parsing and storing of the number of lanes. Patch 
2/3 adds functionality for intercepting and injecting the requested 
number of lanes when writing the register for NUM_LANES for the TXA 
register 0x00. Lastly patch 3/3 fixes a type related to lane settings 
for TXB which is confusing (at lest to me) when reviewing the result of 
this series.

Patch 1/3 and 2/3 could be squashed together but as the method in 2/3 is 
less then obvious since it intercepts the long tables of register writes 
I thought splitting them could ease review.

The series is based on the latest media-tree master and is tested on 
Renesas M3-N in 1-, 2- and 4- lane mode.

Niklas Söderlund (3):
  i2c: adv748x: store number of CSI-2 lanes described in device tree
  i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter
  i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down

 drivers/media/i2c/adv748x/adv748x-core.c | 89 +++++++++++++++++++++---
 drivers/media/i2c/adv748x/adv748x.h      |  1 +
 2 files changed, 81 insertions(+), 9 deletions(-)

-- 
2.18.0
