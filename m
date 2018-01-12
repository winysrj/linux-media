Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37033 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964844AbeALR5A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 12:57:00 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: corbet@lwn.net, mchehab@kernel.org, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] media: ov7670: Implement mbus configuration
Date: Fri, 12 Jan 2018 18:56:46 +0100
Message-Id: <1515779808-21420-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   round 3 for this series.

I have now removed 'pll-bypass' property as suggested by Sakari, and
restructured bindings description to list hsync and vsync properties as
required.

Changelog reported below.

Thanks
   j

v2->v3:
- Drop 'pll-bypass' property
- Make 'plck-hb-disable' a boolean optional property
- List 'hsync' and 'vsync' polarities as required endpoint properties
- Restructured 'ov7670_parse_dt()' function to reflect the above changes

v1->v2:
- Split bindings description and implementation
- Addressed Sakari's comments on v1
- Check for return values of register writes in set_fmt()
- TODO: decide if "pll-bypass" should be an OF property.

Jacopo Mondi (2):
  media: dt-bindings: Add OF properties to ov7670
  v4l2: i2c: ov7670: Implement OF mbus configuration

 .../devicetree/bindings/media/i2c/ov7670.txt       |  18 +++-
 drivers/media/i2c/ov7670.c                         | 102 ++++++++++++++++++---
 2 files changed, 104 insertions(+), 16 deletions(-)

--
2.7.4
