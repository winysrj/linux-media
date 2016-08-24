Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:41446 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754192AbcHXPhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 11:37:08 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] doc-rst:media: build separated PDF books (experimental)
Date: Wed, 24 Aug 2016 17:36:16 +0200
Message-Id: <1472052976-22541-4-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
References: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

This patch is only to demonstrate, how to build separated PDF books of
the media sub-folder and close open links with intersphinx.

It is an experimental state (I detected an build error, which I have not
yet traced deep).

Builds PDFs of:

* media_uapi.pdf:  Linux Media Infrastructure userspace API
* media_kapi.pdf:  Media subsystem kernel internal API
* dvb_drivers.pdf: Linux Digital TV driver-specific documentation
* v4l_drivers.pdf: Video4Linux (V4L) driver-specific documentation

It uses the intersphinx extension to close links which refer to content
outside of the (small) pdf-book. The intersphinx links refer to the
documentation served at url:

  https://www.linuxtv.org/downloads/v4l-dvb-apis-new/

E.g.: on page 154 of the media_kapi.pdf in paragraph """YUV Formats
lists existing packed ...""" the 'YUV Formats' text refer to url:

  https://www.linuxtv.org/downloads/v4l-dvb-apis-new/media/uapi/v4l/subdev-formats.html#v4l2-mbus-pixelcode-yuv8

This is only a small example to illustrate how we can build small books
and link them with intersphinx.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/media/conf.py | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
index bef927b..84575de 100644
--- a/Documentation/media/conf.py
+++ b/Documentation/media/conf.py
@@ -5,6 +5,21 @@ project = 'Linux Media Subsystem Documentation'
 tags.add("subproject")
 
 latex_documents = [
-    ('index', 'media.tex', 'Linux Media Subsystem Documentation',
+    ('media_uapi', 'media_uapi.tex', 'Linux Media Infrastructure userspace API',
+     'The kernel development community', 'manual'),
+    ('media_kapi', 'media_kapi.tex', 'Media subsystem kernel internal API',
+     'The kernel development community', 'manual'),
+    ('dvb-drivers/index', 'dvb_drivers.tex', 'Linux Digital TV driver-specific documentation',
+     'The kernel development community', 'manual'),
+    ('v4l-drivers/index', 'v4l_drivers.tex', 'Video4Linux (V4L) driver-specific documentation',
      'The kernel development community', 'manual'),
 ]
+
+# Since intersphinx is not activated in the global Documentation/conf.py we
+# activate it here. If times comes where it is activated in the global conf.py,
+# we may have to drop these two lines.
+extensions.append('sphinx.ext.intersphinx')
+intersphinx_mapping = {}
+
+# add intersphinx inventory of the *complete* documentation from linuxtv.org
+intersphinx_mapping['media'] = ('https://www.linuxtv.org/downloads/v4l-dvb-apis-new/', None)
-- 
2.7.4

