Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:03 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id F2F7DC00124C
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:02 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 10/17] mixer: Silence mixer probe errors
Date: Sat, 13 Feb 2016 19:47:31 +0100
Message-Id: <1455389258-13470-10-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On most systems now a days we end up using digital loopback and do not
have a valid mixer config, silence mixer error spew on startup.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/mixer-alsa.c | 34 ++++++++++++++++++++++------------
 src/mixer-oss.c  | 12 ++++++++----
 src/mixer.c      |  4 ++--
 src/mixer.h      |  2 +-
 4 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/src/mixer-alsa.c b/src/mixer-alsa.c
index a549899..e84a3d0 100644
--- a/src/mixer-alsa.c
+++ b/src/mixer-alsa.c
@@ -33,24 +33,28 @@ static snd_mixer_elem_t *elem = NULL;
 
 static long alsa_min, alsa_max, alsa_vol;
 
-static void alsa_open_mixer( void )
+static void alsa_open_mixer( int verbose )
 {
     int err;
     static snd_mixer_selem_id_t *sid = NULL;
     if ((err = snd_mixer_open (&handle, 0)) < 0) {
-        fprintf(stderr, "mixer: open error: %s\n", snd_strerror(err));
+        if (verbose)
+            fprintf(stderr, "mixer: open error: %s\n", snd_strerror(err));
         return;
     }
     if ((err = snd_mixer_attach (handle, card)) < 0) {
-        fprintf(stderr, "mixer: attach error: %s\n", snd_strerror(err));
+        if (verbose)
+            fprintf(stderr, "mixer: attach error: %s\n", snd_strerror(err));
         goto error;
     }
     if ((err = snd_mixer_selem_register (handle, NULL, NULL)) < 0) {
-        fprintf(stderr, "mixer: register error: %s\n", snd_strerror(err));
+        if (verbose)
+            fprintf(stderr, "mixer: register error: %s\n", snd_strerror(err));
         goto error;
     }
     if ((err = snd_mixer_load (handle)) < 0) {
-        fprintf(stderr, "mixer: load error: %s\n", snd_strerror(err));
+        if (verbose)
+            fprintf(stderr, "mixer: load error: %s\n", snd_strerror(err));
         goto error;
     }
     snd_mixer_selem_id_malloc(&sid);
@@ -58,16 +62,20 @@ static void alsa_open_mixer( void )
         goto error;
     snd_mixer_selem_id_set_name(sid, channel);
     if (!(elem = snd_mixer_find_selem(handle, sid))) {
-        fprintf(stderr, "mixer: unable to find mixer for channel %s\n", channel);
+        if (verbose)
+            fprintf(stderr, "mixer: unable to find mixer for channel %s\n",
+                    channel);
         goto error;
     }
     if (!snd_mixer_selem_has_playback_volume(elem)) {
-        fprintf(stderr, "mixer: no playback\n");
+        if (verbose)
+            fprintf(stderr, "mixer: no playback\n");
         goto error;
     }
     snd_mixer_selem_get_playback_volume_range(elem, &alsa_min, &alsa_max);
     if ((alsa_max - alsa_min) <= 0) {
-        fprintf(stderr, "mixer: no valid playback range\n");
+        if (verbose)
+            fprintf(stderr, "mixer: no valid playback range\n");
         goto error;
     }
     snd_mixer_selem_id_free(sid);
@@ -174,7 +182,7 @@ static int alsa_ismute( void )
     return muted;
 }
 
-static int alsa_set_device( const char *devname )
+static int alsa_set_device( const char *devname, int verbose )
 {
     int i;
 
@@ -189,10 +197,12 @@ static int alsa_set_device( const char *devname )
         card[i] = 0;
         channel = card + i + 1;
     }
-    alsa_open_mixer();
+    alsa_open_mixer( verbose );
     if (!handle) {
-        fprintf( stderr, "mixer: Can't open mixer %s (channel %s), "
-                 "mixer volume and mute unavailable.\n", card, channel );
+        if( verbose ) {
+            fprintf( stderr, "mixer: Can't open mixer %s (channel %s), "
+                     "mixer volume and mute unavailable.\n", card, channel );
+        }
         return -1;
     }
     return 0;
diff --git a/src/mixer-oss.c b/src/mixer-oss.c
index 08aa0ca..f2441fe 100644
--- a/src/mixer-oss.c
+++ b/src/mixer-oss.c
@@ -181,7 +181,7 @@ static int oss_ismute( void )
 
 static char *oss_core_devnames[] = SOUND_DEVICE_NAMES;
 
-static int oss_set_device( const char *devname )
+static int oss_set_device( const char *devname, int verbose )
 {
     const char *channame;
     int found = 0;
@@ -198,8 +198,10 @@ static int oss_set_device( const char *devname )
         channame = mixer_device + i + 1;
     }
     if( !file_is_openable_for_read( mixer_device ) ) {
-        fprintf( stderr, "mixer: Can't open device %s, "
-                 "mixer volume and mute unavailable.\n", mixer_device );
+        if( verbose ) {
+            fprintf( stderr, "mixer: Can't open device %s, "
+                     "mixer volume and mute unavailable.\n", mixer_device );
+        }
         return -1;
     }
 
@@ -212,7 +214,9 @@ static int oss_set_device( const char *devname )
         }
     }
     if( !found ) {
-        fprintf( stderr, "mixer: No such mixer channel '%s', using channel 'line'.\n", channame );
+        if( verbose ) {
+            fprintf( stderr, "mixer: No such mixer channel '%s'.\n", channame );
+        }
         return -1;
     }
     mixer_dev_mask = 1 << mixer_channel;
diff --git a/src/mixer.c b/src/mixer.c
index 5356d2b..c87df3a 100644
--- a/src/mixer.c
+++ b/src/mixer.c
@@ -29,7 +29,7 @@
 /**
  * Sets the mixer device and channel.
  */
-static int null_set_device( const char *devname )
+static int null_set_device( const char *devname, int verbose )
 {
     return 0;
 }
@@ -159,7 +159,7 @@ void mixer_init( config_t *cfg, const char *v4ldev )
         mixer = mixers[i];
         if (!mixer)
             continue;
-        if (mixer->set_device(devname) == 0)
+        if( mixer->set_device( devname, config_get_verbose( cfg ) ) == 0 )
             break;
     }
 
diff --git a/src/mixer.h b/src/mixer.h
index f51f481..9b6f67b 100644
--- a/src/mixer.h
+++ b/src/mixer.h
@@ -40,7 +40,7 @@ struct mixer {
 /**
  * Sets the mixer device and channel.
  */
-int (* set_device)( const char *devname );
+int (* set_device)( const char *devname, int verbose );
 
 /**
  * Sets the initial state of the mixer device.
-- 
2.5.0

