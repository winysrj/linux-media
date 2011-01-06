Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:52335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab1AFUAD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 15:00:03 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p06K03ax015169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 6 Jan 2011 15:00:03 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 4/6] rc/imon: default to key mode instead of mouse mode
Date: Thu,  6 Jan 2011 14:59:35 -0500
Message-Id: <1294343977-31929-5-git-send-email-jarod@redhat.com>
In-Reply-To: <1294343839-31784-1-git-send-email-jarod@redhat.com>
References: <1294343839-31784-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

My initial thinking was that we should default to mouse mode, so people
could use the mouse function to click on something on a login screen,
but a lot of systems where a remote is useful automatically log in a
user and launch a media center application, some of which hide the
mouse, which can be confusing to users if they punch buttons on the
remote and don't see any feedback. Plus, first and foremost, its a
remote, so lets default to being a remote, and only toggle into mouse
mode when the user explicitly asks for it. As a nice side-effect, this
actually simplifies some of the code a fair bit...

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 7034207..e7dc6b4 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -988,7 +988,6 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 	int retval;
 	struct imon_context *ictx = rc->priv;
 	struct device *dev = ictx->dev;
-	bool pad_mouse;
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
@@ -1000,29 +999,20 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 	case RC_TYPE_RC6:
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
-		pad_mouse = false;
 		break;
 	case RC_TYPE_UNKNOWN:
 	case RC_TYPE_OTHER:
 		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
-		if (pad_stabilize && !nomouse)
-			pad_mouse = true;
-		else {
+		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
-			pad_mouse = false;
-		}
 		/* ir_proto_packet[0] = 0x00; // already the default */
 		rc_type = RC_TYPE_OTHER;
 		break;
 	default:
 		dev_warn(dev, "Unsupported IR protocol specified, overriding "
 			 "to iMON IR protocol\n");
-		if (pad_stabilize && !nomouse)
-			pad_mouse = true;
-		else {
+		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
-			pad_mouse = false;
-		}
 		/* ir_proto_packet[0] = 0x00; // already the default */
 		rc_type = RC_TYPE_OTHER;
 		break;
@@ -1035,7 +1025,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 		goto out;
 
 	ictx->rc_type = rc_type;
-	ictx->pad_mouse = pad_mouse;
+	ictx->pad_mouse = false;
 
 out:
 	return retval;
@@ -1517,7 +1507,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 			return;
 		} else {
-			ictx->pad_mouse = 0;
+			ictx->pad_mouse = false;
 			dev_dbg(dev, "mouse mode disabled, passing key value\n");
 		}
 	}
-- 
1.7.3.4

