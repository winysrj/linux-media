Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35029 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbcIPJjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 05:39:46 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, ulrich.hecht+renesas@gmail.com,
        laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk,
        devicetree@vger.kernel.org
Subject: [PATCH 0/2] media: adv7604: fix default-input property inconsistencies
Date: Fri, 16 Sep 2016 11:39:40 +0200
Message-Id: <20160916093942.17213-1-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a fix for the inconsistency in the adv7604 bindings regarding the
default-input property, clarifying that it should be a property of the
device, not the endpoint, and a patch to implement it.

CU
Uli


Ulrich Hecht (2):
  media: adv7604: fix bindings inconsistency for default-input
  media: adv7604: automatic "default-input" selection

 Documentation/devicetree/bindings/media/i2c/adv7604.txt | 3 +--
 drivers/media/i2c/adv7604.c                             | 5 ++++-
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.9.3

