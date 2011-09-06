Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1IFPaN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:13 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 03/10] Backport mixer-alsa patch from Fedora
Date: Tue,  6 Sep 2011 12:29:49 -0300
Message-Id: <1315322996-10576-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-2-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
 <1315322996-10576-2-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit e53212e85a71d831fff3bf61c792ed7235fa3a79
Author: Tomas Smetana <tsmetana@fedoraproject.org>
Date:   Mon May 11 16:24:09 2009 +0000

    Added first version of the ALSA mixer patch. Unused yet.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 configure.ac     |   12 ++-
 src/Makefile.am  |   15 ++-
 src/commands.c   |    8 +-
 src/mixer-alsa.c |  240 +++++++++++++++++++++++++++++++++++++++++++++++
 src/mixer-oss.c  |  261 +++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mixer.c      |  272 +++++++++++++++---------------------------------------
 src/mixer.h      |   31 +++++--
 src/tvtime.c     |   10 +-
 src/videoinput.c |    6 +-
 9 files changed, 628 insertions(+), 227 deletions(-)
 create mode 100644 src/mixer-alsa.c
 create mode 100644 src/mixer-oss.c

diff --git a/configure.ac b/configure.ac
index eac6c20..6cdedfb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -76,18 +76,26 @@ dnl ---------------------------------------------
 dnl libxml2
 dnl ---------------------------------------------
 dnl Test for libxml2
-
 AC_PATH_PROG(LIBXML2_CONFIG,xml2-config,no)
 if test "$LIBXML2_CONFIG" = "no" ; then
 	AC_MSG_ERROR(libxml2 needed and xml2-config not found)
 else
 	XML2_LIBS="`$LIBXML2_CONFIG --libs`"
 	XML2_FLAG="`$LIBXML2_CONFIG --cflags`"
-	AC_DEFINE(HAVE_LIBXML2,,[LIBXML2 support])	
+	AC_DEFINE(HAVE_LIBXML2,,[LIBXML2 support])
 fi
 AC_SUBST(XML2_LIBS)
 AC_SUBST(XML2_FLAG)
 
+dnl ---------------------------------------------
+dnl libasound2
+dnl ---------------------------------------------
+dnl Test for ALSA
+AM_PATH_ALSA(1.0.9,
+	[ AC_DEFINE(HAVE_ALSA,1,[Define this if you have Alsa (libasound) installed]) ],
+	AC_MSG_RESULT(libasound needed and not found))
+AM_CONDITIONAL(HAVE_ALSA, test x"$no_alsa" != "yes")
+
 
 dnl ---------------------------------------------
 dnl asound
diff --git a/src/Makefile.am b/src/Makefile.am
index 3a38aac..56e26a6 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -29,6 +29,11 @@ OPT_CFLAGS = -Wall -pedantic -I. -DDATADIR="\"$(pkgdatadir)\"" \
 	-DCONFDIR="\"$(pkgsysconfdir)\"" -DFIFODIR="\"$(tmpdir)\"" \
 	-D_LARGEFILE64_SOURCE -DLOCALEDIR="\"$(localedir)\""
 
+if HAVE_ALSA
+ALSA_SRCS =	mixer-alsa.c
+else
+ALSA_SRCS =
+endif
 COMMON_SRCS = mixer.c videoinput.c rtctimer.c leetft.c osdtools.c tvtimeconf.c \
 	pngoutput.c tvtimeosd.c input.c cpu_accel.c speedy.c pnginput.c \
 	deinterlace.c videotools.c attributes.h deinterlace.h leetft.h \
@@ -40,7 +45,7 @@ COMMON_SRCS = mixer.c videoinput.c rtctimer.c leetft.c osdtools.c tvtimeconf.c \
 	utils.h utils.c pulldown.h pulldown.c hashtable.h hashtable.c \
 	cpuinfo.h cpuinfo.c menu.c menu.h \
 	outputfilter.h outputfilter.c xmltv.h xmltv.c gettext.h tvtimeglyphs.h \
-	copyfunctions.h copyfunctions.c alsa_stream.c
+	copyfunctions.h copyfunctions.c alsa_stream.c mixer-oss.c $(ALSA_SRCS)
 
 if ARCH_X86
 DSCALER_SRCS = $(top_srcdir)/plugins/dscalerapi.h \
