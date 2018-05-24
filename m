Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:34367 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966725AbeEXWCc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 18:02:32 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 0/9] rcar-vin: Add support for parallel input on Gen3
Date: Fri, 25 May 2018 00:02:10 +0200
Message-Id: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series adds support for parallel video input to the Gen3 version of
rcar-vin driver.

Compared to v3, this new iteration closes all comments from Niklas and Sergei.

As the meat of the patch series hasn't changed much, please refer to v3 cover
letter for more details.

The most notable change is the great simplification of the parallel
input notifiers registration in [5/9], as now the media controller is
initialized before parallel inputs are parsed. As the media device is now
properly initialized, parallel input notifiers can be registered as soon as new
input devices are discovered, without having to wait for the group notifier
complete callback to be called. Thanks Niklas for pointing that out.

Testing:
Tested image capture on both Draak and Salvator-X M3-W with a fake parallel
input device added.

Test branch for Salvator-X available at
git://jmondi.org d3/media-master/salvator-x-dts_csi2/m3w-add_parallel_to_dts+driver-v4
For Draak at:
git://jmondi.org d3/media-master/salvator-x-dts_csi2/d3-vin-driver-v4+enable-HDMI-in-dts
(sorry for the horrid branch names :)

Niklas, I know you have a V3M with expansion that has both CSI-2 and parallel
input. Could you give this one a spin please?

No changelog reported here, except from the one reported above.

Most of the other changes are minors, the most notable ones are reported in
each patch commit message.

Thanks
   j

Jacopo Mondi (9):
  media: rcar-vin: Rename 'digital' to 'parallel'
  media: rcar-vin: Remove two empty lines
  media: rcar-vin: Create a group notifier
  media: rcar-vin: Cache the mbus configuration flags
  media: rcar-vin: Parse parallel input on Gen3
  media: rcar-vin: Link parallel input media entities
  media: rcar-vin: Handle parallel subdev in link_notify
  media: rcar-vin: Rename _rcar_info to rcar_info
  media: rcar-vin: Add support for R-Car R8A77995 SoC

 drivers/media/platform/rcar-vin/rcar-core.c | 258 ++++++++++++++++++----------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  36 ++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  29 ++--
 4 files changed, 215 insertions(+), 120 deletions(-)

--
2.7.4
