Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57579 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754702AbcHSDat (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:30:49 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 15/20] [media] dev-sliced-vbi.rst: use a footnote for VBI images
Date: Thu, 18 Aug 2016 13:15:44 -0300
Message-Id: <ff8856adecfeb409b51edfa60aa6f79fe9aa6c40.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like on dvb-raw-vbi.rst, the LaTeX output doesn't work
well with cell spans. Also, this is actually a note, so, move
it to a footnote.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 9f59ba6847ec..9f348e164782 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -155,8 +155,7 @@ struct v4l2_sliced_vbi_format
 	  service the driver chooses.
 
 	  Data services are defined in :ref:`vbi-services2`. Array indices
-	  map to ITU-R line numbers (see also :ref:`vbi-525` and
-	  :ref:`vbi-625`) as follows:
+	  map to ITU-R line numbers\ [#f2]_ as follows:
 
     -  .. row 3
 
@@ -838,3 +837,6 @@ Line Identifiers for struct v4l2_mpeg_vbi_itv0_line id field
 .. [#f1]
    According to :ref:`ETS 300 706 <ets300706>` lines 6-22 of the first
    field and lines 5-22 of the second field may carry Teletext data.
+
+.. [#f2]
+   See also :ref:`vbi-525` and :ref:`vbi-625`.
-- 
2.7.4


