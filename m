Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47977 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755032AbcHVOFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 10:05:41 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH] docs-rst: add package adjustbox
Date: Mon, 22 Aug 2016 11:04:49 -0300
Message-Id: <1f1ca6f00b0e60054f89b97ba5cc2ba9cade7e73.1471874617.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need adjustbox to allow adjusting the size of tables that
are bigger than the line width. There are quite a few of them
at the media books.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

PS.: This changeset were fold into one of the media patches on a previous
patch series. However, in order to avoid merge conflicts during he merge
window, better to split and submit it via docs-next tree.

 Documentation/conf.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 42045c26581b..c25e95d46272 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -326,6 +326,9 @@ latex_elements = {
         \\setromanfont{DejaVu Sans}
         \\setmonofont{DejaVu Sans Mono}
 
+	% To allow adjusting table sizes
+	\\usepackage{adjustbox}
+
      '''
 }
 
-- 
2.7.4


