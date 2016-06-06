Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:53070 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbcFFJCL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 05:02:11 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavan Savoy <pavan_savoy@ti.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] drivers: misc: ti-st: Use int instead of fuzzy char for callback status
Date: Mon,  6 Jun 2016 11:02:03 +0200
Message-Id: <1465203723-16928-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On mips and parisc:

    drivers/bluetooth/btwilink.c: In function 'ti_st_open':
    drivers/bluetooth/btwilink.c:174:21: warning: overflow in implicit constant conversion [-Woverflow]
       hst->reg_status = -EINPROGRESS;

    drivers/nfc/nfcwilink.c: In function 'nfcwilink_open':
    drivers/nfc/nfcwilink.c:396:31: warning: overflow in implicit constant conversion [-Woverflow]
      drv->st_register_cb_status = -EINPROGRESS;

There are actually two issues:
  1. Whether "char" is signed or unsigned depends on the architecture.
     As the completion callback data is used to pass a (negative) error
     code, it should always be signed.
  2. EINPROGRESS is 150 on mips, 245 on parisc.
     Hence -EINPROGRESS doesn't fit in a signed 8-bit number.

Change the callback status from "char" to "int" to fix these.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested only.
---
 drivers/bluetooth/btwilink.c              | 4 ++--
 drivers/media/radio/wl128x/fmdrv_common.c | 2 +-
 drivers/misc/ti-st/st_core.c              | 2 +-
 drivers/nfc/nfcwilink.c                   | 4 ++--
 include/linux/ti_wilink_st.h              | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
index 24a652f9252be899..485281b3f1677678 100644
--- a/drivers/bluetooth/btwilink.c
+++ b/drivers/bluetooth/btwilink.c
@@ -51,7 +51,7 @@
  */
 struct ti_st {
 	struct hci_dev *hdev;
-	char reg_status;
+	int reg_status;
 	long (*st_write) (struct sk_buff *);
 	struct completion wait_reg_completion;
 };
@@ -83,7 +83,7 @@ static inline void ti_st_tx_complete(struct ti_st *hst, int pkt_type)
  * status.ti_st_open() function will wait for signal from this
  * API when st_register() function returns ST_PENDING.
  */
-static void st_reg_completion_cb(void *priv_data, char data)
+static void st_reg_completion_cb(void *priv_data, int data)
 {
 	struct ti_st *lhst = priv_data;
 
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 3f9e6df7d837ac27..642b89c66bcb99eb 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1472,7 +1472,7 @@ static long fm_st_receive(void *arg, struct sk_buff *skb)
  * Called by ST layer to indicate protocol registration completion
  * status.
  */
-static void fm_st_reg_comp_cb(void *arg, char data)
+static void fm_st_reg_comp_cb(void *arg, int data)
 {
 	struct fmdev *fmdev;
 
diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index dcdbd58672ccc6d2..00051590e00f9647 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -141,7 +141,7 @@ static void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
  * This function is being called with spin lock held, protocol drivers are
  * only expected to complete their waits and do nothing more than that.
  */
-static void st_reg_complete(struct st_data_s *st_gdata, char err)
+static void st_reg_complete(struct st_data_s *st_gdata, int err)
 {
 	unsigned char i = 0;
 	pr_info(" %s ", __func__);
diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index f81e500e765061fd..3fbd18b8e473f696 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -94,7 +94,7 @@ struct nfcwilink {
 	struct nci_dev			*ndev;
 	unsigned long			flags;
 
-	char				st_register_cb_status;
+	int				st_register_cb_status;
 	long				(*st_write) (struct sk_buff *);
 
 	struct completion		completed;
@@ -320,7 +320,7 @@ exit:
 }
 
 /* Called by ST when registration is complete */
-static void nfcwilink_register_complete(void *priv_data, char data)
+static void nfcwilink_register_complete(void *priv_data, int data)
 {
 	struct nfcwilink *drv = priv_data;
 
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 0a0d56834c8eb412..f2293028ab9d65e6 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -71,7 +71,7 @@ struct st_proto_s {
 	enum proto_type type;
 	long (*recv) (void *, struct sk_buff *);
 	unsigned char (*match_packet) (const unsigned char *data);
-	void (*reg_complete_cb) (void *, char data);
+	void (*reg_complete_cb) (void *, int data);
 	long (*write) (struct sk_buff *skb);
 	void *priv_data;
 
-- 
1.9.1

