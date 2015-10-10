Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 05/26] [media] tveeprom: Remove two unused fields from struct
Date: Sat, 10 Oct 2015 10:35:48 -0300
Message-Id: <6dd3187447e710db23de81ed4877fc8f72e80411.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The digitizer* fields aren't used. Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/tveeprom.h b/include/media/tveeprom.h
index f7119ee3977b..bb484967ef8b 100644
--- a/include/media/tveeprom.h
+++ b/include/media/tveeprom.h
@@ -32,9 +32,6 @@ struct tveeprom {
 	u32 tuner2_formats;
 	u32 tuner2_hauppauge_model;
 
-	u32 digitizer;
-	u32 digitizer_formats;
-
 	u32 audio_processor;
 	u32 decoder_processor;
 
-- 
2.4.3


