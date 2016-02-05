Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbcBEPRi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 10:17:38 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 07559804E4
	for <linux-media@vger.kernel.org>; Fri,  5 Feb 2016 15:17:37 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH xawtv3 2/2] xawtv: Allow setting alsa_latency from ~/.xawtv
Date: Fri,  5 Feb 2016 16:17:30 +0100
Message-Id: <1454685450-30470-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1454685450-30470-1-git-send-email-hdegoede@redhat.com>
References: <1454685450-30470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This avoids the need to always have to specify this on the cmdline on
systems which need a value different from the default.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 man/xawtvrc.5 |  5 +++++
 x11/xt.c      | 16 +++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/man/xawtvrc.5 b/man/xawtvrc.5
index 136ceba..f1c3333 100644
--- a/man/xawtvrc.5
+++ b/man/xawtvrc.5
@@ -209,6 +209,11 @@ details.
 .TP
 .B filter = name
 Enable the specified filter.
+.TP
+.B alsa_latency = time_in_ms
+This can be used to specify the latency for the ALSA digital sound loopback
+which xawtv does. The default is 30ms if you're getting sound dropouts on your
+system try increasing this setting.
 .SS The [launch] section
 You can start other programs from within xawtv.  This is configured
 with entries in the "[launch]" section:
diff --git a/x11/xt.c b/x11/xt.c
index 2065ff4..9affb4a 100644
--- a/x11/xt.c
+++ b/x11/xt.c
@@ -65,6 +65,10 @@
 
 /*----------------------------------------------------------------------*/
 
+#define ALSA_LATENCY_DEFAULT 30
+#define STR(X) __STR(X)
+#define __STR(X) #X
+
 XtAppContext      app_context;
 Widget            app_shell, tv;
 Widget            on_shell;
@@ -167,7 +171,7 @@ XtResource args_desc[] = {
 	"alsa_latency",
 	XtCValue, XtRInt, sizeof(int),
 	XtOffset(struct ARGS*,alsa_latency),
-	XtRString, "30"
+	XtRString, STR(ALSA_LATENCY_DEFAULT)
     },{
 	/* Integer */
 	"debug",
@@ -1414,9 +1418,15 @@ static void x11_mute_notify(int val)
 {
     if (val)
 	alsa_thread_stop();
-    else if (!alsa_thread_is_running())
+    else if (!alsa_thread_is_running()) {
+        if (args.readconfig && args.alsa_latency == ALSA_LATENCY_DEFAULT) {
+            int val = cfg_get_int("global", "alsa_latency");
+            if (val > 0)
+                args.alsa_latency = val;
+        }
 	alsa_thread_startup(alsa_out, alsa_cap, args.alsa_latency,
 			    stderr, debug);
+    }
 }
 #endif
 
@@ -1698,7 +1708,7 @@ usage(void)
 	    "      -(no)alsa       enable/disable alsa streaming. Default: enabled\n"
 	    "      -(no)alsa-cap   manually specify an alsa capture interface\n"
 	    "      -(no)alsa-pb    manually specify an alsa playback interface\n"
-	    "      -alsa-latency   manually specify an alsa latency in ms. Default: 30\n"
+	    "      -alsa-latency   manually specify an alsa latency in ms. Default: " STR(ALSA_LATENCY_DEFAULT) "\n"
 #endif
 	    "  -b  -bpp n          color depth of the display is n (n=24,32)\n"
 	    "  -o  -outfile file   filename base for snapshots\n"
-- 
2.5.0

