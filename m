Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1CPUYk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:40 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKOeaJ026214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:24:40 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 5/6] lirc_zilog: error out if buffer read bytes != chunk size
Date: Wed, 16 Mar 2011 16:24:30 -0400
Message-Id: <1300307071-19665-6-git-send-email-jarod@redhat.com>
In-Reply-To: <1300307071-19665-1-git-send-email-jarod@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/lirc/lirc_zilog.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 407d4b4..5ada643 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -950,6 +950,10 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 				ret = copy_to_user((void *)outbuf+written, buf,
 						   rbuf->chunk_size);
 				written += rbuf->chunk_size;
+			} else {
+				zilog_error("Buffer read failed!\n");
+				ret = -EIO;
+				break;
 			}
 		}
 	}
-- 
1.7.1

