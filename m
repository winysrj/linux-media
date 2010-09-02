Return-path: <mchehab@localhost>
Received: from devils.ext.ti.com ([198.47.26.153]:42283 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab0IBOq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 10:46:28 -0400
From: raja_mani@ti.com
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@infradead.org
Cc: matti.j.aaltonen@nokia.com, Raja Mani <raja_mani@ti.com>,
	Pramodh AG <pramodh_ag@ti.com>
Subject: [RFC/PATCH 6/8] drivers:staging:ti-st: Extend FM TX global data structure.
Date: Thu,  2 Sep 2010 11:57:58 -0400
Message-Id: <1283443080-30644-7-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-6-git-send-email-raja_mani@ti.com>
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com>
 <1283443080-30644-2-git-send-email-raja_mani@ti.com>
 <1283443080-30644-3-git-send-email-raja_mani@ti.com>
 <1283443080-30644-4-git-send-email-raja_mani@ti.com>
 <1283443080-30644-5-git-send-email-raja_mani@ti.com>
 <1283443080-30644-6-git-send-email-raja_mani@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

From: Raja Mani <raja_mani@ti.com>

 Add new members in FM TX global data structure (struct fmtx_data)
 to track current Audio mode, Reemphasis and Region setting in TX mode.

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
---
 drivers/staging/ti-st/fmdrv.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ti-st/fmdrv.h b/drivers/staging/ti-st/fmdrv.h
index d560570..f8a4ce3 100644
--- a/drivers/staging/ti-st/fmdrv.h
+++ b/drivers/staging/ti-st/fmdrv.h
@@ -173,6 +173,7 @@ struct fm_rx {
 struct tx_rds {
 	unsigned char text_type;
 	unsigned char text[25];
+	unsigned char flag;
 	unsigned int af_freq;
 };
 /*
@@ -187,6 +188,9 @@ struct fmtx_data {
 	unsigned char pwr_lvl;
 	unsigned char xmit_state;
 	unsigned char audio_io;
+	unsigned char region;
+	unsigned short aud_mode;
+	unsigned int preemph;
 	unsigned long tx_frq;
 	struct tx_rds rds;
 };
-- 
1.5.6.3

