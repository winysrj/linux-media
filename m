Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35125 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739AbcEKODC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 10:03:02 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v4 0/8] Lager/Koelsch board HDMI input support
Date: Wed, 11 May 2016 16:02:48 +0200
Message-Id: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This series implements Lager/Koelsch HDMI input support on top of version 6
of Niklas's rcar-vin rewrite ("[PATCHv6] [media] rcar-vin: add Renesas R-Car
VIN driver").

This revision addresses the issues found in Hans Verkuil's review of the series
(except for the EDID intialization, which I have left in), and adds his Koelsch
support patch.

CU
Uli


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
  r8a7791-koelsch.dts: add HDMI input

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

 arch/arm/boot/dts/r8a7790-lager.dts         |  39 +++++++
 arch/arm/boot/dts/r8a7791-koelsch.dts       |  41 ++++++++
 drivers/media/i2c/adv7604.c                 |  18 +++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 158 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |   2 +
 drivers/media/v4l2-core/v4l2-subdev.c       |  19 +++-
 include/media/v4l2-subdev.h                 |  10 ++
 7 files changed, 282 insertions(+), 5 deletions(-)

-- 
2.7.4

