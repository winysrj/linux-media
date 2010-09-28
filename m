Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab0I1SsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:48:21 -0400
Date: Tue, 28 Sep 2010 15:46:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/10] V4L/DVB: cx231xx: fix Kconfig dependencies
Message-ID: <20100928154654.737813ab@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

ERROR: "cx2341x_mpeg_ctrls" [drivers/media/video/cx231xx/cx231xx.ko] undefined!
ERROR: "cx2341x_fill_defaults" [drivers/media/video/cx231xx/cx231xx.ko] undefined!
ERROR: "cx2341x_log_status" [drivers/media/video/cx231xx/cx231xx.ko] undefined!
ERROR: "cx2341x_ctrl_get_menu" [drivers/media/video/cx231xx/cx231xx.ko] undefined!
ERROR: "cx2341x_update" [drivers/media/video/cx231xx/cx231xx.ko] undefined!
ERROR: "cx2341x_ctrl_query" [drivers/media/video/cx231xx/cx231xx.ko] undefined!
ERROR: "cx2341x_ext_ctrls" [drivers/media/video/cx231xx/cx231xx.ko] undefined!

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index 5ac7ece..bb04914 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -6,6 +6,7 @@ config VIDEO_CX231XX
 	depends on VIDEO_IR
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
+	select VIDEO_CX2341X
 
 	---help---
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
-- 
1.7.1


