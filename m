Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47612 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbZKGVtZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:49:25 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:49:28 +0000
Message-ID: <1257630568.15927.406.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 14/75] bcm3510: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/bcm3510.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index cf5e576..a08bd1f 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -852,3 +852,4 @@ static struct dvb_frontend_ops bcm3510_ops = {
 MODULE_DESCRIPTION("Broadcom BCM3510 ATSC (8VSB/16VSB & ITU J83 AnnexB FEC QAM64/256) demodulator driver");
 MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(BCM3510_DEFAULT_FIRMWARE);
-- 
1.6.5.2



