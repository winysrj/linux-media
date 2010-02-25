Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab0BYReA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 12:34:00 -0500
Date: Thu, 25 Feb 2010 14:33:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 3/4] DocBook/v4l/pixfmt.xml: Add missing formats for gspca
 cpia1 and sn9c2028 drivers
Message-ID: <20100225143327.0466365f@pedra>
In-Reply-To: <c541522de5dec33a56dbe94a26fadf400fd7e536.1267119175.git.mchehab@redhat.com>
References: <c541522de5dec33a56dbe94a26fadf400fd7e536.1267119175.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index 885968d..6e38f50 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -685,6 +685,11 @@ http://www.ivtvdriver.org/</ulink></para><para>The format is documented in the
 kernel sources in the file <filename>Documentation/video4linux/cx2341x/README.hm12</filename>
 </para></entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-CPIA1">
+	    <entry><constant>V4L2_PIX_FMT_CPIA1</constant></entry>
+	    <entry>'CPIA'</entry>
+	    <entry>YUV format used by the gspca cpia1 driver.</entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-SPCA501">
 	    <entry><constant>V4L2_PIX_FMT_SPCA501</constant></entry>
 	    <entry>'S501'</entry>
@@ -770,6 +775,11 @@ kernel sources in the file <filename>Documentation/video4linux/cx2341x/README.hm
 	    <entry>'S920'</entry>
 	    <entry>YUV 4:2:0 format of the gspca sn9c20x driver.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-SN9C2028">
+	    <entry><constant>V4L2_PIX_FMT_SN9C2028</constant></entry>
+	    <entry>'SONX'</entry>
+	    <entry>Compressed GBRG bayer format of the gspca sn9c2028 driver.</entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-STV0680">
 	    <entry><constant>V4L2_PIX_FMT_STV0680</constant></entry>
 	    <entry>'S680'</entry>
-- 
1.6.6.1


