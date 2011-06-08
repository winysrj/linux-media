Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1FHUZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:08 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KP7VV016060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:07 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Ue024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:06 -0400
Date: Wed, 8 Jun 2011 17:22:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/13] [media] DocBook/audio.xml: match section ID's with
 the reference links
Message-ID: <20110608172259.6f825953@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Make sure that both audio.h.xml and audio.xml will match the same names.
This way, it is now possible to identify API spec gaps:

Error: no ID for constraint linkend: AUDIO_CONTINUE.
Error: no ID for constraint linkend: AUDIO_GET_PTS.
Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.

While here, fix the cut-and-paste description error on AUDIO_SET_KARAOKE.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index a747f2a..18604dd 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -150,6 +150,7 @@ DVB_DOCUMENTED = \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,<link linkend=\".*\">\(DTV_IOCTL_MAX_MSGS\|dtv_cmds_h\)<\/link>,\1,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
+	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\)-t,\1,g" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
index eeb96b8..60abf9a 100644
--- a/Documentation/DocBook/media/dvb/audio.xml
+++ b/Documentation/DocBook/media/dvb/audio.xml
@@ -14,7 +14,7 @@ the omission of the audio and video device.
 audio device.
 </para>
 
-<section id="audio_stream_source_t">
+<section id="audio-stream-source-t">
 <title>audio_stream_source_t</title>
 <para>The audio stream source is set through the AUDIO_SELECT_SOURCE call and can take
 the following values, depending on whether we are replaying from an internal (demux) or
@@ -33,7 +33,7 @@ call.
 </para>
 
 </section>
-<section id="audio_play_state_t">
+<section id="audio-play-state-t">
 <title>audio_play_state_t</title>
 <para>The following values can be returned by the AUDIO_GET_STATUS call representing the
 state of audio playback.
@@ -47,7 +47,7 @@ state of audio playback.
 </programlisting>
 
 </section>
-<section id="audio_channel_select_t">
+<section id="audio-channel-select-t">
 <title>audio_channel_select_t</title>
 <para>The audio channel selected via AUDIO_CHANNEL_SELECT is determined by the
 following values.
@@ -61,7 +61,7 @@ following values.
 </programlisting>
 
 </section>
-<section id="struct_audio_status">
+<section id="audio-status">
 <title>struct audio_status</title>
 <para>The AUDIO_GET_STATUS call returns the following structure informing about various
 states of the playback operation.
@@ -78,7 +78,7 @@ states of the playback operation.
 </programlisting>
 
 </section>
-<section id="struct_audio_mixer">
+<section id="audio-mixer">
 <title>struct audio_mixer</title>
 <para>The following structure is used by the AUDIO_SET_MIXER call to set the audio
 volume.
@@ -109,7 +109,7 @@ bits set according to the hardwares capabilities.
 </programlisting>
 
 </section>
-<section id="struct_audio_karaoke">
+<section id="audio-karaoke">
 <title>struct audio_karaoke</title>
 <para>The ioctl AUDIO_SET_KARAOKE uses the following format:
 </para>
@@ -128,7 +128,7 @@ and right.
 </para>
 
 </section>
-<section id="audio_attributes">
+<section id="audio-attributes-t">
 <title>audio attributes</title>
 <para>The following attributes can be set by a call to AUDIO_SET_ATTRIBUTES:
 </para>
@@ -358,7 +358,7 @@ and right.
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_STOP"
 role="subsection"><title>AUDIO_STOP</title>
 <para>DESCRIPTION
 </para>
@@ -409,7 +409,7 @@ role="subsection"><title>AUDIO_STOP</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_PLAY"
 role="subsection"><title>AUDIO_PLAY</title>
 <para>DESCRIPTION
 </para>
@@ -461,7 +461,7 @@ role="subsection"><title>AUDIO_PLAY</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_PAUSE"
 role="subsection"><title>AUDIO_PAUSE</title>
 <para>DESCRIPTION
 </para>
@@ -521,7 +521,7 @@ role="subsection"><title>AUDIO_PAUSE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SELECT_SOURCE"
 role="subsection"><title>AUDIO_SELECT_SOURCE</title>
 <para>DESCRIPTION
 </para>
