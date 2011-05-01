Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:53576 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755780Ab1EATGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 15:06:05 -0400
Received: from tobias-t61p.localnet (unknown [10.2.3.10])
	by mail.lorenz.priv (Postfix) with ESMTPS id E29F0141ED
	for <linux-media@vger.kernel.org>; Sun,  1 May 2011 21:06:00 +0200 (CEST)
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/6] important fix for rds locking
Date: Sun, 1 May 2011 21:00:44 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105012100.44349.tobias.lorenz@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch removes a redundant mutex_lock in fops_read.
Every rds read attempt would stall otherwise.

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
b/drivers/media/radio/si470x/radio-si470x-common.c
index ac76dfe..5cbeeb3 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -438,7 +438,6 @@ static ssize_t si470x_fops_read(struct file *file, char 
__user *buf,
 	unsigned int block_count = 0;
 
 	/* switch on rds reception */
-	mutex_lock(&radio->lock);
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		si470x_rds_on(radio);
 
@@ -479,9 +478,9 @@ static ssize_t si470x_fops_read(struct file *file, char 
__user *buf,
 		buf += 3;
 		retval += 3;
 	}
+	mutex_unlock(&radio->lock);
 
 done:
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
-- 
1.7.4.1

