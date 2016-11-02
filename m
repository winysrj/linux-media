Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38970 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753977AbcKBMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/11] s5p-cec/st-cec: update TODOs
Date: Wed,  2 Nov 2016 13:46:34 +0100
Message-Id: <20161102124635.11989-11-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Update the TODOs explaining why these two drivers remain in
staging. The reason is that these drivers rely on userspace to
set the physical address, but that should come from the HDMI
output driver. This in turn needs the upcoming HDMI notifier
framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/s5p-cec/TODO | 12 ++++++------
 drivers/staging/media/st-cec/TODO  |  7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)
 create mode 100644 drivers/staging/media/st-cec/TODO

diff --git a/drivers/staging/media/s5p-cec/TODO b/drivers/staging/media/s5p-cec/TODO
index f51d526..64f21ba 100644
--- a/drivers/staging/media/s5p-cec/TODO
+++ b/drivers/staging/media/s5p-cec/TODO
@@ -1,7 +1,7 @@
-This driver depends on the CEC framework, which is currently in
-staging, so therefor this driver is in staging as well.
+This driver requires that userspace sets the physical address.
+However, this should be passed on from the corresponding
+Samsung HDMI driver.
 
-In addition, this driver requires that userspace sets the physical
-address. However, this should be passed on from the corresponding
-samsung HDMI driver. It is very annoying if userspace has to do this,
-and other than USB CEC adapters this must be handled automatically.
+We have to wait until the HDMI notifier framework has been merged
+in order to handle this gracefully, until that time this driver
+has to remain in staging.
diff --git a/drivers/staging/media/st-cec/TODO b/drivers/staging/media/st-cec/TODO
new file mode 100644
index 0000000..c612897
--- /dev/null
+++ b/drivers/staging/media/st-cec/TODO
@@ -0,0 +1,7 @@
+This driver requires that userspace sets the physical address.
+However, this should be passed on from the corresponding
+ST HDMI driver.
+
+We have to wait until the HDMI notifier framework has been merged
+in order to handle this gracefully, until that time this driver
+has to remain in staging.
-- 
2.10.1

