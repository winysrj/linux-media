Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35698
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751098AbdISNmr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 09:42:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 5/6] media: dvb_frontend: better document the -EPERM condition
Date: Tue, 19 Sep 2017 10:42:37 -0300
Message-Id: <347ca7486c6c33f4229c6dc182cdde73b7e8879e.1505827883.git.mchehab@s-opensource.com>
In-Reply-To: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
In-Reply-To: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two readonly ioctls can't be allowed if the frontend device
is opened in read only mode. Explain why.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index d0a17d67ab1b..db3f8c597a24 100644
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
+	 * that don't interfere at the tune logic should be accepted.
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
