Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4159 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaGNM7h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/12] DocBook media: fix incorrect header reference
Date: Mon, 14 Jul 2014 14:59:03 +0200
Message-Id: <1405342752-46998-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
References: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The text referred to videodev.h when videodev2.h was meant. Fixed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 91dcbc8..a01f8b5 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -248,7 +248,7 @@ has just as many pad bytes after it as the other rows.</para>
 
     <para>In V4L2 each format has an identifier which looks like
 <constant>PIX_FMT_XXX</constant>, defined in the <link
-linkend="videodev">videodev.h</link> header file. These identifiers
+linkend="videodev">videodev2.h</link> header file. These identifiers
 represent <link linkend="v4l2-fourcc">four character (FourCC) codes</link>
 which are also listed below, however they are not the same as those
 used in the Windows world.</para>
-- 
2.0.1

