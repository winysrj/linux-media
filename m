Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:56601 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1CPObG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 10:31:06 -0400
Received: from mail2.matrix-vision.com (localhost [127.0.0.1])
	by mail2.matrix-vision.com (Postfix) with ESMTP id B6AF13F645
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 15:22:54 +0100 (CET)
Received: from erinome (g2.matrix-vision.com [80.152.136.245])
	by mail2.matrix-vision.com (Postfix) with ESMTPA id 88A333F60D
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 15:22:54 +0100 (CET)
Received: from erinome (localhost [127.0.0.1])
	by erinome (Postfix) with ESMTP id 2BBF96F8A
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 15:22:54 +0100 (CET)
Received: from [192.168.65.46] (host65-46.intern.matrix-vision.de [192.168.65.46])
	by erinome (Postfix) with ESMTPA id 0A43D6F8A
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 15:22:54 +0100 (CET)
Message-ID: <4D80C7BD.3030704@matrix-vision.de>
Date: Wed, 16 Mar 2011 15:22:53 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] ignore Documentation/DocBook/media/
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 81a09633855b88d19f013d7e559e0c4f602ba711 Mon Sep 17 00:00:00 2001
From: Michael Jones <michael.jones@matrix-vision.de>
Date: Thu, 10 Mar 2011 16:16:38 +0100
Subject: [PATCH] ignore Documentation/DocBook/media/

It is created and populated by 'make htmldocs'


Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
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
