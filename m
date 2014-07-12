Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaGLAh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 20:37:57 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] DocBook: Fix ISDB-T Interleaving property
Date: Fri, 11 Jul 2014 21:37:46 -0300
Message-Id: <1405125468-4748-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1405125468-4748-1-git-send-email-m.chehab@samsung.com>
References: <1405125468-4748-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DocBook documentation is incorrect: on ISDB-T, interleaving
time is always a power of 2. Fix it and provides a table showing
the actual interleaving length for each mode.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml | 44 ++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 24c22cabc668..948ddaab592e 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -555,10 +555,46 @@ typedef enum fe_delivery_system {
 		</section>
 		<section id="DTV-ISDBT-LAYER-TIME-INTERLEAVING">
 			<title><constant>DTV_ISDBT_LAYER*_TIME_INTERLEAVING</constant></title>
-			<para>Possible values: 0, 1, 2, 3, -1 (AUTO)</para>
-			<para>Note: The real inter-leaver depth-names depend on the mode (fft-size); the values
-				here are referring to what can be found in the TMCC-structure -
-				independent of the mode.</para>
+			<para>Valid values: 0, 1, 2, 4, -1 (AUTO)</para>
+			<para>when DTV_ISDBT_SOUND_BROADCASTING is active, value 8 is also valid.</para>
+			<para>Note: The real time interleaving length depends on the mode (fft-size). The values
+				here are referring to what can be found in the TMCC-structure, as shown in the table below.</para>
+			<informaltable id="isdbt-layer-interleaving-table">
+				<tgroup cols="4" align="center">
+					<tbody>
+						<row>
+							<entry>DTV_ISDBT_LAYER*_TIME_INTERLEAVING</entry>
+							<entry>Mode 1 (2K FFT)</entry>
+							<entry>Mode 2 (4K FFT)</entry>
+							<entry>Mode 3 (8K FFT)</entry>
+						</row>
+						<row>
+							<entry>0</entry>
+							<entry>0</entry>
+							<entry>0</entry>
+							<entry>0</entry>
+						</row>
+						<row>
+							<entry>1</entry>
+							<entry>4</entry>
+							<entry>2</entry>
+							<entry>1</entry>
+						</row>
+						<row>
+							<entry>2</entry>
+							<entry>8</entry>
+							<entry>4</entry>
+							<entry>2</entry>
+						</row>
+						<row>
+							<entry>4</entry>
+							<entry>16</entry>
+							<entry>8</entry>
+							<entry>4</entry>
+						</row>
+					</tbody>
+				</tgroup>
+			</informaltable>
 		</section>
 		<section id="DTV-ATSCMH-FIC-VER">
 			<title><constant>DTV_ATSCMH_FIC_VER</constant></title>
-- 
1.9.3

