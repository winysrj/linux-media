Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1FHUZS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:18 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPHvA016645
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:18 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Uk024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:17 -0400
Date: Wed, 8 Jun 2011 17:23:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/13] [media] DocBook/demux.xml: Fix section references
 with dmx.h.xml
Message-ID: <20110608172305.7271d17b@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Make the reference links at dmx.h.xml to match the ones at demux.xml.

While here, also syncronizes the structures defined inside the API,
in order to match the current API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 249edd3..0b055ad 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -150,7 +150,7 @@ DVB_DOCUMENTED = \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,<link linkend=\".*\">\(DTV_IOCTL_MAX_MSGS\|dtv_cmds_h\)<\/link>,\1,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
-	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\|ca-slot-info\|ca-descr-info\|ca-caps\|ca-msg\|ca-descr\|ca-pid\)-t,\1,g" \
+	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\|ca-slot-info\|ca-descr-info\|ca-caps\|ca-msg\|ca-descr\|ca-pid\|dmx-filter\|dmx-caps\)-t,\1,g" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index 1b8c4e9..a297f0a 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -7,15 +7,19 @@ accessed by including <emphasis role="tt">linux/dvb/dmx.h</emphasis> in your app
 <section id="dmx_types">
 <title>Demux Data Types</title>
 
-<section id="dmx_output_t">
+<section id="dmx-output-t">
 <title>dmx_output_t</title>
- <programlisting>
- typedef enum
- {
-	 DMX_OUT_DECODER,
-	 DMX_OUT_TAP,
-	 DMX_OUT_TS_TAP
- } dmx_output_t;
+<programlisting>
+typedef enum
+{
+	DMX_OUT_DECODER, /&#x22C6; Streaming directly to decoder. &#x22C6;/
+	DMX_OUT_TAP,     /&#x22C6; Output going to a memory buffer &#x22C6;/
+			 /&#x22C6; (to be retrieved via the read command).&#x22C6;/
+	DMX_OUT_TS_TAP,  /&#x22C6; Output multiplexed into a new TS  &#x22C6;/
+			 /&#x22C6; (to be retrieved by reading from the &#x22C6;/
+			 /&#x22C6; logical DVR device).                 &#x22C6;/
+	DMX_OUT_TSDEMUX_TAP /&#x22C6; Like TS_TAP but retrieved from the DMX device &#x22C6;/
+} dmx_output_t;
 </programlisting>
 <para><emphasis role="tt">DMX_OUT_TAP</emphasis> delivers the stream output to the demux device on which the ioctl is
 called.
@@ -26,96 +30,95 @@ specified.
 </para>
 </section>
 
-<section id="dmx_input_t">
+<section id="dmx-input-t">
 <title>dmx_input_t</title>
- <programlisting>
- typedef enum
- {
-	 DMX_IN_FRONTEND,
-	 DMX_IN_DVR
- } dmx_input_t;
+<programlisting>
+typedef enum
+{
+	DMX_IN_FRONTEND, /&#x22C6; Input from a front-end device.  &#x22C6;/
+	DMX_IN_DVR       /&#x22C6; Input from the logical DVR device.  &#x22C6;/
+} dmx_input_t;
 </programlisting>
 </section>
 
-<section id="dmx_pes_type_t">
+<section id="dmx-pes-type-t">
 <title>dmx_pes_type_t</title>
- <programlisting>
- typedef enum
- {
-	 DMX_PES_AUDIO,
-	 DMX_PES_VIDEO,
-	 DMX_PES_TELETEXT,
-	 DMX_PES_SUBTITLE,
-	 DMX_PES_PCR,
-	 DMX_PES_OTHER
- } dmx_pes_type_t;
-</programlisting>
-</section>
+<programlisting>
+typedef enum
+{
+	DMX_PES_AUDIO0,
+	DMX_PES_VIDEO0,
+	DMX_PES_TELETEXT0,
+	DMX_PES_SUBTITLE0,
+	DMX_PES_PCR0,
 
-<section id="dmx_event_t">
-<title>dmx_event_t</title>
- <programlisting>
- typedef enum
- {
-	 DMX_SCRAMBLING_EV,
-	 DMX_FRONTEND_EV
- } dmx_event_t;
-</programlisting>
-</section>
+	DMX_PES_AUDIO1,
+	DMX_PES_VIDEO1,
+	DMX_PES_TELETEXT1,
+	DMX_PES_SUBTITLE1,
+	DMX_PES_PCR1,
+
+	DMX_PES_AUDIO2,
+	DMX_PES_VIDEO2,
+	DMX_PES_TELETEXT2,
+	DMX_PES_SUBTITLE2,
+	DMX_PES_PCR2,
+
+	DMX_PES_AUDIO3,
+	DMX_PES_VIDEO3,
+	DMX_PES_TELETEXT3,
+	DMX_PES_SUBTITLE3,
+	DMX_PES_PCR3,
 
-<section id="dmx_scrambling_status_t">
-<title>dmx_scrambling_status_t</title>
- <programlisting>
- typedef enum
- {
-	 DMX_SCRAMBLING_OFF,
-	 DMX_SCRAMBLING_ON
- } dmx_scrambling_status_t;
+	DMX_PES_OTHER
+} dmx_pes_type_t;
 </programlisting>
 </section>
 
