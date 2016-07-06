Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35520 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbcGFPw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 11:52:57 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v5 0/4] Lager/Koelsch board HDMI input support
Date: Wed,  6 Jul 2016 17:39:32 +0200
Message-Id: <1467819576-17743-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Sorry for the delay.  This revision drops all patches that have since been
picked up.  It amends the default input selection to fall back to input 0 if
nothing else is specified, and it replaces the hard-coded EDID blob with an
implementation of G_EDID and S_EDID in rcar-vin.

CU
Uli


Changes since v4:
- drop merged patches
- adv7604: always fall back to input 0 if nothing else is specified
- rcar-vin: implement G_EDID, S_EDID in place of hard-coded EDID blob

Changes since v3:
- rvin_enum_dv_timings(): use vin->src_pad_idx
- rvin_dv_timings_cap(): likewise
- rvin_s_dv_timings(): update vin->format
- add Koelsch support

Changes since v2:
- rebased on top of rcar-vin driver v4
- removed "adv7604: fix SPA register location for ADV7612" (picked up)
- changed prefix of dts patch to "ARM: dts: lager: "


Hans Verkuil (1):
  ARM: dts: koelsch: add HDMI input

Ulrich Hecht (2):
  media: adv7604: automatic "default-input" selection
  rcar-vin: implement EDID control ioctls

William Towle (1):
  ARM: dts: lager: Add entries for VIN HDMI input support

 arch/arm/boot/dts/r8a7790-lager.dts         | 41 ++++++++++++++++++++++++++++-
 arch/arm/boot/dts/r8a7791-koelsch.dts       | 41 +++++++++++++++++++++++++++++
 drivers/media/i2c/adv7604.c                 |  5 +++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 17 ++++++++++++
 4 files changed, 102 insertions(+), 2 deletions(-)

-- 
2.7.4

