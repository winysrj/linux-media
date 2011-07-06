Return-path: <mchehab@localhost>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48091 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1GFRd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 13:33:29 -0400
Date: Wed, 6 Jul 2011 19:33:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, Henrik Kurelid <henrik@kurelid.se>
Subject: [PATCH] [media] firedtv: change some -EFAULT returns to more
 fitting error codes
Message-ID: <20110706193315.42fb981c@stein>
In-Reply-To: <4E14877F.6060208@redhat.com>
References: <4E14877F.6060208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Mauro Carvalho Chehab wrote:
> I'm validating if all drivers are behaving equally with respect to the
> error codes returned to userspace, and double-checking with the API.
> 
> On almost all places, -EFAULT code is used only to indicate when
> copy_from_user/copy_to_user fails. However, firedtv uses a lot of
> -EFAULT, where it seems to me that other error codes should be used
> instead (like -EIO for bus transfer errors and -EINVAL/-ERANGE for 
> invalid/out of range parameters).

This concerns only the CI (CAM) related code of firedtv of which I know
little.  Let's just pass through the error returns of lower level I/O
code where applicable, and -EACCES (permission denied) when a seemingly
valid but negative FCP response or an unknown-to-firedtv CA message is
received.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Henrik Kurelid <henrik@kurelid.se>
---
Only tested on FireDTV-{C,T}/CI without CAM.

 drivers/media/dvb/firewire/firedtv-avc.c |    2 
 drivers/media/dvb/firewire/firedtv-ci.c  |   34 +++++++++++------------
 2 files changed, 17 insertions(+), 19 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -1208,7 +1208,7 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 	if (r->response != AVC_RESPONSE_ACCEPTED) {
 		dev_err(fdtv->device,
 			"CA PMT failed with response 0x%x\n",
r->response);
-		ret = -EFAULT;
+		ret = -EACCES;
 	}
 out:
 	mutex_unlock(&fdtv->avc_mutex);
Index: b/drivers/media/dvb/firewire/firedtv-ci.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-ci.c
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -45,11 +45,6 @@ static int fdtv_get_ca_flags(struct fire
 	return flags;
 }
 
-static int fdtv_ca_reset(struct firedtv *fdtv)
-{
-	return avc_ca_reset(fdtv) ? -EFAULT : 0;
-}
-
 static int fdtv_ca_get_caps(void *arg)
 {
 	struct ca_caps *cap = arg;
@@ -65,12 +60,14 @@ static int fdtv_ca_get_slot_info(struct
 {
 	struct firedtv_tuner_status stat;
 	struct ca_slot_info *slot = arg;
+	int err;
 
-	if (avc_tuner_status(fdtv, &stat))
-		return -EFAULT;
+	err = avc_tuner_status(fdtv, &stat);
+	if (err)
+		return err;
 
 	if (slot->num != 0)
-		return -EFAULT;
+		return -EACCES;
 
 	slot->type = CA_CI;
 	slot->flags = fdtv_get_ca_flags(&stat);
@@ -81,21 +78,21 @@ static int fdtv_ca_app_info(struct fired
 {
 	struct ca_msg *reply = arg;
 
-	return avc_ca_app_info(fdtv, reply->msg, &reply->length) ?
-EFAULT : 0;
+	return avc_ca_app_info(fdtv, reply->msg, &reply->length);
 }
 
 static int fdtv_ca_info(struct firedtv *fdtv, void *arg)
 {
 	struct ca_msg *reply = arg;
 
-	return avc_ca_info(fdtv, reply->msg, &reply->length) ? -EFAULT :
0;
+	return avc_ca_info(fdtv, reply->msg, &reply->length);
 }
 
 static int fdtv_ca_get_mmi(struct firedtv *fdtv, void *arg)
 {
 	struct ca_msg *reply = arg;
 
-	return avc_ca_get_mmi(fdtv, reply->msg, &reply->length) ?
-EFAULT : 0;
+	return avc_ca_get_mmi(fdtv, reply->msg, &reply->length);
 }
 
 static int fdtv_ca_get_msg(struct firedtv *fdtv, void *arg)
@@ -111,14 +108,15 @@ static int fdtv_ca_get_msg(struct firedt
 		err = fdtv_ca_info(fdtv, arg);
 		break;
 	default:
-		if (avc_tuner_status(fdtv, &stat))
-			err = -EFAULT;
-		else if (stat.ca_mmi == 1)
+		err = avc_tuner_status(fdtv, &stat);
+		if (err)
+			break;
+		if (stat.ca_mmi == 1)
 			err = fdtv_ca_get_mmi(fdtv, arg);
 		else {
 			dev_info(fdtv->device, "unhandled CA message
0x%08x\n", fdtv->ca_last_command);
-			err = -EFAULT;
+			err = -EACCES;
 		}
 	}
 	fdtv->ca_last_command = 0;
@@ -141,7 +139,7 @@ static int fdtv_ca_pmt(struct firedtv *f
 		data_length = msg->msg[3];
 	}
 
-	return avc_ca_pmt(fdtv, &msg->msg[data_pos], data_length) ?
-EFAULT : 0;
+	return avc_ca_pmt(fdtv, &msg->msg[data_pos], data_length);
 }
 
 static int fdtv_ca_send_msg(struct firedtv *fdtv, void *arg)
@@ -170,7 +168,7 @@ static int fdtv_ca_send_msg(struct fired
 	default:
 		dev_err(fdtv->device, "unhandled CA message 0x%08x\n",
 			fdtv->ca_last_command);
-		err = -EFAULT;
+		err = -EACCES;
 	}
 	return err;
 }
@@ -184,7 +182,7 @@ static int fdtv_ca_ioctl(struct file *fi
 
 	switch (cmd) {
 	case CA_RESET:
-		err = fdtv_ca_reset(fdtv);
+		err = avc_ca_reset(fdtv);
 		break;
 	case CA_GET_CAP:
 		err = fdtv_ca_get_caps(arg);


-- 
Stefan Richter
-=====-==-== -=== --==-
http://arcgraph.de/sr/
