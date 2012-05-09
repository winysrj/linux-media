Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54882 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2EILXG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 07:23:06 -0400
Received: by bkcji2 with SMTP id ji2so146377bkc.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 04:23:04 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH] Terratec Cinergy C PCI HD (CI)
Date: Wed, 09 May 2012 14:23:14 +0300
Message-ID: <1543153.gDfgtO0cjd@useri>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart4518749.8EDGmXpGgU"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart4518749.8EDGmXpGgU
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

This patch seems for rectifying a typo. But actually the difference between
mantis_vp2040.c and mantis_vp2033.c code is a card name only.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
--nextPart4518749.8EDGmXpGgU
Content-Disposition: inline; filename="1.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="1.patch"

diff -r 990a92e2410f linux/drivers/media/dvb/mantis/mantis_cards.c
--- a/linux/drivers/media/dvb/mantis/mantis_cards.c	Wed May 09 01:37:05 2012 +0300
+++ b/linux/drivers/media/dvb/mantis/mantis_cards.c	Wed May 09 14:04:31 2012 +0300
@@ -276,7 +276,7 @@
 	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config),
 	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config),
 	MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config),
-	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2033_config),
+	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
 	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config),
 	{ }
 };
diff -r 990a92e2410f linux/drivers/media/dvb/mantis/mantis_core.c
--- a/linux/drivers/media/dvb/mantis/mantis_core.c	Wed May 09 01:37:05 2012 +0300
+++ b/linux/drivers/media/dvb/mantis/mantis_core.c	Wed May 09 14:04:31 2012 +0300
@@ -121,7 +121,7 @@
 		mantis->hwconfig = &vp2033_mantis_config;
 		break;
 	case MANTIS_VP_2040_DVB_C:	/* VP-2040 */
-	case TERRATEC_CINERGY_C_PCI:	/* VP-2040 clone */
+	case CINERGY_C:	/* VP-2040 clone */
 	case TECHNISAT_CABLESTAR_HD2:
 		mantis->hwconfig = &vp2040_mantis_config;
 		break;

--nextPart4518749.8EDGmXpGgU--

