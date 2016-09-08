Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43805 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941747AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 45/47] [media] media-ioc-g-topology.rst: fix a c domain reference
Date: Thu,  8 Sep 2016 09:04:07 -0300
Message-Id: <61ff79392c9eece5f0ba9443b4813d13aadda5c5.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One reference there is still using :ref:. Fix it, to solve this
warning:
  Documentation/media/uapi/mediactl/media-ioc-g-topology.rst:236: WARNING: undefined label: media-v2-intf-devnode (if the link has no caption the label must precede a section header)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 0b26fd865b72..48c9531f4db0 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -234,7 +234,7 @@ desired arrays with the media graph elements.
        -  ``devnode``
 
        -  Used only for device node interfaces. See
-	  :ref:`media-v2-intf-devnode` for details..
+	  :c:type:`media_v2_intf_devnode` for details..
 
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
-- 
2.7.4


