Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35921 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933405AbcIVNTL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 09:19:11 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        ulrich.hecht+renesas@gmail.com, laurent.pinchart@ideasonboard.com,
        william.towle@codethink.co.uk, devicetree@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Subject: [PATCH v2 0/2] media: adv7604: fix default-input property inconsistencies
Date: Thu, 22 Sep 2016 15:18:58 +0200
Message-Id: <1474550340-31455-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a fix for the inconsistency in the adv7604 bindings regarding the
default-input property, clarifying that it should be a property of the
device, not the endpoint, and a patch to implement it.

This revision implements Laurent's suggestions:

- The default input should not be set if the default-input property is missing.
- The old code for parsing the property in the endpoint node can be removed.
- The rationale for the change should go in the commit message.

CU
Uli


Ulrich Hecht (2):
  media: adv7604: fix bindings inconsistency for default-input
  media: adv7604: automatic "default-input" selection

 Documentation/devicetree/bindings/media/i2c/adv7604.txt | 3 +--
 drivers/media/i2c/adv7604.c                             | 6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.7.4

