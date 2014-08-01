Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:50570 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbaHAPD0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 11:03:26 -0400
Received: from pps.filterd (m0046670.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.14.5/8.14.5) with SMTP id s71ExcBo016213
	for <linux-media@vger.kernel.org>; Fri, 1 Aug 2014 17:03:25 +0200
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
	by mx07-00178001.pphosted.com with ESMTP id 1nfm837snd-1
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Fri, 01 Aug 2014 17:03:25 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 98E5031
	for <linux-media@vger.kernel.org>; Fri,  1 Aug 2014 15:03:20 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas4.st.com [10.75.90.69])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B89BD5A2F0
	for <linux-media@vger.kernel.org>; Fri,  1 Aug 2014 15:03:22 +0000 (GMT)
From: Jean-Marc VOLLE <jean-marc.volle@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>
Date: Fri, 1 Aug 2014 17:02:51 +0200
Subject: [PATCH] ITU BT2020 support in v4l2_colorspace
Message-ID: <1406905371-17609-1-git-send-email-jean-marc.volle@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: vollejm <jean-marc.volle@st.com>

UHD video content may be encoded using a new color space (BT2020). This patch
adds it to the  v4l2_colorspace enum


Signed-off-by: <jean-marc.volle@st.com>
---
 Documentation/DocBook/media/v4l/biblio.xml | 10 ++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml | 14 ++++++++++++++
 include/uapi/linux/videodev2.h             |  4 ++++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index d2eb79e..d3930cf 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -117,6 +117,16 @@ url="http://www.itu.ch">http://www.itu.ch</ulink>)</corpauthor>
       <title>ITU-R Recommendation BT.1119 "625-line
 television Wide Screen Signalling (WSS)"</title>
     </biblioentry>
+    <biblioentry id="itu2020">
+      <abbrev>ITU&nbsp;BT.2020</abbrev>
+      <authorgroup>
+	<corpauthor>International Telecommunication Union (<ulink
+url="http://www.itu.ch">http://www.itu.ch</ulink>)</corpauthor>
+      </authorgroup>
+      <title>ITU-R Recommendation BT.2020 "Parameter values for
+	      ultra-high definition television systems for production
+	      and international programme exchange"</title>
+    </biblioentry>
 
     <biblioentry id="jfif">
       <abbrev>JFIF</abbrev>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 91dcbc8..f0c70dd 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -599,6 +599,20 @@ are still clamped to [0;255].</para>
 1.099&nbsp;I<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&lt;&nbsp;I</entry>
 	    <entry spanname="spam">n/a</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_COLORSPACE_BT2020</constant></entry>
+	    <entry>9</entry>
+	    <entry>BT2020, see <xref linkend="itu2020" /></entry>
+	    <entry>x&nbsp;=&nbsp;0.708, y&nbsp;=&nbsp;0.292</entry>
+	    <entry>x&nbsp;=&nbsp;0.170, y&nbsp;=&nbsp;0.797</entry>
+	    <entry>x&nbsp;=&nbsp;0.131, y&nbsp;=&nbsp;0.046</entry>
+	    <entry>x&nbsp;=&nbsp;0.3127, y&nbsp;=&nbsp;0.3290,
+	    Illuminant D<subscript>65</subscript></entry>
+	    <entry>see <xref linkend="itu2020" /></entry>
+	    <entry>see <xref linkend="itu2020" /></entry>
+	    <entry>see <xref linkend="itu2020" /></entry>
+	    <entry>see <xref linkend="itu2020" /></entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 168ff50..6af06e1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -197,6 +197,10 @@ enum v4l2_colorspace {
 
 	/* For RGB colourspaces, this is probably a good start. */
 	V4L2_COLORSPACE_SRGB          = 8,
+
+	/* UHD BT2020 colorspace */
+	V4L2_COLORSPACE_BT2020          = 9,
+
 };
 
 enum v4l2_priority {
-- 
1.9.1
