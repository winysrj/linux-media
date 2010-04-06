Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab0DFSSX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:23 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IINDc008011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:23 -0400
Date: Tue, 6 Apr 2010 15:18:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 25/26] V4L/DVB: re-add enable/disable check to the IR
 decoders
Message-ID: <20100406151800.7653fe23@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A previous cleanup patch removed more than needed. Re-add the logic that
disable the decoders.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 28d7735..9d1ada9 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -142,6 +142,9 @@ static int ir_nec_decode(struct input_dev *input_dev,
 	if (!data)
 		return -EINVAL;
 
+	if (!data->enabled)
+		return 0;
+
 	/* Except for the initial event, what matters is the previous bit */
 	bit = (ev->type & IR_PULSE) ? 1 : 0;
 
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index 61b5839..4fb3ce4 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -153,6 +153,9 @@ static int ir_rc5_decode(struct input_dev *input_dev,
 	if (!data)
 		return -EINVAL;
 
+	if (!data->enabled)
+		return 0;
+
 	/* Except for the initial event, what matters is the previous bit */
 	bit = (ev->type & IR_PULSE) ? 1 : 0;
 
-- 
1.6.6.1


