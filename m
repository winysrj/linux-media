Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:16 -0500
Received: by faao14 with SMTP id o14so4498582faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:15 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 01/13] staging: as102: Remove comment tags for editors configuration
Date: Sun,  6 Nov 2011 21:31:38 +0100
Message-Id: <1320611510-3326-2-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Piotr Chmura <chmooreck@poczta.onet.pl>

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c     |    2 --
 drivers/staging/media/as102/as102_drv.h     |    2 --
 drivers/staging/media/as102/as102_fe.c      |    2 --
 drivers/staging/media/as102/as102_fw.c      |    2 --
 drivers/staging/media/as102/as102_fw.h      |    2 --
 drivers/staging/media/as102/as102_usb_drv.c |    2 --
 drivers/staging/media/as102/as102_usb_drv.h |    1 -
 drivers/staging/media/as102/as10x_cmd.h     |    1 -
 8 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index d335c7d..771d550 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -347,5 +347,3 @@ module_exit(as102_driver_exit);
 MODULE_DESCRIPTION(DRIVER_FULL_NAME);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pierrick Hascoet <pierrick.hascoet@abilis.com>");
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index bcda635..7f56f64 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -137,5 +137,3 @@ void as102_dvb_unregister(struct as102_dev_t *dev);
 
 int as102_dvb_register_fe(struct as102_dev_t *dev, struct dvb_frontend *fe);
 int as102_dvb_unregister_fe(struct dvb_frontend *dev);
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 3550f90..7d7dd55 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -599,5 +599,3 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 			as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
 	}
 }
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index c019df9..4fb2987 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -247,5 +247,3 @@ error:
 	return errno;
 }
 #endif
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_fw.h b/drivers/staging/media/as102/as102_fw.h
index 27e5347..951a1fa 100644
--- a/drivers/staging/media/as102/as102_fw.h
+++ b/drivers/staging/media/as102/as102_fw.h
@@ -38,5 +38,3 @@ struct as10x_fw_pkt_t {
 #ifdef __KERNEL__
 int as102_fw_upload(struct as102_bus_adapter_t *bus_adap);
 #endif
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 264be2d..0a8f12b 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -474,5 +474,3 @@ static int as102_release(struct inode *inode, struct file *file)
 }
 
 MODULE_DEVICE_TABLE(usb, as102_usb_id_table);
-
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index fb1fc41..35925b7 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -56,4 +56,3 @@ struct as10x_usb_token_cmd_t {
 	struct as10x_cmd_t r;
 };
 #endif
-/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
index 01a7163..6f837b1 100644
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ b/drivers/staging/media/as102/as10x_cmd.h
@@ -537,4 +537,3 @@ int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
 }
 #endif
 #endif
-/* EOF - vim: set textwidth=80 ts=3 sw=3 sts=3 et: */
-- 
1.7.5.4

