Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:54293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab0LQSMD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 13:12:03 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBHIC2Gi028030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 13:12:02 -0500
Received: from pedra (vpn-232-172.phx2.redhat.com [10.3.232.172])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oBHIC0ww009397
	for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 13:12:01 -0500
Date: Fri, 17 Dec 2010 16:11:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] cx231xx: Fix IR keymap for Pixelview SBTVD
 Hybrid
Message-ID: <20101217161154.3b04240f@pedra>
In-Reply-To: <82a22bd7fd5218d7c3fd51d9c41815f511549373.1292609429.git.mchehab@redhat.com>
References: <82a22bd7fd5218d7c3fd51d9c41815f511549373.1292609429.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 6175650..6905607 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -412,7 +412,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_i2c_master = 2,
 		.demod_i2c_master = 1,
 		.ir_i2c_master = 2,
-		.rc_map_name = RC_MAP_PIXELVIEW_NEW,
+		.rc_map_name = RC_MAP_PIXELVIEW_002T,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
 		.norm = V4L2_STD_PAL_M,
-- 
1.7.1

