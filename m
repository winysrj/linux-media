Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736Ab3DQHMM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 03:12:12 -0400
Date: Wed, 17 Apr 2013 10:11:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] dvb-frontends: lg2160: dubious one-bit signed
 bitfield
Message-ID: <20130417071146.GB7923@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sparse complains that these are "dubious one-bit signed bitfields" and
the comment says it was intended to be 1 and 0 instead of -1 and 0.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-frontends/lg2160.h b/drivers/media/dvb-frontends/lg2160.h
index a5f0368..194a07a 100644
--- a/drivers/media/dvb-frontends/lg2160.h
+++ b/drivers/media/dvb-frontends/lg2160.h
@@ -57,10 +57,10 @@ struct lg2160_config {
 	u16 if_khz;
 
 	/* disable i2c repeater - 0:repeater enabled 1:repeater disabled */
-	int deny_i2c_rptr:1;
+	unsigned int deny_i2c_rptr:1;
 
 	/* spectral inversion - 0:disabled 1:enabled */
-	int spectral_inversion:1;
+	unsigned int spectral_inversion:1;
 
 	unsigned int output_if;
 	enum lg2160_spi_clock spi_clock;
