Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754322AbcHSDqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 20/20] [media] diff-v4l.rst: Make capabilities table fit in LaTeX
Date: Thu, 18 Aug 2016 13:15:49 -0300
Message-Id: <9c5cc2e8a1f01eb7418967c0cf75a7f579e5403e.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This table has several troubles:
	- a duplicated "struct" on its name;
	- a reference to a V4L version 1 struct that will never
	  point to something (as we got rid of V4L1 API a long
	  time ago);
	- misses hints for LaTeX output (column size and longtable
	  style).

Fix them.

It should be noticed that the first column of this table is
not aligned with the rest. I suspect that this is a bug at
the flat-table extension.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/diff-v4l.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/diff-v4l.rst b/Documentation/media/uapi/v4l/diff-v4l.rst
index e1e034df514c..93263e477127 100644
--- a/Documentation/media/uapi/v4l/diff-v4l.rst
+++ b/Documentation/media/uapi/v4l/diff-v4l.rst
@@ -95,7 +95,9 @@ and radio devices supporting a set of related functions like video
 capturing, video overlay and VBI capturing. See :ref:`open` for an
 introduction.
 
+.. tabularcolumns:: |p{5.5cm}|p{6.5cm}|p{5.5cm}
 
+.. cssclass:: longtable
 
 .. flat-table::
     :header-rows:  1
@@ -104,7 +106,7 @@ introduction.
 
     -  .. row 1
 
-       -  struct :c:type:`struct video_capability` ``type``
+       -  ``struct video_capability`` ``type``
 
        -  struct :ref:`v4l2_capability <v4l2-capability>`
 	  ``capabilities`` flags
-- 
2.7.4


