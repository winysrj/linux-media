Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3080 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2HNKKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 06:10:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/2] DocBook: update RDS references to the latest RDS standards.
Date: Tue, 14 Aug 2012 12:10:02 +0200
Message-Id: <9b0515fba6bec914f362b5784a31b49968690b15.1344938890.git.hans.verkuil@cisco.com>
In-Reply-To: <1344939002-2059-1-git-send-email-hverkuil@xs4all.nl>
References: <1344939002-2059-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c074996da4c197148a64fceefa6aac5090707691.1344938890.git.hans.verkuil@cisco.com>
References: <c074996da4c197148a64fceefa6aac5090707691.1344938890.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/biblio.xml   |   12 ++++++------
 Documentation/DocBook/media/v4l/controls.xml |    6 +++---
 Documentation/DocBook/media/v4l/dev-rds.xml  |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index 1078e45..18b6fc9 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -178,23 +178,23 @@ Signal - NTSC for Studio Applications"</title>
 1125-Line High-Definition Production"</title>
     </biblioentry>
 
-    <biblioentry id="en50067">
-      <abbrev>EN&nbsp;50067</abbrev>
+    <biblioentry id="iec62106">
+      <abbrev>IEC&nbsp;62106</abbrev>
       <authorgroup>
-	<corpauthor>European Committee for Electrotechnical Standardization
-(<ulink url="http://www.cenelec.eu">http://www.cenelec.eu</ulink>)</corpauthor>
+	<corpauthor>International Electrotechnical Commission
+(<ulink url="http://www.iec.ch">http://www.iec.ch</ulink>)</corpauthor>
       </authorgroup>
       <title>Specification of the radio data system (RDS) for VHF/FM sound broadcasting
 in the frequency range from 87,5 to 108,0 MHz</title>
     </biblioentry>
 
     <biblioentry id="nrsc4">
-      <abbrev>NRSC-4</abbrev>
+      <abbrev>NRSC-4-B</abbrev>
       <authorgroup>
 	<corpauthor>National Radio Systems Committee
 (<ulink url="http://www.nrscstandards.org">http://www.nrscstandards.org</ulink>)</corpauthor>
       </authorgroup>
-      <title>NRSC-4: United States RBDS Standard</title>
+      <title>NRSC-4-B: United States RBDS Standard</title>
     </biblioentry>
 
     <biblioentry id="iso12232">
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 93dc48b..93b9c68 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3505,7 +3505,7 @@ This encodes up to 31 pre-defined programme types.</entry>
 	  </row>
 	  <row><entry spanname="descr">Sets the Programme Service name (PS_NAME) for transmission.
 It is intended for static display on a receiver. It is the primary aid to listeners in programme service
-identification and selection.  In Annex E of <xref linkend="en50067" />, the RDS specification,
+identification and selection.  In Annex E of <xref linkend="iec62106" />, the RDS specification,
 there is a full description of the correct character encoding for Programme Service name strings.
 Also from RDS specification, PS is usually a single eight character text. However, it is also possible
 to find receivers which can scroll strings sized as 8 x N characters. So, this control must be configured
@@ -3519,7 +3519,7 @@ with steps of 8 characters. The result is it must always contain a string with s
 what is being broadcasted. RDS Radio Text can be applied when broadcaster wishes to transmit longer PS names,
 programme-related information or any other text. In these cases, RadioText should be used in addition to
 <constant>V4L2_CID_RDS_TX_PS_NAME</constant>. The encoding for Radio Text strings is also fully described
-in Annex E of <xref linkend="en50067" />. The length of Radio Text strings depends on which RDS Block is being
+in Annex E of <xref linkend="iec62106" />. The length of Radio Text strings depends on which RDS Block is being
 used to transmit it, either 32 (2A block) or 64 (2B block).  However, it is also possible
 to find receivers which can scroll strings sized as 32 x N or 64 x N characters. So, this control must be configured
 with steps of 32 or 64 characters. The result is it must always contain a string with size multiple of 32 or 64. </entry>
@@ -3650,7 +3650,7 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
       </table>
 
 <para>For more details about RDS specification, refer to
-<xref linkend="en50067" /> document, from CENELEC.</para>
+<xref linkend="iec62106" /> document, from CENELEC.</para>
     </section>
 
     <section id="flash-controls">
diff --git a/Documentation/DocBook/media/v4l/dev-rds.xml b/Documentation/DocBook/media/v4l/dev-rds.xml
index 38883a4..be2f337 100644
--- a/Documentation/DocBook/media/v4l/dev-rds.xml
+++ b/Documentation/DocBook/media/v4l/dev-rds.xml
@@ -6,7 +6,7 @@ information, on an inaudible audio subcarrier of a radio program. This
 interface is aimed at devices capable of receiving and/or transmitting RDS
 information.</para>
 
-      <para>For more information see the core RDS standard <xref linkend="en50067" />
+      <para>For more information see the core RDS standard <xref linkend="iec62106" />
 and the RBDS standard <xref linkend="nrsc4" />.</para>
 
       <para>Note that the RBDS standard as is used in the USA is almost identical
-- 
1.7.10.4

