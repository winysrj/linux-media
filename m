Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:47547 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbeCURtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 13:49:53 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Luca Ceresoli <luca@lucaceresoli.net>
Subject: [PATCH] media: doc: fix ReST link syntax
Date: Wed, 21 Mar 2018 18:49:39 +0100
Message-Id: <1521654579-31272-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a ':' i excess, resulting in an unwanted ':' in the rendered
output.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 Documentation/media/kapi/v4l2-dev.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
index 7bb0505b60f1..eb03ccc41c41 100644
--- a/Documentation/media/kapi/v4l2-dev.rst
+++ b/Documentation/media/kapi/v4l2-dev.rst
@@ -31,7 +31,7 @@ of the video device exits.
 The default :c:func:`video_device_release` callback currently
 just calls ``kfree`` to free the allocated memory.
 
-There is also a ::c:func:`video_device_release_empty` function that does
+There is also a :c:func:`video_device_release_empty` function that does
 nothing (is empty) and should be used if the struct is embedded and there
 is nothing to do when it is released.
 
-- 
2.7.4
