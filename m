Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab3CUNCz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:02:55 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LD2tgt009610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 09:02:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/6] siano: Fix the remaining checkpatch.pl compliants
Date: Thu, 21 Mar 2013 10:02:42 -0300
Message-Id: <1363870963-28552-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all other remaining checkpatch.pl compliants on the Siano driver,
except for the 80-cols (soft) limit. Those are harder to fix, and
probably not worth to do right now.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c     | 15 +++++++--------
 drivers/media/common/siano/smscoreapi.h     |  4 ----
 drivers/media/common/siano/smsdvb-debugfs.c |  7 ++-----
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 19e7a5f..e7fc4de 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -57,8 +57,8 @@ struct smscore_client_t {
 	struct list_head entry;
 	struct smscore_device_t *coredev;
 	void			*context;
-	struct list_head 	idlist;
-	onresponse_t	onresponse_handler;
+	struct list_head	idlist;
+	onresponse_t		onresponse_handler;
 	onremove_t		onremove_handler;
 };
 
@@ -874,7 +874,7 @@ int smscore_configure_board(struct smscore_device_t *coredev)
  * sets initial device mode and notifies client hotplugs that device is ready
  *
  * @param coredev pointer to a coredev object returned by
- * 		  smscore_register_device
+ *		  smscore_register_device
  *
  * @return 0 on success, <0 on error.
  */
@@ -961,7 +961,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 	while (size && rc >= 0) {
 		struct sms_data_download *data_msg =
 			(struct sms_data_download *) msg;
-		int payload_size = min((int) size, SMS_MAX_PAYLOAD_SIZE);
+		int payload_size = min_t(int, size, SMS_MAX_PAYLOAD_SIZE);
 
 		SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_DATA_DOWNLOAD_REQ,
 			     (u16)(sizeof(struct sms_msg_hdr) +
@@ -1225,8 +1225,7 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 		if (num_buffers == coredev->num_buffers)
 			break;
 		if (++retry > 10) {
-			sms_info("exiting although "
-				 "not all buffers released.");
+			sms_info("exiting although not all buffers released.");
 			break;
 		}
 
@@ -1279,8 +1278,8 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 				coredev, msg, msg->msg_length,
 				&coredev->version_ex_done);
 			if (rc < 0)
-				sms_err("MSG_SMS_GET_VERSION_EX_REQ failed "
-					"second try, rc %d", rc);
+				sms_err("MSG_SMS_GET_VERSION_EX_REQ failed second try, rc %d",
+					rc);
 		} else
 			rc = -ETIME;
 	}
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index d3e781f..d0799e3 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -40,10 +40,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #define kmutex_trylock(_p_) mutex_trylock(_p_)
 #define kmutex_unlock(_p_) mutex_unlock(_p_)
 
-#ifndef min
-#define min(a, b) (((a) < (b)) ? (a) : (b))
-#endif
-
 /*
  * Define the firmware names used by the driver.
  * Those should match what's used at smscoreapi.c and sms-cards.c
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index a881da5..4c5691e 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -112,7 +112,7 @@ void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
 		      "burst_cycle_time = %d\n", p->burst_cycle_time);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "calc_burst_cycle_time = %d\n",
-	              p->calc_burst_cycle_time);
+		      p->calc_burst_cycle_time);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "num_of_rows = %d\n", p->num_of_rows);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
@@ -509,8 +509,6 @@ void smsdvb_debugfs_release(struct smsdvb_client_t *client)
 	if (!client->debugfs)
 		return;
 
-printk("%s\n", __func__);
-
 	client->prt_dvb_stats     = NULL;
 	client->prt_isdb_stats    = NULL;
 	client->prt_isdb_stats_ex = NULL;
@@ -548,7 +546,6 @@ int smsdvb_debugfs_register(void)
 
 void smsdvb_debugfs_unregister(void)
 {
-	if (smsdvb_debugfs_usb_root)
-		debugfs_remove_recursive(smsdvb_debugfs_usb_root);
+	debugfs_remove_recursive(smsdvb_debugfs_usb_root);
 	smsdvb_debugfs_usb_root = NULL;
 }
-- 
1.8.1.4

