Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZIQFKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 01:10:00 -0400
Date: Thu, 17 Sep 2009 02:09:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Boettcher <patrick.boettcher@desy.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [hg:v4l-dvb] DocBook/media: Add isdb-t documentation
Message-ID: <20090917020923.5572340f@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

I've added the isdb-t docs at the new media DocBook. Please double check. It were
generated from your text document at dvb-spec dir.

For your convenience, it is already compiled at linuxtv.org/docs.php:
	http://linuxtv.org/downloads/v4l-dvb-apis/ch09s03.html

(and the site will automatically update if we change something at the docbook).

You can also compile it locally with "make spec". You need to have xmlto and
the oasis DTD's, in order to compile.

It is understandable that most of us were afraid on touching at LaTex docs, but having
everything in DocBook makes easier for people to update: just one language, XML based.
For those seeking for a good XML editor, I recommend quanta. It comes together
with kde (on RHEL, the package name is kdewebdev). Don't forget to say to the editor to use
DocBook XML 4.1.2 format.

Starting from now, I kindly ask developers that need to touch at Media API to
always send an update to the DocBook. It would be great if someone could write
a complete S2API spec.

Cheers,
Mauro.
	

Forwarded message:

Date: Thu, 17 Sep 2009 04:25:02 +0200
From: Patch from Mauro Carvalho Chehab  <hg-commit@linuxtv.org>
To: linuxtv-commits@linuxtv.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,        Mauro Carvalho Chehab  <mchehab@redhat.com>
Subject: [hg:v4l-dvb] DocBook/media: Add isdb-t documentation


The patch number 12915 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
to http://linuxtv.org/hg/v4l-dvb master development tree.

Kernel patches in this development tree may be modified to be backward
compatible with older kernels. Compatibility modifications will be
removed before inclusion into the mainstream Kernel

If anyone has any objections, please let us know by sending a message to:
	Linux Media Mailing List <linux-media@vger.kernel.org>

------

From: Mauro Carvalho Chehab  <mchehab@redhat.com>
DocBook/media: Add isdb-t documentation


Adds ISDB-T_and_ISDB-Tsb_with_S2API spec converted into DocBook format.

The text is authored by Patrick Boettcher, and was converted to DocBook
by me.

Priority: normal

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


---

 linux/Documentation/DocBook/dvb/dvbapi.xml   |    8 
 linux/Documentation/DocBook/dvb/frontend.xml |    1 
 linux/Documentation/DocBook/dvb/isdbt.xml    |  313 +++++++++++++++++++
 media-specs/Makefile                         |    1 
 4 files changed, 323 insertions(+)

diff -r 258d168cf311 -r 72b7493653f7 linux/Documentation/DocBook/dvb/dvbapi.xml
--- a/linux/Documentation/DocBook/dvb/dvbapi.xml	Wed Sep 16 16:44:11 2009 -0300
+++ b/linux/Documentation/DocBook/dvb/dvbapi.xml	Wed Sep 16 23:22:05 2009 -0300
@@ -30,6 +30,14 @@
 <revhistory>
 <!-- Put document revisions here, newest first. -->
 <revision>
+<revnumber>2.0.1</revnumber>
+<date>2009-09-16</date>
+<authorinitials>mcc</authorinitials>
+<revremark>
+Added ISDB-T test originally written by Patrick Boettcher
+</revremark>
+</revision>
+<revision>
 <revnumber>2.0.0</revnumber>
 <date>2009-09-06</date>
 <authorinitials>mcc</authorinitials>
diff -r 258d168cf311 -r 72b7493653f7 linux/Documentation/DocBook/dvb/frontend.xml
--- a/linux/Documentation/DocBook/dvb/frontend.xml	Wed Sep 16 16:44:11 2009 -0300
+++ b/linux/Documentation/DocBook/dvb/frontend.xml	Wed Sep 16 23:22:05 2009 -0300
@@ -1763,3 +1763,4 @@
  </row></tbody></tgroup></informaltable>
 </section>
 </section>
