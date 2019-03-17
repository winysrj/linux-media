Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB94C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 930C62087C
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfCQQcV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 12:32:21 -0400
Received: from gofer.mess.org ([88.97.38.141]:46505 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfCQQcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 12:32:21 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 3A9E5601BD; Sun, 17 Mar 2019 16:32:20 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH v4l-utils] libdvbv5: leaks and double free in dvb_fe_open_fname()
Date:   Sun, 17 Mar 2019 16:32:20 +0000
Message-Id: <20190317163220.1881-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

dvb_fe_open_fname() takes ownership of fname if the function succeeds, but
also in two of the error paths (e.g. if the ioctl FE_GET_PROPERTY fails).

Adjust dvb_fe_open_fname() so it copies fname rather than taking ownership
(and passing that to params). This makes the code cleaner.

Signed-off-by: Sean Young <sean@mess.org>
---
 lib/libdvbv5/dvb-dev-local.c |  2 +-
 lib/libdvbv5/dvb-fe.c        | 18 ++++++++----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/lib/libdvbv5/dvb-dev-local.c b/lib/libdvbv5/dvb-dev-local.c
index e98b967a..2de9a614 100644
--- a/lib/libdvbv5/dvb-dev-local.c
+++ b/lib/libdvbv5/dvb-dev-local.c
@@ -467,7 +467,7 @@ static struct dvb_open_descriptor
 			flags &= ~O_NONBLOCK;
 		}
 
-		ret = dvb_fe_open_fname(parms, strdup(dev->path), flags);
+		ret = dvb_fe_open_fname(parms, dev->path, flags);
 		if (ret) {
 			free(open_dev);
 			return NULL;
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 5dcf492e..7f634766 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -133,7 +133,6 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 					  int flags)
 {
 	int ret;
-	char *fname;
 	struct dvb_device *dvb;
 	struct dvb_dev_list *dvb_dev;
 	struct dvb_v5_fe_parms_priv *parms = NULL;
@@ -153,7 +152,6 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 		dvb_dev_free(dvb);
 		return NULL;
 	}
-	fname = strdup(dvb_dev->path);
 
 	if (!strcmp(dvb_dev->bus_addr, "platform:dvbloopback")) {
 		logfunc(LOG_WARNING, _("Detected dvbloopback"));
@@ -161,14 +159,10 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 	}
 
 	dvb_dev_free(dvb);
-	if (!fname) {
-		logfunc(LOG_ERR, _("fname calloc: %s"), strerror(errno));
-		return NULL;
-	}
+
 	parms = calloc(sizeof(*parms), 1);
 	if (!parms) {
 		logfunc(LOG_ERR, _("parms calloc: %s"), strerror(errno));
-		free(fname);
 		return NULL;
 	}
 	parms->p.verbose = verbose;
@@ -183,7 +177,7 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 	if (use_legacy_call)
 		parms->p.legacy_fe = 1;
 
-	ret = dvb_fe_open_fname(parms, fname, flags);
+	ret = dvb_fe_open_fname(parms, dvb_dev->path, flags);
 	if (ret < 0) {
 		dvb_v5_free(parms);
 		return NULL;
@@ -203,7 +197,6 @@ int dvb_fe_open_fname(struct dvb_v5_fe_parms_priv *parms, char *fname,
 	fd = open(fname, flags, 0);
 	if (fd == -1) {
 		dvb_logerr(_("%s while opening %s"), strerror(errno), fname);
-		free(fname);
 		return -errno;
 	}
 
@@ -224,7 +217,12 @@ int dvb_fe_open_fname(struct dvb_v5_fe_parms_priv *parms, char *fname,
 		}
 	}
 
-	parms->fname = fname;
+	parms->fname = strdup(fname);
+	if (!parms->fname) {
+		dvb_logerr(_("fname calloc: %s"), strerror(errno));
+		return -errno;
+	}
+
 	parms->fd = fd;
 	parms->fe_flags = flags;
 	parms->dvb_prop[0].cmd = DTV_API_VERSION;
-- 
2.20.1

