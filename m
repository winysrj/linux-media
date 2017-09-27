Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33174
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751958AbdI0Vkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH v2 11/37] media: dvb_frontend: better document the -EPERM condition
Date: Wed, 27 Sep 2017 18:40:12 -0300
Message-Id: <843a94e803d017f36884ea3a7c26914e18ca7a7d.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two readonly ioctls can't be allowed if the frontend device
is opened in read only mode. Explain why.

Reviewed by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 01bd19fd4c57..2036cf1b7784 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1940,9 +1940,23 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 		return -ENODEV;
 	}
 
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
-	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
-	     cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
+	/*
+	 * If the frontend is opened in read-only mode, only the ioctls
+	 * that don't interfere with the tune logic should be accepted.
+	 * That allows an external application to monitor the DVB QoS and
+	 * statistics parameters.
+	 *
+	 * That matches all _IOR() ioctls, except for two special cases:
+	 *   - FE_GET_EVENT is part of the tuning logic on a DVB application;
+	 *   - FE_DISEQC_RECV_SLAVE_REPLY is part of DiSEqC 2.0
+	 *     setup
+	 * So, those two ioctls should also return -EPERM, as otherwise
+	 * reading from them would interfere with a DVB tune application
+	 */
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY
+	    && (_IOC_DIR(cmd) != _IOC_READ
+		|| cmd == FE_GET_EVENT
+		|| cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
 		up(&fepriv->sem);
 		return -EPERM;
 	}
-- 
2.13.5
