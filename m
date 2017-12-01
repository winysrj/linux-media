Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:40460 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbdLAMbr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 07:31:47 -0500
Received: by mail-pf0-f193.google.com with SMTP id v26so4592013pfl.7
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 04:31:46 -0800 (PST)
From: Jaedon Shin <jaedon.shin@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>
Subject: [PATCH 3/3] media: dvb_frontend: Add commands implementation for compat ioct
Date: Fri,  1 Dec 2017 21:31:30 +0900
Message-Id: <20171201123130.23128-4-jaedon.shin@gmail.com>
In-Reply-To: <20171201123130.23128-1-jaedon.shin@gmail.com>
References: <20171201123130.23128-1-jaedon.shin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dtv_properties structure and the dtv_property structure are
different sizes in 32-bit and 64-bit system. This patch provides
FE_SET_PROPERTY and FE_GET_PROPERTY ioctl commands implementation for
32-bit user space applications.

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 131 ++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 1ae23403a0ab..f3751a573dfe 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1976,9 +1976,140 @@ static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
 }
 
 #ifdef CONFIG_COMPAT
+struct compat_dtv_property {
+	__u32 cmd;
+	__u32 reserved[3];
+	union {
+		__u32 data;
+		struct dtv_fe_stats st;
+		struct {
+			__u8 data[32];
+			__u32 len;
+			__u32 reserved1[3];
+			compat_uptr_t reserved2;
+		} buffer;
+	} u;
+	int result;
+} __attribute__ ((packed));
+
+struct compat_dtv_properties {
+	__u32 num;
+	compat_uptr_t props;
+};
+
+#define COMPAT_FE_SET_PROPERTY	   _IOW('o', 82, struct compat_dtv_properties)
+#define COMPAT_FE_GET_PROPERTY	   _IOR('o', 83, struct compat_dtv_properties)
+
+static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
+					    unsigned long arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int i, err = 0;
+
+	if (cmd == COMPAT_FE_SET_PROPERTY) {
+		struct compat_dtv_properties prop, *tvps = NULL;
+		struct compat_dtv_property *tvp = NULL;
+
+		if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
+			return -EFAULT;
+
+		tvps = &prop;
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_set(fe, file,
+							(tvp + i)->cmd,
+							(tvp + i)->u.data);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		kfree(tvp);
+	} else if (cmd == COMPAT_FE_GET_PROPERTY) {
+		struct compat_dtv_properties prop, *tvps = NULL;
+		struct compat_dtv_property *tvp = NULL;
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
+
+		if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
+			return -EFAULT;
+
+		tvps = &prop;
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		/*
+		 * Let's use our own copy of property cache, in order to
+		 * avoid mangling with DTV zigzag logic, as drivers might
+		 * return crap, if they don't check if the data is available
+		 * before updating the properties cache.
+		 */
+		if (fepriv->state != FESTATE_IDLE) {
+			err = dtv_get_frontend(fe, &getp, NULL);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_get(
+			    fe, &getp, (struct dtv_property *)tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+
+		if (copy_to_user((void __user *)compat_ptr(tvps->props), tvp,
+				 tvps->num * sizeof(struct compat_dtv_property))) {
+			kfree(tvp);
+			return -EFAULT;
+		}
+		kfree(tvp);
+	}
+
+	return err;
+}
+
 static long dvb_frontend_compat_ioctl(struct file *file, unsigned int cmd,
 				      unsigned long arg)
 {
+	struct dvb_device *dvbdev = file->private_data;
+	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int err;
+
+	if (cmd == COMPAT_FE_SET_PROPERTY || cmd == COMPAT_FE_GET_PROPERTY) {
+		if (down_interruptible(&fepriv->sem))
+			return -ERESTARTSYS;
+
+		err = dvb_frontend_handle_compat_ioctl(file, cmd, arg);
+
+		up(&fepriv->sem);
+		return err;
+	}
+
 	return dvb_frontend_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 }
 #endif
-- 
2.15.0
