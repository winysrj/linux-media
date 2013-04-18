Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17668 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3DRTUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 15:20:52 -0400
Date: Thu, 18 Apr 2013 22:20:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	kbuild@01.org
Subject: [patch 1/2] [media] r820t: precendence bug in r820t_xtal_check()
Message-ID: <20130418192040.GA17798@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The test as written is always false.  It looks like the intent was to
test that the bit was not set.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 905a106..ba033fd 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1378,7 +1378,7 @@ static int r820t_xtal_check(struct r820t_priv *priv)
 		rc = r820t_read(priv, 0x00, data, sizeof(data));
 		if (rc < 0)
 			return rc;
-		if ((!data[2]) & 0x40)
+		if (!(data[2] & 0x40))
 			continue;
 
 		val = data[2] & 0x3f;
