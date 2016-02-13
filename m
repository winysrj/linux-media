Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSry (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:54 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 29CF5C0C2344
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:54 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 06/17] mute: Delay unmute on signal lock to give msp3400 time to sync
Date: Sat, 13 Feb 2016 19:47:27 +0100
Message-Id: <1455389258-13470-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delay unmute on signal lock, this fixes a loud plop sound on changing
channels on cards with a msp3400 stereo sound decoder.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/videoinput.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/videoinput.c b/src/videoinput.c
index 0af6ab7..f66a35e 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -123,6 +123,12 @@ int videoinput_get_time_per_field( int norm )
     }
 }
 
+static int videoinput_get_unmute_delay( int norm )
+{
+    /* The msp3400 needs some time before it provides stable audio */
+    return 400000 / videoinput_get_time_per_field( norm );
+}
+
 typedef struct capture_buffer_s
 {
     struct v4l2_buffer vidbuf;
@@ -158,6 +164,7 @@ struct videoinput_s
     int hasaudio;
     int audiomode;
     int change_muted;
+    int change_muted_delay;
     int user_muted;
     int hw_muted;
 
@@ -360,6 +367,7 @@ videoinput_t *videoinput_new( config_t *cfg, int norm, int verbose,
     vidin->signal_recover_wait = 0;
     vidin->signal_acquire_wait = 0;
     vidin->change_muted = 1;
+    vidin->change_muted_delay = videoinput_get_unmute_delay( norm );
     vidin->user_muted = user_muted;
     vidin->hw_muted = 1;
     vidin->hasaudio = 1;
@@ -752,6 +760,7 @@ void videoinput_set_tuner_freq( videoinput_t *vidin, int freqKHz )
         }
 
         vidin->change_muted = 1;
+        vidin->change_muted_delay = videoinput_get_unmute_delay( vidin->norm );
         videoinput_do_mute( vidin );
         vidin->cur_tuner_state = TUNER_STATE_SIGNAL_DETECTED;
         vidin->signal_acquire_wait = SIGNAL_ACQUIRE_DELAY;
@@ -921,7 +930,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
                 vidin->cur_tuner_state = TUNER_STATE_HAS_SIGNAL;
             }
         default:
-            if( vidin->change_muted ) {
+            if( vidin->change_muted && --vidin->change_muted_delay == 0 ) {
                 vidin->change_muted = 0;
                 videoinput_do_mute( vidin );
             }
@@ -934,6 +943,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
             vidin->cur_tuner_state = TUNER_STATE_SIGNAL_LOST;
             vidin->signal_recover_wait = SIGNAL_RECOVER_DELAY;
             vidin->change_muted = 1;
+            vidin->change_muted_delay = videoinput_get_unmute_delay( vidin->norm );
             videoinput_do_mute( vidin );
         case TUNER_STATE_SIGNAL_LOST:
             if( vidin->signal_recover_wait ) {
-- 
2.5.0

