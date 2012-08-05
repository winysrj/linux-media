Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab2HEDaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 23:30:16 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q753UGOi025069
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 4 Aug 2012 23:30:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/5] [media] az6007: Fix the number of parameters for QAM setup
Date: Sun,  5 Aug 2012 00:30:11 -0300
Message-Id: <1344137411-27948-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
References: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove those warning messages:
[  121.696758] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  121.703401] drxk: 02 00 00 00 10 00 07 00 03 02                    ..........
[  121.703587] drxk: Warning -22 on QAMDemodulatorCommand

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/az6007.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb/dvb-usb-v2/az6007.c b/drivers/media/dvb/dvb-usb-v2/az6007.c
index 35ed915..4671eaa 100644
--- a/drivers/media/dvb/dvb-usb-v2/az6007.c
+++ b/drivers/media/dvb/dvb-usb-v2/az6007.c
@@ -64,6 +64,7 @@ static struct drxk_config terratec_h7_drxk = {
 	.no_i2c_bridge = false,
 	.chunk_size = 64,
 	.mpeg_out_clk_strength = 0x02,
+	.qam_demod_parameter_count = 2,
 	.microcode_name = "dvb-usb-terratec-h7-drxk.fw",
 };
 
-- 
1.7.11.2