@@ -74,10 +79,10 @@ bin_PROGRAMS = tvtime tvtime-command tvtime-configure tvtime-scanner
 
 tvtime_SOURCES = $(COMMON_SRCS) $(OUTPUT_SRCS) $(PLUGIN_SRCS) tvtime.c
 tvtime_CFLAGS = $(TTF_CFLAGS) $(PNG_CFLAGS) $(OPT_CFLAGS) \
-	$(PLUGIN_CFLAGS) $(X11_CFLAGS) $(XML2_FLAG) \
+	$(PLUGIN_CFLAGS) $(X11_CFLAGS) $(XML2_FLAG) $(ALSA_CFLAGS) \
 	$(FONT_CFLAGS) $(AM_CFLAGS)
 tvtime_LDFLAGS  = $(TTF_LIBS) $(ZLIB_LIBS) $(PNG_LIBS) \
-	$(X11_LIBS) $(XML2_LIBS) $(ASOUND_LIBS) -lm -lstdc++
+	$(X11_LIBS) $(XML2_LIBS) $(ALSA_LIBS) -lm -lstdc++
 
 tvtime_command_SOURCES = utils.h utils.c tvtimeconf.h tvtimeconf.c \
 	tvtime-command.c
@@ -90,6 +95,6 @@ tvtime_configure_LDFLAGS  = $(ZLIB_LIBS) $(XML2_LIBS)
 tvtime_scanner_SOURCES = utils.h utils.c videoinput.h videoinput.c \
 	tvtimeconf.h tvtimeconf.c station.h station.c tvtime-scanner.c \
 	mixer.h mixer.c
-tvtime_scanner_CFLAGS = $(OPT_CFLAGS) $(XML2_FLAG) $(AM_CFLAGS)
-tvtime_scanner_LDFLAGS  = $(ZLIB_LIBS) $(XML2_LIBS)
+tvtime_scanner_CFLAGS = $(OPT_CFLAGS) $(XML2_FLAG) $(ALSA_CFLAGS) $(AM_CFLAGS)
+tvtime_scanner_LDFLAGS  = $(ZLIB_LIBS) $(XML2_LIBS) $(ALSA_LIBS)
 
diff --git a/src/commands.c b/src/commands.c
index 964cab7..9141276 100644
--- a/src/commands.c
+++ b/src/commands.c
@@ -3012,10 +3012,10 @@ void commands_handle( commands_t *cmd, int tvtime_cmd, const char *arg )
         break;
 
     case TVTIME_MIXER_TOGGLE_MUTE:
-        mixer_mute( !mixer_ismute() );
+        mixer->mute( !mixer->ismute() );
 
         if( cmd->osd ) {
-            tvtime_osd_show_data_bar( cmd->osd, _("Volume"), (mixer_get_volume()) & 0xff );
+            tvtime_osd_show_data_bar( cmd->osd, _("Volume"), (mixer->get_volume()) & 0xff );
         }
         break;
 
