Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab1FHUZZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:25 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPPwJ011459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:25 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Uo024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:24 -0400
Date: Wed, 8 Jun 2011 17:23:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/13] [media] DocBook/video.xml: Fix section references
 with video.h.xml
Message-ID: <20110608172309.520252fc@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Make the reference links at video.h.xml to match the ones at video.xml.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index a914eb0..1e909c2 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -146,7 +146,7 @@ DVB_DOCUMENTED = \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,<link\s\+linkend=\".*\">\(DTV_IOCTL_MAX_MSGS\|dtv_cmds_h\|__.*_old\)<\/link>,\1,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
-	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\|ca-slot-info\|ca-descr-info\|ca-caps\|ca-msg\|ca-descr\|ca-pid\|dmx-filter\|dmx-caps\)-t,\1,g" \
+	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\|ca-slot-info\|ca-descr-info\|ca-caps\|ca-msg\|ca-descr\|ca-pid\|dmx-filter\|dmx-caps\|video-system\|video-highlight\|video-spu\|video-spu-palette\|video-navi-pack\)-t,\1,g" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,<link\s\+linkend=\".*\">\(__.*_OLD\)<\/link>,\1,g" \
diff --git a/Documentation/DocBook/media/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
index 7bb287e..ef30f69 100644
--- a/Documentation/DocBook/media/dvb/video.xml
+++ b/Documentation/DocBook/media/dvb/video.xml
@@ -18,15 +18,16 @@ supported on some MPEG decoders made for DVD playback.
 <section id="video_types">
 <title>Video Data Types</title>
 
-<section id="video_format_t">
+<section id="video-format-t">
 <title>video_format_t</title>
 <para>The <emphasis role="tt">video_format_t</emphasis> data type defined by
 </para>
 <programlisting>
- typedef enum {
-	 VIDEO_FORMAT_4_3,
-	 VIDEO_FORMAT_16_9
- } video_format_t;
+typedef enum {
+	VIDEO_FORMAT_4_3,     /&#x22C6; Select 4:3 format &#x22C6;/
+	VIDEO_FORMAT_16_9,    /&#x22C6; Select 16:9 format. &#x22C6;/
+	VIDEO_FORMAT_221_1    /&#x22C6; 2.21:1 &#x22C6;/
+} video_format_t;
 </programlisting>
 <para>is used in the VIDEO_SET_FORMAT function (??) to tell the driver which aspect ratio
 the output hardware (e.g. TV) has. It is also used in the data structures video_status
@@ -36,34 +37,36 @@ stream.
 </para>
 </section>
 
-<section id="video_display_format_t">
+<section id="video-display-format-t">
 <title>video_display_format_t</title>
 <para>In case the display format of the video stream and of the display hardware differ the
 application has to specify how to handle the cropping of the picture. This can be done using
 the VIDEO_SET_DISPLAY_FORMAT call (??) which accepts
 </para>
 <programlisting>
- typedef enum {
-	 VIDEO_PAN_SCAN,
-	 VIDEO_LETTER_BOX,
-	 VIDEO_CENTER_CUT_OUT
- } video_display_format_t;
+typedef enum {
+	VIDEO_PAN_SCAN,       /&#x22C6; use pan and scan format &#x22C6;/
+	VIDEO_LETTER_BOX,     /&#x22C6; use letterbox format &#x22C6;/
+	VIDEO_CENTER_CUT_OUT  /&#x22C6; use center cut out format &#x22C6;/
+} video_displayformat_t;
 </programlisting>
 <para>as argument.
 </para>
 </section>
 
-<section id="video_stream_source">
+<section id="video-stream-source-t">
 <title>video stream source</title>
 <para>The video stream source is set through the VIDEO_SELECT_SOURCE call and can take
 the following values, depending on whether we are replaying from an internal (demuxer) or
 external (user write) source.
 </para>
 <programlisting>
- typedef enum {
-	 VIDEO_SOURCE_DEMUX,
-	 VIDEO_SOURCE_MEMORY
- } video_stream_source_t;
+typedef enum {
+	VIDEO_SOURCE_DEMUX, /&#x22C6; Select the demux as the main source &#x22C6;/
+	VIDEO_SOURCE_MEMORY /&#x22C6; If this source is selected, the stream
+			       comes from the user through the write
+			       system call &#x22C6;/
+} video_stream_source_t;
 </programlisting>
 <para>VIDEO_SOURCE_DEMUX selects the demultiplexer (fed either by the frontend or the
 DVR device) as the source of the video stream. If VIDEO_SOURCE_MEMORY
