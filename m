Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:37415 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbeFLO0a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 10:26:30 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 0/6] media: rcar-vin: Brush endpoint properties
Date: Tue, 12 Jun 2018 16:26:00 +0200
Message-Id: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
  4th round for the VIN endpoint brushing series.

Slightly enlarged the linux-media receiver list, as this new version
introduces a common property in 'video-interfaces.txt'.

Compared to v3 I have dropped the last controversial parts:

- The custom 'renesas,hsync-as-de' property has been dropped: do not handle
  CHS bit for the moment.
- Do not remove properties not parsed by the driver and not listed in the
  interface bindings from Gen2 boards. As this lead to a long discussion, I
  have now proposed a patch to clearly state that properties not listed in the
  interface bindings can be optionally specified, but they don't affect the
  interface behaviour. To avoid more discussions this patch may be dropped
  and things will stay the way they are now.

For the common 'data-enable-active' property, I guess with Rob's ack we should
be fine there and I hope the rest of the series won't slow down its acceptance.

Thanks
   j

Jacopo Mondi (6):
  dt-bindings: media: rcar-vin: Describe optional ep properties
  dt-bindings: media: Document data-enable-active property
  media: v4l2-fwnode: parse 'data-enable-active' prop
  dt-bindings: media: rcar-vin: Add 'data-enable-active'
  media: rcar-vin: Handle data-enable polarity
  dt-bindings: media: rcar-vin: Clarify optional props

 Documentation/devicetree/bindings/media/rcar_vin.txt   | 18 ++++++++++++++++++
 .../devicetree/bindings/media/video-interfaces.txt     |  2 ++
 drivers/media/platform/rcar-vin/rcar-dma.c             |  5 +++++
 drivers/media/v4l2-core/v4l2-fwnode.c                  |  4 ++++
 include/media/v4l2-mediabus.h                          |  2 ++
 5 files changed, 31 insertions(+)

--
2.7.4
