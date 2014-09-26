Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaIZSh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 14:37:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] Documentation: FE_SET_PROPERTY requires R/W
Date: Fri, 26 Sep 2014 15:37:38 -0300
Message-Id: <1411756658-10412-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FE_SET_PROPERTY requires to open the devnode on R/W mode, or
otherwise it will fail. Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 948ddaab592e..3018564ddfd9 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -120,8 +120,8 @@ struct dtv_properties {
 </para>
 <informaltable><tgroup cols="1"><tbody><row><entry
  align="char">
-<para>This ioctl call sets one or more frontend properties. This call only
- requires read-only access to the device.</para>
+<para>This ioctl call sets one or more frontend properties. This call
+ requires read/write access to the device.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 <para>SYNOPSIS
-- 
1.9.3

