Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55710 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbcF2NVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:00 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 11/15] lirc_dev: fix variable constant comparisons
Date: Wed, 29 Jun 2016 22:20:40 +0900
Message-id: <1467206444-9935-12-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When comparing a variable with a constant, the comparison should
start from the variable and not from the constant. It's also
written in the human DNA.

Swap the terms of comparisons whenever the constant comes first
and fix the following checkpatch warning:

  WARNING: Comparisons should place the constant on the right side of the test

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index c11cfc0..7e5cb85 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -245,13 +245,13 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		return -EINVAL;
 	}
 
-	if (MAX_IRCTL_DEVICES <= d->minor) {
+	if (d->minor >= MAX_IRCTL_DEVICES) {
 		dev_err(d->dev, "minor must be between 0 and %d!\n",
 						MAX_IRCTL_DEVICES - 1);
 		return -EBADRQC;
 	}
 
-	if (1 > d->code_length || (BUFLEN * 8) < d->code_length) {
+	if (d->code_length < 1 || d->code_length > (BUFLEN * 8)) {
 		dev_err(d->dev, "code length must be less than %d bits\n",
 								BUFLEN * 8);
 		return -EBADRQC;
@@ -282,7 +282,7 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
 			if (!irctls[minor])
 				break;
-		if (MAX_IRCTL_DEVICES == minor) {
+		if (minor == MAX_IRCTL_DEVICES) {
 			dev_err(d->dev, "no free slots for drivers!\n");
 			err = -ENOMEM;
 			goto out_lock;
-- 
2.8.1

