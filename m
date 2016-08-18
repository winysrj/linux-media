Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57501 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754618AbcHSDai (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:30:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 13/20] [media] dev-raw-vbi.rst: adjust table columns for LaTeX output
Date: Thu, 18 Aug 2016 13:15:42 -0300
Message-Id: <60a2303eafe3d220277c035c51c4d6b57518e115.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the needed tags to fix LaTeX output of the tables there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-raw-vbi.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index 859b5bc8abbb..1b59239c7fb7 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -102,7 +102,9 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _v4l2-vbi-format:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{2.4cm}|p{4.4cm}|p{10.7cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: struct v4l2_vbi_format
     :header-rows:  0
@@ -228,7 +230,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _vbifmt-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+.. tabularcolumns:: |p{4.0cm}|p{1.5cm}|p{12.0cm}|
 
 .. flat-table:: Raw VBI Format Flags
     :header-rows:  0
-- 
2.7.4


