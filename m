Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab0DFSSm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:42 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIg4t022141
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:42 -0400
Date: Tue, 6 Apr 2010 15:18:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 21/26] V4L/DVB: cx88: don't handle IR on Pixelview too fast
Message-ID: <20100406151801.589eb9cb@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index f5d6130..9dbec1c 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -315,9 +315,9 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PIXELVIEW_PLAYTV_ULTRA_PRO:
 		ir_codes = RC_MAP_PIXELVIEW;
 		ir->gpio_addr = MO_GP1_IO;
-		ir->mask_keycode = 0x1f;
+		ir->mask_keycode = 0x1f;	/* Only command is retrieved */
 		ir->mask_keyup = 0x80;
-		ir->polling = 1; /* ms */
+		ir->polling = 10; /* ms */
 		break;
 	case CX88_BOARD_PROLINK_PV_8000GT:
 	case CX88_BOARD_PROLINK_PV_GLOBAL_XTREME:
-- 
1.6.6.1