@@ -3029,9 +3029,9 @@ void commands_handle( commands_t *cmd, int tvtime_cmd, const char *arg )
         /* Check to see if an argument was passed, if so, use it. */
         if (atoi(arg) > 0) {
             int perc = atoi(arg);
-            volume = mixer_set_volume( ( (tvtime_cmd == TVTIME_MIXER_UP) ? perc : -perc ) );
+            volume = mixer->set_volume( ( (tvtime_cmd == TVTIME_MIXER_UP) ? perc : -perc ) );
         } else {
-            volume = mixer_set_volume( ( (tvtime_cmd == TVTIME_MIXER_UP) ? 1 : -1 ) );
+            volume = mixer->set_volume( ( (tvtime_cmd == TVTIME_MIXER_UP) ? 1 : -1 ) );
         }
 
         if( cmd->osd ) {
diff --git a/src/mixer-alsa.c b/src/mixer-alsa.c
new file mode 100644
index 0000000..635d44c
--- /dev/null
+++ b/src/mixer-alsa.c
@@ -0,0 +1,240 @@
+/**
+ * Copyright (C) 2006 Philipp Hahn <pmhahn@users.sourceforge.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <stdio.h>
+#include <sys/types.h>
+#include <string.h>
+#include <math.h>
+#include <alsa/asoundlib.h>
+#include "utils.h"
+#include "mixer.h"
+
+static const char alsa_core_devnames[] = "default";
+static char *card, *channel;
+static int muted = 0;
+static int mutecount = 0;
+static snd_mixer_t *handle = NULL;
+static snd_mixer_elem_t *elem = NULL;
+
+static long alsa_min, alsa_max, alsa_vol;
+
+static void alsa_open_mixer( void )
+{
+    int err;
+    static snd_mixer_selem_id_t *sid = NULL;
+    if ((err = snd_mixer_open (&handle, 0)) < 0) {
+        fprintf(stderr, "mixer: open error: %s\n", snd_strerror(err));
+        return;
+    }
+    if ((err = snd_mixer_attach (handle, card)) < 0) {
+        fprintf(stderr, "mixer: attach error: %s\n", snd_strerror(err));
+        goto error;
+    }
+    if ((err = snd_mixer_selem_register (handle, NULL, NULL)) < 0) {
+        fprintf(stderr, "mixer: register error: %s\n", snd_strerror(err));
+        goto error;
+    }
+    if ((err = snd_mixer_load (handle)) < 0) {
+        fprintf(stderr, "mixer: load error: %s\n", snd_strerror(err));
+        goto error;
+    }
+    snd_mixer_selem_id_malloc(&sid);
+    if (sid == NULL)
+        goto error;
+    snd_mixer_selem_id_set_name(sid, channel);
+    if (!(elem = snd_mixer_find_selem(handle, sid))) {
+        fprintf(stderr, "mixer: find error: %s\n", snd_strerror(err));
+        goto error;
+    }
+    if (!snd_mixer_selem_has_playback_volume(elem)) {
+        fprintf(stderr, "mixer: no playback\n");
+        goto error;
+    }
+    snd_mixer_selem_get_playback_volume_range(elem, &alsa_min, &alsa_max);
+    if ((alsa_max - alsa_min) <= 0) {
+        fprintf(stderr, "mixer: no valid playback range\n");
+        goto error;
+    }
+    snd_mixer_selem_id_free(sid);
+    return;
+
+error:
+    if (sid)
+        snd_mixer_selem_id_free(sid);
+    if (handle) {
+        snd_mixer_close(handle);
+        handle = NULL;
+    }
+    return;
+}
+
+/* Volume saved to file */
+static int alsa_get_unmute_volume( void )
+{
+    long val;
+    assert (elem);
+
+    if (snd_mixer_selem_is_playback_mono(elem)) {
+        snd_mixer_selem_get_playback_volume(elem, SND_MIXER_SCHN_MONO, &val);
+        return val;
+    } else {
+        int c, n = 0;
+        long sum = 0;
+        for (c = 0; c <= SND_MIXER_SCHN_LAST; c++) {
+            if (snd_mixer_selem_has_playback_channel(elem, c)) {
+                snd_mixer_selem_get_playback_volume(elem, SND_MIXER_SCHN_FRONT_LEFT, &val);
+                sum += val;
+                n++;
+            }
+        }
+        if (! n) {
+            return 0;
+        }
+
+        val = sum / n;
+        sum = (long)((double)(alsa_vol * (alsa_max - alsa_min)) / 100. + 0.5);
+
+        if (sum != val) {
+           alsa_vol = (long)(((val * 100.) / (alsa_max - alsa_min)) + 0.5);
+        }
+        return alsa_vol;
+    }
+}
+
+static int alsa_get_volume( void )
+{
+    if (muted)
+        return 0;
+    else
+        return alsa_get_unmute_volume();
+}
+
+static int alsa_set_volume( int percentdiff )
+{
+    long volume;
+
+    alsa_get_volume();
+
+    alsa_vol += percentdiff;
+    if( alsa_vol > 100 ) alsa_vol = 100;
+    if( alsa_vol < 0 ) alsa_vol = 0;
+
+    volume = (long)((alsa_vol * (alsa_max - alsa_min) / 100.) + 0.5);
+
+    snd_mixer_selem_set_playback_volume_all(elem, volume + alsa_min);
+    snd_mixer_selem_set_playback_switch_all(elem, 1);
+    muted = 0;
+    mutecount = 0;
+
+    return alsa_vol;
+}
+
+static void alsa_mute( int mute )
+{
+    /**
+     * Make sure that if multiple users mute the card,
+     * we only honour the last one.
+     */
+    if( !mute && mutecount ) mutecount--;
+    if( mutecount ) return;
+
+    if( mute ) {
+        mutecount++;
+        muted = 1;
+        if (snd_mixer_selem_has_playback_switch(elem))
+            snd_mixer_selem_set_playback_switch_all(elem, 0);
+        else
+            fprintf(stderr, "mixer: mute not implemented\n");
+    } else {
+        muted = 0;
+        if (snd_mixer_selem_has_playback_switch(elem))
+            snd_mixer_selem_set_playback_switch_all(elem, 1);
+        else
+            fprintf(stderr, "mixer: mute not implemented\n");
+    }
+}
+
+static int alsa_ismute( void )
+{
+    return muted;
+}
+
+static int alsa_set_device( const char *devname )
+{
+    int i;
+
+    if (card) free(card);
+    card = strdup( devname );
+    if( !card ) return -1;
+
+    i = strcspn( card, "/" );
+    if( i == strlen( card ) ) {
+        channel = "Line";
+    } else {
+        card[i] = 0;
+        channel = card + i + 1;
+    }
+    alsa_open_mixer();
+    if (!handle) {
+        fprintf( stderr, "mixer: Can't open mixer %s, "
+                 "mixer volume and mute unavailable.\n", card );
+        return -1;
+    }
+    return 0;
+}
+
+static void alsa_set_state( int ismuted, int unmute_volume )
+{
+    /**
+     * 1. we come back unmuted: Don't touch anything
+     * 2. we don't have a saved volume: Don't touch anything
+     * 3. we come back muted and we have a saved volume:
+     *    - if tvtime muted it, unmute to old volume
+     *    - if user did it, remember that we're muted and old volume
+     */
+    if( alsa_get_volume() == 0 && unmute_volume > 0 ) {
+        snd_mixer_selem_set_playback_volume_all(elem, unmute_volume);
+        muted = 1;
+
+        if( !ismuted ) {
+            alsa_mute( 0 );
+        }
+    }
+}
+
+static void alsa_close_device( void )
+{
+    elem = NULL;
+    if (handle)
+        snd_mixer_close(handle);
+    handle = NULL;
+    muted = 0;
+    mutecount = 0;
+}
+
+struct mixer alsa_mixer = {
+    .set_device = alsa_set_device,
+    .set_state = alsa_set_state,
+    .get_volume = alsa_get_volume,
+    .get_unmute_volume = alsa_get_unmute_volume,
+    .set_volume = alsa_set_volume,
+    .mute = alsa_mute,
+    .ismute = alsa_ismute,
+    .close_device = alsa_close_device,
+};
+// vim: ts=4 sw=4 et foldmethod=marker
diff --git a/src/mixer-oss.c b/src/mixer-oss.c
new file mode 100644
index 0000000..08aa0ca
--- /dev/null
+++ b/src/mixer-oss.c
@@ -0,0 +1,261 @@
+/**
+ * Copyright (C) 2002, 2003 Doug Bell <drbell@users.sourceforge.net>
+ *
+ * Some mixer routines from mplayer, http://mplayer.sourceforge.net.
+ * Copyright (C) 2000-2002. by A'rpi/ESP-team & others
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <stdio.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/soundcard.h>
+#include <sys/mman.h>
+#include <string.h>
+#include "utils.h"
+#include "mixer.h"
+
+static char *mixer_device = "/dev/mixer";
+static int saved_volume = (50 << 8 & 0xFF00) | (50 & 0x00FF);
+static int mixer_channel = SOUND_MIXER_LINE;
+static int mixer_dev_mask = 1 << SOUND_MIXER_LINE;
+static int muted = 0;
+static int mutecount = 0;
+static int fd = -1;
+
+static int oss_get_volume( void )
+{
+    int v, cmd, devs;
+    int curvol = 0;
+
+    if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
+    if( fd != -1 ) {
+
+        ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
+        if( devs & mixer_dev_mask ) {
+            cmd = MIXER_READ( mixer_channel );
+        } else {
+            return curvol;
+        }
+
+        ioctl( fd, cmd, &v );
+        curvol = ( v & 0xFF00 ) >> 8;
+    }
+
+    return curvol;
+}
+
+static int oss_get_unmute_volume( void )
+{
+    if( muted ) {
+        return saved_volume;
+    } else {
+        int v, cmd, devs;
+
+        if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
+        if( fd != -1 ) {
+
+            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
+            if( devs & mixer_dev_mask ) {
+                cmd = MIXER_READ( mixer_channel );
+            } else {
+                return -1;
+            }
+
+            ioctl( fd, cmd, &v );
+            return v;
+        }
+    }
+
+    return -1;
+}
+
+static int oss_set_volume( int percentdiff )
+{
+    int v, cmd, devs, levelpercentage;
+
+    levelpercentage = oss_get_volume();
+
+    levelpercentage += percentdiff;
+    if( levelpercentage > 100 ) levelpercentage = 100;
+    if( levelpercentage < 0 ) levelpercentage = 0;
+
+    if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
+    if( fd != -1 ) {
+        ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
+        if( devs & mixer_dev_mask ) {
+            cmd = MIXER_WRITE( mixer_channel );
+        } else {
+            return 0;
+        }
+
+        v = ( levelpercentage << 8 ) | levelpercentage;
+        ioctl( fd, cmd, &v );
+        muted = 0;
+        mutecount = 0;
+        return v;
+    }
+
+    return 0;
+}
+
+static void oss_mute( int mute )
+{
+    int v, cmd, devs;
+
+    /**
+     * Make sure that if multiple users mute the card,
+     * we only honour the last one.
+     */
+    if( !mute && mutecount ) mutecount--;
+    if( mutecount ) return;
+
+    if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
+
+    if( mute ) {
+        mutecount++;
+        if( fd != -1 ) {
+
+            /* Save volume */
+            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
+            if( devs & mixer_dev_mask ) {
+                cmd = MIXER_READ( mixer_channel );
+            } else {
+                return;
+            }
+
+            ioctl( fd,cmd,&v );
+            saved_volume = v;
+
+            /* Now set volume to 0 */
+            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
+            if( devs & mixer_dev_mask ) {
+                cmd = MIXER_WRITE( mixer_channel );
+            } else {
+                return;
+            }
+
+            v = 0;
+            ioctl( fd, cmd, &v );
+
+            muted = 1;
+            return;
+        }
+    } else {
+        if( fd != -1 ) {
+            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
+            if( devs & mixer_dev_mask ) {
+                cmd = MIXER_WRITE( mixer_channel );
+            } else {
+                return;
+            }
+
+            v = saved_volume;
+            ioctl( fd, cmd, &v );
+            muted = 0;
+            return;
+        }
+    }
+}
+
+static int oss_ismute( void )
+{
+    return muted;
+}
+
+static char *oss_core_devnames[] = SOUND_DEVICE_NAMES;
+
+static int oss_set_device( const char *devname )
+{
+    const char *channame;
+    int found = 0;
+    int i;
+
+    mixer_device = strdup( devname );
+    if( !mixer_device ) return -1;
+
+    i = strcspn( mixer_device, ":" );
+    if( i == strlen( mixer_device ) ) {
+        channame = "line";
+    } else {
+        mixer_device[ i ] = 0;
+        channame = mixer_device + i + 1;
+    }
+    if( !file_is_openable_for_read( mixer_device ) ) {
+        fprintf( stderr, "mixer: Can't open device %s, "
+                 "mixer volume and mute unavailable.\n", mixer_device );
+        return -1;
+    }
+
+    mixer_channel = SOUND_MIXER_LINE;
+    for( i = 0; i < SOUND_MIXER_NRDEVICES; i++ ) {
+        if( !strcasecmp( channame, oss_core_devnames[ i ] ) ) {
+            mixer_channel = i;
+            found = 1;
+            break;
+        }
+    }
+    if( !found ) {
+        fprintf( stderr, "mixer: No such mixer channel '%s', using channel 'line'.\n", channame );
+        return -1;
+    }
+    mixer_dev_mask = 1 << mixer_channel;
+    return 0;
+}
+
+static void oss_set_state( int ismuted, int unmute_volume )
+{
+    /**
+     * 1. we come back unmuted: Don't touch anything
+     * 2. we don't have a saved volume: Don't touch anything
+     * 3. we come back muted and we have a saved volume:
+     *    - if tvtime muted it, unmute to old volume
+     *    - if user did it, remember that we're muted and old volume
+     */
+    if( oss_get_volume() == 0 && unmute_volume > 0 ) {
+        saved_volume = unmute_volume;
+        muted = 1;
+
+        if( !ismuted ) {
+            oss_mute( 0 );
+        }
+    }
+}
+
+static void oss_close_device( void )
+{
+    if( fd >= 0 ) close( fd );
+    saved_volume = (50 << 8 & 0xFF00) | (50 & 0x00FF);
+    mixer_channel = SOUND_MIXER_LINE;
+    mixer_dev_mask = 1 << SOUND_MIXER_LINE;
+    muted = 0;
+    mutecount = 0;
+    fd = -1;
+}
+
+struct mixer oss_mixer = {
+    .set_device = oss_set_device,
+    .set_state = oss_set_state,
+    .get_volume = oss_get_volume,
+    .get_unmute_volume = oss_get_unmute_volume,
+    .set_volume = oss_set_volume,
+    .mute = oss_mute,
+    .ismute = oss_ismute,
+    .close_device = oss_close_device,
+};
diff --git a/src/mixer.c b/src/mixer.c
index bd2e5d9..901ef78 100644
--- a/src/mixer.c
+++ b/src/mixer.c
@@ -19,230 +19,104 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <stdio.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/ioctl.h>
-#include <sys/soundcard.h>
-#include <sys/mman.h>
-#include <string.h>
-#include "utils.h"
 #include "mixer.h"
 
