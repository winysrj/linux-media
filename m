Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43810 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941749AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 46/47] [media] docs-rst: fix two wrong :name: tags
Date: Thu,  8 Sep 2016 09:04:08 -0300
Message-Id: <6c8ff3e3315a5032cc65b3952c8ba06145573f7c.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a typo there, causing 4 warnings:

  Documentation/media/uapi/rc/lirc-read.rst:26: WARNING: c:type reference target not found: name
  Documentation/media/uapi/rc/lirc-read.rst:26: WARNING: c:type reference target not found: lirc
  Documentation/media/uapi/v4l/func-poll.rst:25: WARNING: c:type reference target not found: name
  Documentation/media/uapi/v4l/func-poll.rst:25: WARNING: c:type reference target not found: v4l2

 Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-read.rst  | 2 +-
 Documentation/media/uapi/v4l/func-poll.rst | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index 62bd3d8c9c67..4c678f60e872 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: ssize_t read( int fd, void *buf, size_t count )
-    :name lirc-read
+    :name: lirc-read
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-poll.rst b/Documentation/media/uapi/v4l/func-poll.rst
index 186cd61b6cd1..d0432dc09b05 100644
--- a/Documentation/media/uapi/v4l/func-poll.rst
+++ b/Documentation/media/uapi/v4l/func-poll.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
-    name: v4l2-poll
+    :name: v4l2-poll
 
 Arguments
 =========
-- 
2.7.4


