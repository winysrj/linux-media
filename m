Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34435 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbeADJwo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 04:52:44 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: corbet@lwn.net, mchehab@kernel.org, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] media: ov7670: Implement mbus configuration
Date: Thu,  4 Jan 2018 10:52:31 +0100
Message-Id: <1515059553-10219-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series adds mbus configuration properties to ov7670 sensor driver.

I have sent v1 a few days ago and forgot to cc device tree people. Doing it
now with bindings description and implementation split in 2 separate patches.

I have fixed Sakari's comment on v1, and I'm sending v2 out with support for
"pll-bypass" custom property as it was in v1. If we decide it is not worth
to make an OF property out of it, I will drop it in v3. Technically it is not
even an mbus configuration option, so I'm fine dropping it eventually.

Thanks
  j

v1->v2:
- Split bindings description and implementation
- Addressed Sakari's comments on v1
- Check for return values of register writes in set_fmt()
- TODO: decide if "pll-bypass" should be an OF property.

Jacopo Mondi (2):
  v4l2: i2c: ov7670: Implement OF mbus configuration
  media: dt-bindings: Add OF properties to ov7670

 .../devicetree/bindings/media/i2c/ov7670.txt       |  14 +++
 drivers/media/i2c/ov7670.c                         | 124 ++++++++++++++++++---
 2 files changed, 124 insertions(+), 14 deletions(-)

--
2.7.4
