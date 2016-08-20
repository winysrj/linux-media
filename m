Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48540 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752822AbcHTMwM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 08:52:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/2] [media] v4l2-dev.rst: adjust table to fit into page
Date: Sat, 20 Aug 2016 09:51:53 -0300
Message-Id: <4b05049d2020b3ec4c6ececf232bc035a598126f.1471697421.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One table here is not being properly displayed on LaTeX
format. Adjust it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-dev.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
index 821b835be3c8..d07258a362d1 100644
--- a/Documentation/media/kapi/v4l2-dev.rst
+++ b/Documentation/media/kapi/v4l2-dev.rst
@@ -262,6 +262,7 @@ file operations.
 
 It is a bitmask and the following bits can be set:
 
+.. tabularcolumns:: |p{5ex}|L|
 
 ===== ================================================================
 Mask  Description
-- 
2.7.4

