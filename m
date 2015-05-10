Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:33740 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbbEJK6c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2015 06:58:32 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 1ED4325A3DC9
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:58:31 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3ll2SQ6hPbz5vND
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:58:30 +0200 (CEST)
Date: Sun, 10 May 2015 12:58:19 +0200
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] Compile without ENABLE_NLS
Message-ID: <20150510105819.GD27779@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 utils/dvb/dvb-fe-tool.c        | 2 ++
 utils/dvb/dvb-format-convert.c | 2 ++
 utils/dvb/dvbv5-scan.c         | 2 ++
 utils/dvb/dvbv5-zap.c          | 2 ++
 utils/keytable/keytable.c      | 2 ++
 5 files changed, 10 insertions(+)

diff --git a/utils/dvb/dvb-fe-tool.c b/utils/dvb/dvb-fe-tool.c
index d4c7778..151fdef 100644
--- a/utils/dvb/dvb-fe-tool.c
+++ b/utils/dvb/dvb-fe-tool.c
@@ -276,9 +276,11 @@ int main(int argc, char *argv[])
 	struct dvb_v5_fe_parms *parms;
 	int fe_flags = O_RDWR;
 
+#ifdef ENABLE_NLS
 	setlocale (LC_ALL, "");
 	bindtextdomain (PACKAGE, LOCALEDIR);
 	textdomain (PACKAGE);
+#endif
 
 	argp_parse(&argp, argc, argv, ARGP_NO_HELP | ARGP_NO_EXIT, 0, 0);
 
diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
index e39df03..09451d4 100644
--- a/utils/dvb/dvb-format-convert.c
+++ b/utils/dvb/dvb-format-convert.c
@@ -132,9 +132,11 @@ int main(int argc, char **argv)
 		.args_doc = N_("<input file> <output file>"),
 	};
 
+#ifdef ENABLE_NLS
 	setlocale (LC_ALL, "");
 	bindtextdomain (PACKAGE, LOCALEDIR);
 	textdomain (PACKAGE);
+#endif
 
 	memset(&args, 0, sizeof(args));
 	argp_parse(&argp, argc, argv, ARGP_NO_HELP | ARGP_NO_EXIT, &idx, &args);
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 1bd1bcf..9858070 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -461,9 +461,11 @@ int main(int argc, char **argv)
 		.args_doc = N_("<initial file>"),
 	};
 
+#ifdef ENABLE_NLS
 	setlocale (LC_ALL, "");
 	bindtextdomain (PACKAGE, LOCALEDIR);
 	textdomain (PACKAGE);
+#endif
 
 	memset(&args, 0, sizeof(args));
 	args.sat_number = -1;
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 9fd0798..387aacc 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -754,9 +754,11 @@ int main(int argc, char **argv)
 		.args_doc = N_("<channel name> [or <frequency> if in monitor mode]"),
 	};
 
+#ifdef ENABLE_NLS
 	setlocale (LC_ALL, "");
 	bindtextdomain (PACKAGE, LOCALEDIR);
 	textdomain (PACKAGE);
+#endif
 
 	memset(&args, 0, sizeof(args));
 	args.sat_number = -1;
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index dcbfd83..501fd7a 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -1571,9 +1571,11 @@ int main(int argc, char *argv[])
 	static struct sysfs_names *names;
 	struct rc_device	  rc_dev;
 
+#ifdef ENABLE_NLS
 	setlocale (LC_ALL, "");
 	bindtextdomain (PACKAGE, LOCALEDIR);
 	textdomain (PACKAGE);
+#endif
 
 	argp_parse(&argp, argc, argv, ARGP_NO_HELP | ARGP_NO_EXIT, 0, 0);
 
-- 
2.3.6
