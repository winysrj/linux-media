Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:37237 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab3A1VqD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 16:46:03 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@amarulasolutions.com>,
	linux-doc@vger.kernel.org,
	Michael Trimarchi <michael@amarulasolutions.com>
Subject: [PATCH 1/2] [media] Documentation/media-framework.txt: fix a sentence
Date: Mon, 28 Jan 2013 22:45:31 +0100
Message-Id: <1359409532-32088-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1359409532-32088-1-git-send-email-ospite@studenti.unina.it>
References: <1359409532-32088-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antonio Ospite <ao2@amarulasolutions.com>

Signed-off-by: Antonio Ospite <ao2@amarulasolutions.com>
---

Hi,

Actually I am not 100% sure whether the old form was correct English
already or not but the new one sounds better to me.

Thanks,
   Antonio

 Documentation/media-framework.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 8028754..77bd0a4 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -336,7 +336,7 @@ Calls to media_entity_pipeline_start() can be nested. The pipeline pointer must
 be identical for all nested calls to the function.
 
 media_entity_pipeline_start() may return an error. In that case, it will
-clean up any the changes it did by itself.
+clean up any of the changes it did by itself.
 
 When stopping the stream, drivers must notify the entities with
 
-- 
1.7.10.4

