Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:47963 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752053AbeBHIhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:37:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 08/15] media-ioc-g-topology.rst: fix interface-to-entity link description
Date: Thu,  8 Feb 2018 09:36:48 +0100
Message-Id: <20180208083655.32248-9-hverkuil@xs4all.nl>
In-Reply-To: <20180208083655.32248-1-hverkuil@xs4all.nl>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The source_id and sink_id descriptions were the same for interface-to-entity
links. The source_id is the interface ID, not the entity ID. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 997e6b17440d..870a6c0d1f7a 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -334,7 +334,7 @@ desired arrays with the media graph elements.
 
        -  On pad to pad links: unique ID for the source pad.
 
-	  On interface to entity links: unique ID for the entity.
+	  On interface to entity links: unique ID for the interface.
 
     -  .. row 3
 
-- 
2.15.1
