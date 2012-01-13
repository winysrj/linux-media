Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:62337 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2AMG2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 01:28:44 -0500
Date: Fri, 13 Jan 2012 09:28:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mb86a20s: fix off by one checks
Message-ID: <20120113062834.GA23737@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clearly ">=" was intended here instead of ">".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 38778a8..4e6f836 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -535,7 +535,7 @@ static int mb86a20s_get_modulation(struct mb86a20s_state *state,
 		[2] = 0x8e,	/* Layer C */
 	};
 
-	if (layer > ARRAY_SIZE(reg))
+	if (layer >= ARRAY_SIZE(reg))
 		return -EINVAL;
 	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
 	if (rc < 0)
@@ -568,7 +568,7 @@ static int mb86a20s_get_fec(struct mb86a20s_state *state,
 		[2] = 0x8f,	/* Layer C */
 	};
 
-	if (layer > ARRAY_SIZE(reg))
+	if (layer >= ARRAY_SIZE(reg))
 		return -EINVAL;
 	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
 	if (rc < 0)
@@ -603,7 +603,7 @@ static int mb86a20s_get_interleaving(struct mb86a20s_state *state,
 		[2] = 0x90,	/* Layer C */
 	};
 
-	if (layer > ARRAY_SIZE(reg))
+	if (layer >= ARRAY_SIZE(reg))
 		return -EINVAL;
 	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
 	if (rc < 0)
@@ -627,7 +627,7 @@ static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
 		[2] = 0x91,	/* Layer C */
 	};
 
-	if (layer > ARRAY_SIZE(reg))
+	if (layer >= ARRAY_SIZE(reg))
 		return -EINVAL;
 	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
 	if (rc < 0)
