Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46883 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbeE2IsT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:48:19 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v5 0/10] rcar-vin: Add support for parallel input on Gen3
Date: Tue, 29 May 2018 10:47:58 +0200
Message-Id: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series adds support for parallel video input to the Gen3 version of
rcar-vin driver.

Since last version one patch has been added (as anticipated by email) to clean
up the memory reserved for notifier's async subdevices if the notifier
registration fails ([4/10]), and two comments from Niklas has been addressed
in [6/10], where the group notifier is now cleaned up in the error path if
it's necessary to do that.

Patches 4,5 and 6 have not yet been Acked-by/Reviewed-by, all the other ones
have at least one tag, so things looks quite good.

Additional changelogs in single patches.

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

 drivers/media/platform/rcar-vin/rcar-core.c | 269 +++++++++++++++++++---------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  36 ++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  29 +--
 4 files changed, 230 insertions(+), 116 deletions(-)

--
2.7.4