@@ -72,49 +75,55 @@ call.
 </para>
 </section>
 
-<section id="video_play_state">
+<section id="video-play-state-t">
 <title>video play state</title>
 <para>The following values can be returned by the VIDEO_GET_STATUS call representing the
 state of video playback.
 </para>
 <programlisting>
- typedef enum {
-	 VIDEO_STOPPED,
-	 VIDEO_PLAYING,
-	 VIDEO_FREEZED
- } video_play_state_t;
+typedef enum {
+	VIDEO_STOPPED, /&#x22C6; Video is stopped &#x22C6;/
+	VIDEO_PLAYING, /&#x22C6; Video is currently playing &#x22C6;/
+	VIDEO_FREEZED  /&#x22C6; Video is freezed &#x22C6;/
+} video_play_state_t;
 </programlisting>
 </section>
 
-<section id="video_event">
+<section id="video-event">
 <title>struct video_event</title>
 <para>The following is the structure of a video event as it is returned by the VIDEO_GET_EVENT
 call.
 </para>
 <programlisting>
- struct video_event {
-	 int32_t type;
-	 time_t timestamp;
-	 union {
-		 video_format_t video_format;
-	 } u;
- };
+struct video_event {
+	__s32 type;
+#define VIDEO_EVENT_SIZE_CHANGED	1
+#define VIDEO_EVENT_FRAME_RATE_CHANGED	2
+#define VIDEO_EVENT_DECODER_STOPPED 	3
+#define VIDEO_EVENT_VSYNC 		4
+	__kernel_time_t timestamp;
+	union {
+		video_size_t size;
+		unsigned int frame_rate;	/&#x22C6; in frames per 1000sec &#x22C6;/
+		unsigned char vsync_field;	/&#x22C6; unknown/odd/even/progressive &#x22C6;/
+	} u;
+};
 </programlisting>
 </section>
 
-<section id="video_status">
+<section id="video-status">
 <title>struct video_status</title>
 <para>The VIDEO_GET_STATUS call returns the following structure informing about various
 states of the playback operation.
 </para>
 <programlisting>
- struct video_status {
-	 boolean video_blank;
-	 video_play_state_t play_state;
-	 video_stream_source_t stream_source;
-	 video_format_t video_format;
-	 video_displayformat_t display_format;
- };
+struct video_status {
+	int                   video_blank;   /&#x22C6; blank video on freeze? &#x22C6;/
+	video_play_state_t    play_state;    /&#x22C6; current state of playback &#x22C6;/
+	video_stream_source_t stream_source; /&#x22C6; current source (demux/memory) &#x22C6;/
+	video_format_t        video_format;  /&#x22C6; current aspect ratio of stream &#x22C6;/
+	video_displayformat_t display_format;/&#x22C6; selected cropping mode &#x22C6;/
+};
 </programlisting>
 <para>If video_blank is set video will be blanked out if the channel is changed or if playback is
 stopped. Otherwise, the last picture will be displayed. play_state indicates if the video is
@@ -127,17 +136,17 @@ device.
 </para>
 </section>
 
-<section id="video_still_picture">
+<section id="video-still-picture">
 <title>struct video_still_picture</title>
 <para>An I-frame displayed via the VIDEO_STILLPICTURE call is passed on within the
 following structure.
 </para>
 <programlisting>
- /&#x22C6; pointer to and size of a single iframe in memory &#x22C6;/
- struct video_still_picture {
-	 char &#x22C6;iFrame;
-	 int32_t size;
- };
+/&#x22C6; pointer to and size of a single iframe in memory &#x22C6;/
+struct video_still_picture {
+	char &#x22C6;iFrame;        /&#x22C6; pointer to a single iframe in memory &#x22C6;/
+	int32_t size;
+};
 </programlisting>
 </section>
 
@@ -164,26 +173,26 @@ bits set according to the hardwares capabilities.
 </programlisting>
 </section>
 
