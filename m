Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43797 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941748AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 47/47] [media] rc-map.h: fix a Sphinx warning
Date: Thu,  8 Sep 2016 09:04:09 -0300
Message-Id: <9ad4d4cd915ceb891f120c9b9f594598fafe5762.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	./include/media/rc-map.h:121: WARNING: Inline emphasis start-string without end-string.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/rc-map.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 173ad58fb61b..3c8edb34f84a 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -117,7 +117,7 @@ struct rc_map_table {
  * @scan: pointer to struct &rc_map_table
  * @size: Max number of entries
  * @len: Number of entries that are in use
- * @alloc: size of *scan, in bytes
+ * @alloc: size of \*scan, in bytes
  * @rc_type: type of the remote controller protocol, as defined at
  *	     enum &rc_type
  * @name: name of the key map table
-- 
2.7.4


