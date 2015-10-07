Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:57882 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbbJGKjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2015 06:39:40 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 0/2] [media] rcar_vin: Remove obsolete platform data support
Date: Wed,  7 Oct 2015 12:39:34 +0200
Message-Id: <1444214376-26931-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hi,

Since commit 3d7608e4c169af03 ("ARM: shmobile: bockw: remove legacy
board file and config"), Renesas R-Car SoCs are only supported in
generic DT-only ARM multi-platform builds.  The driver doesn't need to
use platform data anymore, hence this series remove platform data
configuration.

Changes compared to v1:
  - Added patch 2.

Geert Uytterhoeven (2):
  [media] rcar_vin: Remove obsolete r8a779x-vin platform_device_id
    entries
  [media] rcar_vin: Remove obsolete platform data support

 drivers/media/platform/soc_camera/rcar_vin.c | 77 +++++++++++-----------------
 include/linux/platform_data/camera-rcar.h    | 25 ---------
 2 files changed, 29 insertions(+), 73 deletions(-)
 delete mode 100644 include/linux/platform_data/camera-rcar.h

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