-<section id="video_system">
+<section id="video-system">
 <title>video system</title>
 <para>A call to VIDEO_SET_SYSTEM sets the desired video system for TV output. The
 following system types can be set:
 </para>
 <programlisting>
- typedef enum {
-	  VIDEO_SYSTEM_PAL,
-	  VIDEO_SYSTEM_NTSC,
-	  VIDEO_SYSTEM_PALN,
-	  VIDEO_SYSTEM_PALNc,
-	  VIDEO_SYSTEM_PALM,
-	  VIDEO_SYSTEM_NTSC60,
-	  VIDEO_SYSTEM_PAL60,
-	  VIDEO_SYSTEM_PALM60
- } video_system_t;
+typedef enum {
+	 VIDEO_SYSTEM_PAL,
+	 VIDEO_SYSTEM_NTSC,
+	 VIDEO_SYSTEM_PALN,
+	 VIDEO_SYSTEM_PALNc,
+	 VIDEO_SYSTEM_PALM,
+	 VIDEO_SYSTEM_NTSC60,
+	 VIDEO_SYSTEM_PAL60,
+	 VIDEO_SYSTEM_PALM60
+} video_system_t;
 </programlisting>
 </section>
 
-<section id="video_highlight">
+<section id="video-highlight">
 <title>struct video_highlight</title>
 <para>Calling the ioctl VIDEO_SET_HIGHLIGHTS posts the SPU highlight information. The
 call expects the following format for that information:
@@ -210,7 +219,7 @@ call expects the following format for that information:
 </programlisting>
 
 </section>
-<section id="video_spu">
+<section id="video-spu">
 <title>video SPU</title>
 <para>Calling VIDEO_SET_SPU deactivates or activates SPU decoding, according to the
 following format:
@@ -224,7 +233,7 @@ following format:
 </programlisting>
 
 </section>
-<section id="video_spu_palette">
+<section id="video-spu-palette">
 <title>video SPU palette</title>
 <para>The following structure is used to set the SPU palette by calling VIDEO_SPU_PALETTE:
 </para>
@@ -237,7 +246,7 @@ following format:
 </programlisting>
 
 </section>
-<section id="video_navi_pack">
+<section id="video-navi-pack">
 <title>video NAVI pack</title>
 <para>In order to get the navigational data the following structure has to be passed to the ioctl
 VIDEO_GET_NAVI:
@@ -252,7 +261,7 @@ VIDEO_GET_NAVI:
 </section>
 
 
-<section id="video_attributes">
+<section id="video-attributes-t">
 <title>video attributes</title>
 <para>The following attributes can be set by a call to VIDEO_SET_ATTRIBUTES:
 </para>
@@ -488,7 +497,7 @@ VIDEO_GET_NAVI:
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_STOP"
 role="subsection"><title>VIDEO_STOP</title>
 <para>DESCRIPTION
 </para>
@@ -562,7 +571,7 @@ role="subsection"><title>VIDEO_STOP</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_PLAY"
 role="subsection"><title>VIDEO_PLAY</title>
 <para>DESCRIPTION
 </para>
@@ -615,7 +624,7 @@ role="subsection"><title>VIDEO_PLAY</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_FREEZE"
 role="subsection"><title>VIDEO_FREEZE</title>
 <para>DESCRIPTION
 </para>
@@ -672,7 +681,7 @@ role="subsection"><title>VIDEO_FREEZE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_CONTINUE"
 role="subsection"><title>VIDEO_CONTINUE</title>
 <para>DESCRIPTION
 </para>
@@ -725,7 +734,7 @@ role="subsection"><title>VIDEO_CONTINUE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SELECT_SOURCE"
 role="subsection"><title>VIDEO_SELECT_SOURCE</title>
 <para>DESCRIPTION
 </para>
@@ -788,7 +797,7 @@ role="subsection"><title>VIDEO_SELECT_SOURCE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_BLANK"
 role="subsection"><title>VIDEO_SET_BLANK</title>
 <para>DESCRIPTION
 </para>
@@ -861,7 +870,7 @@ role="subsection"><title>VIDEO_SET_BLANK</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_GET_STATUS"
 role="subsection"><title>VIDEO_GET_STATUS</title>
 <para>DESCRIPTION
 </para>
