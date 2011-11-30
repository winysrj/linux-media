Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981Ab1K3RIe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:08:34 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAUH8YZN024430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 12:08:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 5/5] [media] tm6000: Use a 16 scancode bitmask for IR
Date: Wed, 30 Nov 2011 15:08:24 -0200
Message-Id: <1322672904-17340-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322672904-17340-4-git-send-email-mchehab@redhat.com>
References: <1322672904-17340-1-git-send-email-mchehab@redhat.com>
 <1322672904-17340-2-git-send-email-mchehab@redhat.com>
 <1322672904-17340-3-git-send-email-mchehab@redhat.com>
 <1322672904-17340-4-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This should allow using 24 or 32 bits NEC IR decoding tables with
those devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-input.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 6eaf770..e3467d4 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -416,6 +416,8 @@ int tm6000_ir_init(struct tm6000_core *dev)
 
 	/* input setup */
 	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
+	/* Neded, in order to support NEC remotes with 24 or 32 bits */
+	rc->scanmask = 0xffff;
 	rc->priv = ir;
 	rc->change_protocol = tm6000_ir_change_protocol;
 	if (&dev->int_in) {
-- 
1.7.7.3

