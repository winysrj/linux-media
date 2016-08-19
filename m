Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43180 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754702AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 08/15] [media] fix v4l2-selection-*.rst tables for LaTeX output
Date: Fri, 19 Aug 2016 10:04:58 -0300
Message-Id: <3412a26e86a0914b817c8edafaae6730c10fd5a8.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the tables there to fit inside the page margins.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/v4l2-selection-flags.rst   | 1 +
 Documentation/media/uapi/v4l/v4l2-selection-targets.rst | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Documentation/media/uapi/v4l/v4l2-selection-flags.rst b/Documentation/media/uapi/v4l/v4l2-selection-flags.rst
index 3ce3731faf5f..9ef139f8e21d 100644
--- a/Documentation/media/uapi/v4l/v4l2-selection-flags.rst
+++ b/Documentation/media/uapi/v4l/v4l2-selection-flags.rst
@@ -6,6 +6,7 @@
 Selection flags
 ***************
 
+.. tabularcolumns:: |p{5.2cm}|p{2.0cm}|p{6.5cm}|p{1.2cm}|p{1.6cm}|
 
 .. _v4l2-selection-flags-table:
 
diff --git a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
index 7519099a50cd..a82b58f5ebcf 100644
--- a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
+++ b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
@@ -12,6 +12,8 @@ of the two interfaces they are used.
 
 .. _v4l2-selection-targets-table:
 
+.. tabularcolumns:: |p{5.8cm}|p{1.4cm}|p{6.5cm}|p{1.2cm}|p{1.6cm}|
+
 .. flat-table:: Selection target definitions
     :header-rows:  1
     :stub-columns: 0
-- 
2.7.4


