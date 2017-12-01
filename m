Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36009 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbdLAMbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 07:31:44 -0500
Received: by mail-pf0-f195.google.com with SMTP id p84so4592044pfd.3
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 04:31:44 -0800 (PST)
From: Jaedon Shin <jaedon.shin@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>
Subject: [PATCH 2/3] media: dvb_frontend: Add compat_ioctl callback
Date: Fri,  1 Dec 2017 21:31:29 +0900
Message-Id: <20171201123130.23128-3-jaedon.shin@gmail.com>
In-Reply-To: <20171201123130.23128-1-jaedon.shin@gmail.com>
References: <20171201123130.23128-1-jaedon.shin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds compat_ioctl for 32-bit user space applications on a 64-bit system.

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 11 +++++++++++
 fs/compat_ioctl.c                     | 17 -----------------
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6d8f4dd39c0c..1ae23403a0ab 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1975,6 +1975,14 @@ static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
 	return dvb_usercopy(file, cmd, arg, dvb_frontend_do_ioctl);
 }
 
+#ifdef CONFIG_COMPAT
+static long dvb_frontend_compat_ioctl(struct file *file, unsigned int cmd,
+				      unsigned long arg)
+{
+	return dvb_frontend_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2657,6 +2665,9 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= dvb_frontend_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= dvb_frontend_compat_ioctl,
+#endif
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5fc5dc660600..9a1fe60cce9a 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1218,23 +1218,6 @@ COMPATIBLE_IOCTL(DMX_SET_PES_FILTER)
 COMPATIBLE_IOCTL(DMX_SET_BUFFER_SIZE)
 COMPATIBLE_IOCTL(DMX_GET_PES_PIDS)
 COMPATIBLE_IOCTL(DMX_GET_STC)
-COMPATIBLE_IOCTL(FE_GET_INFO)
-COMPATIBLE_IOCTL(FE_DISEQC_RESET_OVERLOAD)
-COMPATIBLE_IOCTL(FE_DISEQC_SEND_MASTER_CMD)
-COMPATIBLE_IOCTL(FE_DISEQC_RECV_SLAVE_REPLY)
-COMPATIBLE_IOCTL(FE_DISEQC_SEND_BURST)
-COMPATIBLE_IOCTL(FE_SET_TONE)
-COMPATIBLE_IOCTL(FE_SET_VOLTAGE)
-COMPATIBLE_IOCTL(FE_ENABLE_HIGH_LNB_VOLTAGE)
-COMPATIBLE_IOCTL(FE_READ_STATUS)
-COMPATIBLE_IOCTL(FE_READ_BER)
-COMPATIBLE_IOCTL(FE_READ_SIGNAL_STRENGTH)
-COMPATIBLE_IOCTL(FE_READ_SNR)
-COMPATIBLE_IOCTL(FE_READ_UNCORRECTED_BLOCKS)
-COMPATIBLE_IOCTL(FE_SET_FRONTEND)
-COMPATIBLE_IOCTL(FE_GET_FRONTEND)
-COMPATIBLE_IOCTL(FE_GET_EVENT)
-COMPATIBLE_IOCTL(FE_DISHNETWORK_SEND_LEGACY_CMD)
 COMPATIBLE_IOCTL(VIDEO_STOP)
 COMPATIBLE_IOCTL(VIDEO_PLAY)
 COMPATIBLE_IOCTL(VIDEO_FREEZE)
-- 
2.15.0
