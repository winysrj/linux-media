Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44590 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755339AbbKCU6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 15:58:47 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [v4l-utils 2/5] utils: Properly use ENABLE_NLS for locale related code
Date: Tue,  3 Nov 2015 21:58:37 +0100
Message-Id: <1446584320-25016-3-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various tools in utils/ use ENABLE_NLS to decide whether locale
support is available or not, and only include <locale.h> if ENABLE_NLS
is defined. However, they unconditionally use functions defined in
<locale.h> such as setlocale(), bindtextdomain() or textdomain(),
which causes build failures when the prototypes of such functions are
not available due to <locale.h> not being included.

In order to fix this, we add ENABLE_NLS conditionals around the calls
to these functions.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 utils/dvb/dvb-fe-tool.c        | 2 ++
 utils/dvb/dvb-format-convert.c | 2 ++
 utils/dvb/dvbv5-scan.c         | 2 ++
 utils/dvb/dvbv5-zap.c          | 2 ++
 utils/keytable/keytable.c      | 2 ++
 5 files changed, 10 insertions(+)

diff --git a/utils/dvb/dvb-fe-tool.c b/utils/dvb/dvb-fe-tool.c
index efc2ebf..ba01aa9 100644
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
index be1586d..1bb0ced 100644
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
index 2812166..848259b 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -758,9 +758,11 @@ int main(int argc, char **argv)
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
index 63938b9..3922ad2 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -1467,9 +1467,11 @@ int main(int argc, char *argv[])
 	static struct sysfs_names *names;
 	struct rc_device	  rc_dev;
 
+#ifdef ENABLE_NLS
 	setlocale (LC_ALL, "");
 	bindtextdomain (PACKAGE, LOCALEDIR);
 	textdomain (PACKAGE);
+#endif
 
 	argp_parse(&argp, argc, argv, ARGP_NO_HELP | ARGP_NO_EXIT, 0, 0);
 
-- 
2.6.2

