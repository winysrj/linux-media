Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:47461 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727444AbeJEDAO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 23:00:14 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/3] rcar-vin: add support for UDS (Up Down Scaler)
Date: Thu,  4 Oct 2018 22:03:59 +0200
Message-Id: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se>
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

* Changes since v1
- Patch 1/3 have been replaced with a less strict version after good 
  comments from Hans.

Niklas Söderlund (3):
  rcar-vin: align width before stream start
  rcar-vin: add support for UDS (Up Down Scaler)
  rcar-vin: declare which VINs can use a Up Down Scaler (UDS)

 drivers/media/platform/rcar-vin/rcar-core.c |  18 +++
 drivers/media/platform/rcar-vin/rcar-dma.c  | 139 ++++++++++++++++++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c |   9 ++
 drivers/media/platform/rcar-vin/rcar-vin.h  |  24 ++++
 4 files changed, 180 insertions(+), 10 deletions(-)

-- 
2.19.0