-static char *mixer_device = "/dev/mixer";
-static int saved_volume = (50 << 8 & 0xFF00) | (50 & 0x00FF);
-static int mixer_channel = SOUND_MIXER_LINE;
-static int mixer_dev_mask = 1 << SOUND_MIXER_LINE;
-static int muted = 0;
-static int mutecount = 0;
-static int fd = -1;
-
-int mixer_get_volume( void )
+/**
+ * Sets the mixer device and channel.
+ */
+static int null_set_device( const char *devname )
 {
-    int v, cmd, devs;
-    int curvol = 0;
-
-    if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
-    if( fd != -1 ) {
-
-        ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
-        if( devs & mixer_dev_mask ) {
-            cmd = MIXER_READ( mixer_channel );
-        } else {
-            return curvol;
-        }
-
-        ioctl( fd, cmd, &v );
-        curvol = ( v & 0xFF00 ) >> 8;
-    }
-
-    return curvol;
+    return 0;
 }
 
-int mixer_get_unmute_volume( void )
+/**
+ * Sets the initial state of the mixer device.
+ */
+static void null_set_state( int ismuted, int unmute_volume )
 {
-    if( muted ) {
-        return saved_volume;
-    } else {
-        int v, cmd, devs;
-
-        if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
-        if( fd != -1 ) {
-
-            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
-            if( devs & mixer_dev_mask ) {
-                cmd = MIXER_READ( mixer_channel );
-            } else {
-                return -1;
-            }
-
-            ioctl( fd, cmd, &v );
-            return v;
-        }
-    }
-
-    return -1;
 }
 
