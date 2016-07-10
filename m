Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbcGJKsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 06:48:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/6] [media] doc-rst: remove an extra label on V4L2 and CEC parts
Date: Sun, 10 Jul 2016 07:47:41 -0300
Message-Id: <5956542901f81ca79318062511262206954e27b3.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to say: Table of Contents there. Also, this
generates a duplicated caption xref. So, remove, to use the
same format on every part.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-api.rst | 1 -
 Documentation/media/uapi/v4l/v4l2.rst    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index e7dc8253f1e2..246fbae2e079 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -15,7 +15,6 @@ This part describes the CEC: Consumer Electronics Control
 .. toctree::
     :maxdepth: 1
     :numbered:
-    :caption: Table of Contents
 
     cec-intro
     cec-funcs
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index 301f95b5bdc6..c0859ebc88ee 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -14,7 +14,6 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
 .. toctree::
     :numbered:
     :maxdepth: 1
-    :caption: Table of Contents
 
     common
     pixfmt
-- 
2.7.4

