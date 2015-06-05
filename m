Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbbFEO2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/11] [media] bt8xx: remove needless check
Date: Fri,  5 Jun 2015 11:27:38 -0300
Message-Id: <e445af95ff02b82de88636f302d322c37721f103.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/pci/bt8xx/dst_ca.c:323 ca_get_message() warn: this array is probably non-NULL. 'p_ca_message->msg'
	drivers/media/pci/bt8xx/dst_ca.c:498 ca_send_message() warn: this array is probably non-NULL. 'p_ca_message->msg'

Those two checks are needless/useless, as the ca_msg struct is
declared as:
typedef struct ca_msg {
        unsigned int index;
        unsigned int type;
        unsigned int length;
        unsigned char msg[256];
} ca_msg_t;

So, if the p_ca_message pointer is not null, msg will also be
not null.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index c22c4ae06844..c5cc14ef8347 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -320,29 +320,27 @@ static int ca_get_message(struct dst_state *state, struct ca_msg *p_ca_message,
 	if (copy_from_user(p_ca_message, arg, sizeof (struct ca_msg)))
 		return -EFAULT;
 
-	if (p_ca_message->msg) {
-		dprintk(verbose, DST_CA_NOTICE, 1, " Message = [%*ph]",
-			3, p_ca_message->msg);
+	dprintk(verbose, DST_CA_NOTICE, 1, " Message = [%*ph]",
+		3, p_ca_message->msg);
 
-		for (i = 0; i < 3; i++) {
-			command = command | p_ca_message->msg[i];
-			if (i < 2)
-				command = command << 8;
-		}
-		dprintk(verbose, DST_CA_NOTICE, 1, " Command=[0x%x]", command);
+	for (i = 0; i < 3; i++) {
+		command = command | p_ca_message->msg[i];
+		if (i < 2)
+			command = command << 8;
+	}
+	dprintk(verbose, DST_CA_NOTICE, 1, " Command=[0x%x]", command);
 
-		switch (command) {
-		case CA_APP_INFO:
-			memcpy(p_ca_message->msg, state->messages, 128);
-			if (copy_to_user(arg, p_ca_message, sizeof (struct ca_msg)) )
-				return -EFAULT;
-			break;
-		case CA_INFO:
-			memcpy(p_ca_message->msg, state->messages, 128);
-			if (copy_to_user(arg, p_ca_message, sizeof (struct ca_msg)) )
-				return -EFAULT;
-			break;
-		}
+	switch (command) {
+	case CA_APP_INFO:
+		memcpy(p_ca_message->msg, state->messages, 128);
+		if (copy_to_user(arg, p_ca_message, sizeof (struct ca_msg)) )
+			return -EFAULT;
+		break;
+	case CA_INFO:
+		memcpy(p_ca_message->msg, state->messages, 128);
+		if (copy_to_user(arg, p_ca_message, sizeof (struct ca_msg)) )
+			return -EFAULT;
+		break;
 	}
 
 	return 0;
@@ -494,60 +492,58 @@ static int ca_send_message(struct dst_state *state, struct ca_msg *p_ca_message,
 		goto free_mem_and_exit;
 	}
 
+	/*	EN50221 tag	*/
+	command = 0;
 
-	if (p_ca_message->msg) {
-		/*	EN50221 tag	*/
-		command = 0;
+	for (i = 0; i < 3; i++) {
+		command = command | p_ca_message->msg[i];
+		if (i < 2)
+			command = command << 8;
+	}
+	dprintk(verbose, DST_CA_DEBUG, 1, " Command=[0x%x]\n", command);
 
-		for (i = 0; i < 3; i++) {
-			command = command | p_ca_message->msg[i];
-			if (i < 2)
-				command = command << 8;
+	switch (command) {
+	case CA_PMT:
+		dprintk(verbose, DST_CA_DEBUG, 1, "Command = SEND_CA_PMT");
+		if ((ca_set_pmt(state, p_ca_message, hw_buffer, 0, 0)) < 0) {	// code simplification started
+			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_PMT Failed !");
+			result = -1;
+			goto free_mem_and_exit;
 		}
-		dprintk(verbose, DST_CA_DEBUG, 1, " Command=[0x%x]\n", command);
-
-		switch (command) {
-		case CA_PMT:
-			dprintk(verbose, DST_CA_DEBUG, 1, "Command = SEND_CA_PMT");
-			if ((ca_set_pmt(state, p_ca_message, hw_buffer, 0, 0)) < 0) {	// code simplification started
-				dprintk(verbose, DST_CA_ERROR, 1, " -->CA_PMT Failed !");
-				result = -1;
-				goto free_mem_and_exit;
-			}
-			dprintk(verbose, DST_CA_INFO, 1, " -->CA_PMT Success !");
-			break;
-		case CA_PMT_REPLY:
-			dprintk(verbose, DST_CA_INFO, 1, "Command = CA_PMT_REPLY");
-			/*      Have to handle the 2 basic types of cards here  */
-			if ((dst_check_ca_pmt(state, p_ca_message, hw_buffer)) < 0) {
-				dprintk(verbose, DST_CA_ERROR, 1, " -->CA_PMT_REPLY Failed !");
-				result = -1;
-				goto free_mem_and_exit;
-			}
-			dprintk(verbose, DST_CA_INFO, 1, " -->CA_PMT_REPLY Success !");
-			break;
-		case CA_APP_INFO_ENQUIRY:		// only for debugging
-			dprintk(verbose, DST_CA_INFO, 1, " Getting Cam Application information");
+		dprintk(verbose, DST_CA_INFO, 1, " -->CA_PMT Success !");
+		break;
+	case CA_PMT_REPLY:
+		dprintk(verbose, DST_CA_INFO, 1, "Command = CA_PMT_REPLY");
+		/*      Have to handle the 2 basic types of cards here  */
+		if ((dst_check_ca_pmt(state, p_ca_message, hw_buffer)) < 0) {
+			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_PMT_REPLY Failed !");
+			result = -1;
+			goto free_mem_and_exit;
+		}
+		dprintk(verbose, DST_CA_INFO, 1, " -->CA_PMT_REPLY Success !");
+		break;
+	case CA_APP_INFO_ENQUIRY:		// only for debugging
+		dprintk(verbose, DST_CA_INFO, 1, " Getting Cam Application information");
 
-			if ((ca_get_app_info(state)) < 0) {
-				dprintk(verbose, DST_CA_ERROR, 1, " -->CA_APP_INFO_ENQUIRY Failed !");
-				result = -1;
-				goto free_mem_and_exit;
-			}
-			dprintk(verbose, DST_CA_INFO, 1, " -->CA_APP_INFO_ENQUIRY Success !");
-			break;
-		case CA_INFO_ENQUIRY:
-			dprintk(verbose, DST_CA_INFO, 1, " Getting CA Information");
+		if ((ca_get_app_info(state)) < 0) {
+			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_APP_INFO_ENQUIRY Failed !");
+			result = -1;
+			goto free_mem_and_exit;
+		}
+		dprintk(verbose, DST_CA_INFO, 1, " -->CA_APP_INFO_ENQUIRY Success !");
+		break;
+	case CA_INFO_ENQUIRY:
+		dprintk(verbose, DST_CA_INFO, 1, " Getting CA Information");
 
-			if ((ca_get_ca_info(state)) < 0) {
-				dprintk(verbose, DST_CA_ERROR, 1, " -->CA_INFO_ENQUIRY Failed !");
-				result = -1;
-				goto free_mem_and_exit;
-			}
-			dprintk(verbose, DST_CA_INFO, 1, " -->CA_INFO_ENQUIRY Success !");
-			break;
+		if ((ca_get_ca_info(state)) < 0) {
+			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_INFO_ENQUIRY Failed !");
+			result = -1;
+			goto free_mem_and_exit;
 		}
+		dprintk(verbose, DST_CA_INFO, 1, " -->CA_INFO_ENQUIRY Success !");
+		break;
 	}
+
 free_mem_and_exit:
 	kfree (hw_buffer);
 
-- 
2.4.2

