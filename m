Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbcGTOlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:41:40 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 5/5] [media] doc-rst: Fix license for the media books
Date: Wed, 20 Jul 2016 11:41:35 -0300
Message-Id: <b14585c6ad29c27fc701c9781603f3a358a6702f.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kAPI, v4l-drivers and dvb-drivers never used the
GNU FDL license. The addition of such license header were
just due to copy-and-paste. So, let's fix it.

As the media_kapi were part of device-drivers.tmp, it is
under GPL v2+.

The other two books is an agregation of files without any
license explicitly specified. So, they're all bound to the
Kernel's COPYING license. So, they're GPL v2 only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst | 15 ++++++++++-----
 Documentation/media/media_kapi.rst        | 16 +++++++++++-----
 Documentation/media/v4l-drivers/index.rst | 15 ++++++++++-----
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index e4c2e74db9dc..ea0da6d63299 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -8,11 +8,16 @@ Linux Digital TV driver-specific documentation
 
 **Copyright** |copy| 2001-2016 : LinuxTV Developers
 
-Permission is granted to copy, distribute and/or modify this document
-under the terms of the GNU Free Documentation License, Version 1.1 or
-any later version published by the Free Software Foundation. A copy of
-the license is included in the chapter entitled "GNU Free Documentation
-License".
+This documentation is free software; you can redistribute it and/or modify it
+under the terms of the GNU General Public License as published by the Free
+Software Foundation version 2 of the License.
+
+This program is distributed in the hope that it will be useful, but WITHOUT
+ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+more details.
+
+For more details see the file COPYING in the source distribution of Linux.
 
 .. class:: toc-title
 
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index 5414d2a7dfb8..431fc3e43d6a 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -8,11 +8,17 @@ Media subsystem kernel internal API
 
 **Copyright** |copy| 2009-2016 : LinuxTV Developers
 
-Permission is granted to copy, distribute and/or modify this document
-under the terms of the GNU Free Documentation License, Version 1.1 or
-any later version published by the Free Software Foundation. A copy of
-the license is included in the chapter entitled "GNU Free Documentation
-License".
+This documentation is free software; you can redistribute it and/or modify it
+under the terms of the GNU General Public License as published by the Free
+Software Foundation; either version 2 of the License, or (at your option) any
+later version.
+
+This program is distributed in the hope that it will be useful, but WITHOUT
+ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+more details.
+
+For more details see the file COPYING in the source distribution of Linux.
 
 .. class:: toc-title
 
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 2aab653905ce..aac566f88833 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -8,11 +8,16 @@ Video4Linux (V4L)  driver-specific documentation
 
 **Copyright** |copy| 1999-2016 : LinuxTV Developers
 
-Permission is granted to copy, distribute and/or modify this document
-under the terms of the GNU Free Documentation License, Version 1.1 or
-any later version published by the Free Software Foundation. A copy of
-the license is included in the chapter entitled "GNU Free Documentation
-License".
+This documentation is free software; you can redistribute it and/or modify it
+under the terms of the GNU General Public License as published by the Free
+Software Foundation version 2 of the License.
+
+This program is distributed in the hope that it will be useful, but WITHOUT
+ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+more details.
+
+For more details see the file COPYING in the source distribution of Linux.
 
 .. class:: toc-title
 
-- 
2.7.4

