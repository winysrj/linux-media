Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:55259 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbeIQQ6B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:58:01 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3 0/4] media: adv748x: Allow probe with a single output endpoint
Date: Mon, 17 Sep 2018 13:30:53 +0200
Message-Id: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent, Kieran, Niklas,
   to address the Ebisu board use case, this series allows the adv748x driver
to probe with a single output connection defined.

Compared to v2, I have dropped the last patch, as without any dynamic routing
support it is not that helpful, and I've fixed most of commit messages as
suggested by Kieran.

I have tested in 3 conditions on Salvator-X M3-W:
- AFE input not registered
- TXB not registered (Ebisu use case)
- AFE and TXB not registered

Let me know if I can help testing this on Ebisu.

Thanks
   j

v2 -> v3:
- Drop v2 patch [5/5]
- Add Kieran's tags and modify commit messages as he suggested

Jacopo Mondi (4):
  media: i2c: adv748x: Support probing a single output
  media: i2c: adv748x: Handle TX[A|B] power management
  media: i2c: adv748x: Conditionally enable only CSI-2 outputs
  media: i2c: adv748x: Register only enabled inputs

 drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
 drivers/media/i2c/adv748x/adv748x-core.c | 83 +++++++++++++++++---------------
 drivers/media/i2c/adv748x/adv748x-csi2.c | 29 ++++-------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      | 19 ++++++--
 5 files changed, 68 insertions(+), 67 deletions(-)

--
2.7.4
