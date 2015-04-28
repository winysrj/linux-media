Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030338AbbD1PoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:14 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/14] qt1010: Reduce text size by using static const
Date: Tue, 28 Apr 2015 12:43:53 -0300
Message-Id: <4749f230222deb2cb2d57f849fb8e698e4d5f9ef.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using static const allows the compiler to optimize the code.

Before static const:
   text	   data	    bss	    dec	    hex	filename
   4982	    524	   1568	   7074	   1ba2	drivers/media/tuners/qt1010.o

After static const:
   text	   data	    bss	    dec	    hex	filename
   4714	    524	   1568	   6806	   1a96	drivers/media/tuners/qt1010.o

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index bc419f8a9671..74b6b17cdbaf 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -294,7 +294,7 @@ static int qt1010_init(struct dvb_frontend *fe)
 	int err = 0;
 	u8 i, tmpval, *valptr = NULL;
 
-	qt1010_i2c_oper_t i2c_data[] = {
+	static const qt1010_i2c_oper_t i2c_data[] = {
 		{ QT1010_WR, 0x01, 0x80 },
 		{ QT1010_WR, 0x0d, 0x84 },
 		{ QT1010_WR, 0x0e, 0xb7 },
-- 
2.1.0

