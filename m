Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbcGHNEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 21/54] doc-rst: mediactl: fix some wrong cross references
Date: Fri,  8 Jul 2016 10:03:13 -0300
Message-Id: <8c1cc62a52e9d7b1289d4c6b0bbf2bcea7dd65e7.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those cross references should point to media control syscalls,
and not to V4L ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/mediactl/media-func-close.rst | 2 +-
 Documentation/linux_tv/media/mediactl/media-func-ioctl.rst | 4 ++--
 Documentation/linux_tv/media/mediactl/media-func-open.rst  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/linux_tv/media/mediactl/media-func-close.rst b/Documentation/linux_tv/media/mediactl/media-func-close.rst
index 3f3d9bb1f32a..39ef70ac8656 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-close.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-close.rst
@@ -40,7 +40,7 @@ are freed. The device configuration remain unchanged.
 Return Value
 ============
 
-:ref:`close() <func-close>` returns 0 on success. On error, -1 is returned, and
+:ref:`close() <media-func-close>` returns 0 on success. On error, -1 is returned, and
 ``errno`` is set appropriately. Possible error codes are:
 
 EBADF
diff --git a/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst b/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
index 1b28e2d20de4..9d1b23133edf 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
@@ -40,8 +40,8 @@ Arguments
 Description
 ===========
 
-The :ref:`ioctl() <func-ioctl>` function manipulates media device parameters.
-The argument ``fd`` must be an open file descriptor.
+The :ref:`ioctl() <media-func-ioctl>` function manipulates media device
+parameters. The argument ``fd`` must be an open file descriptor.
 
 The ioctl ``request`` code specifies the media function to be called. It
 has encoded in it whether the argument is an input, output or read/write
diff --git a/Documentation/linux_tv/media/mediactl/media-func-open.rst b/Documentation/linux_tv/media/mediactl/media-func-open.rst
index 43b9ddc5c38f..2b2ecd85b995 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-open.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-open.rst
@@ -37,7 +37,7 @@ Arguments
 Description
 ===========
 
-To open a media device applications call :ref:`open() <func-open>` with the
+To open a media device applications call :ref:`open() <media-func-open>` with the
 desired device name. The function has no side effects; the device
 configuration remain unchanged.
 
-- 
2.7.4

