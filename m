Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:46709 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753478AbeDCVQB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 17:16:01 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5/5] media: docs: selection: fix misleading sentence about the CROP API
Date: Tue,  3 Apr 2018 23:15:46 +0200
Message-Id: <1522790146-16061-5-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
References: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The API limitation described here is about the CROP API, not about the
entire V4L2.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst b/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
index ba1064a244a0..e7455fb1e572 100644
--- a/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
+++ b/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
@@ -15,7 +15,7 @@ because the described operation is actually the composing. The
 selection API makes a clear distinction between composing and cropping
 operations by setting the appropriate targets.
 
-The V4L2 API lacks any support for composing to and cropping from an
+The CROP API lacks any support for composing to and cropping from an
 image inside a memory buffer. The application could configure a
 capture device to fill only a part of an image by abusing V4L2
 API. Cropping a smaller image from a larger one is achieved by setting
-- 
2.7.4
