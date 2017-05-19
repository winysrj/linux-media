Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32906 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754793AbdESNHL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 09:07:11 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, geert@linux-m68k.org,
        magnus.damm@gmail.com, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, sergei.shtylyov@cogentembedded.com,
        horms@verge.net.au, devicetree@vger.kernel.org,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3 0/4] r8a7793 Gose video input support
Date: Fri, 19 May 2017 15:07:00 +0200
Message-Id: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a by-the-datasheet implementation of analog and digital video input
on the Gose board.

This revision adds new bindings that distinguish between ADV7180 variants
with three and six input ports. There are numerous variants of this chip,
but since all that have "CP" in their names have three inputs, and all that
have "ST" have six, I have limited myself to two new compatible strings,
"adv7180cp" and "adv7180st".

The digital input patch has received minor tweaks of the port names for
consistency, and the Gose analog input patch has been modified to use the
new bindings, and a composite video connector has been added.

CU
Uli


Changes since v2:
- hdmi: port hdmi_con renamed to hdmi_con_out
- adv7180: added new compatibility strings and bindings
- composite: added connector, use new bindings

Changes since v1:
- r8a7793.dtsi: added VIN2
- modeled HDMI decoder input/output and connector
- added "renesas,rcar-gen2-vin" compat strings
- removed unnecessary "remote" node and aliases
- set ADV7612 interrupt to GP4_2


Ulrich Hecht (4):
  ARM: dts: gose: add HDMI input
  media: adv7180: add adv7180cp, adv7180st compatible strings
  media: adv7180: Add adv7180cp, adv7180st bindings
  ARM: dts: gose: add composite video input

 .../devicetree/bindings/media/i2c/adv7180.txt      |  15 +++
 arch/arm/boot/dts/r8a7793-gose.dts                 | 127 ++++++++++++++++++++-
 drivers/media/i2c/adv7180.c                        |   2 +
 3 files changed, 142 insertions(+), 2 deletions(-)

-- 
2.7.4
