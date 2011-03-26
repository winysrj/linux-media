Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:32654 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1CZU2d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 16:28:33 -0400
Date: Sat, 26 Mar 2011 13:28:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org,
	torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: fix broken media build
Message-Id: <20110326132800.326fa555.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

DocBook/v4l/ no longer has any *.png files, so the 'cp' command fails,
breaking the build.  Drop the *.png cp.

cp: cannot stat `linux-2.6.38-git18/Documentation/DocBook/v4l/*.png': No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/Makefile |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.38-git18.orig/Documentation/DocBook/Makefile
+++ linux-2.6.38-git18/Documentation/DocBook/Makefile
@@ -55,7 +55,6 @@ mandocs: $(MAN)
 build_images = mkdir -p $(objtree)/Documentation/DocBook/media/ && \
 	       cp $(srctree)/Documentation/DocBook/dvb/*.png \
 	          $(srctree)/Documentation/DocBook/v4l/*.gif \
-	          $(srctree)/Documentation/DocBook/v4l/*.png \
 		  $(objtree)/Documentation/DocBook/media/
 
 xmldoclinks:
