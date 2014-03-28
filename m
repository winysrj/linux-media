Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32603 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaC1I0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 04:26:17 -0400
Date: Fri, 28 Mar 2014 11:26:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] av7110: fix confusing indenting
Message-ID: <20140328082603.GJ25192@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The else statement here is not aligned with the correct if statement.
I think the code works as intended and it's just the indenting which is
wrong.  Also kernel style says we should use curly braces here so I have
added those.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This patch doesn't change how the code works, but I would still
appreciate extra review because maybe the original code is wrong?

diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index 301029c..9544cfc 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -958,8 +958,10 @@ static unsigned int dvb_video_poll(struct file *file, poll_table *wait)
 		if (av7110->playing) {
 			if (FREE_COND)
 				mask |= (POLLOUT | POLLWRNORM);
-			} else /* if not playing: may play if asked for */
-				mask |= (POLLOUT | POLLWRNORM);
+		} else {
+			/* if not playing: may play if asked for */
+			mask |= (POLLOUT | POLLWRNORM);
+		}
 	}
 
 	return mask;
