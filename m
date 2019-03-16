Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EC8C4360F
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEE2421900
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfCPPrh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:47:37 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:35813 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfCPPrh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 11:47:37 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id C90B71BF205;
        Sat, 16 Mar 2019 15:47:32 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dave.stevenson@raspberrypi.org
Subject: [RFC 0/5] media: Implement negotiation of CSI-2 data lanes
Date:   Sat, 16 Mar 2019 16:47:56 +0100
Message-Id: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,
   this RFC series implements negotiation of CSI-2 data lanes number and
position by extending the v4l2_mbus_frame_desc structure with a 'phy' field
that describes the media bus configuration.

The use case this series cover is the following one:
the Gen-3 R-Car boards include an ADV748x HDMI/CVBS to CSI-2 converter
connected to its CSI-2 receivers. The ADV748x chip has recently gained support
for routing both HDMI and analogue video streams through its 4 lanes TXA
transmitter, specifically to support the Ebisu board that has a single CSI-2
receiver, compared to all other Gen-3 board where the ADV748x TXes are connected
to different CSI-2 receivers, and where analogue video is streamed out from the
ADV748x single lane TXB transmitter.

To properly support transmission of analogue video through TXA, the number of
data lanes shall be dynamically reduced to 1, in order to comply with the MIPI
CSI-2 minimum clock frequency requirements.

So far, the number of data lanes has always come from DT as a static parameter,
preventing its run-time modifications. This series moves the adv748x and
the R-Car CSI-2 one to use the DT property as an indication of the number of
physically available lanes instead, and to negotiate the number of lanes in
use based on the transmitter requirements, in this case the selected
analogue video routing path.

Sending as RFC as this series is based on the in-review v4l2-multiplexed support
which extends the frame descriptor with CSI-2 specific informations:
[PATCH v3 00/31] v4l: add support for multiplexed streams

In detail on the patches:
1/5 expands the frame descriptor with D-PHY (and a TODO C-PHY) configurations
2/5 is possibly for inclusion as it addresses the same issue tackled by the
    not-so-welcome "[PATCH] media: adv748x: Don't disable CSI-2 on link_setup"
3/5 moves the adv748x to dynamically select the number of data lanes to
    use based on the selected routing
4/5 adds to the adv748x frame descriptor the D-PHY bus configuration parameters
5/5 makes the R-Car CSI-2 receiver configure itself using the bus configuration
    reported by the remote subdevice

Tested on Ebisu E3 board capturing HDMI and analogue video from TXA output,
and on Salvator-X M3-W capturing analogue video from TXA and making sure the
most canonical use case of capturing HDMI through TXA and analogue through TXB
still works. The image quality on E3 is the expected one, while on Salvator-X
the AFE->TXA routing produces images with visible artifacts and mangled colors,
but for an RFC I consider this good enough as a proof of concept.

Sending to renesas-soc and linux-media with Dave in Cc has I recall he expressed
interest for this feature during review of some adv748x patch series.

For the interested ones, the series is available at:
git://jmondi.org/linux v4l2-mux/media-master/v3-/data-lanes-negotiation

Thanks
  j

Jacopo Mondi (5):
  v4l: subdev: Add MIPI CSI-2 PHY to frame desc
  media: adv748x: Post-pone IO10 write to power up
  media: adv748x: Make lanes number depend on routing
  media: adv748x: Report D-PHY configuration
  media: rcar-csi2: Configure CSI-2 with frame desc

 drivers/media/i2c/adv748x/adv748x-core.c    | 72 ++++++++++++++-------
 drivers/media/i2c/adv748x/adv748x-csi2.c    | 21 ++++--
 drivers/media/i2c/adv748x/adv748x.h         |  3 +
 drivers/media/platform/rcar-vin/rcar-csi2.c | 71 ++++++++++++--------
 include/media/v4l2-subdev.h                 | 42 ++++++++++--
 5 files changed, 147 insertions(+), 62 deletions(-)

--
2.21.0

