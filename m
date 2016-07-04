Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 19/51] Documentation: control.rst: Fix missing reference for example 8
Date: Mon,  4 Jul 2016 08:46:40 -0300
Message-Id: <ecbd2674298dba5774a42d31da35251e75314569.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion broke references and captions for examples.

Fix the missing reference for control enumeration.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/control.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index 5defd1995e13..736d79080229 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -371,6 +371,8 @@ device has one or more controls, ``VIDIOC_QUERYMENU`` when it has one or
 more menu type controls.
 
 
+.. _enum_all_controls:
+
 .. code-block:: c
     :caption: Example 8: Enumerating all user controls
 
-- 
2.7.4


