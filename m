Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:45043 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727067AbeKOR4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 12:56:12 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cedrus: add action item to the TODO
Message-ID: <99a00f6e-3cd7-b063-107f-ec27c5c9833d@xs4all.nl>
Date: Thu, 15 Nov 2018 08:49:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mention that the request validation should increment the memory refcount
of reference buffers so we don't forget to do this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/staging/media/sunxi/cedrus/TODO b/drivers/staging/media/sunxi/cedrus/TODO
index ec277ece47af..a951b3fd1ea1 100644
--- a/drivers/staging/media/sunxi/cedrus/TODO
+++ b/drivers/staging/media/sunxi/cedrus/TODO
@@ -5,3 +5,8 @@ Before this stateless decoder driver can leave the staging area:
 * Userspace support for the Request API needs to be reviewed;
 * Another stateless decoder driver should be submitted;
 * At least one stateless encoder driver should be submitted.
+* When queueing a request containing references to I frames, the
+  refcount of the memory for those I frames needs to be incremented
+  and decremented when the request is completed. This will likely
+  require some help from vb2. The driver should fail the request
+  if the memory/buffer is gone.
