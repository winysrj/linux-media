Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab1JaQZz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:55 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:55 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 13/17] staging: as102: Convert the comments to kernel-doc style
Date: Mon, 31 Oct 2011 17:24:51 +0100
Message-Id: <1320078295-3379-14-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also amend some mismatched comments.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c        |    5 +-
 drivers/staging/media/as102/as10x_cmd.c        |  105 +++++++++++-------------
 drivers/staging/media/as102/as10x_cmd_cfg.c    |   65 +++++++--------
 drivers/staging/media/as102/as10x_cmd_stream.c |   48 +++++------
 4 files changed, 106 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index e1e32be..27a1571 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -331,8 +331,9 @@ static int __init as102_driver_init(void)
 module_init(as102_driver_init);
 
 /**
- * \brief as102 driver exit point. This function is called when device has
- *       to be removed.
+ * as102_driver_exit - as102 driver exit point
+ *
+ * This function is called when device has to be removed.
  */
 static void __exit as102_driver_exit(void)
 {
diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index 77aae39..0dcba80 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -24,11 +24,11 @@
 #include "as10x_cmd.h"
 
 /**
-   \brief  send turn on command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \return 0 when no error, < 0 in case of error.
-  \callgraph
-*/
+ * as10x_cmd_turn_on - send turn on command to AS10x
+ * @phandle:   pointer to AS10x handle
+ *
+ * Return 0 when no error, < 0 in case of error.
+ */
 int as10x_cmd_turn_on(as10x_handle_t *phandle)
 {
 	int error;
@@ -70,11 +70,11 @@ out:
 }
 
 /**
-   \brief  send turn off command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_turn_off - send turn off command to AS10x
+ * @phandle:   pointer to AS10x handle
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_turn_off(as10x_handle_t *phandle)
 {
 	int error;
@@ -115,11 +115,11 @@ out:
 }
 
 /**
-   \brief  send set tune command to AS10x
-   \param  phandle: pointer to AS10x handle
-   \param  ptune:   tune parameters
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
+ * as10x_cmd_set_tune - send set tune command to AS10x
+ * @phandle: pointer to AS10x handle
+ * @ptune:   tune parameters
+ *
+ * Return 0 on success or negative value in case of error.
  */
 int as10x_cmd_set_tune(as10x_handle_t *phandle, struct as10x_tune_args *ptune)
 {
@@ -174,11 +174,11 @@ out:
 }
 
 /**
-   \brief  send get tune status command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \param  pstatus:   pointer to updated status structure of the current tune
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
+ * as10x_cmd_get_tune_status - send get tune status command to AS10x
+ * @phandle: pointer to AS10x handle
+ * @pstatus: pointer to updated status structure of the current tune
+ *
+ * Return 0 on success or negative value in case of error.
  */
 int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
 			      struct as10x_tune_status *pstatus)
