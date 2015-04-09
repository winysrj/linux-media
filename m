Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbbDITg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 15:36:56 -0400
Subject: [PATCH] dvb: Document FE_SCALE_DECIBEL units consistently
From: David Howells <dhowells@redhat.com>
To: mchehab@osg.samsung.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Thu, 09 Apr 2015 20:36:49 +0100
Message-ID: <20150409193649.6875.19630.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In comments and in the documentation, the units of properties marked with the
FE_SCALE_DECIBEL scale are specified in terms of 1/1000 dB or 0.0001 dB.  This
is inconsistent, however, as 1/1000 is 0.001, not 0.0001.

Note that the v4l-utils divide the value by 1000 for the signal strength
suggesting that the 1/1000 is correct.

Settle on millidecibels, ie. 1/1000dB or 0.001dB.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/DocBook/media/dvb/dvbproperty.xml |    4 ++--
 include/uapi/linux/dvb/frontend.h               |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 3018564..7ddab2b 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -953,7 +953,7 @@ enum fe_interleaving {
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
 			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
-			<listitem><para><constant>FE_SCALE_DECIBEL</constant> - signal strength is in 0.0001 dBm units, power measured in miliwatts. This value is generally negative.</para></listitem>
+			<listitem><para><constant>FE_SCALE_DECIBEL</constant> - signal strength is in 0.001 dBm units, power measured in miliwatts. This value is generally negative.</para></listitem>
 			<listitem><para><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for power (actually, 0 to 65535).</para></listitem>
 		</itemizedlist>
 	</section>
@@ -963,7 +963,7 @@ enum fe_interleaving {
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
 			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
-			<listitem><para><constant>FE_SCALE_DECIBEL</constant> - Signal/Noise ratio is in 0.0001 dB units.</para></listitem>
+			<listitem><para><constant>FE_SCALE_DECIBEL</constant> - Signal/Noise ratio is in 0.001 dB units.</para></listitem>
 			<listitem><para><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for Signal/Noise (actually, 0 to 65535).</para></listitem>
 		</itemizedlist>
 	</section>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c56d77c..466f569 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -467,7 +467,7 @@ struct dtv_cmds_h {
  * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
  *			    could indicate a temporary or a permanent
  *			    condition.
- * @FE_SCALE_DECIBEL: The scale is measured in 0.0001 dB steps, typically
+ * @FE_SCALE_DECIBEL: The scale is measured in 0.001 dB steps, typically
  *		  used on signal measures.
  * @FE_SCALE_RELATIVE: The scale is a relative percentual measure,
  *			ranging from 0 (0%) to 0xffff (100%).
@@ -516,7 +516,7 @@ struct dtv_stats {
 	__u8 scale;	/* enum fecap_scale_params type */
 	union {
 		__u64 uvalue;	/* for counters and relative scales */
-		__s64 svalue;	/* for 0.0001 dB measures */
+		__s64 svalue;	/* for 0.001 dB measures */
 	};
 } __attribute__ ((packed));
 

