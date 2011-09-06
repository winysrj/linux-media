Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab1IFPaO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:14 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 04/10] Properly document alsa mixer
Date: Tue,  6 Sep 2011 12:29:50 -0300
Message-Id: <1315322996-10576-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-3-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
 <1315322996-10576-2-git-send-email-mchehab@redhat.com>
 <1315322996-10576-3-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Backported from Fedora:

commit 16ee4edaccd1a6a6869e4abf07581a2f7c6df1fb
Author: Tomas Smetana <tsmetana@fedoraproject.org>
Date:   Thu Jul 9 07:09:44 2009 +0000

    - fix a typo in the default config file

commit a4c64442a7c94cd175bca661e88682ee8de87ce4
Author: Tomas Smetana <tsmetana@fedoraproject.org>
Date:   Sun Jun 28 10:01:27 2009 +0000

    - try to document the new ALSA mixer settings, make ALSA mixer the default
        one

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 docs/html/default.tvtime.xml |    8 +++++---
 docs/man/en/tvtime.xml.5     |    5 ++++-
 src/tvtimeconf.c             |   18 +++++++++++-------
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/docs/html/default.tvtime.xml b/docs/html/default.tvtime.xml
index 29d939a..bc71d10 100644
--- a/docs/html/default.tvtime.xml
+++ b/docs/html/default.tvtime.xml
@@ -116,13 +116,15 @@
   <option name="VBIDevice" value="/dev/vbi0"/>
 
   <!--
-    This sets the mixer device and channel to use.  The format is device
-    name:channel name.  Valid channels are:
+    This sets the mixer device and channel to use.  The format for OSS
+    is device name:channel name.  Valid OSS channels are:
       vol, bass, treble, synth, pcm, speaker, line, mic, cd, mix, pcm2,
       rec, igain, ogain, line1, line2, line3, dig1, dig2, dig3, phin,
       phout, video, radio, monitor
+    The format for ALSA mixer is device/channel (e.g., "default/Line"
+    or "hw:0/CD")
    -->
-  <option name="MixerDevice" value="/dev/mixer:line"/>
+   <option name="MixerDevice" value="default/Line"/>
 
   <!--
     This option enables 16:9 aspect ratio mode by default on startup.
diff --git a/docs/man/en/tvtime.xml.5 b/docs/man/en/tvtime.xml.5
index 2fa6b61..08ec5df 100644
--- a/docs/man/en/tvtime.xml.5
+++ b/docs/man/en/tvtime.xml.5
@@ -234,7 +234,10 @@ This sets which device to use for VBI decoding.
 .TP
 <option name="MixerDevice" value="/dev/mixer:line"/>
 This sets the mixer device and channel to use.  The format is device
-name:channel name.  Valid channels are:
+name:channel name for OSS mixer (e.g., "/dev/mixer:Line") or device/channel
+for ALSA (e.g., "hw:0/CD").
+
+Valid OSS channels are:
 
 .nh
 .IR vol ", " bass ", " treble ", " synth ", " pcm ", " speaker ", "
diff --git a/src/tvtimeconf.c b/src/tvtimeconf.c
index 5db6325..375686f 100644
--- a/src/tvtimeconf.c
+++ b/src/tvtimeconf.c
@@ -643,9 +643,11 @@ static void print_usage( char **argv )
     lfputs( _("  -l, --xmltvlanguage=LANG   Use XMLTV data in given language, if available.\n"), stderr );
     lfputs( _("  -v, --verbose              Print debugging messages to stderr.\n"), stderr );
     lfputs( _("  -X, --display=DISPLAY      Use the given X display to connect to.\n"), stderr );
-    lfputs( _("  -x, --mixer=DEVICE[:CH]    The mixer device and channel to control.\n"
-              "                             (defaults to /dev/mixer:line)\n\n"
-              "                             Valid channels are:\n"
+    lfputs( _("  -x, --mixer=<DEVICE[:CH]>|<DEVICE/CH>\n"
+              "                             The mixer device and channel to control. The first\n"
+              "                             variant sets the OSS mixer the second one ALSA.\n"
+              "                             (defaults to default/Line)\n\n"
+              "                             Valid channels for OSS are:\n"
               "                                 vol, bass, treble, synth, pcm, speaker, line,\n"
               "                                 mic, cd, mix, pcm2, rec, igain, ogain, line1,\n"
               "                                 line2, line3, dig1, dig2, dig3, phin, phout,\n"
@@ -691,9 +693,11 @@ static void print_config_usage( char **argv )
     lfputs( _("  -R, --priority=PRI         Sets the process priority to run tvtime at.\n"), stderr );
     lfputs( _("  -t, --xmltv=FILE           Read XMLTV listings from the given file.\n"), stderr );
     lfputs( _("  -l, --xmltvlanguage=LANG   Use XMLTV data in given language, if available.\n"), stderr );
-    lfputs( _("  -x, --mixer=DEVICE[:CH]    The mixer device and channel to control.\n"
-              "                             (defaults to /dev/mixer:line)\n\n"
-              "                             Valid channels are:\n"
+    lfputs( _("  -x, --mixer=<DEVICE[:CH]>|<DEVICE/CH>\n"
+              "                             The mixer device and channel to control. The first\n"
+              "                             variant sets the OSS mixer the second one ALSA.\n"
+              "                             (defaults to default/Line)\n\n"
+              "                             Valid channels for OSS are:\n"
               "                                 vol, bass, treble, synth, pcm, speaker, line,\n"
               "                                 mic, cd, mix, pcm2, rec, igain, ogain, line1,\n"
               "                                 line2, line3, dig1, dig2, dig3, phin, phout,\n"
@@ -786,7 +790,7 @@ config_t *config_new( void )
 
     ct->uid = getuid();
 
-    ct->mixerdev = strdup( "/dev/mixer:line" );
+    ct->mixerdev = strdup( "default/Line" );
 
     ct->deinterlace_method = strdup( "GreedyH" );
     ct->check_freq_present = 1;
-- 
1.7.6.1