+&sub-isdbt;
diff -r 258d168cf311 -r 72b7493653f7 linux/Documentation/DocBook/dvb/isdbt.xml
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/Documentation/DocBook/dvb/isdbt.xml	Wed Sep 16 23:22:05 2009 -0300
@@ -0,0 +1,313 @@
+<section id="isdbt">
+	<title>ISDB-T frontend</title>
+	<para>This section describes shortly what are the possible parameters in the Linux
+		DVB-API called "S2API" and now DVB API 5 in order to tune an ISDB-T/ISDB-Tsb
+		demodulator:</para>
+
+	<para>This ISDB-T/ISDB-Tsb API extension should reflect all information
+		needed to tune any ISDB-T/ISDB-Tsb hardware. Of course it is possible
+		that some very sophisticated devices won't need certain parameters to
+		tune.</para>
+
+	<para>The information given here should help application writers to know how
+		to handle ISDB-T and ISDB-Tsb hardware using the Linux DVB-API.</para>
+
+	<para>The details given here about ISDB-T and ISDB-Tsb are just enough to
+		basically show the dependencies between the needed parameter values,
+		but surely some information is left out. For more detailed information
+		see the following documents:</para>
+
+	<para>ARIB STD-B31 - "Transmission System for Digital Terrestrial
+		Television Broadcasting" and</para>
+	<para>ARIB TR-B14 - "Operational Guidelines for Digital Terrestrial
+		Television Broadcasting".</para>
+
+	<para>In order to read this document one has to have some knowledge the
+		channel structure in ISDB-T and ISDB-Tsb. I.e. it has to be known to
+		the reader that an ISDB-T channel consists of 13 segments, that it can
+		have up to 3 layer sharing those segments, and things like that.</para>
+
+	<para>Parameters used by ISDB-T and ISDB-Tsb.</para>
+
+	<section id="isdbt-parms">
+		<title>Parameters that are common with DVB-T and ATSC</title>
+
+		<section id="isdbt-freq">
+			<title><constant>DTV_FREQUENCY</constant></title>
+
+			<para>Central frequency of the channel.</para>
+
+			<para>For ISDB-T the channels are usally transmitted with an offset of 143kHz. E.g. a
+				valid frequncy could be 474143 kHz. The stepping is bound to the bandwidth of
+				the channel which is 6MHz.</para>
+
+			<para>As in ISDB-Tsb the channel consists of only one or three segments the
+				frequency step is 429kHz, 3*429 respectively. As for ISDB-T the
+				central frequency of the channel is expected.</para>
+		</section>
+
+		<section id="isdbt-bw">
+			<title><constant>DTV_BANDWIDTH_HZ</constant> (optional)</title>
+
+			<para>Possible values:</para>
+
+			<para>For ISDB-T it should be always 6000000Hz (6MHz)</para>
+			<para>For ISDB-Tsb it can vary depending on the number of connected segments</para>
+
+			<para>Note: Hardware specific values might be given here, but standard
+				applications should not bother to set a value to this field as
+				standard demods are ignoring it anyway.</para>
+
+			<para>Bandwidth in ISDB-T is fixed (6MHz) or can be easily derived from
+				other parameters (DTV_ISDBT_SB_SEGMENT_IDX,
+				DTV_ISDBT_SB_SEGMENT_COUNT).</para>
+		</section>
+
+		<section id="isdbt-delivery-sys">
+			<title><constant>DTV_DELIVERY_SYSTEM</constant></title>
+
+			<para>Possible values: <constant>SYS_ISDBT</constant></para>
+		</section>
+
+		<section id="isdbt-tx-mode">
+			<title><constant>DTV_TRANSMISSION_MODE</constant></title>
+
+			<para>ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
+				'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K</para>
+
+			<para>Possible values: <constant>TRANSMISSION_MODE_2K</constant>, <constant>TRANSMISSION_MODE_8K</constant>,
+				<constant>TRANSMISSION_MODE_AUTO</constant>, <constant>TRANSMISSION_MODE_4K</constant></para>
+
+			<para>If <constant>DTV_TRANSMISSION_MODE</constant> is set the <constant>TRANSMISSION_MODE_AUTO</constant> the
+				hardware will try to find the correct FFT-size (if capable) and will
+				use TMCC to fill in the missing parameters.</para>
+
+			<para><constant>TRANSMISSION_MODE_4K</constant> is added at the same time as the other new parameters.</para>
+		</section>
+
+		<section id="isdbt-guard-interval">
+			<title><constant>DTV_GUARD_INTERVAL</constant></title>
+
+			<para>Possible values: <constant>GUARD_INTERVAL_1_32</constant>, <constant>GUARD_INTERVAL_1_16</constant>, <constant>GUARD_INTERVAL_1_8</constant>,
+				<constant>GUARD_INTERVAL_1_4</constant>, <constant>GUARD_INTERVAL_AUTO</constant></para>
+
+			<para>If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
+				try to find the correct guard interval (if capable) and will use TMCC to fill
+				in the missing parameters.</para>
+		</section>
+	</section>
+	<section id="isdbt-new-parms">ISDB-T only parameters
+
+		<section id="isdbt-part-rec">
+			<title><constant>DTV_ISDBT_PARTIAL_RECEPTION</constant></title>
+
+			<para><constant>If DTV_ISDBT_SOUND_BROADCASTING</constant> is '0' this bit-field represents whether
+				the channel is in partial reception mode or not.</para>
+
+			<para>If '1' <constant>DTV_ISDBT_LAYERA_*</constant> values are assigned to the center segment and
+				<constant>DTV_ISDBT_LAYERA_SEGMENT_COUNT</constant> has to be '1'.</para>
+
+			<para>If in addition <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'
+				<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> represents whether this ISDB-Tsb channel
+				is consisting of one segment and layer or three segments and two layers.</para>
+
+			<para>Possible values: 0, 1, -1 (AUTO)</para>
+		</section>
+
+		<section id="isdbt-sound-bcast">
+			<title><constant>DTV_ISDBT_SOUND_BROADCASTING</constant></title>
+
+			<para>This field represents whether the other DTV_ISDBT_*-parameters are
+				referring to an ISDB-T and an ISDB-Tsb channel. (See also
+				<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>).</para>
+
+			Possible values: 0, 1, -1 (AUTO)
+		</section>
+
+		<section id="isdbt-sb-ch-id">
+			<title><constant>DTV_ISDBT_SB_SUBCHANNEL_ID</constant></title>
+
+			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
+
+			<para>(Note of the author: This might not be the correct description of the
+				<constant>SUBCHANNEL-ID</constant> in all details, but it is my understanding of the technical
+				background needed to program a device)</para>
+
+			<para>An ISDB-Tsb channel (1 or 3 segments) can be broadcasted alone or in a
+				set of connected ISDB-Tsb channels. In this set of channels every
+				channel can be received independently. The number of connected
+				ISDB-Tsb segment can vary, e.g. depending on the frequency spectrum
+				bandwidth available.</para>
+
+			<para>Example: Assume 8 ISDB-Tsb connected segments are broadcasted. The
+				broadcaster has several possibilities to put those channels in the
+				air: Assuming a normal 13-segment ISDB-T spectrum he can align the 8
+				segments from position 1-8 to 5-13 or anything in between.</para>
+
+			<para>The underlying layer of segments are subchannels: each segment is
+				consisting of several subchannels with a predefined IDs. A sub-channel
+				is used to help the demodulator to synchronize on the channel.</para>
+
+			<para>An ISDB-T channel is always centered over all sub-channels. As for
+				the example above, in ISDB-Tsb it is no longer as simple as that.</para>
+
+			<para><constant>The DTV_ISDBT_SB_SUBCHANNEL_ID</constant> parameter is used to give the
+				sub-channel ID of the segment to be demodulated.</para>
+
+			<para>Possible values: 0 .. 41, -1 (AUTO)</para>
+		</section>
+
+		<section id="isdbt-sb-seg-idx">
+
+			<title><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant></title>
+
+			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
+
+			<para><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant> gives the index of the segment to be
+				demodulated for an ISDB-Tsb channel where several of them are
+				transmitted in the connected manner.</para>
+
+			<para>Possible values: 0 .. <constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant> - 1</para>
+
+			<para>Note: This value cannot be determined by an automatic channel search.</para>
+		</section>
+
+		<section id="isdbt-sb-seg-cnt">
+			<title><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant></title>
+
+			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
+
+			<para><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant> gives the total count of connected ISDB-Tsb
+				channels.</para>
+
+			<para>Possible values: 1 .. 13</para>
+
+			<para>Note: This value cannot be determined by an automatic channel search.</para>
+		</section>
+
+		<section id="isdb-hierq-layers">
+			<title>Hierarchical layers</title>
+
+			<para>ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
+				ISDB-T hierarchical layers can be decoded simultaneously. For that
+				reason a ISDB-T demodulator has 3 viterbi and 3 reed-solomon-decoders.</para>
+
+			<para>ISDB-T has 3 hierarchical layers which each can use a part of the
+				available segments. The total number of segments over all layers has
+				to 13 in ISDB-T.</para>
+
+			<section id="isdbt-layer-ena">
+				<title><constant>DTV_ISDBT_LAYER_ENABLED</constant></title>
+
+				<para>Hierarchical reception in ISDB-T is achieved by enabling or disabling
+					layers in the decoding process. Setting all bits of
+					<constant>DTV_ISDBT_LAYER_ENABLED</constant> to '1' forces all layers (if applicable) to be
+					demodulated. This is the default.</para>
+
+				<para>If the channel is in the partial reception mode
+					(<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> = 1) the central segment can be decoded
+					independently of the other 12 segments. In that mode layer A has to
+					have a <constant>SEGMENT_COUNT</constant> of 1.</para>
+
+				<para>In ISDB-Tsb only layer A is used, it can be 1 or 3 in ISDB-Tsb
+					according to <constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>. <constant>SEGMENT_COUNT</constant> must be filled
+					accordingly.</para>
+
+				<para>Possible values: 0x1, 0x2, 0x4 (|-able)</para>
+
+				<para><constant>DTV_ISDBT_LAYER_ENABLED[0:0]</constant> - layer A</para>
+				<para><constant>DTV_ISDBT_LAYER_ENABLED[1:1]</constant> - layer B</para>
+				<para><constant>DTV_ISDBT_LAYER_ENABLED[2:2]</constant> - layer C</para>
+				<para><constant>DTV_ISDBT_LAYER_ENABLED[31:3]</constant> unused</para>
+			</section>
+
+			<section id="isdbt-layer-fec">
+				<title><constant>DTV_ISDBT_LAYER*_FEC</constant></title>
+
+				<para>Possible values: <constant>FEC_AUTO</constant>, <constant>FEC_1_2</constant>, <constant>FEC_2_3</constant>, <constant>FEC_3_4</constant>, <constant>FEC_5_6</constant>, <constant>FEC_7_8</constant></para>
+			</section>
+
+			<section id="isdbt-layer-mod">
+				<title><constant>DTV_ISDBT_LAYER*_MODULATION</constant></title>
+
+				<para>Possible values: <constant>QAM_AUTO</constant>, QP<constant>SK, QAM_16</constant>, <constant>QAM_64</constant>, <constant>DQPSK</constant></para>
+
+				<para>Note: If layer C is <constant>DQPSK</constant> layer B has to be <constant>DQPSK</constant>. If layer B is <constant>DQPSK</constant>
+					and <constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>=0 layer has to be <constant>DQPSK</constant>.</para>
+			</section>
+
+			<section id="isdbt-layer-seg-cnt">
+				<title><constant>DTV_ISDBT_LAYER*_SEGMENT_COUNT</constant></title>
+
+				<para>Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)</para>
+
+				<para>Note: Truth table for <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> and
+					<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> and <constant>LAYER</constant>*_SEGMENT_COUNT</para>
+
+				<informaltable id="isdbt-layer_seg-cnt-table">
+					<tgroup cols="6">
+
+						<tbody>
+							<row>
+								<entry>PR</entry>
+								<entry>SB</entry>
+								<entry>Layer A width</entry>
+								<entry>Layer B width</entry>
+								<entry>Layer C width</entry>
+								<entry>total width</entry>
+							</row>
+
+							<row>
+								<entry>0</entry>
+								<entry>0</entry>
+								<entry>1 .. 13</entry>
+								<entry>1 .. 13</entry>
+								<entry>1 .. 13</entry>
+								<entry>13</entry>
+							</row>
+
+							<row>
+								<entry>1</entry>
+								<entry>0</entry>
+								<entry>1</entry>
+								<entry>1 .. 13</entry>
+								<entry>1 .. 13</entry>
+								<entry>13</entry>
+							</row>
+
+							<row>
+								<entry>0</entry>
+								<entry>1</entry>
+								<entry>1</entry>
+								<entry>0</entry>
+								<entry>0</entry>
+								<entry>1</entry>
+							</row>
+
+							<row>
+								<entry>1</entry>
+								<entry>1</entry>
+								<entry>1</entry>
+								<entry>2</entry>
+								<entry>0</entry>
+								<entry>13</entry>
+							</row>
+						</tbody>
+
+					</tgroup>
+				</informaltable>
+
+			</section>
+
+			<section id="isdbt_layer_t_interl">
+				<title><constant>DTV_ISDBT_LAYER*_TIME_INTERLEAVING</constant></title>
+
+				<para>Possible values: 0, 1, 2, 3, -1 (AUTO)</para>
+
+				<para>Note: The real inter-leaver depth-names depend on the mode (fft-size); the values
+					here are referring to what can be found in the TMCC-structure -
+					independent of the mode.</para>
+			</section>
+		</section>
+	</section>
+</section>
\ No newline at end of file
diff -r 258d168cf311 -r 72b7493653f7 media-specs/Makefile
--- a/media-specs/Makefile	Wed Sep 16 16:44:11 2009 -0300
+++ b/media-specs/Makefile	Wed Sep 16 23:22:05 2009 -0300
@@ -115,6 +115,7 @@
 DVB_SGMLS = \
 	dvb/intro.xml \
 	dvb/frontend.xml \
+	dvb/isdbt.xml \
 	dvb/demux.xml \
 	dvb/video.xml \
 	dvb/audio.xml \


---

Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/72b7493653f74bcd0017036afaef924e77eba450




Cheers,
Mauro
