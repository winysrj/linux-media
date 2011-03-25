Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:55748 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1CYIZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 04:25:59 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] ignore Documentation/DocBook/media/
Date: Fri, 25 Mar 2011 09:25:08 +0100
Message-Id: <1301041508-7866-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It only contains generated files

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---

Re-sending this because patchwork didn't catch it the first time.

 Documentation/DocBook/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/.gitignore b/Documentation/DocBook/.gitignore
index c6def35..679034c 100644
--- a/Documentation/DocBook/.gitignore
+++ b/Documentation/DocBook/.gitignore
@@ -8,3 +8,4 @@
 *.dvi
 *.log
 *.out
+media/
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
