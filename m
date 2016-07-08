Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbcGHNGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:06:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: remove an invalid include from the docs
Date: Fri,  8 Jul 2016 10:06:30 -0300
Message-Id: <a97369b5e21ea9b8b5fef7c0f4f48bbe60c07ca3.1467983185.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I suspect that this is a left over from Markus tests.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/audio_h.rst | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/audio_h.rst b/Documentation/linux_tv/media/dvb/audio_h.rst
index 0ea0b41b20ae..e00c3010fdf9 100644
--- a/Documentation/linux_tv/media/dvb/audio_h.rst
+++ b/Documentation/linux_tv/media/dvb/audio_h.rst
@@ -7,5 +7,3 @@ DVB Audio Header File
 *********************
 
 .. kernel-include:: $BUILDDIR/audio.h.rst
-
-.. kernel-include:: $BUILDDIR/../../../../etc/adduser.conf
-- 
2.7.4