-<section id="dmx_filter">
+<section id="dmx-filter">
 <title>struct dmx_filter</title>
  <programlisting>
  typedef struct dmx_filter
- {
-	 uint8_t         filter[DMX_FILTER_SIZE];
-	 uint8_t         mask[DMX_FILTER_SIZE];
- } dmx_filter_t;
+{
+	__u8  filter[DMX_FILTER_SIZE];
+	__u8  mask[DMX_FILTER_SIZE];
+	__u8  mode[DMX_FILTER_SIZE];
+} dmx_filter_t;
 </programlisting>
 </section>
 
-<section id="dmx_sct_filter_params">
+<section id="dmx-sct-filter-params">
 <title>struct dmx_sct_filter_params</title>
- <programlisting>
- struct dmx_sct_filter_params
- {
-	 uint16_t            pid;
-	 dmx_filter_t        filter;
-	 uint32_t            timeout;
-	 uint32_t            flags;
- #define DMX_CHECK_CRC       1
- #define DMX_ONESHOT         2
- #define DMX_IMMEDIATE_START 4
- };
+<programlisting>
+struct dmx_sct_filter_params
+{
+	__u16          pid;
+	dmx_filter_t   filter;
+	__u32          timeout;
+	__u32          flags;
+#define DMX_CHECK_CRC       1
+#define DMX_ONESHOT         2
+#define DMX_IMMEDIATE_START 4
+#define DMX_KERNEL_CLIENT   0x8000
+};
 </programlisting>
 </section>
 
-<section id="dmx_pes_filter_params">
+<section id="dmx-pes-filter-params">
 <title>struct dmx_pes_filter_params</title>
- <programlisting>
- struct dmx_pes_filter_params
- {
-	 uint16_t            pid;
-	 dmx_input_t         input;
-	 dmx_output_t        output;
-	 dmx_pes_type_t      pes_type;
-	 uint32_t            flags;
- };
+<programlisting>
+struct dmx_pes_filter_params
+{
+	__u16          pid;
+	dmx_input_t    input;
+	dmx_output_t   output;
+	dmx_pes_type_t pes_type;
+	__u32          flags;
+};
 </programlisting>
 </section>
 
-<section id="dmx_event">
+<section id="dmx-event">
 <title>struct dmx_event</title>
  <programlisting>
  struct dmx_event
@@ -130,14 +133,14 @@ specified.
 </programlisting>
 </section>
 
-<section id="dmx_stc">
+<section id="dmx-stc">
 <title>struct dmx_stc</title>
  <programlisting>
- struct dmx_stc {
-	 unsigned int num;       /&#x22C6; input : which STC? 0..N &#x22C6;/
-	 unsigned int base;      /&#x22C6; output: divisor for stc to get 90 kHz clock &#x22C6;/
-	 uint64_t stc;           /&#x22C6; output: stc in 'base'&#x22C6;90 kHz units &#x22C6;/
- };
+struct dmx_stc {
+	unsigned int num;	/&#x22C6; input : which STC? 0..N &#x22C6;/
+	unsigned int base;	/&#x22C6; output: divisor for stc to get 90 kHz clock &#x22C6;/
+	__u64 stc;		/&#x22C6; output: stc in 'base'&#x22C6;90 kHz units &#x22C6;/
+};
 </programlisting>
  </section>
 
@@ -491,7 +494,7 @@ specified.
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="dmx_start">
+<section id="DMX_START">
 <title>DMX_START</title>
 <para>DESCRIPTION
 </para>
@@ -556,7 +559,7 @@ specified.
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="dmx_stop">
+<section id="DMX_STOP">
 <title>DMX_STOP</title>
 <para>DESCRIPTION
 </para>
@@ -603,7 +606,7 @@ specified.
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="dmx_set_filter">
+<section id="DMX_SET_FILTER">
 <title>DMX_SET_FILTER</title>
 <para>DESCRIPTION
 </para>
@@ -673,7 +676,7 @@ specified.
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="dmx_set_pes_filter">
+<section id="DMX_SET_PES_FILTER">
 <title>DMX_SET_PES_FILTER</title>
 <para>DESCRIPTION
 </para>
@@ -756,7 +759,7 @@ specified.
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="dms_set_buffer_size">
+<section id="DMX_SET_BUFFER_SIZE">
 <title>DMX_SET_BUFFER_SIZE</title>
 <para>DESCRIPTION
 </para>
@@ -819,7 +822,7 @@ specified.
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="dmx_get_event">
+<section id="DMX_GET_EVENT">
 <title>DMX_GET_EVENT</title>
 <para>DESCRIPTION
 </para>
@@ -899,7 +902,7 @@ specified.
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="dmx_get_stc">
+<section id="DMX_GET_STC">
 <title>DMX_GET_STC</title>
 <para>DESCRIPTION
 </para>
-- 
1.7.1


