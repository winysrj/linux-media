Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34502 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756670AbcIPNJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 09:09:39 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: horms@verge.net.au
Cc: geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        ulrich.hecht+renesas@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/3] r8a7793 Gose video input support
Date: Fri, 16 Sep 2016 15:09:32 +0200
Message-Id: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a by-the-datasheet implementation of analog and digital video input
on the Gose board.

I don't have that hardware, so if somebody could test this, I would
appreciate it.  To get the digital part to work, use Hans's R-Car branch
(https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=rcar) plus the
"media: adv7604: automatic "default-input" selection" patch.

CU
Uli


Ulrich Hecht (3):
  ARM: dts: r8a7793: Enable VIN0, VIN1
  ARM: dts: gose: add HDMI input
  ARM: dts: gose: add composite video input

 arch/arm/boot/dts/r8a7793-gose.dts | 77 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/r8a7793.dtsi     | 20 ++++++++++
 2 files changed, 97 insertions(+)

-- 
2.9.3

