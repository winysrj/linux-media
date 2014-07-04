Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbaGDRPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:15:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 02/14] dib8000: Fix ADC OFF settings
Date: Fri,  4 Jul 2014 14:15:28 -0300
Message-Id: <1404494140-17777-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADC OFF values are wrong. This causes troubles on detecting
weak signals.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index cf837158f822..cd300ac23935 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -588,8 +588,8 @@ static int dib8000_set_adc_state(struct dib8000_state *state, enum dibx000_adc_s
 		break;
 
 	case DIBX000_ADC_OFF:	// leave the VBG voltage on
-		reg_907 |= (1 << 14) | (1 << 13) | (1 << 12);
-		reg_908 |= (1 << 5) | (1 << 4) | (1 << 3) | (1 << 2);
+		reg_907 = (1 << 13) | (1 << 12);
+		reg_908 = (1 << 6) | (1 << 5) | (1 << 4) | (1 << 3) | (1 << 1);
 		break;
 
 	case DIBX000_VBG_ENABLE:
-- 
1.9.3

