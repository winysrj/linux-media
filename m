Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:55418 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1EHTRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 15:17:43 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH v2 4/5] cxd2820r: Update frontend capabilities to advertise QAM-256
Date: Sun,  8 May 2011 20:17:19 +0100
Message-Id: <1304882240-23044-5-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC6BF28.8070006@redhat.com>
References: <4DC6BF28.8070006@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is supported in DVB-T2 mode, so added to the T/T2 frontend.

Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
---
 drivers/media/dvb/frontends/cxd2820r_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index e900c4c..0779f69 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -855,7 +855,8 @@ static struct dvb_frontend_ops cxd2820r_ops[2] = {
 				FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 |
 				FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 				FE_CAN_QPSK | FE_CAN_QAM_16 |
-				FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
+				FE_CAN_QAM_64 | FE_CAN_QAM_256 |
+				FE_CAN_QAM_AUTO |
 				FE_CAN_TRANSMISSION_MODE_AUTO |
 				FE_CAN_GUARD_INTERVAL_AUTO |
 				FE_CAN_HIERARCHY_AUTO |
-- 
1.7.1

