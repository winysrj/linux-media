Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab0JWTna (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 15:43:30 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9NJhUvG020891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 15:43:30 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9NJhUZ8026924
	for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 15:43:30 -0400
Date: Sat, 23 Oct 2010 15:43:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] imon: fix nomouse modprobe option
Message-ID: <20101023194329.GE4825@redhat.com>
References: <20101023194107.GB4825@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023194107.GB4825@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Pointed out by Bonne Eggleston on the lirc list.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index b4d489d..f782a9d 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1004,7 +1004,7 @@ int imon_ir_change_protocol(void *priv, u64 ir_type)
 	case IR_TYPE_UNKNOWN:
 	case IR_TYPE_OTHER:
 		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
-		if (pad_stabilize)
+		if (pad_stabilize && !nomouse)
 			pad_mouse = true;
 		else {
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
@@ -1016,7 +1016,7 @@ int imon_ir_change_protocol(void *priv, u64 ir_type)
 	default:
 		dev_warn(dev, "Unsupported IR protocol specified, overriding "
 			 "to iMON IR protocol\n");
-		if (pad_stabilize)
+		if (pad_stabilize && !nomouse)
 			pad_mouse = true;
 		else {
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
-- 
1.7.2.3


-- 
Jarod Wilson
jarod@redhat.com

