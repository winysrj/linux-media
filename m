Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:41682 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756364Ab1CNVDo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 17:03:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 14 Mar 2011 22:03:40 +0100
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: <mchehab@infradead.org>
Cc: Nils Faerber <nils.faerber@kernelconcepts.de>,
	<linux-media@vger.kernel.org>
Subject: [PATCH] fix of mutex locking bug in =?UTF-8?Q?fops=5Fread?=
Message-ID: <28773e810fb3efb9dc0a9cc683a2268f@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch fixes a mutex locking bug causing userspace processes
to hang indefinitely upon reading the radio device for RDS data.

Signed-off-by: Nils Faerber <nils.faerber@kernelconcepts.de>
Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c
b/drivers/media/radio/si470x/radio-si470x-common.c
index 4c69698..41ee757 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -483,7 +483,6 @@ static ssize_t si470x_fops_read(struct file *file,
char __user *buf,
 	count /= 3;
 
 	/* copy RDS block out of internal buffer and to user buffer */
-	mutex_lock(&radio->lock);
 	while (block_count < count) {
 		if (radio->rd_index == radio->wr_index)
 			break;
-- 
1.7.2.3


