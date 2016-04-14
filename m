Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35697 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbcDNQRz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 12:17:55 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3 0/7] Lager board HDMI input support
Date: Thu, 14 Apr 2016 18:17:43 +0200
Message-Id: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This series implements Lager HDMI input support on top of version 4 of
Niklas's rcar-vin rewrite ("[PATCHv4] [media] rcar-vin: add Renesas R-Car
VIN driver").

Apart from rebasing, this revision removes one patch that has since been
picked up, squashes the DT changes into one patch and adjusts its subject
line slightly.

CU
Uli


Changes since v2:
- rebased on top of rcar-vin driver v4
- removed "adv7604: fix SPA register location for ADV7612" (picked up)
- changed prefix of dts patch to "ARM: dts: lager: "


Laurent Pinchart (1):
  v4l: subdev: Add pad config allocator and init

Ulrich Hecht (4):
  media: rcar_vin: Use correct pad number in try_fmt
  media: rcar-vin: pad-aware driver initialisation
  media: rcar-vin: add DV timings support
  media: rcar-vin: initialize EDID data

William Towle (2):
  media: adv7604: automatic "default-input" selection
  ARM: dts: lager: Add entries for VIN HDMI input support

 arch/arm/boot/dts/r8a7790-lager.dts         |  41 +++++++-
 drivers/media/i2c/adv7604.c                 |  18 +++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 145 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |   2 +
 drivers/media/v4l2-core/v4l2-subdev.c       |  19 +++-
 include/media/v4l2-subdev.h                 |  10 ++
 6 files changed, 229 insertions(+), 6 deletions(-)

-- 
2.7.4

