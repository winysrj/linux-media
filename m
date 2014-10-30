Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbaJ3KRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 06:17:05 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux1394-devel@lists.sourceforge.net
Subject: [PATCH] [media] fix a warning on avr32 arch
Date: Thu, 30 Oct 2014 08:16:57 -0200
Message-Id: <3948e2c09f98e556afe11f0e3d348bbe610af31e.1414664215.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

on avr32 arch, those warnings happen:
	drivers/media/firewire/firedtv-fw.c: In function 'node_update':
	drivers/media/firewire/firedtv-fw.c:329: warning: comparison is always true due to limited range of data type

In this particular case, the signal is desired, as the isochannel
var can be initalized with -1 inside the driver.

So, change the type to s8, to avoid issues on archs where char
is unsigned.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/firewire/firedtv.h b/drivers/media/firewire/firedtv.h
index c2ba085e0d20..346a85be6de2 100644
--- a/drivers/media/firewire/firedtv.h
+++ b/drivers/media/firewire/firedtv.h
@@ -96,7 +96,7 @@ struct firedtv {
 
 	enum model_type		type;
 	char			subunit;
-	char			isochannel;
+	s8			isochannel;
 	struct fdtv_ir_context	*ir_context;
 
 	fe_sec_voltage_t	voltage;
-- 
1.9.3

