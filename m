Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab1FHUZK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:10 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KP9JN016076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:09 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Uf024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:08 -0400
Date: Wed, 8 Jun 2011 17:23:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/13] [media] DocBook/audio.xml: synchronize attribute
 changes
Message-ID: <20110608172300.6c90de89@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some attributes suffered some changes since DVBv1. Sync them with the
current API header files.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
index 60abf9a..b3d3895 100644
--- a/Documentation/DocBook/media/dvb/audio.xml
+++ b/Documentation/DocBook/media/dvb/audio.xml
@@ -21,10 +21,10 @@ the following values, depending on whether we are replaying from an internal (de
 external (user write) source.
 </para>
 <programlisting>
- typedef enum {
-	 AUDIO_SOURCE_DEMUX,
-	 AUDIO_SOURCE_MEMORY
- } audio_stream_source_t;
+typedef enum {
+	AUDIO_SOURCE_DEMUX,
+	AUDIO_SOURCE_MEMORY
+} audio_stream_source_t;
 </programlisting>
 <para>AUDIO_SOURCE_DEMUX selects the demultiplexer (fed either by the frontend or the
 DVR device) as the source of the video stream. If AUDIO_SOURCE_MEMORY
@@ -39,11 +39,11 @@ call.
 state of audio playback.
 </para>
 <programlisting>
- typedef enum {
-	 AUDIO_STOPPED,
-	 AUDIO_PLAYING,
-	 AUDIO_PAUSED
- } audio_play_state_t;
+typedef enum {
+	AUDIO_STOPPED,
+	AUDIO_PLAYING,
+	AUDIO_PAUSED
+} audio_play_state_t;
 </programlisting>
 
 </section>
@@ -53,11 +53,13 @@ state of audio playback.
 following values.
 </para>
 <programlisting>
- typedef enum {
-	 AUDIO_STEREO,
-	 AUDIO_MONO_LEFT,
-	 AUDIO_MONO_RIGHT,
- } audio_channel_select_t;
+typedef enum {
+	AUDIO_STEREO,
+	AUDIO_MONO_LEFT,
+	AUDIO_MONO_RIGHT,
+	AUDIO_MONO,
+	AUDIO_STEREO_SWAPPED
+} audio_channel_select_t;
 </programlisting>
 
 </section>
@@ -67,14 +69,15 @@ following values.
 states of the playback operation.
 </para>
 <programlisting>
- typedef struct audio_status {
-	 boolean AV_sync_state;
-	 boolean mute_state;
-	 audio_play_state_t play_state;
-	 audio_stream_source_t stream_source;
-	 audio_channel_select_t channel_select;
-	 boolean bypass_mode;
- } audio_status_t;
+typedef struct audio_status {
+	boolean AV_sync_state;
+	boolean mute_state;
+	audio_play_state_t play_state;
+	audio_stream_source_t stream_source;
+	audio_channel_select_t channel_select;
+	boolean bypass_mode;
+	audio_mixer_t mixer_state;
+} audio_status_t;
 </programlisting>
 
 </section>
@@ -84,10 +87,10 @@ states of the playback operation.
 volume.
 </para>
 <programlisting>
- typedef struct audio_mixer {
-	 unsigned int volume_left;
-	 unsigned int volume_right;
- } audio_mixer_t;
+typedef struct audio_mixer {
+	unsigned int volume_left;
+	unsigned int volume_right;
+} audio_mixer_t;
 </programlisting>
 
 </section>
@@ -114,12 +117,12 @@ bits set according to the hardwares capabilities.
 <para>The ioctl AUDIO_SET_KARAOKE uses the following format:
 </para>
 <programlisting>
- typedef
- struct audio_karaoke{
-	 int vocal1;
-	 int vocal2;
-	 int melody;
- } audio_karaoke_t;
+typedef
+struct audio_karaoke {
+	int vocal1;
+	int vocal2;
+	int melody;
+} audio_karaoke_t;
 </programlisting>
 <para>If Vocal1 or Vocal2 are non-zero, they get mixed into left and right t at 70% each. If both,
 Vocal1 and Vocal2 are non-zero, Vocal1 gets mixed into the left channel and Vocal2 into the
diff --git a/include/linux/dvb/audio.h b/include/linux/dvb/audio.h
index fec66bd..d47bccd 100644
--- a/include/linux/dvb/audio.h
+++ b/include/linux/dvb/audio.h
@@ -67,7 +67,7 @@ typedef struct audio_status {
 
 
 typedef
-struct audio_karaoke{  /* if Vocal1 or Vocal2 are non-zero, they get mixed  */
+struct audio_karaoke {  /* if Vocal1 or Vocal2 are non-zero, they get mixed  */
 	int vocal1;    /* into left and right t at 70% each */
 	int vocal2;    /* if both, Vocal1 and Vocal2 are non-zero, Vocal1 gets*/
 	int melody;    /* mixed into the left channel and */
-- 
1.7.1


