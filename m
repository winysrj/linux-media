Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61747 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab3DTKCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 06:02:20 -0400
Date: Sat, 20 Apr 2013 18:02:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: kbuild-all@01.org, linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] r820t: quiet gcc warning on n_ring
Message-ID: <20130420100216.GB24551@localhost>
References: <516ff3b5.J3wZZ5D4m/PHbRWT%fengguang.wu@intel.com>
 <20130418105241.5e1dcea6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418105241.5e1dcea6@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 drivers/media/tuners/r820t.c: In function 'r820t_imr':
 drivers/media/tuners/r820t.c:1871:8: warning: 'n_ring' may be used uninitialized in this function [-Wmaybe-uninitialized]

Mauro: This is a FALSE POSITIVE: the loop will always return a value
for n_ring, as the last test will fill it with 15, if the loop fails.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/media/tuners/r820t.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index fa2e9ae..a975ffe 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1852,15 +1852,12 @@ static int r820t_imr(struct r820t_priv *priv, unsigned imr_mem, bool im_flag)
 	else
 		ring_ref = priv->cfg->xtal;
 
+	n_ring = 15;
 	for (n = 0; n < 16; n++) {
 		if ((16 + n) * 8 * ring_ref >= 3100000) {
 			n_ring = n;
 			break;
 		}
-
-		/* n_ring not found */
-		if (n == 15)
-			n_ring = n;
 	}
 
 	reg18 = r820t_read_cache_reg(priv, 0x18);
-- 
1.7.10.4

