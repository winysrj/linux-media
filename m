Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966209Ab0GPV35 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 17:29:57 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6GLTvUo019849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 16 Jul 2010 17:29:57 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6GLTtMA000785
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Jul 2010 17:29:56 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o6GLTtni019989
	for <linux-media@vger.kernel.org>; Fri, 16 Jul 2010 17:29:55 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o6GLTs9c019988
	for linux-media@vger.kernel.org; Fri, 16 Jul 2010 17:29:54 -0400
Date: Fri, 16 Jul 2010 17:29:54 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/lirc: use memdup_user instead of copy_from_user
Message-ID: <20100716212953.GA19872@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inspired by 64047b94ede76e0c72ba8af98505e96d6a664519

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-lirc-codec.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index afb1ada..ee1f2d4 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -74,14 +74,9 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 	if (count > LIRCBUF_SIZE || count % 2 == 0)
 		return -EINVAL;
 
-	txbuf = kzalloc(sizeof(int) * LIRCBUF_SIZE, GFP_KERNEL);
-	if (!txbuf)
-		return -ENOMEM;
-
-	if (copy_from_user(txbuf, buf, n)) {
-		ret = -EFAULT;
-		goto out;
-	}
+	txbuf = memdup_user(buf, n);
+	if (IS_ERR(txbuf))
+		return PTR_ERR(txbuf);
 
 	ir_dev = lirc->ir_dev;
 	if (!ir_dev) {
-- 
1.7.1.1

-- 
Jarod Wilson
jarod@redhat.com

