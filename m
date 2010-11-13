Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab0KMTd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 14:33:29 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oADJXTC3001768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 14:33:29 -0500
Received: from pedra (vpn-229-222.phx2.redhat.com [10.3.229.222])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oADJXRSi018179
	for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 14:33:28 -0500
Date: Sat, 13 Nov 2010 17:33:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] saa7134: use rc-core raw decoders for Encore FM
 5.3
Message-ID: <20101113173318.07a9c864@pedra>
In-Reply-To: <cover.1289676395.git.mchehab@redhat.com>
References: <cover.1289676395.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index fbb2ff1..4878f46 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -767,9 +767,10 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV_FM53:
 		ir_codes     = RC_MAP_ENCORE_ENLTV_FM53;
-		mask_keydown = 0x0040000;
-		mask_keycode = 0x00007f;
-		nec_gpio = 1;
+		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
+		mask_keyup   = 0x0040000;
+		mask_keycode = 0xffff;
+		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_10MOONSTVMASTER3:
 		ir_codes     = RC_MAP_ENCORE_ENLTV;
-- 
1.7.1


