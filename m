Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44306 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab0GNQUI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 12:20:08 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl PATCH 1/3] Create initial .gitignore file
Date: Wed, 14 Jul 2010 11:17:24 -0500
Message-Id: <1279124246-12187-2-git-send-email-saaguirre@ti.com>
In-Reply-To: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The idea of this file is to ignore build generated files, and also
the "standard" patches subfolder, used by quilt for example.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 .gitignore |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..1e56cf5
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,4 @@
+*.o
+media-ctl
+
+patches/*
-- 
1.6.3.3

