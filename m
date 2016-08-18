Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754702AbcHSDap (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:30:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 12/20] [media] dev-raw-vbi.rst: add a footnote for the count limits
Date: Thu, 18 Aug 2016 13:15:41 -0300
Message-Id: <a732c3e6320dfa6e08cc8d661db9c6113ec2542d.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a bug with LaTeX output on flat-tables with Sphinx 1.4.5
that prevents references at a cell span to be broken. As the
text is indeed too long, it makes sense to place the reference
to the pictures showing the VBI limits as a footnote.

That makes the text easier to read and also solves the issue
with LaTeX output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-raw-vbi.rst | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index 95de08b8fbf2..859b5bc8abbb 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -196,10 +196,9 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 	  driver. Anyway, drivers may not support single field capturing and
 	  return both count values non-zero.
 
-	  Both ``count`` values set to zero, or line numbers outside the
-	  bounds depicted in :ref:`vbi-525` and :ref:`vbi-625`, or a
-	  field image covering lines of two fields, are invalid and shall
-	  not be returned by the driver.
+	  Both ``count`` values set to zero, or line numbers are outside the
+	  bounds depicted\ [#f4]_, or a field image covering lines of two
+	  fields, are invalid and shall not be returned by the driver.
 
 	  To initialize the ``start`` and ``count`` fields, applications
 	  must first determine the current video standard selection. The
@@ -352,3 +351,6 @@ another process.
    Most VBI services transmit on both fields, but some have different
    semantics depending on the field number. These cannot be reliable
    decoded or encoded when ``V4L2_VBI_UNSYNC`` is set.
+
+.. [#f4]
+   The valid values ar shown at :ref:`vbi-525` and :ref:`vbi-625`.
-- 
2.7.4


