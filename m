Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60608 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbbJAR0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 13:26:20 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tim Bird <tim.bird@sonymobile.com>, linux-doc@vger.kernel.org
Subject: [PATCH 1/5] [media] DocBook: add the new videobuf2-v4l2 header
Date: Thu,  1 Oct 2015 14:25:58 -0300
Message-Id: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This header should also be used to generate documentation. So,
add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 1d6008d51b55..31cefc9af98e 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -231,6 +231,7 @@ X!Isound/sound_firmware.c
 !Iinclude/media/v4l2-of.h
 !Iinclude/media/v4l2-subdev.h
 !Iinclude/media/videobuf2-core.h
+!Iinclude/media/videobuf2-v4l2.h
 !Iinclude/media/videobuf2-memops.h
      </sect1>
      <sect1><title>Digital TV (DVB) devices</title>
-- 
2.4.3