@@ -929,7 +938,7 @@ role="subsection"><title>VIDEO_GET_STATUS</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_GET_EVENT"
 role="subsection"><title>VIDEO_GET_EVENT</title>
 <para>DESCRIPTION
 </para>
@@ -1018,7 +1027,7 @@ role="subsection"><title>VIDEO_GET_EVENT</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_DISPLAY_FORMAT"
 role="subsection"><title>VIDEO_SET_DISPLAY_FORMAT</title>
 <para>DESCRIPTION
 </para>
@@ -1088,7 +1097,7 @@ role="subsection"><title>VIDEO_SET_DISPLAY_FORMAT</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_STILLPICTURE"
 role="subsection"><title>VIDEO_STILLPICTURE</title>
 <para>DESCRIPTION
 </para>
@@ -1158,7 +1167,7 @@ role="subsection"><title>VIDEO_STILLPICTURE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_FAST_FORWARD"
 role="subsection"><title>VIDEO_FAST_FORWARD</title>
 <para>DESCRIPTION
 </para>
@@ -1232,7 +1241,7 @@ role="subsection"><title>VIDEO_FAST_FORWARD</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SLOWMOTION"
 role="subsection"><title>VIDEO_SLOWMOTION</title>
 <para>DESCRIPTION
 </para>
@@ -1306,7 +1315,7 @@ role="subsection"><title>VIDEO_SLOWMOTION</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_GET_CAPABILITIES"
 role="subsection"><title>VIDEO_GET_CAPABILITIES</title>
 <para>DESCRIPTION
 </para>
@@ -1368,7 +1377,7 @@ role="subsection"><title>VIDEO_GET_CAPABILITIES</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_ID"
 role="subsection"><title>VIDEO_SET_ID</title>
 <para>DESCRIPTION
 </para>
@@ -1435,7 +1444,7 @@ role="subsection"><title>VIDEO_SET_ID</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_CLEAR_BUFFER"
 role="subsection"><title>VIDEO_CLEAR_BUFFER</title>
 <para>DESCRIPTION
 </para>
@@ -1479,7 +1488,7 @@ role="subsection"><title>VIDEO_CLEAR_BUFFER</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_STREAMTYPE"
 role="subsection"><title>VIDEO_SET_STREAMTYPE</title>
 <para>DESCRIPTION
 </para>
@@ -1540,7 +1549,7 @@ role="subsection"><title>VIDEO_SET_STREAMTYPE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_FORMAT"
 role="subsection"><title>VIDEO_SET_FORMAT</title>
 <para>DESCRIPTION
 </para>
@@ -1601,7 +1610,7 @@ role="subsection"><title>VIDEO_SET_FORMAT</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_SYSTEM"
 role="subsection"><title>VIDEO_SET_SYSTEM</title>
 <para>DESCRIPTION
 </para>
@@ -1663,7 +1672,7 @@ role="subsection"><title>VIDEO_SET_SYSTEM</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_HIGHLIGHT"
 role="subsection"><title>VIDEO_SET_HIGHLIGHT</title>
 <para>DESCRIPTION
 </para>
@@ -1723,7 +1732,7 @@ role="subsection"><title>VIDEO_SET_HIGHLIGHT</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_SPU"
 role="subsection"><title>VIDEO_SET_SPU</title>
 <para>DESCRIPTION
 </para>
@@ -1785,7 +1794,7 @@ role="subsection"><title>VIDEO_SET_SPU</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_SPU_PALETTE"
 role="subsection"><title>VIDEO_SET_SPU_PALETTE</title>
 <para>DESCRIPTION
 </para>
@@ -1845,7 +1854,7 @@ role="subsection"><title>VIDEO_SET_SPU_PALETTE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_GET_NAVI"
 role="subsection"><title>VIDEO_GET_NAVI</title>
 <para>DESCRIPTION
 </para>
@@ -1907,7 +1916,7 @@ role="subsection"><title>VIDEO_GET_NAVI</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
-</section><section
+</section><section id="VIDEO_SET_ATTRIBUTES"
 role="subsection"><title>VIDEO_SET_ATTRIBUTES</title>
 <para>DESCRIPTION
 </para>
-- 
1.7.1


