Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51743 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733AbbEaM72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 08:59:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] DocBook media: fix typos
Date: Sun, 31 May 2015 14:59:10 +0200
Message-Id: <1433077152-18200-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

satellital -> satellite
antena -> antenna

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml    | 8 ++++----
 Documentation/DocBook/media/dvb/fe-set-tone.xml    | 2 +-
 Documentation/DocBook/media/dvb/fe-set-voltage.xml | 2 +-
 Documentation/DocBook/media/dvb/frontend.xml       | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index a5d0a20..00bf3ed 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -3,7 +3,7 @@
 <para>Tuning into a Digital TV physical channel and starting decoding it
     requires to change a set of parameters, in order to control the
     tuner, the demodulator, the Linear Low-noise Amplifier (LNA) and to set the
-    antena subsystem via Satellite Equipment Control (SEC), on satellital
+    antenna subsystem via Satellite Equipment Control (SEC), on satellite
     systems. The actual parameters are specific to each particular digital
     TV standards, and may change as the digital TV specs evolutes.</para>
 <para>In the past, the strategy used were to have an union with the parameters
@@ -171,7 +171,7 @@ get/set up to 64 properties. The actual meaning of each property is described on
 		<para>Central frequency of the channel.</para>
 
 		<para>Notes:</para>
-		<para>1)For satellital delivery systems, it is measured in kHz.
+		<para>1)For satellite delivery systems, it is measured in kHz.
 			For the other ones, it is measured in Hz.</para>
 		<para>2)For ISDB-T, the channels are usually transmitted with an offset of 143kHz.
 			E.g. a valid frequency could be 474143 kHz. The stepping is bound to the bandwidth of
@@ -1434,8 +1434,8 @@ enum fe_interleaving {
 		<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 	</section>
 	</section>
-	<section id="frontend-property-satellital-systems">
-	<title>Properties used on satellital delivery systems</title>
+	<section id="frontend-property-satellite-systems">
+	<title>Properties used on satellite delivery systems</title>
 	<section id="dvbs-params">
 		<title>DVB-S delivery system</title>
 		<para>The following parameters are valid for DVB-S:</para>
diff --git a/Documentation/DocBook/media/dvb/fe-set-tone.xml b/Documentation/DocBook/media/dvb/fe-set-tone.xml
index f3d9655..4ef6c74 100644
--- a/Documentation/DocBook/media/dvb/fe-set-tone.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-tone.xml
@@ -49,7 +49,7 @@
 
 <para>This ioctl is used to set the generation of the continuous 22kHz tone.
     This call requires read/write permissions.</para>
-<para>Usually, satellital antenna subsystems require that the digital TV
+<para>Usually, satellite antenna subsystems require that the digital TV
     device to send a 22kHz tone in order to select between high/low band on
     some dual-band LNBf. It is also used to send signals to DiSEqC equipment,
     but this is done using the DiSEqC ioctls.</para>
diff --git a/Documentation/DocBook/media/dvb/fe-set-voltage.xml b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
index d43d51a..688fbc2 100644
--- a/Documentation/DocBook/media/dvb/fe-set-voltage.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
@@ -49,7 +49,7 @@
 
 <para>This ioctl allows to set the DC voltage level sent through the antenna
     cable to 13V, 18V or off.</para>
-<para>Usually, a satellital antenna subsystems require that the digital TV
+<para>Usually, a satellite antenna subsystems require that the digital TV
     device to send a DC voltage to feed power to the LNBf. Depending on the
     LNBf type, the polarization or the intermediate frequency (IF) of the LNBf
     can controlled by the voltage level. Other devices (for example, the ones
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index d81b3ff..9eda6c0 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -4,7 +4,7 @@
 <itemizedlist>
     <listitem>Terrestrial systems: DVB-T, DVB-T2, ATSC, ATSC M/H, ISDB-T, DVB-H, DTMB, CMMB</listitem>
     <listitem>Cable systems: DVB-C Annex A/C, ClearQAM (DVB-C Annex B), ISDB-C</listitem>
-    <listitem>Satellital systems: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS</listitem>
+    <listitem>Satellite systems: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS</listitem>
 </itemizedlist>
 <para>The DVB frontend controls several sub-devices including:</para>
 <itemizedlist>
@@ -21,7 +21,7 @@
 
 <para>NOTE: Transmission via the internet (DVB-IP)
     is not yet handled by this API but a future extension is possible.</para>
-<para>On Satellital systems, the API support for the Satellite Equipment Control
+<para>On Satellite systems, the API support for the Satellite Equipment Control
     (SEC) allows to power control and to send/receive signals to control the
     antenna subsystem, selecting the polarization and choosing the Intermediate
     Frequency IF) of the Low Noise Block Converter Feed Horn (LNBf). It
-- 
2.1.4

