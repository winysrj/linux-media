Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1K3SuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 13:50:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAUIo5bP005278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 13:50:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] [media] tm6000: fix OOPS at tm6000_ir_int_stop() and tm6000_ir_int_start()
Date: Wed, 30 Nov 2011 16:50:00 -0200
Message-Id: <1322679000-26453-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322679000-26453-1-git-send-email-mchehab@redhat.com>
References: <1322679000-26453-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ 3755.608233] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[ 3755.616360] IP: [<ffffffffa03b80b7>] tm6000_ir_int_stop+0x10/0x1b [tm6000]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-input.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index e3467d4..af4bcf5 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -377,6 +377,9 @@ int tm6000_ir_int_start(struct tm6000_core *dev)
 {
 	struct tm6000_IR *ir = dev->ir;
 
+	if (!ir)
+		return;
+
 	return __tm6000_ir_int_start(ir->rc);
 }
 
@@ -384,6 +387,9 @@ void tm6000_ir_int_stop(struct tm6000_core *dev)
 {
 	struct tm6000_IR *ir = dev->ir;
 
+	if (!ir || !ir->rc)
+		return;
+
 	__tm6000_ir_int_stop(ir->rc);
 }
 
-- 
1.7.7.3

