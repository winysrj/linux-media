Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57556 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754690AbcHSDaq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:30:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 16/20] [media] dev-sliced-vbi.rst: Adjust tables on LaTeX output
Date: Thu, 18 Aug 2016 13:15:45 -0300
Message-Id: <87391ed7cdb51e1167cab7475a3a2fa2fea1bb2e.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better format the tables in a way that will fit inside the
page.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst | 34 +++++++++++++++++--------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 9f348e164782..074aa3798152 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -105,7 +105,9 @@ which may return ``EBUSY`` can be the
 struct v4l2_sliced_vbi_format
 -----------------------------
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|
+.. tabularcolumns:: |p{1.0cm}|p{4.5cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|
+
+.. cssclass:: longtable
 
 .. flat-table::
     :header-rows:  0
@@ -242,16 +244,20 @@ struct v4l2_sliced_vbi_format
        -  ``reserved``\ [2]
 
        -  :cspan:`2` This array is reserved for future extensions.
+
 	  Applications and drivers must set it to zero.
 
 
-
 .. _vbi-services2:
 
 Sliced VBI services
 -------------------
 
-.. tabularcolumns:: |p{4.4cm}|p{2.2cm}|p{2.2cm}|p{4.4cm}|p{4.3cm}|
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{5.0cm}|p{1.4cm}|p{3.0cm}|p{2.5cm}|p{9.0cm}|
 
 .. flat-table::
     :header-rows:  1
@@ -277,7 +283,9 @@ Sliced VBI services
 
        -  0x0001
 
-       -  :ref:`ets300706`, :ref:`itu653`
+       -  :ref:`ets300706`,
+
+	  :ref:`itu653`
 
        -  PAL/SECAM line 7-22, 320-335 (second field 7-22)
 
@@ -316,7 +324,9 @@ Sliced VBI services
 
        -  0x4000
 
-       -  :ref:`itu1119`, :ref:`en300294`
+       -  :ref:`itu1119`,
+
+	  :ref:`en300294`
 
        -  PAL/SECAM line 23
 
@@ -344,6 +354,10 @@ Sliced VBI services
 
        -  :cspan:`2` Set of services applicable to 625 line systems.
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
+
 
 Drivers may return an ``EINVAL`` error code when applications attempt to
 read or write data without prior format negotiation, after switching the
@@ -561,7 +575,7 @@ number).
 struct v4l2_mpeg_vbi_fmt_ivtv
 -----------------------------
 
-.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+.. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{1.0cm}|p{11.5cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -661,7 +675,7 @@ Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
 struct v4l2_mpeg_vbi_itv0
 -------------------------
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{4.4cm}|p{2.4cm}|p{10.7cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -687,9 +701,9 @@ struct v4l2_mpeg_vbi_itv0
 	  ::
 
 	      linemask[0] b0:     line  6     first field
-	      linemask[0] b17:        line 23     first field
-	      linemask[0] b18:        line  6     second field
-	      linemask[0] b31:        line 19     second field
+	      linemask[0] b17:    line 23     first field
+	      linemask[0] b18:    line  6     second field
+	      linemask[0] b31:    line 19     second field
 	      linemask[1] b0:     line 20     second field
 	      linemask[1] b3:     line 23     second field
 	      linemask[1] b4-b31: unused and set to 0
-- 
2.7.4


