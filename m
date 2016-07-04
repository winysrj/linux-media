Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbcGDLr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 18/51] Documentation: control.rst: read the example captions
Date: Mon,  4 Jul 2016 08:46:39 -0300
Message-Id: <0f9f873ea2899855aea0fb44831a9c280826cb1f.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those got removed by the doc conversion.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/control.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index d6df648767c5..5defd1995e13 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -372,6 +372,8 @@ more menu type controls.
 
 
 .. code-block:: c
+    :caption: Example 8: Enumerating all user controls
+
 
     struct v4l2_queryctrl queryctrl;
     struct v4l2_querymenu querymenu;
@@ -435,6 +437,7 @@ more menu type controls.
 
 
 .. code-block:: c
+    :caption: Example 9: Enumerating all user controls (alternative)
 
     memset(&queryctrl, 0, sizeof(queryctrl));
 
@@ -459,6 +462,7 @@ more menu type controls.
 
 
 .. code-block:: c
+    :caption: Example 10: Changing controls
 
     struct v4l2_queryctrl queryctrl;
     struct v4l2_control control;
-- 
2.7.4


