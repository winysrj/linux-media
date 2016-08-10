Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:38209 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbcHJSJE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:09:04 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] v4l-utils: add comments to the build instructions
Date: Wed, 10 Aug 2016 11:52:18 +0200
Message-Id: <1470822739-29519-2-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

From: Heiser, Markus <markus.heiser@darmarIT.de>

On Debian derivated distributions (ubuntu 16.04) the package
'autoconf-archive' is required.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 README | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/README b/README
index 1dd5108..172bed0 100644
--- a/README
+++ b/README
@@ -22,7 +22,8 @@ each distro.
 
 On Debian and derivated distributions, you need to install the following
 packages with apt-get or aptitude:
-	debhelper dh-autoreconf autotools-dev doxygen graphviz libasound2-dev
+	debhelper dh-autoreconf autotools-dev autoconf-archive
+        doxygen graphviz libasound2-dev
 	libtool libjpeg-dev libqt4-dev libqt4-opengl-dev libudev-dev libx11-dev
 	pkg-config udev make gcc git
 
@@ -47,6 +48,11 @@ After downloading and installing the needed packages, you should run:
 	./configure
 	make
 
+If ./configure exit with some errors try::
+
+	autoreconf -i --force
+	./configure
+
 And, to install on your system:
 	sudo make install
 
-- 
2.7.4

