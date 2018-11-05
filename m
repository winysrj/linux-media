Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:49552 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727615AbeKEQtu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 11:49:50 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 05/11] [media] marvell-ccic: don't generate EOF on parallel bus
Date: Mon,  5 Nov 2018 08:30:48 +0100
Message-Id: <20181105073054.24407-6-lkundrak@v3.sk>
In-Reply-To: <20181105073054.24407-1-lkundrak@v3.sk>
References: <20181105073054.24407-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The commit 05fed81625bf ("[media] marvell-ccic: add MIPI support for
marvell-ccic driver") that claimed to add CSI2 turned on C0_EOF_VSYNC for
parallel bus without a very good explanation.

That broke camera on OLPC XO-1.75 which precisely uses a sensor on a
parallel bus. Revert that chunk.

Tested on an OLPC XO-1.75.

Fixes: 05fed81625bf755cc67c5864cdfd18b69ea828d1
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/me=
dia/platform/marvell-ccic/mcam-core.c
index d97f39bde9bd..d24e5b7a3bc5 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -792,12 +792,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	 * Make sure it knows we want to use hsync/vsync.
 	 */
 	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
-	/*
-	 * This field controls the generation of EOF(DVP only)
-	 */
-	if (cam->bus_type !=3D V4L2_MBUS_CSI2_DPHY)
-		mcam_reg_set_bit(cam, REG_CTRL0,
-				C0_EOF_VSYNC | C0_VEDGE_CTRL);
 }
=20
=20
--=20
2.19.1