-int mixer_set_volume( int percentdiff )
+/**
+ * Returns the current volume setting.
+ */
+static int null_get_volume( void )
 {
-    int v, cmd, devs, levelpercentage;
-
-    levelpercentage = mixer_get_volume();
-
-    levelpercentage += percentdiff;
-    if( levelpercentage > 100 ) levelpercentage = 100;
-    if( levelpercentage < 0 ) levelpercentage = 0;
-
-    if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
-    if( fd != -1 ) {
-        ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
-        if( devs & mixer_dev_mask ) {
-            cmd = MIXER_WRITE( mixer_channel );
-        } else {
-            return 0;
-        }
-
-        v = ( levelpercentage << 8 ) | levelpercentage;
-        ioctl( fd, cmd, &v );
-        muted = 0;
-        mutecount = 0;
-        return v;
-    }
-
     return 0;
 }
 
-void mixer_mute( int mute )
+/**
+ * Returns the volume that would be used to restore the unmute state.
+ */
+static int null_get_unmute_volume( void )
 {
-    int v, cmd, devs;
-
-    /**
-     * Make sure that if multiple users mute the card,
-     * we only honour the last one.
-     */
-    if( !mute && mutecount ) mutecount--;
-    if( mutecount ) return;
-
-    if( fd < 0 ) fd = open( mixer_device, O_RDONLY );
-
-    if( mute ) {
-        mutecount++;
-        if( fd != -1 ) {
-
-            /* Save volume */
-            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
-            if( devs & mixer_dev_mask ) {
-                cmd = MIXER_READ( mixer_channel );
-            } else {
-                return;
-            }
-
-            ioctl( fd,cmd,&v );
-            saved_volume = v;
-
-            /* Now set volume to 0 */
-            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
-            if( devs & mixer_dev_mask ) {
-                cmd = MIXER_WRITE( mixer_channel );
-            } else {
-                return;
-            }
+    return 0;
+}
 
-            v = 0;
-            ioctl( fd, cmd, &v );
+/**
+ * Tunes the relative volume.
+ */
+static int null_set_volume( int percentdiff )
+{
+    return 0;
+}
 
-            muted = 1;
-            return;
-        }
-    } else {
-        if( fd != -1 ) {
-            ioctl( fd, SOUND_MIXER_READ_DEVMASK, &devs );
-            if( devs & mixer_dev_mask ) {
-                cmd = MIXER_WRITE( mixer_channel );
-            } else {
-                return;
-            }
+/**
+ * Sets the mute state.
+ */
+static void null_mute( int mute )
+{
+}
 
-            v = saved_volume;
-            ioctl( fd, cmd, &v );
-            muted = 0;
-            return;
-        }
-    }
+/**
+ * Returns true if the mixer is muted.
+ */
+static int null_ismute( void )
+{
+    return 0;
 }
 
