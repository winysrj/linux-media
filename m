Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54953 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbbFHMYT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 08:24:19 -0400
Message-ID: <5575896C.3090303@xs4all.nl>
Date: Mon, 08 Jun 2015 14:24:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH] bdisp: update MAINTAINERS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for the bdisp driver to the MAINTAINERS file.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3cfb979..de3cf29 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1964,6 +1964,14 @@ W:	http://bcache.evilpiepirate.org
 S:	Maintained:
 F:	drivers/md/bcache/
 
+BDISP ST MEDIA DRIVER
+M:	Fabien Dessenne <fabien.dessenne@st.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Supported
+F:	drivers/media/platform/sti/bdisp
+
 BEFS FILE SYSTEM
 S:	Orphan
 F:	Documentation/filesystems/befs.txt
