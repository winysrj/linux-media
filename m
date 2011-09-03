Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:40727 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1ICR0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2011 13:26:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id A8DFF3153E1C
	for <linux-media@vger.kernel.org>; Sat,  3 Sep 2011 19:26:42 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id S6uLQ9-EX-uh for <linux-media@vger.kernel.org>;
	Sat,  3 Sep 2011 19:26:36 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 62FDC3153E1D
	for <linux-media@vger.kernel.org>; Sat,  3 Sep 2011 19:26:35 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] DVB: Change API version in documentation: 3 -> 5.4
Date: Sat,  3 Sep 2011 17:26:34 +0000
Message-Id: <1315070794-6323-2-git-send-email-obi@linuxtv.org>
In-Reply-To: <4E625385.4050008@redhat.com>
References: <4E625385.4050008@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 Documentation/DocBook/media/dvb/intro.xml |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index c75dc7c..170064a 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -205,7 +205,7 @@ a partial path like:</para>
 additional include file <emphasis
 role="tt">linux/dvb/version.h</emphasis> exists, which defines the
 constant <emphasis role="tt">DVB_API_VERSION</emphasis>. This document
-describes <emphasis role="tt">DVB_API_VERSION&#x00A0;3</emphasis>.
+describes <emphasis role="tt">DVB_API_VERSION 5.4</emphasis>.
 </para>
 
 </section>
-- 
1.7.2.5