@@ -232,11 +232,11 @@ out:
 }
 
 /**
-   \brief  send get TPS command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \param  ptps:      pointer to TPS parameters structure
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
+ * send get TPS command to AS10x
+ * @phandle:   pointer to AS10x handle
+ * @ptps:      pointer to TPS parameters structure
+ *
+ * Return 0 on success or negative value in case of error.
  */
 int as10x_cmd_get_tps(as10x_handle_t *phandle, struct as10x_tps *ptps)
 {
@@ -295,12 +295,12 @@ out:
 }
 
 /**
-   \brief  send get demod stats command to AS10x
-   \param  phandle:       pointer to AS10x handle
-   \param  pdemod_stats:  pointer to demod stats parameters structure
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_get_demod_stats - send get demod stats command to AS10x
+ * @phandle:       pointer to AS10x handle
+ * @pdemod_stats:  pointer to demod stats parameters structure
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
 			      struct as10x_demod_stats *pdemod_stats)
 {
@@ -359,13 +359,13 @@ out:
 }
 
 /**
-   \brief  send get impulse response command to AS10x
-   \param  phandle:        pointer to AS10x handle
-   \param  is_ready:       pointer to value indicating when impulse
-			   response data is ready
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_get_impulse_resp - send get impulse response command to AS10x
+ * @phandle:  pointer to AS10x handle
+ * @is_ready: pointer to value indicating when impulse
+ *	      response data is ready
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_get_impulse_resp(as10x_handle_t     *phandle,
 			       uint8_t *is_ready)
 {
@@ -414,16 +414,12 @@ out:
 	return error;
 }
 
-
-
 /**
-   \brief  build AS10x command header
-   \param  pcmd:     pointer to AS10x command buffer
-   \param  xid:      sequence id of the command
-   \param  cmd_len:  lenght of the command
-   \return -
-   \callgraph
-*/
+ * as10x_cmd_build - build AS10x command header
+ * @pcmd:     pointer to AS10x command buffer
+ * @xid:      sequence id of the command
+ * @cmd_len:  length of the command
+ */
 void as10x_cmd_build(struct as10x_cmd_t *pcmd,
 		     uint16_t xid, uint16_t cmd_len)
 {
@@ -434,13 +430,12 @@ void as10x_cmd_build(struct as10x_cmd_t *pcmd,
 }
 
 /**
-   \brief  Parse command response
-   \param  pcmd:       pointer to AS10x command buffer
-   \param  cmd_seqid:  sequence id of the command
-   \param  cmd_len:    lenght of the command
-   \return 0 when no error, < 0 in case of error
-   \callgraph
-*/
+ * as10x_rsp_parse - Parse command response
+ * @prsp:       pointer to AS10x command buffer
+ * @proc_id:    id of the command
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
 {
 	int error;
@@ -455,5 +450,3 @@ int as10x_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
 
 	return AS10X_CMD_ERROR;
 }
-
-
diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
index dca2cbf..ec6f69f 100644
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ b/drivers/staging/media/as102/as10x_cmd_cfg.c
@@ -27,13 +27,13 @@
 /***************************/
 
 /**
-   \brief  send get context command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \param  tag:       context tag
-   \param  pvalue:    pointer where to store context value read
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_get_context - Send get context command to AS10x
+ * @phandle:   pointer to AS10x handle
+ * @tag:       context tag
+ * @pvalue:    pointer where to store context value read
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_get_context(as10x_handle_t *phandle, uint16_t tag,
 			  uint32_t *pvalue)
 {
@@ -86,13 +86,13 @@ out:
 }
 
 /**
-   \brief  send set context command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \param  tag:       context tag
-   \param  value:     value to set in context
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_set_context - send set context command to AS10x
+ * @phandle:   pointer to AS10x handle
+ * @tag:       context tag
+ * @value:     value to set in context
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
 			  uint32_t value)
 {
@@ -141,17 +141,16 @@ out:
 }
 
 /**
-   \brief  send eLNA change mode command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \param  tag:       context tag
-   \param  mode:      mode selected:
-		     - ON    : 0x0 => eLNA always ON
-		     - OFF   : 0x1 => eLNA always OFF
-		     - AUTO  : 0x2 => eLNA follow hysteresis parameters to be
-				      ON or OFF
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_eLNA_change_mode - send eLNA change mode command to AS10x
+ * @phandle:   pointer to AS10x handle
+ * @mode:      mode selected:
+ *	        - ON    : 0x0 => eLNA always ON
+ *	        - OFF   : 0x1 => eLNA always OFF
+ *	        - AUTO  : 0x2 => eLNA follow hysteresis parameters
+ *				 to be ON or OFF
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode)
 {
 	int error;
@@ -194,14 +193,14 @@ out:
 }
 
 /**
-   \brief  Parse context command response. Since this command does not follow
-	   the common response, a specific parse function is required.
-   \param  prsp:       pointer to AS10x command response buffer
-   \param  proc_id:    id of the command
-   \return 0 when no error, < 0 in case of error.
-	   ABILIS_RC_NOK
-   \callgraph
-*/
+ * as10x_context_rsp_parse - Parse context command response
+ * @prsp:       pointer to AS10x command response buffer
+ * @proc_id:    id of the command
+ *
+ * Since the contex command reponse does not follow the common
+ * response, a specific parse function is required.
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
 {
 	int err;
diff --git a/drivers/staging/media/as102/as10x_cmd_stream.c b/drivers/staging/media/as102/as10x_cmd_stream.c
index e8c668c..045c706 100644
--- a/drivers/staging/media/as102/as10x_cmd_stream.c
+++ b/drivers/staging/media/as102/as10x_cmd_stream.c
@@ -21,15 +21,13 @@
 #include "as102_drv.h"
 #include "as10x_cmd.h"
 
-
 /**
-   \brief  send add filter command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \param  filter:    TSFilter filter for DVB-T
-   \param  pfilter_handle: pointer where to store filter handle
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_add_PID_filter - send add filter command to AS10x
+ * @phandle:   pointer to AS10x handle
+ * @filter:    TSFilter filter for DVB-T
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
 			     struct as10x_ts_filter *filter)
 {
@@ -84,12 +82,12 @@ out:
 }
 
 /**
-   \brief  Send delete filter command to AS10x
-   \param  phandle:       pointer to AS10x handle
-   \param  filter_handle: filter handle
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_del_PID_filter - Send delete filter command to AS10x
+ * @phandle:      pointer to AS10x handle
+ * @pid_value:    PID to delete
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
 			     uint16_t pid_value)
 {
@@ -133,11 +131,11 @@ out:
 }
 
 /**
-   \brief Send start streaming command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_start_streaming - Send start streaming command to AS10x
+ * @phandle:   pointer to AS10x handle
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_start_streaming(as10x_handle_t *phandle)
 {
 	int error;
@@ -179,11 +177,11 @@ out:
 }
 
 /**
-   \brief Send stop streaming command to AS10x
-   \param  phandle:   pointer to AS10x handle
-   \return 0 when no error, < 0 in case of error.
-   \callgraph
-*/
+ * as10x_cmd_stop_streaming - Send stop streaming command to AS10x
+ * @phandle:   pointer to AS10x handle
+ *
+ * Return 0 on success or negative value in case of error.
+ */
 int as10x_cmd_stop_streaming(as10x_handle_t *phandle)
 {
 	int8_t error;
@@ -223,5 +221,3 @@ out:
 	LEAVE();
 	return error;
 }
-
-
-- 
1.7.4.1

