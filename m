Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbHVR2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:34 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/39] [media] Docbook: Fix s_rx_carrier_range parameter description
Date: Sat, 22 Aug 2015 14:27:51 -0300
Message-Id: <aa445c7d3174ee7311b0735edea135b8aa6037ee.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/rc-core.h:178): No description found for parameter 's_rx_carrier_range'
Warning(.//include/media/rc-core.h:178): Excess struct/union/enum/typedef member 's_rx_carrier' description in 'rc_dev'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 5642fbea886e..63eb5217edd5 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -112,7 +112,7 @@ enum rc_filter_type {
  * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
  * @s_tx_carrier: set transmit carrier frequency
  * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
- * @s_rx_carrier: inform driver about carrier it is expected to handle
+ * @s_rx_carrier_range: inform driver about carrier it is expected to handle
  * @tx_ir: transmit IR
  * @s_idle: enable/disable hardware idle mode, upon which,
  *	device doesn't interrupt host until it sees IR pulses
-- 
2.4.3

