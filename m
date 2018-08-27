Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:50729 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbeH0POf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 11:14:35 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/2] media: adv748x: Allow probe with a single output endpoint
Date: Mon, 27 Aug 2018 13:28:03 +0200
Message-Id: <1535369285-26032-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent, Kieran, Niklas,
   to address the Ebisu board use case, this series allows the adv748x driver
to probe with a single output connection defined.

This series (hopefully) allows capturing on E3, but considering the fixed
routing between HDMI->TXA and CVBS->TXB, only from HDMI input.

Not having an Ebisu, I have tested on M3-W Salvator-X disabling the TXB output
and the CSI20 interface connected to it. I'm able to capture with HDMI with
no visible regressions.

Laurent: to help testing on E3, I have pushed this series on top of Ebisu HDMI
and CVBS enablement to
git://jmondi.org/linux ebisu/renesas-drivers/adv748x_probe

Thanks
  j

Jacopo Mondi (2):
  media: i2c: adv748x: Support probing a single output
  media: i2c: adv748x: Handle TX[A|B] power management

 drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
 drivers/media/i2c/adv748x/adv748x-core.c | 90 ++++++++++++++++++--------------
 drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      |  6 ++-
 5 files changed, 61 insertions(+), 61 deletions(-)

--
2.7.4
