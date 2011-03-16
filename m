Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab1CPUYj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:39 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKOdW9026207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:24:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 4/6] lirc: silence some compile warnings
Date: Wed, 16 Mar 2011 16:24:29 -0400
Message-Id: <1300307071-19665-5-git-send-email-jarod@redhat.com>
In-Reply-To: <1300307071-19665-1-git-send-email-jarod@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Both lirc_imon and lirc_sasem were causing gcc to complain about the
possible use of uninitialized variables.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/lirc/lirc_imon.c  |    2 +-
 drivers/staging/lirc/lirc_sasem.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lirc/lirc_imon.c b/drivers/staging/lirc/lirc_imon.c
index 235cab0..4039eda 100644
--- a/drivers/staging/lirc/lirc_imon.c
+++ b/drivers/staging/lirc/lirc_imon.c
@@ -379,7 +379,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 	struct imon_context *context;
 	const unsigned char vfd_packet6[] = {
 		0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF };
-	int *data_buf;
+	int *data_buf = NULL;
 
 	context = file->private_data;
 	if (!context) {
diff --git a/drivers/staging/lirc/lirc_sasem.c b/drivers/staging/lirc/lirc_sasem.c
index 925eabe..63a438d 100644
--- a/drivers/staging/lirc/lirc_sasem.c
+++ b/drivers/staging/lirc/lirc_sasem.c
@@ -364,7 +364,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 	int i;
 	int retval = 0;
 	struct sasem_context *context;
-	int *data_buf;
+	int *data_buf = NULL;
 
 	context = (struct sasem_context *) file->private_data;
 	if (!context) {
-- 
1.7.1