-int mixer_ismute( void )
+/**
+ * Closes the mixer device if it is open.
+ */
+static void null_close_device( void )
 {
-    return muted;
 }
 
-static char *oss_core_devnames[] = SOUND_DEVICE_NAMES;
+/* The null device, which always works. */
+static struct mixer null_mixer = {
+    .set_device = null_set_device,
+    .set_state = null_set_state,
+    .get_volume = null_get_volume,
+    .get_unmute_volume = null_get_unmute_volume,
+    .set_volume = null_set_volume,
+    .mute = null_mute,
+    .ismute = null_ismute,
+    .close_device = null_close_device,
+};
+
+/* List of all available access methods.
+ * Uses weak symbols: NULL is not linked in. */
+static struct mixer *mixers[] = {
+    &alsa_mixer,
+    &oss_mixer,
+    &null_mixer /* LAST */
+};
+/* The actual access method. */
+struct mixer *mixer = &null_mixer;
 
+/**
+ * Sets the mixer device and channel.
+ * Try each access method until one succeeds.
+ */
 void mixer_set_device( const char *devname )
 {
-    const char *channame;
-    int found = 0;
     int i;
-
-    mixer_device = strdup( devname );
-    if( !mixer_device ) return;
-
-    i = strcspn( mixer_device, ":" );
-    if( i == strlen( mixer_device ) ) {
-        channame = "line";
-    } else {
-        mixer_device[ i ] = 0;
-        channame = mixer_device + i + 1;
-    }
-    if( !file_is_openable_for_read( mixer_device ) ) {
-        fprintf( stderr, "mixer: Can't open device %s, "
-                 "mixer volume and mute unavailable.\n", mixer_device );
-    }
-
-    mixer_channel = SOUND_MIXER_LINE;
-    for( i = 0; i < SOUND_MIXER_NRDEVICES; i++ ) {
-        if( !strcasecmp( channame, oss_core_devnames[ i ] ) ) {
-            mixer_channel = i;
-            found = 1;
+    mixer->close_device();
+    for (i = 0; i < sizeof(mixers)/sizeof(mixers[0]); i++) {
+        mixer = mixers[i];
+        if (!mixer)
+            continue;
+        if (mixer->set_device(devname) == 0)
             break;
-        }
-    }
-    if( !found ) {
-        fprintf( stderr, "mixer: No such mixer channel '%s', using channel 'line'.\n", channame );
-    }
-    mixer_dev_mask = 1 << mixer_channel;
-}
-
-void mixer_set_state( int ismuted, int unmute_volume )
-{
-    /**
-     * 1. we come back unmuted: Don't touch anything
-     * 2. we don't have a saved volume: Don't touch anything
-     * 3. we come back muted and we have a saved volume:
-     *    - if tvtime muted it, unmute to old volume
-     *    - if user did it, remember that we're muted and old volume
-     */
-    if( mixer_get_volume() == 0 && unmute_volume > 0 ) {
-        saved_volume = unmute_volume;
-        muted = 1;
-
-        if( !ismuted ) {
-            mixer_mute( 0 );
-        }
     }
 }
-
-void mixer_close_device( void )
-{
-    if( fd >= 0 ) close( fd );
-    saved_volume = (50 << 8 & 0xFF00) | (50 & 0x00FF);
-    mixer_channel = SOUND_MIXER_LINE;
-    mixer_dev_mask = 1 << SOUND_MIXER_LINE;
-    muted = 0;
-    mutecount = 0;
-    fd = -1;
-}
-
diff --git a/src/mixer.h b/src/mixer.h
index 07923f4..a26fc88 100644
--- a/src/mixer.h
+++ b/src/mixer.h
@@ -27,45 +27,58 @@ extern "C" {
 #endif
 
 /**
- * Sets the mixer device and channel.  The device name is of the form
- * devicename:channelname.  The default is /dev/mixer:line.
+ * Sets the mixer device and channel.
+ * All interfaces are scanned until one succeeds.
  */
 void mixer_set_device( const char *devname );
 
+struct mixer {
+/**
+ * Sets the mixer device and channel.
+ */
+int (* set_device)( const char *devname );
+
 /**
  * Sets the initial state of the mixer device.
  */
-void mixer_set_state( int ismuted, int unmute_volume );
+void (* set_state)( int ismuted, int unmute_volume );
 
 /**
  * Returns the current volume setting.
  */
-int mixer_get_volume( void );
+int (* get_volume)( void );
 
 /**
  * Returns the volume that would be used to restore the unmute state.
  */
-int mixer_get_unmute_volume( void );
+int (* get_unmute_volume)( void );
 
 /**
  * Tunes the relative volume.
  */
-int mixer_set_volume( int percentdiff );
+int (* set_volume)( int percentdiff );
 
 /**
  * Sets the mute state.
  */
-void mixer_mute( int mute );
+void (* mute)( int mute );
 
 /**
  * Returns true if the mixer is muted.
  */
-int mixer_ismute( void );
+int (* ismute)( void );
 
 /**
  * Closes the mixer device if it is open.
  */
-void mixer_close_device( void );
+void (* close_device)( void );
+};
+
+#pragma weak alsa_mixer
+extern struct mixer alsa_mixer;
+#pragma weak oss_mixer
+extern struct mixer oss_mixer;
+extern struct mixer *mixer;
 
 #ifdef __cplusplus
 };
diff --git a/src/tvtime.c b/src/tvtime.c
index d9066cc..3d42d53 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -1430,7 +1430,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
 
     /* Set the mixer device. */
     mixer_set_device( config_get_mixer_device( ct ) );
-    mixer_set_state( config_get_muted( ct ), config_get_unmute_volume( ct ) );
+    mixer->set_state( config_get_muted( ct ), config_get_unmute_volume( ct ) );
 
     /* Setup OSD stuff. */
     pixel_aspect = ( (double) width ) /
@@ -2555,14 +2555,14 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     snprintf( number, 4, "%d", quiet_screenshots );
     config_save( ct, "QuietScreenshots", number );
 
-    snprintf( number, 6, "%d", mixer_get_unmute_volume() );
+    snprintf( number, 6, "%d", mixer->get_unmute_volume() );
     config_save( ct, "UnmuteVolume", number );
 
-    snprintf( number, 4, "%d", mixer_ismute() );
+    snprintf( number, 4, "%d", mixer->ismute() );
     config_save( ct, "Muted", number );
 
     if( config_get_mute_on_exit( ct ) ) {
-        mixer_mute( 1 );
+        mixer->mute( 1 );
     }
 
     if( vidin ) {
@@ -2599,7 +2599,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     if( osd ) {
         tvtime_osd_delete( osd );
     }
-    mixer_close_device();
+    mixer->close_device();
 
     /* Free temporary memory. */
     free( colourbars );
diff --git a/src/videoinput.c b/src/videoinput.c
index dd60334..2102b04 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -760,7 +760,7 @@ void videoinput_set_tuner_freq( videoinput_t *vidin, int freqKHz )
         }
 
         vidin->change_muted = 1;
-        mixer_mute( 1 );
+        mixer->mute( 1 );
         videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
         vidin->cur_tuner_state = TUNER_STATE_SIGNAL_DETECTED;
         vidin->signal_acquire_wait = SIGNAL_ACQUIRE_DELAY;
@@ -931,7 +931,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
             if( vidin->change_muted ) {
                 vidin->change_muted = 0;
                 videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
-                mixer_mute( 0 );
+                mixer->mute( 0 );
             }
             break;
         }
@@ -942,7 +942,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
             vidin->cur_tuner_state = TUNER_STATE_SIGNAL_LOST;
             vidin->signal_recover_wait = SIGNAL_RECOVER_DELAY;
             vidin->change_muted = 1;
-            mixer_mute( 1 );
+            mixer->mute( 1 );
             videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
         case TUNER_STATE_SIGNAL_LOST:
             if( vidin->signal_recover_wait ) {
-- 
1.7.6.1

