Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbLQLJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 06:09:42 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH] [media] uapi/media.h: Use u32 for the number of graph objects
Date: Thu, 17 Dec 2015 09:09:21 -0200
Message-Id: <40e950dbb6a3b7f73da52e147fa51441b762131a.1450350558.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While we need to keep a u64 alignment to avoid compat32 issues,
having the number of entities/pads/links/interfaces represented
by an u64 is incoherent with the ID number, with is an u32.

In order to make it coherent, change those quantities to u32.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/uapi/linux/media.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index cacfceb0d81d..5dbb208e5451 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -330,16 +330,20 @@ struct media_v2_link {
 struct media_v2_topology {
 	__u64 topology_version;
 
-	__u64 num_entities;
+	__u32 num_entities;
+	__u32 reserved1;
 	__u64 ptr_entities;
 
-	__u64 num_interfaces;
+	__u32 num_interfaces;
+	__u32 reserved2;
 	__u64 ptr_interfaces;
 
-	__u64 num_pads;
+	__u32 num_pads;
+	__u32 reserved3;
 	__u64 ptr_pads;
 
-	__u64 num_links;
+	__u32 num_links;
+	__u32 reserved4;
 	__u64 ptr_links;
 };
 
-- 
2.5.0

