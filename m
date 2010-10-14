Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab0JNUym (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 16:54:42 -0400
Message-ID: <4CB76E0E.7000704@redhat.com>
Date: Thu, 14 Oct 2010 17:54:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] V4L/DVB: ir: properly handle an error at input_register
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Be sure to rollback all init if input register fails.

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index a616bd0..5f24cd6 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -507,6 +507,8 @@ int __ir_input_register(struct input_dev *input_dev,
 		}
 
 	rc = ir_register_input(input_dev);
+	if (rc < 0)
+		goto out_event;
 
 	IR_dprintk(1, "Registered input device on %s for %s remote%s.\n",
 		   driver_name, rc_tab->name,
