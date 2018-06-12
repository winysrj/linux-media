Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:55513 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754286AbeFLJnm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 05:43:42 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3
Date: Tue, 12 Jun 2018 11:43:22 +0200
Message-Id: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series adds support for parallel video input to the Gen3 version of
rcar-vin driver.

Few changes compared to v5, closing a few comments from Kieran and Niklas,
and fixed the label names I forgot to change in previous version.

Changlog in the individual patches when relevant.

A few patches have not yet been acked-by, but things look smooth and we
should be close to have this finalized.

Thanks
   j

Jacopo Mondi (10):
  media: rcar-vin: Rename 'digital' to 'parallel'
  media: rcar-vin: Remove two empty lines
  media: rcar-vin: Create a group notifier
  media: rcar-vin: Cleanup notifier in error path
  media: rcar-vin: Cache the mbus configuration flags
  media: rcar-vin: Parse parallel input on Gen3
  media: rcar-vin: Link parallel input media entities
  media: rcar-vin: Handle parallel subdev in link_notify
  media: rcar-vin: Rename _rcar_info to rcar_info
  media: rcar-vin: Add support for R-Car R8A77995 SoC

 drivers/media/platform/rcar-vin/rcar-core.c | 265 ++++++++++++++++++----------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  36 ++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  29 +--
 4 files changed, 223 insertions(+), 119 deletions(-)

--
2.7.4
