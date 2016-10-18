Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36749 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934175AbcJRPC3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 11:02:29 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: horms@verge.net.au
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        geert@linux-m68k.org, sergei.shtylyov@cogentembedded.com,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v2 0/3] r8a7793 Gose video input support
Date: Tue, 18 Oct 2016 17:02:20 +0200
Message-Id: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a by-the-datasheet implementation of analog and digital video input
on the Gose board.

I have tried to address all concerns raised by reviewers, with the exception
of the composite input patch, which has been left as is for now.

CU
Uli


Changes since v1:
- r8a7793.dtsi: added VIN2
- modeled HDMI decoder input/output and connector
- added "renesas,rcar-gen2-vin" compat strings
- removed unnecessary "remote" node and aliases
- set ADV7612 interrupt to GP4_2


Ulrich Hecht (3):
  ARM: dts: r8a7793: Enable VIN0-VIN2
  ARM: dts: gose: add HDMI input
  ARM: dts: gose: add composite video input

 arch/arm/boot/dts/r8a7793-gose.dts | 100 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/r8a7793.dtsi     |  27 ++++++++++
 2 files changed, 127 insertions(+)

-- 
2.7.4

