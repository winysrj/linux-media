Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38662 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 15/41] Documentation: linux_tv: fix remaining lack of escapes
Date: Mon,  4 Jul 2016 22:30:50 -0300
Message-Id: <51b85fd8afbbea884b55f6ed7a02974323feb619.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add escape before asterisk to fix those warnings:

Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst:47: WARNING: Inline emphasis start-string without end-string.
Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst:78: WARNING: Inline emphasis start-string without end-string.
Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst:87: WARNING: Inline emphasis start-string without end-string.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst         | 2 +-
 Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
index e0c66b877ada..a30dc97d6e15 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
@@ -44,7 +44,7 @@ Arguments
 
     -  .. row 3
 
-       -  struct dvb_frontend_event *ev
+       -  struct dvb_frontend_event \*ev
 
        -  Points to the location where the event,
 
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst b/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
index b0d4a946e151..6989f4ae4748 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
@@ -75,7 +75,7 @@ returned during the enumeration process.
 
        -  struct :ref:`media_pad_desc <media-pad-desc>`
 
-       -  *\ ``pads``
+       -  \*\ ``pads``
 
        -  Pointer to a pads array allocated by the application. Ignored if
           NULL.
@@ -84,7 +84,7 @@ returned during the enumeration process.
 
        -  struct :ref:`media_link_desc <media-link-desc>`
 
-       -  *\ ``links``
+       -  \*\ ``links``
 
        -  Pointer to a links array allocated by the application. Ignored if
           NULL.
-- 
2.7.4

