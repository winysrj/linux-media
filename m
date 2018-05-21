Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36741 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753382AbeEUR14 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:27:56 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 0/4] media: rcar-vin: Brush endpoint properties
Date: Mon, 21 May 2018 19:27:39 +0200
Message-Id: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series touches the bindings and the driver handling endpoint
properties for digital subdevices of the R-Car VIN driver.

The first patch simply documents what are the endpoint properties supported
at the moment while the second extends them with 'data-active' one.

As the VIN hardware allows to use HSYNC as data enable signal when the CLCKENB
pin is left unconnected, the 'data-active' property presence determinates
if HSYNC has to be used or not as data enable signal. Compared to v1, the
handling logic of this property has changed, and HSYNC is selected in its place
only when running V4L2_MBUS_PARALLEL media bus type. When running with
embedded synchronizations if the property is not specified, the default value
is used (this helps with retro-compatibility too).

I understand this may sound problematic. The property is optional, but when
not specified it may cause HSYNC to be used as data-active, which is not what
one may expect. Anyhow, the processor manual suggests this:

Note: When using ITU-R BT.601, BT.709, BT.1358 interface, and the
VIn_CLKENB pin is unused, the CHS bit must be set to 1.

So it seems reasonable to me.

Alternatively, a dedicated property, as 'renesas,chs' may be introduced, but
I don't particularly like this and I would prefer users to read bindings
documentation carefully, provided I wrote it clearly enough...

While this is still debated too, I left un-touched patch [4/4] that removes
un-used endpoint properties from all Gen-2 DTS that use them. Those properties
are not parsed by the driver nor documented by bindings, and their presence is
only confusing future users.

The series depends on:
[PATCH v3 0/9] rcar-vin: Add support for parallel input on Gen3

Available here for the interested:
git://jmondi.org d3/media-master/salvator-x-dts_csi2/d3-vin-driver-v3

Thanks
   j

v1 -> v2:
- Change data-active properties handling: the property is only considered
  when running with explicit synchronization signals.
- Drop patch 3/6 and 6/6 from v1 as they're not needed anymore as data-active
  handling logic changed.

Jacopo Mondi (4):
  dt-bindings: media: rcar-vin: Describe optional ep properties
  dt-bindings: media: rcar-vin: Document data-active
  media: rcar-vin: Handle CLOCKENB pin polarity
  ARM: dts: rcar-gen2: Remove unused VIN properties

 .../devicetree/bindings/media/rcar_vin.txt         | 19 +++++++++++++++-
 arch/arm/boot/dts/r8a7790-lager.dts                |  3 ---
 arch/arm/boot/dts/r8a7791-koelsch.dts              |  3 ---
 arch/arm/boot/dts/r8a7791-porter.dts               |  1 -
 arch/arm/boot/dts/r8a7793-gose.dts                 |  3 ---
 arch/arm/boot/dts/r8a7794-alt.dts                  |  1 -
 arch/arm/boot/dts/r8a7794-silk.dts                 |  1 -
 drivers/media/platform/rcar-vin/rcar-dma.c         | 25 ++++++++++++++--------
 8 files changed, 34 insertions(+), 22 deletions(-)

--
2.7.4
