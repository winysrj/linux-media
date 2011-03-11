Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1CKUNl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 15:13:41 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2BKDfwX030563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 15:13:41 -0500
Received: from pedra (vpn-228-17.phx2.redhat.com [10.3.228.17])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p2BKCclm009816
	for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 15:13:40 -0500
Date: Fri, 11 Mar 2011 17:08:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] cpia2: Fix some gcc 4.6 warnings when debug is
 disabled
Message-ID: <20110311170828.1563022e@pedra>
In-Reply-To: <07bc26366f39bab1838da48068df633d6a714f4b.1299874085.git.mchehab@redhat.com>
References: <07bc26366f39bab1838da48068df633d6a714f4b.1299874085.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

cpia2_core.c:529:14: warning: variable 'dir' set but not used [-Wunused-but-set-variable]
cpia2_core.c:526:5: warning: variable 'block_index' set but not used [-Wunused-but-set-variable]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/video/cpia2/cpia2_core.c
index aaffca8..ee91e29 100644
--- a/drivers/media/video/cpia2/cpia2_core.c
+++ b/drivers/media/video/cpia2/cpia2_core.c
@@ -519,22 +519,16 @@ int cpia2_do_command(struct camera_data *cam,
  *  cpia2_send_command
  *
  *****************************************************************************/
+
+#define DIR(cmd) ((cmd->direction == TRANSFER_WRITE) ? "Write" : "Read")
+#define BINDEX(cmd) (cmd->req_mode & 0x03)
+
 int cpia2_send_command(struct camera_data *cam, struct cpia2_command *cmd)
 {
 	u8 count;
 	u8 start;
-	u8 block_index;
 	u8 *buffer;
 	int retval;
-	const char* dir;
-
-	if (cmd->direction == TRANSFER_WRITE) {
-		dir = "Write";
-	} else {
-		dir = "Read";
-	}
-
-	block_index = cmd->req_mode & 0x03;
 
 	switch (cmd->req_mode & 0x0c) {
 	case CAMERAACCESS_TYPE_RANDOM:
@@ -542,32 +536,32 @@ int cpia2_send_command(struct camera_data *cam, struct cpia2_command *cmd)
 		start = 0;
 		buffer = (u8 *) & cmd->buffer;
 		if (debugs_on & DEBUG_REG)
-			DBG("%s Random: Register block %s\n", dir,
-			    block_name[block_index]);
+			DBG("%s Random: Register block %s\n", DIR(cmd),
+			    block_name[BINDEX(cmd)]);
 		break;
 	case CAMERAACCESS_TYPE_BLOCK:
 		count = cmd->reg_count;
 		start = cmd->start;
 		buffer = cmd->buffer.block_data;
 		if (debugs_on & DEBUG_REG)
-			DBG("%s Block: Register block %s\n", dir,
-			    block_name[block_index]);
+			DBG("%s Block: Register block %s\n", DIR(cmd),
+			    block_name[BINDEX(cmd)]);
 		break;
 	case CAMERAACCESS_TYPE_MASK:
 		count = cmd->reg_count * sizeof(struct cpia2_reg_mask);
 		start = 0;
 		buffer = (u8 *) & cmd->buffer;
 		if (debugs_on & DEBUG_REG)
-			DBG("%s Mask: Register block %s\n", dir,
-			    block_name[block_index]);
+			DBG("%s Mask: Register block %s\n", DIR(cmd),
+			    block_name[BINDEX(cmd)]);
 		break;
 	case CAMERAACCESS_TYPE_REPEAT:	/* For patch blocks only */
 		count = cmd->reg_count;
 		start = cmd->start;
 		buffer = cmd->buffer.block_data;
 		if (debugs_on & DEBUG_REG)
-			DBG("%s Repeat: Register block %s\n", dir,
-			    block_name[block_index]);
+			DBG("%s Repeat: Register block %s\n", DIR(cmd),
+			    block_name[BINDEX(cmd)]);
 		break;
 	default:
 		LOG("%s: invalid request mode\n",__func__);
@@ -584,10 +578,10 @@ int cpia2_send_command(struct camera_data *cam, struct cpia2_command *cmd)
 		for (i = 0; i < cmd->reg_count; i++) {
 			if((cmd->req_mode & 0x0c) == CAMERAACCESS_TYPE_BLOCK)
 				KINFO("%s Block: [0x%02X] = 0x%02X\n",
-				    dir, start + i, buffer[i]);
+				    DIR(cmd), start + i, buffer[i]);
 			if((cmd->req_mode & 0x0c) == CAMERAACCESS_TYPE_RANDOM)
 				KINFO("%s Random: [0x%02X] = 0x%02X\n",
-				    dir, cmd->buffer.registers[i].index,
+				    DIR(cmd), cmd->buffer.registers[i].index,
 				    cmd->buffer.registers[i].value);
 		}
 	}
-- 
1.7.1

