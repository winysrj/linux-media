Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1FHUZ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:27 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPRcm011479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:27 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Up024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:26 -0400
Date: Wed, 8 Jun 2011 17:23:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/13] [media] DocBook/video.xml: Document the remaining
 data structures
Message-ID: <20110608172310.6d91b712@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Now, all data structures are commented. A few ioctls remain undocumented:

Error: no ID for constraint linkend: VIDEO_GET_SIZE.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
Error: no ID for constraint linkend: VIDEO_GET_PTS.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
Error: no ID for constraint linkend: VIDEO_COMMAND.
Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
index ef30f69..539c79b 100644
--- a/Documentation/DocBook/media/dvb/video.xml
+++ b/Documentation/DocBook/media/dvb/video.xml
@@ -37,8 +37,8 @@ stream.
 </para>
 </section>
 
-<section id="video-display-format-t">
-<title>video_display_format_t</title>
+<section id="video-displayformat-t">
+<title>video_displayformat_t</title>
 <para>In case the display format of the video stream and of the display hardware differ the
 application has to specify how to handle the cropping of the picture. This can be done using
 the VIDEO_SET_DISPLAY_FORMAT call (??) which accepts
@@ -89,6 +89,49 @@ typedef enum {
 </programlisting>
 </section>
 
+<section id="video-command">
+<para>The structure must be zeroed before use by the application
+This ensures it can be extended safely in the future.</para>
+<title>struct video-command</title>
+<programlisting>
+struct video_command {
+	__u32 cmd;
+	__u32 flags;
+	union {
+		struct {
+			__u64 pts;
+		} stop;
+
+		struct {
+			/&#x22C6; 0 or 1000 specifies normal speed,
+			   1 specifies forward single stepping,
+			   -1 specifies backward single stepping,
+			   &gt;>1: playback at speed/1000 of the normal speed,
+			   &lt;-1: reverse playback at (-speed/1000) of the normal speed. &#x22C6;/
+			__s32 speed;
+			__u32 format;
+		} play;
+
+		struct {
+			__u32 data[16];
+		} raw;
+	};
+};
+</programlisting>
+</section>
+
+<section id="video-size-t">
+<title>struct video_size-t</title>
+<programlisting>
+typedef struct {
+	int w;
+	int h;
+	video_format_t aspect_ratio;
+} video_size_t;
+</programlisting>
+</section>
+
+
 <section id="video-event">
 <title>struct video_event</title>
 <para>The following is the structure of a video event as it is returned by the VIDEO_GET_EVENT
-- 
1.7.1

