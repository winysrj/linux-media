Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbcGUUUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:20:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/5] [media] mc-core: Fix a cross-reference
Date: Thu, 21 Jul 2016 17:19:51 -0300
Message-Id: <464178b2a9459d5a64b90941112e6a6b8d5d9dbd.1469132350.git.mchehab@s-opensource.com>
In-Reply-To: <803a5c1a8b6cd3f593833cc883788fb120343cd6.1469132350.git.mchehab@s-opensource.com>
References: <803a5c1a8b6cd3f593833cc883788fb120343cd6.1469132350.git.mchehab@s-opensource.com>
In-Reply-To: <803a5c1a8b6cd3f593833cc883788fb120343cd6.1469132350.git.mchehab@s-opensource.com>
References: <803a5c1a8b6cd3f593833cc883788fb120343cd6.1469132350.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_subdev reference was using the wrong tag. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/mc-core.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 4c47f5e3611d..deae3b7c692d 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -50,7 +50,7 @@ Entities
 Entities are represented by a :c:type:`struct media_entity <media_entity>`
 instance, defined in ``include/media/media-entity.h``. The structure is usually
 embedded into a higher-level structure, such as
-:ref:`v4l2_subdev` or :ref:`video_device`
+:c:type:`v4l2_subdev` or :c:type:`video_device`
 instances, although drivers can allocate entities directly.
 
 Drivers initialize entity pads by calling
-- 
2.7.4

