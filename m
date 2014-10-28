Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 03/13] [media] lgdt3306a: one bit fields should be unsigned
Date: Tue, 28 Oct 2014 13:00:38 -0200
Message-Id: <d0f11347c962e775e6179e67101a22636c59babb.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix two smatch warnings:
	drivers/media/dvb-frontends/lgdt3306a.h:53:28: error: dubious one-bit signed bitfield
	drivers/media/dvb-frontends/lgdt3306a.h:56:33: error: dubious one-bit signed bitfield

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.h b/drivers/media/dvb-frontends/lgdt3306a.h
index 405beebb86e1..0b020e743060 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.h
+++ b/drivers/media/dvb-frontends/lgdt3306a.h
@@ -50,10 +50,10 @@ struct lgdt3306a_config {
 	u16 vsb_if_khz;
 
 	/* disable i2c repeater - 0:repeater enabled 1:repeater disabled */
-	int deny_i2c_rptr:1;
+	unsigned int deny_i2c_rptr:1;
 
 	/* spectral inversion - 0:disabled 1:enabled */
-	int spectral_inversion:1;
+	unsigned int spectral_inversion:1;
 
 	enum lgdt3306a_mpeg_mode mpeg_mode;
 	enum lgdt3306a_tp_clock_edge tpclk_edge;
-- 
1.9.3

