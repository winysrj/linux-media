Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAA7C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ED8220851
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ED8220851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbeLKPQd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:16:33 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:59525 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbeLKPQd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:16:33 -0500
X-Originating-IP: 2.224.242.101
Received: from w540.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 609ADC0025;
        Tue, 11 Dec 2018 15:16:30 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/5] media: adv748x: Implement dynamic routing support
Date:   Tue, 11 Dec 2018 16:16:08 +0100
Message-Id: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,
   this series implements dynamic selection of video source for the
adv748x video/HDMI decoder.

The series aims to have CVBS capture work on R-Car E3 Ebisu board,
where the HDMI and CVBS input share a single CSI-2 TX output.

In all other R-Car Gen3 boards the CVBS input is statically routed to TXB,
while HDMI goes to TXA. On E3 both CVBS and HDMI are routed to TXA, so that
to have CVBS video captured the video routes have to be modified at
run-time.

In order to do so this series implement the 'link_setup()' callback for the
adv748x, that gets called when a link from AFE or HDMI to a TX is created in
the media graph.

Unfortunately this series is not enough to have CVBS properly working
when routed to TXA on any board but E3. The reason is that the number of
CSI-2 data lanes needs to be re-negotiated between the adv748x's CSI-2 TX
and the rcar-csi2 CSI-2 RX when the video input is set to CVBS, and currently
the v4l2 framework does not implement any operation to do so.

I'm hesitant to have the full series merged, as it would allow configuring
a non-working CVBS->TXA link on Gen3 boards, while said configuration is not
yet working properly. At the same time, in order to have CVBS captured on E3
this series is required. I expect some discussions on how to proceed forward,
possibly delaying this series inclusion after a proper lane reconfiguration
operations is added to V4L2.

The series is based on media tree master with the following series from
Niklas applied on top:
[PATCH v4 0/4] i2c: adv748x: add support for CSI-2 TXA to work in 1-, 2- and 4-lane mode

Tested on E3:
HDMI->TXA works as usual
CVBS->TXA captures images (although I have image quality issues)

Tested on Salvator-X M3-W with number of CSI-2 data lanes forced to 2:
HDMI->TXA works but images are not of same quality as in 4 lanes configuration
CVBS->TXA works (with same image quality issues seen on E3)
CVBS->TXB works ((with same image quality issues seen on E3)

When testing on Salvator-X M3-W without forcing the number of data lanes to 2,
capturing CVBS input from TXA hangs (no frames are returned).

Feedbacks on how to proceed forward are welcome. As I've said I'm fine
postponing inclusion of this series after an operation to support CSI-2 data
lane negotiation is implemented in V4L2.

Thanks
   j

Jacopo Mondi (5):
  media: adv748x: Rework reset procedure
  media: adv748x: csi2: Link AFE with TXA and TXB
  media: adv748x: Store the source subdevice in TX
  media: adv748x: Store the TX sink in HDMI/AFE
  media: adv748x: Implement link_setup callback

 drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
 drivers/media/i2c/adv748x/adv748x-core.c | 89 ++++++++++++++++++++++++++------
 drivers/media/i2c/adv748x/adv748x-csi2.c | 64 ++++++++++++++++-------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      |  6 +++
 5 files changed, 125 insertions(+), 38 deletions(-)

--
2.7.4

