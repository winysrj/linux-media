Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138Ab0JUONj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 10:13:39 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9LEDdMZ025188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:13:39 -0400
Received: from pedra (vpn-225-164.phx2.redhat.com [10.3.225.164])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9LE9S5E022469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:13:38 -0400
Date: Thu, 21 Oct 2010 12:07:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] ir-raw-event: Fix a stupid error at a printk
Message-ID: <20101021120746.01ca4ef2@pedra>
In-Reply-To: <cover.1287669886.git.mchehab@redhat.com>
References: <cover.1287669886.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 0d59ef7..a06a07e 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -89,7 +89,7 @@ int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev)
 	if (!ir->raw)
 		return -EINVAL;
 
-	IR_dprintk(2, "sample: (05%dus %s)\n",
+	IR_dprintk(2, "sample: (%05dus %s)\n",
 		TO_US(ev->duration), TO_STR(ev->pulse));
 
 	if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
-- 
1.7.1


