Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36324 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756314AbcIPNJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 09:09:16 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: horms@verge.net.au
Cc: geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        ulrich.hecht+renesas@gmail.com, laurent.pinchart@ideasonboard.com,
        william.towle@codethink.co.uk
Subject: [PATCH 0/2] Renesas Lager/Koelsch HDMI input
Date: Fri, 16 Sep 2016 15:09:07 +0200
Message-Id: <20160916130909.21225-1-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This series enables HDMI input on the Lager and Koelsch boards.
It sits on renesas-devel-20160913-v4.8-rc6 and also applies to the media
tree.

Testing this on a Lager board with v4l2-compliance on top of Hans's R-Car
branch (https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=rcar) with
"media: adv7604: automatic "default-input" selection" applied, it gets a
perfect score (172/172 pass).

CU
Uli


Hans Verkuil (1):
  ARM: dts: koelsch: add HDMI input

William Towle (1):
  ARM: dts: lager: Add entries for VIN HDMI input support

 arch/arm/boot/dts/r8a7790-lager.dts   | 39 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/r8a7791-koelsch.dts | 41 +++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

-- 
2.9.3

