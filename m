Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:8663 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728204AbeINH0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 03:26:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/3] rcar-vin: add support for UDS (Up Down Scaler)
Date: Fri, 14 Sep 2018 04:13:42 +0200
Message-Id: <20180914021345.9277-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series adds support for Renesas R-Car Gen3 VIN Up Down Scaler 
(UDS). Some VIN instances have access to a often shared UDS which can be 
used to scale the captured image up or down. If the scaler is shared it 
can only be used exclusively by one VIN at a time, switching in runtime 
and detection if a UDS are in use is supported in this series. If the 
user tries to start a capture on a VIN which would require the use of a 
scaler but that scaler is in use -EBUSY is returned.

Patch 1/3 fix a format alignment issue found when working with UDS 
support. While patch 2/3 ands the UDS logic and 3/3 defines which VIN on 
which SoC have access to a UDS and how it's shared.

The series is based on top of media-tree/master and is tested on R-Car 
Gen3 H3, M3-W, M3-N and Gen2 Koelsch (checking for regressions as Gen2 
have no UDS).

Niklas Söderlund (3):
  rcar-vin: align format width with hardware limits
  rcar-vin: add support for UDS (Up Down Scaler)
  rcar-vin: declare which VINs can use a Up Down Scaler (UDS)

 drivers/media/platform/rcar-vin/rcar-core.c |  18 +++
 drivers/media/platform/rcar-vin/rcar-dma.c  | 134 +++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  15 +++
 drivers/media/platform/rcar-vin/rcar-vin.h  |  24 ++++
 4 files changed, 185 insertions(+), 6 deletions(-)

-- 
2.18.0
