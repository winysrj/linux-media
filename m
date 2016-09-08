Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44151 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941752AbcIHMEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 09/47] [media] mc-core.rst: Fix cross-references to the source
Date: Thu,  8 Sep 2016 09:03:31 -0300
Message-Id: <8688330d281cf2dccbc7025d06b2de2895ad21c8.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cross-reference to "struct media_pad" was pointing to
a place that doesn't exist. Fix it, and adjust the second
reference on the same paragraph to use the same text.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/mc-core.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 569cfc4f01cd..fb839a6c1f46 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -85,8 +85,9 @@ a driver-specific structure.
 Pads are identified by their entity and their 0-based index in the pads
 array.
 
-Both information are stored in the :c:type:`struct media_pad`, making the
-:c:type:`media_pad` pointer the canonical way to store and pass link references.
+Both information are stored in the :c:type:`struct media_pad <media_pad>`,
+making the :c:type:`struct media_pad <media_pad>` pointer the canonical way
+to store and pass link references.
 
 Pads have flags that describe the pad capabilities and state.
 
-- 
2.7.4


