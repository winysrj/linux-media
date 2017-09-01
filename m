Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46995
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752125AbdIANZE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 20/27] media: dst_ca: return a proper error code from CA errors
Date: Fri,  1 Sep 2017 10:24:42 -0300
Message-Id: <5c5db5628c08e106216aac6a9843f28128f4c9c9.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, on several places, the driver is returning a
"-1" error to userspace, instead of a proper error code.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/dst_ca.c | 41 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 7db47d8bbe15..5ebb86f22935 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -137,7 +137,7 @@ static int dst_put_ci(struct dst_state *state, u8 *data, int len, u8 *ca_string,
 	}
 
 	if(dst_ca_comm_err == RETRIES)
-		return -1;
+		return -EIO;
 
 	return 0;
 }
@@ -152,7 +152,7 @@ static int ca_get_app_info(struct dst_state *state)
 	put_checksum(&command[0], command[0]);
 	if ((dst_put_ci(state, command, sizeof(command), state->messages, GET_REPLY)) < 0) {
 		dprintk(verbose, DST_CA_ERROR, 1, " -->dst_put_ci FAILED !");
-		return -1;
+		return -EIO;
 	}
 	dprintk(verbose, DST_CA_INFO, 1, " -->dst_put_ci SUCCESS !");
 	dprintk(verbose, DST_CA_INFO, 1, " ================================ CI Module Application Info ======================================");
@@ -191,7 +191,7 @@ static int ca_get_ca_info(struct dst_state *state)
 	put_checksum(&slot_command[0], slot_command[0]);
 	if ((dst_put_ci(state, slot_command, sizeof (slot_command), state->messages, GET_REPLY)) < 0) {
 		dprintk(verbose, DST_CA_ERROR, 1, " -->dst_put_ci FAILED !");
-		return -1;
+		return -EIO;
 	}
 	dprintk(verbose, DST_CA_INFO, 1, " -->dst_put_ci SUCCESS !");
 
@@ -235,7 +235,7 @@ static int ca_get_slot_caps(struct dst_state *state, struct ca_caps *p_ca_caps,
 	put_checksum(&slot_command[0], slot_command[0]);
 	if ((dst_put_ci(state, slot_command, sizeof (slot_command), slot_cap, GET_REPLY)) < 0) {
 		dprintk(verbose, DST_CA_ERROR, 1, " -->dst_put_ci FAILED !");
-		return -1;
+		return -EIO;
 	}
 	dprintk(verbose, DST_CA_NOTICE, 1, " -->dst_put_ci SUCCESS !");
 
@@ -275,7 +275,7 @@ static int ca_get_slot_info(struct dst_state *state, struct ca_slot_info *p_ca_s
 	put_checksum(&slot_command[0], 7);
 	if ((dst_put_ci(state, slot_command, sizeof (slot_command), slot_info, GET_REPLY)) < 0) {
 		dprintk(verbose, DST_CA_ERROR, 1, " -->dst_put_ci FAILED !");
-		return -1;
+		return -EIO;
 	}
 	dprintk(verbose, DST_CA_INFO, 1, " -->dst_put_ci SUCCESS !");
 
@@ -347,7 +347,7 @@ static int handle_dst_tag(struct dst_state *state, struct ca_msg *p_ca_message,
 	} else {
 		if (length > 247) {
 			dprintk(verbose, DST_CA_ERROR, 1, " Message too long ! *** Bailing Out *** !");
-			return -1;
+			return -EIO;
 		}
 		hw_buffer->msg[0] = (length & 0xff) + 7;
 		hw_buffer->msg[1] = 0x40;
@@ -373,7 +373,7 @@ static int write_to_8820(struct dst_state *state, struct ca_msg *hw_buffer, u8 l
 		dprintk(verbose, DST_CA_ERROR, 1, " DST-CI Command failed.");
 		dprintk(verbose, DST_CA_NOTICE, 1, " Resetting DST.");
 		rdc_reset_state(state);
-		return -1;
+		return -EIO;
 	}
 	dprintk(verbose, DST_CA_NOTICE, 1, " DST-CI Command success.");
 
@@ -446,7 +446,7 @@ static int dst_check_ca_pmt(struct dst_state *state, struct ca_msg *p_ca_message
 	if (ca_pmt_reply_test) {
 		if ((ca_set_pmt(state, p_ca_message, hw_buffer, 1, GET_REPLY)) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " ca_set_pmt.. failed !");
-			return -1;
+			return -EIO;
 		}
 
 	/*	Process CA PMT Reply		*/
@@ -457,7 +457,7 @@ static int dst_check_ca_pmt(struct dst_state *state, struct ca_msg *p_ca_message
 	if (!ca_pmt_reply_test) {
 		if ((ca_set_pmt(state, p_ca_message, hw_buffer, 0, NO_REPLY)) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " ca_set_pmt.. failed !");
-			return -1;
+			return -EIO;
 		}
 		dprintk(verbose, DST_CA_NOTICE, 1, " ca_set_pmt.. success !");
 	/*	put a dummy message		*/
@@ -566,17 +566,18 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	switch (cmd) {
 	case CA_SEND_MSG:
 		dprintk(verbose, DST_CA_INFO, 1, " Sending message");
-		if ((ca_send_message(state, p_ca_message, arg)) < 0) {
+		result = ca_send_message(state, p_ca_message, arg);
+
+		if (result < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_SEND_MSG Failed !");
-			result = -1;
 			goto free_mem_and_exit;
 		}
 		break;
 	case CA_GET_MSG:
 		dprintk(verbose, DST_CA_INFO, 1, " Getting message");
-		if ((ca_get_message(state, p_ca_message, arg)) < 0) {
+		result = ca_get_message(state, p_ca_message, arg);
+		if (result < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_MSG Failed !");
-			result = -1;
 			goto free_mem_and_exit;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_MSG Success !");
@@ -588,7 +589,8 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		break;
 	case CA_GET_SLOT_INFO:
 		dprintk(verbose, DST_CA_INFO, 1, " Getting Slot info");
-		if ((ca_get_slot_info(state, p_ca_slot_info, arg)) < 0) {
+		result = ca_get_slot_info(state, p_ca_slot_info, arg);
+		if (result < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_SLOT_INFO Failed !");
 			result = -1;
 			goto free_mem_and_exit;
@@ -597,25 +599,26 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		break;
 	case CA_GET_CAP:
 		dprintk(verbose, DST_CA_INFO, 1, " Getting Slot capabilities");
-		if ((ca_get_slot_caps(state, p_ca_caps, arg)) < 0) {
+		result = ca_get_slot_caps(state, p_ca_caps, arg);
+		if (result < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_CAP Failed !");
-			result = -1;
 			goto free_mem_and_exit;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_CAP Success !");
 		break;
 	case CA_GET_DESCR_INFO:
 		dprintk(verbose, DST_CA_INFO, 1, " Getting descrambler description");
-		if ((ca_get_slot_descr(state, p_ca_message, arg)) < 0) {
+		result = ca_get_slot_descr(state, p_ca_message, arg);
+		if (result < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_DESCR_INFO Failed !");
-			result = -1;
 			goto free_mem_and_exit;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_DESCR_INFO Success !");
 		break;
 	case CA_SET_DESCR:
 		dprintk(verbose, DST_CA_INFO, 1, " Setting descrambler");
-		if ((ca_set_slot_descr()) < 0) {
+		result = ca_set_slot_descr();
+		if (result < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_SET_DESCR Failed !");
 			result = -1;
 			goto free_mem_and_exit;
-- 
2.13.5
