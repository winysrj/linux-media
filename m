Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41486 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbcGHNEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 20/54] doc-rst: media-controller-model: fix a typo
Date: Fri,  8 Jul 2016 10:03:12 -0300
Message-Id: <32ad2075a45a65ff3e76430e7e326f3529e98ffc.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove a 'm' at the end of the last phrase.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/mediactl/media-controller-model.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/linux_tv/media/mediactl/media-controller-model.rst b/Documentation/linux_tv/media/mediactl/media-controller-model.rst
index 7be58aecb882..558273cf9570 100644
--- a/Documentation/linux_tv/media/mediactl/media-controller-model.rst
+++ b/Documentation/linux_tv/media/mediactl/media-controller-model.rst
@@ -32,4 +32,4 @@ are:
    from a source pad to a sink pad.
 
 -  An **interface link** is a point-to-point bidirectional control
-   connection between a Linux Kernel interface and an entity.m
+   connection between a Linux Kernel interface and an entity.
-- 
2.7.4

