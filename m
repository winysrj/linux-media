Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:36034 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932606AbeAXJbH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 04:31:07 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: corbet@lwn.net, mchehab@kernel.org, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] media: ov7670: Implement mbus configuration
Date: Wed, 24 Jan 2018 10:30:48 +0100
Message-Id: <1516786250-3750-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   4th round for this series, now based on Hans' 'parm' branch from
git://linuxtv.org/hverkuil/media_tree.git

I addressed Sakari's comments on bindings documentation and driver error path,
and I hope to get both driver and bindings acked to have this included in next
merge window.

Thanks
   j

v3->v4:
- Change bindings documentation to drop default value as vsync and hsync
  polarities are now required properties
- Do not put fwnode handle in driver dt parse error path as dev_fwnode() does
  not increase ref counting

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

 .../devicetree/bindings/media/i2c/ov7670.txt       | 16 +++-
 drivers/media/i2c/ov7670.c                         | 98 ++++++++++++++++++----
 2 files changed, 98 insertions(+), 16 deletions(-)

--
2.7.4
