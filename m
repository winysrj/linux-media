Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53797 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753215AbeBCTSn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 14:18:43 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-ioc-g-topology.rst: fix interface-to-entity link
 description
Message-ID: <2447b7c8-b707-e98a-db92-fb55a1894f6c@xs4all.nl>
Date: Sat, 3 Feb 2018 20:18:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The source_id and sink_id descriptions were the same for interface-to-entity
links. The source_id is the interface ID, not the entity ID. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 997e6b17440d..870a6c0d1f7a 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -334,7 +334,7 @@ desired arrays with the media graph elements.

        -  On pad to pad links: unique ID for the source pad.

-	  On interface to entity links: unique ID for the entity.
+	  On interface to entity links: unique ID for the interface.

     -  .. row 3