@@ -592,7 +592,7 @@ role="subsection"><title>AUDIO_SELECT_SOURCE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_MUTE"
 role="subsection"><title>AUDIO_SET_MUTE</title>
 <para>DESCRIPTION
 </para>
@@ -671,7 +671,7 @@ role="subsection"><title>AUDIO_SET_MUTE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_AV_SYNC"
 role="subsection"><title>AUDIO_SET_AV_SYNC</title>
 <para>DESCRIPTION
 </para>
@@ -750,7 +750,7 @@ role="subsection"><title>AUDIO_SET_AV_SYNC</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_BYPASS_MODE"
 role="subsection"><title>AUDIO_SET_BYPASS_MODE</title>
 <para>DESCRIPTION
 </para>
@@ -833,7 +833,7 @@ role="subsection"><title>AUDIO_SET_BYPASS_MODE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_CHANNEL_SELECT"
 role="subsection"><title>AUDIO_CHANNEL_SELECT</title>
 <para>DESCRIPTION
 </para>
@@ -902,7 +902,7 @@ role="subsection"><title>AUDIO_CHANNEL_SELECT</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_GET_STATUS"
 role="subsection"><title>AUDIO_GET_STATUS</title>
 <para>DESCRIPTION
 </para>
@@ -970,7 +970,7 @@ role="subsection"><title>AUDIO_GET_STATUS</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_GET_CAPABILITIES"
 role="subsection"><title>AUDIO_GET_CAPABILITIES</title>
 <para>DESCRIPTION
 </para>
@@ -1038,7 +1038,7 @@ role="subsection"><title>AUDIO_GET_CAPABILITIES</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_CLEAR_BUFFER"
 role="subsection"><title>AUDIO_CLEAR_BUFFER</title>
 <para>DESCRIPTION
 </para>
@@ -1090,7 +1090,7 @@ role="subsection"><title>AUDIO_CLEAR_BUFFER</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_ID"
 role="subsection"><title>AUDIO_SET_ID</title>
 <para>DESCRIPTION
 </para>
@@ -1161,7 +1161,7 @@ role="subsection"><title>AUDIO_SET_ID</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_MIXER"
 role="subsection"><title>AUDIO_SET_MIXER</title>
 <para>DESCRIPTION
 </para>
@@ -1227,7 +1227,7 @@ role="subsection"><title>AUDIO_SET_MIXER</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_STREAMTYPE"
 role="subsection"><title>AUDIO_SET_STREAMTYPE</title>
 <para>DESCRIPTION
 </para>
@@ -1288,7 +1288,7 @@ role="subsection"><title>AUDIO_SET_STREAMTYPE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_EXT_ID"
 role="subsection"><title>AUDIO_SET_EXT_ID</title>
 <para>DESCRIPTION
 </para>
@@ -1348,7 +1348,7 @@ role="subsection"><title>AUDIO_SET_EXT_ID</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_ATTRIBUTES"
 role="subsection"><title>AUDIO_SET_ATTRIBUTES</title>
 <para>DESCRIPTION
 </para>
@@ -1409,7 +1409,7 @@ role="subsection"><title>AUDIO_SET_ATTRIBUTES</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="AUDIO_SET_KARAOKE"
 role="subsection"><title>AUDIO_SET_KARAOKE</title>
 <para>DESCRIPTION
 </para>
@@ -1422,7 +1422,7 @@ role="subsection"><title>AUDIO_SET_KARAOKE</title>
 </para>
 <informaltable><tgroup cols="1"><tbody><row><entry
  align="char">
-<para>int ioctl(fd, int request = AUDIO_SET_STREAMTYPE,
+<para>int ioctl(fd, int request = AUDIO_SET_KARAOKE,
  audio_karaoke_t &#x22C6;karaoke);</para>
 </entry>
  </row></tbody></tgroup></informaltable>
@@ -1440,7 +1440,7 @@ role="subsection"><title>AUDIO_SET_KARAOKE</title>
 <para>int request</para>
 </entry><entry
  align="char">
-<para>Equals AUDIO_SET_STREAMTYPE for this
+<para>Equals AUDIO_SET_KARAOKE for this
  command.</para>
 </entry>
  </row><row><entry
-- 
1.7.1


