Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754632AbcHSDPc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:15:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 05/20] [media] docs-rst: add column hints for pixfmt-002 and pixfmt-006
Date: Thu, 18 Aug 2016 13:15:34 -0300
Message-Id: <f274ff730fd2dab1d61ad16555e520ea8bfbc4ad.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add column hints for LaTeX to format columns on the tables inside
pixfmt-002.rst and pixfmt-006.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-002.rst | 4 +++-
 Documentation/media/uapi/v4l/pixfmt-006.rst | 5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
index 27d4e78760ba..368da55e5f07 100644
--- a/Documentation/media/uapi/v4l/pixfmt-002.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-002.rst
@@ -7,7 +7,9 @@ Single-planar format structure
 
 .. _v4l2-pix-format:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: struct v4l2_pix_format
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index 1c8321f9b1fb..56b691300158 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -25,6 +25,7 @@ needs to be filled in.
    colorspaces except for BT.2020 which uses limited range R'G'B'
    quantization.
 
+.. tabularcolumns:: |p{6.0cm}|p{11.5cm}|
 
 .. _v4l2-colorspace:
 
@@ -183,6 +184,8 @@ needs to be filled in.
 
 .. _v4l2-ycbcr-encoding:
 
+.. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
+
 .. flat-table:: V4L2 Y'CbCr Encodings
     :header-rows:  1
     :stub-columns: 0
@@ -252,6 +255,8 @@ needs to be filled in.
 
 .. _v4l2-quantization:
 
+.. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
+
 .. flat-table:: V4L2 Quantization Methods
     :header-rows:  1
     :stub-columns: 0
-- 
2.7.4


