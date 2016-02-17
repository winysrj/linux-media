Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36366 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161129AbcBQPs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 10:48:58 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH/RFC 0/9] Lager board HDMI input support
Date: Wed, 17 Feb 2016 16:48:36 +0100
Message-Id: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This series implements Lager HDMI input support on top of Niklas's herculean
rewrite of the rcar-vin driver ("[media] rcar-vin: add Renesas R-Car VIN IP
core").

A couple of the included patches are pushed or have been picked up elsewhere
already and are included here for ease of testing.

The EDID initialization blob has been lifted wholesale from the cobalt
driver, with only the vendor ID adjusted to "REN".

(Note for testing: To get up-to-date DV timings, you have to use a client
that does QUERY_DV_TIMINGS/S_DV_TIMINGS.  Few do.)

CU
Uli


Ian Molton (1):
  ARM: shmobile: lager dts: specify default-input for ADV7612

Laurent Pinchart (1):
  v4l: subdev: Add pad config allocator and init

Ulrich Hecht (5):
  adv7604: fix SPA register location for ADV7612
  media: rcar_vin: Use correct pad number in try_fmt
  media: rcar-vin: pad-aware driver initialisation
  media: rcar-vin: add DV timings support
  media: rcar-vin: initialize EDID data

William Towle (2):
  media: adv7604: automatic "default-input" selection
  ARM: shmobile: lager dts: Add entries for VIN HDMI input support

 arch/arm/boot/dts/r8a7790-lager.dts        |  41 +++++++-
 drivers/media/i2c/adv7604.c                |  27 ++++--
 drivers/media/platform/rcar-vin/rcar-dma.c | 145 ++++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h |   1 +
 drivers/media/v4l2-core/v4l2-subdev.c      |  19 +++-
 include/media/v4l2-subdev.h                |  10 ++
 6 files changed, 229 insertions(+), 14 deletions(-)

-- 
2.6.4

