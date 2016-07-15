Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38106 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbcGOPOR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:14:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] s5p-cec/TODO: add TODO item
Date: Fri, 15 Jul 2016 17:14:08 +0200
Message-Id: <1468595648-30008-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468595648-30008-1-git-send-email-hverkuil@xs4all.nl>
References: <1468595648-30008-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Mention that the HDMI driver should pass on the physical address
to this driver, rather than requiring userspace to do this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <k.debski@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/staging/media/s5p-cec/TODO | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/s5p-cec/TODO b/drivers/staging/media/s5p-cec/TODO
index 7162f9a..f51d526 100644
--- a/drivers/staging/media/s5p-cec/TODO
+++ b/drivers/staging/media/s5p-cec/TODO
@@ -1,3 +1,7 @@
-There's nothing wrong on this driver, except that it depends on
-the media staging core, that it is currently at staging. So,
-this should be kept here while the core is not promoted.
+This driver depends on the CEC framework, which is currently in
+staging, so therefor this driver is in staging as well.
+
+In addition, this driver requires that userspace sets the physical
+address. However, this should be passed on from the corresponding
+samsung HDMI driver. It is very annoying if userspace has to do this,
+and other than USB CEC adapters this must be handled automatically.
-- 
2.8.1

