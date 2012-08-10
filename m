Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17655 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab2HJJZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 05:25:46 -0400
Date: Fri, 10 Aug 2012 12:25:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] qt1010: signedness bug in qt1010_init_meas1()
Message-ID: <20120810092502.GD26875@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

qt1010_init_meas2() returns zero on success and negative error codes on
failure so the return type should be int instead of u8.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/common/tuners/qt1010.c b/drivers/media/common/tuners/qt1010.c
index 2d79b1f..bdc39e1 100644
--- a/drivers/media/common/tuners/qt1010.c
+++ b/drivers/media/common/tuners/qt1010.c
@@ -288,7 +288,7 @@ static int qt1010_init_meas1(struct qt1010_priv *priv,
 	return qt1010_writereg(priv, 0x1e, 0x00);
 }
 
-static u8 qt1010_init_meas2(struct qt1010_priv *priv,
+static int qt1010_init_meas2(struct qt1010_priv *priv,
 			    u8 reg_init_val, u8 *retval)
 {
 	u8 i, val;
