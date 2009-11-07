Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42368 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbZKGVus convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:50:48 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:50:51 +0000
Message-ID: <1257630651.15927.418.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 25/75] dvb-ttpci/av7110: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/ttpci/av7110.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 8d65c65..5ddc9d6 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2922,3 +2922,4 @@ MODULE_DESCRIPTION("driver for the SAA7146 based AV110 PCI DVB cards by "
 		   "Siemens, Technotrend, Hauppauge");
 MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, others");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-ttpci-01.fw");
-- 
1.6.5.2



