Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbcGJKsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 06:48:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 3/6] [media] doc-rst: rename some RC files
Date: Sun, 10 Jul 2016 07:47:42 -0300
Message-Id: <85fafe4f329ad05b8df5945a911b8fc727b931ca.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some files start with an upper letter. Also, they have big
names. rename them.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/{Remote_controllers_Intro.rst => rc-intro.rst}  | 0
 .../rc/{remote_controllers_sysfs_nodes.rst => rc-sysfs-nodes.rst} | 0
 .../{Remote_controllers_table_change.rst => rc-table-change.rst}  | 0
 .../uapi/rc/{Remote_controllers_tables.rst => rc-tables.rst}      | 0
 Documentation/media/uapi/rc/remote_controllers.rst                | 8 ++++----
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename Documentation/media/uapi/rc/{Remote_controllers_Intro.rst => rc-intro.rst} (100%)
 rename Documentation/media/uapi/rc/{remote_controllers_sysfs_nodes.rst => rc-sysfs-nodes.rst} (100%)
 rename Documentation/media/uapi/rc/{Remote_controllers_table_change.rst => rc-table-change.rst} (100%)
 rename Documentation/media/uapi/rc/{Remote_controllers_tables.rst => rc-tables.rst} (100%)

diff --git a/Documentation/media/uapi/rc/Remote_controllers_Intro.rst b/Documentation/media/uapi/rc/rc-intro.rst
similarity index 100%
rename from Documentation/media/uapi/rc/Remote_controllers_Intro.rst
rename to Documentation/media/uapi/rc/rc-intro.rst
diff --git a/Documentation/media/uapi/rc/remote_controllers_sysfs_nodes.rst b/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
similarity index 100%
rename from Documentation/media/uapi/rc/remote_controllers_sysfs_nodes.rst
rename to Documentation/media/uapi/rc/rc-sysfs-nodes.rst
diff --git a/Documentation/media/uapi/rc/Remote_controllers_table_change.rst b/Documentation/media/uapi/rc/rc-table-change.rst
similarity index 100%
rename from Documentation/media/uapi/rc/Remote_controllers_table_change.rst
rename to Documentation/media/uapi/rc/rc-table-change.rst
diff --git a/Documentation/media/uapi/rc/Remote_controllers_tables.rst b/Documentation/media/uapi/rc/rc-tables.rst
similarity index 100%
rename from Documentation/media/uapi/rc/Remote_controllers_tables.rst
rename to Documentation/media/uapi/rc/rc-tables.rst
diff --git a/Documentation/media/uapi/rc/remote_controllers.rst b/Documentation/media/uapi/rc/remote_controllers.rst
index bccceb1e28c3..82e64e7acbe3 100644
--- a/Documentation/media/uapi/rc/remote_controllers.rst
+++ b/Documentation/media/uapi/rc/remote_controllers.rst
@@ -19,10 +19,10 @@ Remote Controllers
     :maxdepth: 1
     :numbered:
 
-    Remote_controllers_Intro
-    remote_controllers_sysfs_nodes
-    Remote_controllers_tables
-    Remote_controllers_table_change
+    rc-intro
+    rc-sysfs-nodes
+    rc-tables
+    rc-table-change
     lirc_device_interface
 
 
-- 
2.7.4

