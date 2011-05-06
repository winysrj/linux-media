Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:34066 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754622Ab1EFTGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 15:06:38 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: media_build broken due to wrong indention of timberdale entry in Kconfig
Date: Fri, 6 May 2011 21:04:50 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TZExN1V+Qg99XUJ"
Message-Id: <201105062104.51754@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_TZExN1V+Qg99XUJ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

'make menuconfig' does not work anymore:

[media_build]$make menuconfig
make -C /usr/local/src/ARCHIVE/git-work/media_build/v4l menuconfig
make[1]: Entering directory `/usr/local/src/ARCHIVE/git-work/media_build/v4l'
/lib/modules/2.6.38.5/build/scripts/kconfig/mconf ./Kconfig
./Kconfig:1527: unknown option "Add"
make[1]: *** [menuconfig] Error 1
make[1]: Leaving directory `/usr/local/src/ARCHIVE/git-work/media_build/v4l'
make: *** [menuconfig] Error 2

Fix attached.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------

--Boundary-00=_TZExN1V+Qg99XUJ
Content-Type: text/x-diff;
  charset="us-ascii";
  name="video-kconfig-timb-fix.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="video-kconfig-timb-fix.diff"

=46rom 0903a2a1574541035a7fcaf7f83c95bb08a91a07 Mon Sep 17 00:00:00 2001
=46rom: Oliver Endriss <o.endriss@gmx.de>
Date: Fri, 6 May 2011 20:43:27 +0200
Subject: [PATCH] Kconfig: Fix indention of ---help--- for timerdale driver

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
=2D--
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 3d25920..d61414e 100644
=2D-- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -689,7 +689,7 @@ config VIDEO_TIMBERDALE
 	select VIDEO_ADV7180
 	select VIDEOBUF_DMA_CONTIG
 	---help---
=2D	Add support for the Video In peripherial of the timberdale FPGA.
+	  Add support for the Video In peripherial of the timberdale FPGA.
=20
 source "drivers/media/video/cx88/Kconfig"
=20
=2D-=20
1.6.5.3


--Boundary-00=_TZExN1V+Qg99XUJ--
