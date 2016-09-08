Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43973 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965391AbcIHMEW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 35/47] [media] docs-rst: fix dmx bad cross-references
Date: Thu,  8 Sep 2016 09:03:57 -0300
Message-Id: <8f2e491a30b68b27ac216ae3f9d3696a569149fc.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some structs are pointed via the typedef. As we replaced
those references, fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dmx-get-caps.rst   | 5 ++---
 Documentation/media/uapi/dvb/dmx-set-source.rst | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dmx-get-caps.rst b/Documentation/media/uapi/dvb/dmx-get-caps.rst
index aaf084a245fd..145fb520d779 100644
--- a/Documentation/media/uapi/dvb/dmx-get-caps.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-caps.rst
@@ -15,7 +15,7 @@ DMX_GET_CAPS
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, DMX_GET_CAPS, dmx_caps_t *caps)
+.. c:function:: int ioctl(fd, DMX_GET_CAPS, struct dmx_caps *caps)
     :name: DMX_GET_CAPS
 
 Arguments
@@ -25,7 +25,7 @@ Arguments
     File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
 ``caps``
-    Undocumented.
+    Pointer to struct :c:type:`dmx_caps`
 
 
 Description
@@ -33,7 +33,6 @@ Description
 
 .. note:: This ioctl is undocumented. Documentation is welcome.
 
-
 Return Value
 ------------
 
diff --git a/Documentation/media/uapi/dvb/dmx-set-source.rst b/Documentation/media/uapi/dvb/dmx-set-source.rst
index a232fd6e5f52..ac7f77b25e06 100644
--- a/Documentation/media/uapi/dvb/dmx-set-source.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-source.rst
@@ -15,7 +15,7 @@ DMX_SET_SOURCE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, DMX_SET_SOURCE, dmx_source_t *src)
+.. c:function:: int ioctl(fd, DMX_SET_SOURCE, struct dmx_source *src)
     :name: DMX_SET_SOURCE
 
 
-- 
2.7.4


